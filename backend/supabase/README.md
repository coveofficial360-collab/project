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

## Apply locally in Supabase SQL editor

Run in this order:

1. `01_schema.sql`
2. `02_seed.sql`
3. `03_screen_queries.sql` if you want quick validation queries

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
