alter table public.notifications
add column if not exists source_announcement_id uuid references public.announcements(id) on delete cascade;

create table if not exists public.device_push_tokens (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.app_users(id) on delete cascade,
  fcm_token text not null unique,
  platform text not null,
  device_label text,
  is_active boolean not null default true,
  last_seen_at timestamptz not null default now(),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create or replace function public.register_device_push_token(
  p_user_id uuid,
  p_fcm_token text,
  p_platform text,
  p_device_label text default null
)
returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  v_token_id uuid;
begin
  insert into public.device_push_tokens (
    user_id,
    fcm_token,
    platform,
    device_label,
    is_active,
    last_seen_at,
    updated_at
  )
  values (
    p_user_id,
    p_fcm_token,
    lower(trim(p_platform)),
    nullif(trim(coalesce(p_device_label, '')), ''),
    true,
    now(),
    now()
  )
  on conflict (fcm_token)
  do update
    set user_id = excluded.user_id,
        platform = excluded.platform,
        device_label = excluded.device_label,
        is_active = true,
        last_seen_at = now(),
        updated_at = now()
  returning id into v_token_id;

  return v_token_id;
end;
$$;

grant select, insert, update, delete on public.device_push_tokens to anon, authenticated;
grant execute on function public.register_device_push_token(uuid, text, text, text) to anon, authenticated;

-- Development-only setup: keep push token registration open for the demo app.
alter table public.device_push_tokens disable row level security;
