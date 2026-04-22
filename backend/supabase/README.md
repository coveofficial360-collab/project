# Supabase Test Data

This folder contains a simple development schema and demo data for the Avenue360 app screens.

## Demo credentials

- Resident: `user@gmail.com` / `user`
- Admin: `admin@gmail.com` / `admin`
- Guard: `guard@gmail.com` / `guard`

The login data is stored in `public.app_users` using bcrypt hashes via `crypt(...)`.
This is for app testing only and should be replaced with real Supabase Auth before production.

## Files

- `01_schema.sql`: tables, views, and the `authenticate_app_user(...)` function
- `02_seed.sql`: demo users and screen data
- `03_screen_queries.sql`: ready-to-run queries for each app area
- `04_actions.sql`: write RPCs for add resident, create visitor pass, complaint, and announcement
- `05_push_notifications.sql`: device token storage for FCM push delivery

## Apply locally in Supabase SQL editor

Run in this order:

1. `01_schema.sql`
2. `02_seed.sql`
3. `05_push_notifications.sql`
4. `04_actions.sql`
5. `03_screen_queries.sql` if you want quick validation queries

## Quick validation

```sql
select * from public.authenticate_app_user('user@gmail.com', 'user', 'resident');
select * from public.authenticate_app_user('admin@gmail.com', 'admin', 'admin');
select * from public.authenticate_app_user('guard@gmail.com', 'guard', 'guard');
```

## Important note

This schema is intentionally permissive for development with the Supabase publishable key.
Before going live, replace this with:

- real Supabase Auth users
- proper RLS policies
- restricted insert/update access

## Push notifications

Push delivery now has three parts:

1. Flutter app registers each device FCM token into `public.device_push_tokens`
2. `create_announcement(...)` creates resident `notifications` rows linked to the announcement
3. Supabase Edge Function `send-announcement-push` sends the actual FCM push

### Required client env vars

Add these to your `env.json` before building the app:

- `FIREBASE_API_KEY`
- `FIREBASE_MESSAGING_SENDER_ID`
- `FIREBASE_PROJECT_ID`
- `FIREBASE_STORAGE_BUCKET`
- `FIREBASE_ANDROID_APP_ID`
- `FIREBASE_IOS_APP_ID`
- `FIREBASE_IOS_BUNDLE_ID`

### Required Edge Function secrets

Set these in Supabase before deploying the function:

- `SUPABASE_URL`
- `SUPABASE_SERVICE_ROLE_KEY`
- `FIREBASE_PROJECT_ID`
- `FIREBASE_CLIENT_EMAIL`
- `FIREBASE_PRIVATE_KEY`

### Deploy the function

```bash
supabase functions deploy send-announcement-push
```
