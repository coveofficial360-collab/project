create extension if not exists pgcrypto with schema extensions;

do $$
begin
  create type public.app_role as enum ('resident', 'admin', 'guard');
exception
  when duplicate_object then null;
end $$;

do $$
begin
  create type public.resident_kind as enum ('owner', 'tenant', 'family');
exception
  when duplicate_object then null;
end $$;

do $$
begin
  create type public.record_status as enum ('active', 'pending', 'expired', 'inactive');
exception
  when duplicate_object then null;
end $$;

do $$
begin
  create type public.bill_state as enum ('due', 'paid', 'expiring');
exception
  when duplicate_object then null;
end $$;

do $$
begin
  create type public.complaint_state as enum ('in_progress', 'pending', 'resolved');
exception
  when duplicate_object then null;
end $$;

do $$
begin
  create type public.notice_kind as enum ('urgent', 'general', 'event', 'facility');
exception
  when duplicate_object then null;
end $$;

do $$
begin
  create type public.visitor_kind as enum ('guest', 'delivery', 'service');
exception
  when duplicate_object then null;
end $$;

do $$
begin
  create type public.announcement_state as enum ('sent', 'scheduled', 'draft');
exception
  when duplicate_object then null;
end $$;

create table if not exists public.app_users (
  id uuid primary key default gen_random_uuid(),
  email text not null unique,
  password_hash text not null,
  role public.app_role not null,
  full_name text not null,
  display_name text,
  phone text,
  unit_number text,
  tower text,
  resident_kind public.resident_kind,
  status public.record_status not null default 'active',
  job_title text,
  avatar_url text,
  bio text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.household_members (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.app_users(id) on delete cascade,
  full_name text not null,
  relation text not null,
  avatar_url text,
  created_at timestamptz not null default now()
);

create table if not exists public.vehicles (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.app_users(id) on delete cascade,
  registration_number text not null,
  vehicle_name text not null,
  vehicle_type text not null,
  created_at timestamptz not null default now()
);

create table if not exists public.amenities (
  id uuid primary key default gen_random_uuid(),
  code text not null unique,
  name text not null,
  category text not null,
  description text not null,
  location_label text not null,
  availability_text text,
  occupancy_note text,
  status_label text not null,
  cta_label text not null,
  image_url text,
  available_now boolean not null default true,
  booking_required boolean not null default true,
  created_at timestamptz not null default now()
);

create table if not exists public.amenity_bookings (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.app_users(id) on delete cascade,
  amenity_id uuid not null references public.amenities(id) on delete cascade,
  booking_date date not null,
  time_slot text not null,
  guest_count integer not null default 0,
  booking_status text not null default 'confirmed',
  booking_fee numeric(10, 2) not null default 0,
  created_at timestamptz not null default now()
);

create table if not exists public.bills (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.app_users(id) on delete cascade,
  code text not null unique,
  title text not null,
  provider text not null,
  category text not null,
  state public.bill_state not null,
  badge_text text not null,
  amount_due numeric(10, 2),
  amount_paid numeric(10, 2),
  due_date date,
  last_paid_on date,
  action_label text,
  created_at timestamptz not null default now()
);

create table if not exists public.payment_methods (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.app_users(id) on delete cascade,
  method_name text not null,
  method_type text not null,
  masked_value text not null,
  note text,
  is_primary boolean not null default false,
  created_at timestamptz not null default now()
);

create table if not exists public.payment_activity (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.app_users(id) on delete cascade,
  activity_title text not null,
  activity_category text not null,
  amount numeric(10, 2) not null,
  status text not null,
  activity_at timestamptz not null,
  created_at timestamptz not null default now()
);

create table if not exists public.complaints (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.app_users(id) on delete cascade,
  code text not null unique,
  title text not null,
  description text not null,
  state public.complaint_state not null,
  assigned_to text,
  meta_label text not null,
  meta_value text not null,
  icon_name text not null,
  accent_hex text not null,
  created_at timestamptz not null,
  resolved_at timestamptz
);

create table if not exists public.notices (
  id uuid primary key default gen_random_uuid(),
  code text not null unique,
  kind public.notice_kind not null,
  title text not null,
  body text not null,
  action_label text,
  audience text not null,
  posted_at timestamptz not null,
  event_date date,
  image_url text,
  created_at timestamptz not null default now()
);

create table if not exists public.notifications (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.app_users(id) on delete cascade,
  kind text not null,
  title text not null,
  body text,
  badge_label text,
  action_label text,
  image_url text,
  is_unread boolean not null default true,
  created_at timestamptz not null
);

create table if not exists public.visitor_passes (
  id uuid primary key default gen_random_uuid(),
  resident_user_id uuid not null references public.app_users(id) on delete cascade,
  visitor_name text not null,
  phone text not null,
  visitor_kind public.visitor_kind not null,
  expected_arrival timestamptz not null,
  status text not null,
  pin_code text not null,
  qr_token text not null,
  created_at timestamptz not null default now()
);

create table if not exists public.admin_transactions (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  subtitle text not null,
  amount numeric(10, 2) not null,
  status text not null,
  icon_name text not null,
  icon_bg_hex text not null,
  created_at timestamptz not null
);

create table if not exists public.announcements (
  id uuid primary key default gen_random_uuid(),
  created_by uuid not null references public.app_users(id) on delete cascade,
  state public.announcement_state not null,
  kind public.notice_kind not null,
  title text not null,
  body text not null,
  target_audience text not null,
  reads_count integer not null default 0,
  scheduled_for timestamptz,
  created_at timestamptz not null default now()
);

create table if not exists public.guard_duty_logs (
  id uuid primary key default gen_random_uuid(),
  guard_user_id uuid not null references public.app_users(id) on delete cascade,
  title text not null,
  details text not null,
  related_visitor_name text,
  related_unit text,
  log_status text not null,
  logged_at timestamptz not null
);

create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists trg_app_users_updated_at on public.app_users;
create trigger trg_app_users_updated_at
before update on public.app_users
for each row
execute function public.set_updated_at();

create or replace function public.authenticate_app_user(
  p_email text,
  p_password text,
  p_role public.app_role default null
)
returns table (
  user_id uuid,
  email text,
  role public.app_role,
  full_name text,
  unit_number text,
  tower text,
  status public.record_status
)
language sql
security definer
set search_path = public
as $$
  select
    u.id,
    u.email,
    u.role,
    u.full_name,
    u.unit_number,
    u.tower,
    u.status
  from public.app_users u
  where lower(u.email) = lower(p_email)
    and u.password_hash = extensions.crypt(p_password, u.password_hash)
    and (p_role is null or u.role = p_role)
  limit 1;
$$;

create or replace view public.resident_directory_v as
select
  u.id,
  u.full_name,
  u.email,
  u.unit_number,
  u.tower,
  u.resident_kind,
  u.status,
  u.avatar_url,
  u.phone
from public.app_users u
where u.role = 'resident'
order by u.full_name;

create or replace view public.admin_dashboard_metrics_v as
select
  (select count(*) from public.app_users where role = 'resident' and status = 'active') as active_residents,
  (select count(*) from public.visitor_passes where status in ('approved', 'expected')) as active_visitor_passes,
  (select count(*) from public.complaints where state in ('in_progress', 'pending')) as open_complaints,
  (select coalesce(sum(amount), 0) from public.admin_transactions where amount > 0) as total_collected;

create or replace view public.guard_gate_activity_v as
select
  vp.id,
  vp.visitor_name,
  vp.phone,
  vp.visitor_kind,
  vp.expected_arrival,
  vp.status,
  resident.full_name as resident_name,
  resident.unit_number,
  resident.tower,
  vp.pin_code
from public.visitor_passes vp
join public.app_users resident on resident.id = vp.resident_user_id
order by vp.expected_arrival asc;

grant usage on schema public to anon, authenticated;
grant select, insert, update, delete on all tables in schema public to anon, authenticated;
grant execute on function public.authenticate_app_user(text, text, public.app_role) to anon, authenticated;
grant select on public.resident_directory_v to anon, authenticated;
grant select on public.admin_dashboard_metrics_v to anon, authenticated;
grant select on public.guard_gate_activity_v to anon, authenticated;
