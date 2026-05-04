import { createClient } from 'jsr:@supabase/supabase-js@2';

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
  'Access-Control-Allow-Methods': 'POST, OPTIONS',
  'Content-Type': 'application/json',
};

type ServiceAccountConfig = {
  clientEmail: string;
  privateKey: string;
  projectId: string;
};

Deno.serve(async (request) => {
  if (request.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders });
  }

  try {
    const supabaseUrl = mustEnv('SUPABASE_URL');
    const serviceRoleKey = mustEnv('SUPABASE_SERVICE_ROLE_KEY');
    const firebase = {
      clientEmail: mustEnv('FIREBASE_CLIENT_EMAIL'),
      privateKey: mustEnv('FIREBASE_PRIVATE_KEY'),
      projectId: mustEnv('FIREBASE_PROJECT_ID'),
    };

    const supabase = createClient(supabaseUrl, serviceRoleKey);
    const body = await request.json();
    const announcementId = body?.announcement_id?.toString();

    if (!announcementId) {
      return jsonResponse({ error: 'Missing announcement_id.' }, 400);
    }

    const { data: announcement, error: announcementError } = await supabase
      .from('announcements')
      .select('id, title, body')
      .eq('id', announcementId)
      .single();

    if (announcementError || !announcement) {
      return jsonResponse(
        { error: announcementError?.message ?? 'Announcement not found.' },
        404,
      );
    }

    const { data: recipientRows, error: recipientError } = await supabase
      .from('notifications')
      .select('user_id')
      .eq('source_announcement_id', announcementId);

    if (recipientError) {
      throw recipientError;
    }

    const userIds = [...new Set((recipientRows ?? []).map((row) => row.user_id))];
    if (userIds.length == 0) {
      return jsonResponse({ attempted: 0, sent: 0, invalidated: 0 });
    }

    const { data: tokenRows, error: tokenError } = await supabase
      .from('device_push_tokens')
      .select('id, fcm_token')
      .in('user_id', userIds)
      .eq('is_active', true);

    if (tokenError) {
      throw tokenError;
    }

    if (!tokenRows || tokenRows.length === 0) {
      return jsonResponse({ attempted: 0, sent: 0, invalidated: 0 });
    }

    const accessToken = await getGoogleAccessToken(firebase);
    const sendResults = await Promise.allSettled(
      tokenRows.map(async (row) => {
        const response = await fetch(
          `https://fcm.googleapis.com/v1/projects/${firebase.projectId}/messages:send`,
          {
            method: 'POST',
            headers: {
              Authorization: `Bearer ${accessToken}`,
              'Content-Type': 'application/json',
            },
            body: JSON.stringify({
              message: {
                token: row.fcm_token,
                notification: {
                  title: announcement.title,
                  body: announcement.body,
                },
                data: {
                  type: 'announcement',
                  announcement_id: announcementId,
                  route: '/notifications',
                },
                android: {
                  notification: {
                    channel_id: 'cove_announcements',
                    sound: 'default',
                  },
                },
                apns: {
                  payload: {
                    aps: {
                      sound: 'default',
                    },
                  },
                },
              },
            }),
          },
        );

        const payload = await response.json().catch(() => ({}));
        if (!response.ok) {
          throw { tokenId: row.id, payload };
        }

        return row.id;
      }),
    );

    const invalidTokenIds: string[] = [];
    let sentCount = 0;

    for (const result of sendResults) {
      if (result.status === 'fulfilled') {
        sentCount += 1;
        continue;
      }

      const tokenId = result.reason?.tokenId?.toString();
      const errorPayload = result.reason?.payload;
      if (tokenId && isInvalidFcmToken(errorPayload)) {
        invalidTokenIds.push(tokenId);
      }
    }

    if (invalidTokenIds.length > 0) {
      await supabase
        .from('device_push_tokens')
        .update({
          is_active: false,
          updated_at: new Date().toISOString(),
        })
        .in('id', invalidTokenIds);
    }

    return jsonResponse({
      attempted: tokenRows.length,
      sent: sentCount,
      invalidated: invalidTokenIds.length,
    });
  } catch (error) {
    const message = error instanceof Error ? error.message : String(error);
    return jsonResponse({ error: message }, 500);
  }
});

function mustEnv(name: string): string {
  const value = Deno.env.get(name);
  if (!value) {
    throw new Error(`Missing required env var ${name}.`);
  }
  return value;
}

function jsonResponse(body: unknown, status = 200): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: corsHeaders,
  });
}

function base64UrlEncodeString(input: string): string {
  return base64UrlEncodeBytes(new TextEncoder().encode(input));
}

function base64UrlEncodeBytes(input: Uint8Array): string {
  return btoa(String.fromCharCode(...input))
    .replaceAll('+', '-')
    .replaceAll('/', '_')
    .replaceAll('=', '');
}

function pemToArrayBuffer(pem: string): ArrayBuffer {
  const normalized = pem.replaceAll('\\n', '\n');
  const base64 = normalized
    .replace('-----BEGIN PRIVATE KEY-----', '')
    .replace('-----END PRIVATE KEY-----', '')
    .replaceAll('\n', '')
    .trim();
  const binary = atob(base64);
  const bytes = Uint8Array.from(binary, (char) => char.charCodeAt(0));
  return bytes.buffer;
}

async function getGoogleAccessToken(
  serviceAccount: ServiceAccountConfig,
): Promise<string> {
  const now = Math.floor(Date.now() / 1000);
  const header = { alg: 'RS256', typ: 'JWT' };
  const payload = {
    iss: serviceAccount.clientEmail,
    sub: serviceAccount.clientEmail,
    aud: 'https://oauth2.googleapis.com/token',
    scope: 'https://www.googleapis.com/auth/firebase.messaging',
    iat: now,
    exp: now + 3600,
  };

  const unsignedJwt =
    `${base64UrlEncodeString(JSON.stringify(header))}.${base64UrlEncodeString(JSON.stringify(payload))}`;

  const privateKey = await crypto.subtle.importKey(
    'pkcs8',
    pemToArrayBuffer(serviceAccount.privateKey),
    {
      name: 'RSASSA-PKCS1-v1_5',
      hash: 'SHA-256',
    },
    false,
    ['sign'],
  );

  const signature = await crypto.subtle.sign(
    'RSASSA-PKCS1-v1_5',
    privateKey,
    new TextEncoder().encode(unsignedJwt),
  );

  const assertion =
    `${unsignedJwt}.${base64UrlEncodeBytes(new Uint8Array(signature))}`;

  const response = await fetch('https://oauth2.googleapis.com/token', {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: new URLSearchParams({
      grant_type: 'urn:ietf:params:oauth:grant-type:jwt-bearer',
      assertion,
    }),
  });

  const payloadResponse = await response.json();
  if (!response.ok || !payloadResponse.access_token) {
    throw new Error(
      `Unable to fetch Google access token: ${JSON.stringify(payloadResponse)}`,
    );
  }

  return payloadResponse.access_token as string;
}

function isInvalidFcmToken(payload: unknown): boolean {
  const serialized = JSON.stringify(payload ?? {});
  return serialized.includes('UNREGISTERED') ||
    serialized.includes('registration-token-not-registered') ||
    serialized.includes('INVALID_ARGUMENT');
}
