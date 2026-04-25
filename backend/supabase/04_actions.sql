create sequence if not exists public.app_complaint_code_seq start 8903;

create or replace function public.create_resident_app_user(
  p_email text,
  p_full_name text,
  p_phone text default null,
  p_unit_number text default null,
  p_resident_kind public.resident_kind default 'owner',
  p_temp_password text default 'welcome123',
  p_avatar_url text default null
)
returns table (
  user_id uuid,
  email text,
  full_name text,
  temporary_password text
)
language plpgsql
security definer
set search_path = public, extensions
as $$
declare
  v_tower text;
  v_user_id uuid;
begin
  v_tower := case
    when p_unit_number is null or btrim(p_unit_number) = '' then null
    when position('-' in p_unit_number) > 0 then
      'Tower ' || upper(split_part(p_unit_number, '-', 1))
    else null
  end;

  insert into public.app_users (
    email,
    password_hash,
    role,
    full_name,
    display_name,
    phone,
    unit_number,
    tower,
    resident_kind,
    status,
    avatar_url,
    bio
  )
  values (
    lower(trim(p_email)),
    extensions.crypt(p_temp_password, extensions.gen_salt('bf')),
    'resident',
    p_full_name,
    split_part(trim(p_full_name), ' ', 1),
    p_phone,
    nullif(trim(p_unit_number), ''),
    v_tower,
    p_resident_kind,
    'active',
    p_avatar_url,
    'Resident created from the Avenue360 admin app.'
  )
  returning id into v_user_id;

  return query
  select
    v_user_id,
    lower(trim(p_email)),
    p_full_name,
    p_temp_password;
end;
$$;

create or replace function public.create_visitor_pass(
  p_resident_user_id uuid,
  p_visitor_name text,
  p_phone text,
  p_visitor_kind public.visitor_kind default 'guest',
  p_expected_arrival timestamptz default now() + interval '1 hour'
)
returns table (
  pass_id uuid,
  visitor_name text,
  pin_code text,
  qr_token text,
  status text
)
language plpgsql
security definer
set search_path = public
as $$
declare
  v_pass_id uuid;
  v_pin_code text := lpad((floor(random() * 10000))::int::text, 4, '0');
  v_qr_token text := 'QR-' || upper(substr(replace(gen_random_uuid()::text, '-', ''), 1, 10));
  v_status text := case
    when p_visitor_kind = 'guest' then 'approved'
    else 'expected'
  end;
begin
  insert into public.visitor_passes (
    resident_user_id,
    visitor_name,
    phone,
    visitor_kind,
    expected_arrival,
    status,
    pin_code,
    qr_token
  )
  values (
    p_resident_user_id,
    p_visitor_name,
    p_phone,
    p_visitor_kind,
    p_expected_arrival,
    v_status,
    v_pin_code,
    v_qr_token
  )
  returning id into v_pass_id;

  return query
  select
    v_pass_id,
    p_visitor_name,
    v_pin_code,
    v_qr_token,
    v_status;
end;
$$;

create or replace function public.create_resident_complaint(
  p_user_id uuid,
  p_title text,
  p_description text,
  p_icon_name text default 'electrical_services',
  p_accent_hex text default '#E2E3E8'
)
returns table (
  complaint_id uuid,
  code text,
  title text,
  state public.complaint_state
)
language plpgsql
security definer
set search_path = public
as $$
declare
  v_complaint_id uuid;
  v_code text := 'CMP-' || lpad(nextval('public.app_complaint_code_seq')::text, 4, '0');
begin
  insert into public.complaints (
    user_id,
    code,
    title,
    description,
    state,
    assigned_to,
    meta_label,
    meta_value,
    icon_name,
    accent_hex,
    created_at,
    resolved_at
  )
  values (
    p_user_id,
    v_code,
    p_title,
    p_description,
    'pending',
    null,
    'STATUS',
    'Awaiting Assignment',
    p_icon_name,
    p_accent_hex,
    now(),
    null
  )
  returning id into v_complaint_id;

  return query
  select
    v_complaint_id,
    v_code,
    p_title,
    'pending'::public.complaint_state;
end;
$$;

create or replace function public.create_announcement(
  p_created_by uuid,
  p_kind public.notice_kind,
  p_title text,
  p_body text,
  p_target_audience text,
  p_state public.announcement_state default 'sent',
  p_scheduled_for timestamptz default null
)
returns table (
  announcement_id uuid,
  title text,
  state public.announcement_state
)
language plpgsql
security definer
set search_path = public
as $$
declare
  v_announcement_id uuid;
  v_notice_code text := 'notice-' || lower(substr(replace(gen_random_uuid()::text, '-', ''), 1, 12));
  v_audience text := lower(coalesce(p_target_audience, ''));
begin
  insert into public.announcements (
    created_by,
    state,
    kind,
    title,
    body,
    target_audience,
    reads_count,
    scheduled_for,
    created_at
  )
  values (
    p_created_by,
    p_state,
    p_kind,
    p_title,
    p_body,
    p_target_audience,
    0,
    p_scheduled_for,
    now()
  )
  returning id into v_announcement_id;

  if p_state = 'sent' then
    insert into public.notices (
      code,
      kind,
      title,
      body,
      action_label,
      audience,
      posted_at,
      event_date,
      image_url
    )
    values (
      v_notice_code,
      p_kind,
      p_title,
      p_body,
      case when p_kind = 'event' then 'RSVP' else 'READ MORE' end,
      p_target_audience,
      now(),
      case
        when p_kind = 'event' and p_scheduled_for is not null then p_scheduled_for::date
        else null
      end,
      null
    );

    insert into public.notifications (
      user_id,
      source_announcement_id,
      kind,
      title,
      body,
      badge_label,
      action_label,
      image_url,
      is_unread,
      created_at
    )
    select
      u.id,
      v_announcement_id,
      p_kind::text,
      p_title,
      p_body,
      case
        when p_kind = 'urgent' then 'URGENT'
        when p_kind = 'event' then 'EVENT'
        when p_kind = 'facility' then 'FACILITY'
        else null
      end,
      'VIEW NOTICE',
      null,
      true,
      now()
    from public.app_users u
    where u.role = 'resident'
      and u.status = 'active'
      and (
        v_audience = ''
        or v_audience like '%all%'
        or v_audience like '%resident%'
        or (v_audience like '%owner%' and u.resident_kind = 'owner')
        or (v_audience like '%tenant%' and u.resident_kind = 'tenant')
        or (v_audience like '%family%' and u.resident_kind = 'family')
      );
  end if;

  return query
  select
    v_announcement_id,
    p_title,
    p_state;
end;
$$;

create or replace function public.create_guard_visitor_entry(
  p_guard_user_id uuid,
  p_visitor_name text,
  p_unit_number text,
  p_purpose text,
  p_phone text default null,
  p_visitor_kind public.visitor_kind default 'guest',
  p_decision text default 'approved'
)
returns table (
  pass_id uuid,
  log_id uuid,
  visitor_name text,
  unit_number text,
  status text,
  pin_code text,
  qr_token text
)
language plpgsql
security definer
set search_path = public
as $$
declare
  v_resident_user_id uuid;
  v_guard_name text;
  v_pass_id uuid;
  v_log_id uuid;
  v_pin_code text := lpad((floor(random() * 10000))::int::text, 4, '0');
  v_qr_token text := 'QR-' || upper(substr(replace(gen_random_uuid()::text, '-', ''), 1, 10));
  v_decision text := lower(trim(coalesce(p_decision, 'approved')));
  v_status text;
  v_log_status text;
  v_log_title text;
  v_log_details text;
  v_clean_unit text := upper(trim(p_unit_number));
  v_clean_phone text := nullif(trim(coalesce(p_phone, '')), '');
begin
  select full_name
  into v_guard_name
  from public.app_users
  where id = p_guard_user_id
    and role = 'guard'
  limit 1;

  if v_guard_name is null then
    raise exception 'Only a guard user can record guard entries.';
  end if;

  select u.id
  into v_resident_user_id
  from public.app_users u
  where u.role = 'resident'
    and upper(trim(coalesce(u.unit_number, ''))) = v_clean_unit
  order by
    case when u.status = 'active' then 0 else 1 end,
    u.created_at asc
  limit 1;

  if v_resident_user_id is null then
    raise exception 'No resident was found for unit %.', p_unit_number;
  end if;

  if v_decision in ('approved', 'approve', 'allow', 'allowed') then
    v_status := 'checked_in';
    v_log_status := 'completed';
    v_log_title := 'Walk-in visitor approved';
    v_log_details :=
      format(
        '%s logged a manual visitor entry for %s at unit %s. Purpose: %s.',
        v_guard_name,
        trim(p_visitor_name),
        v_clean_unit,
        trim(p_purpose)
      );
  elsif v_decision in ('denied', 'deny', 'rejected', 'reject') then
    v_status := 'denied';
    v_log_status := 'denied';
    v_log_title := 'Walk-in visitor denied';
    v_log_details :=
      format(
        '%s denied a manual visitor entry for %s at unit %s. Purpose: %s.',
        v_guard_name,
        trim(p_visitor_name),
        v_clean_unit,
        trim(p_purpose)
      );
  else
    raise exception 'Unsupported guard decision: %', p_decision;
  end if;

  insert into public.visitor_passes (
    resident_user_id,
    visitor_name,
    phone,
    visitor_kind,
    expected_arrival,
    status,
    pin_code,
    qr_token
  )
  values (
    v_resident_user_id,
    trim(p_visitor_name),
    coalesce(v_clean_phone, 'N/A'),
    p_visitor_kind,
    now(),
    v_status,
    v_pin_code,
    v_qr_token
  )
  returning id into v_pass_id;

  insert into public.guard_duty_logs (
    guard_user_id,
    title,
    details,
    related_visitor_name,
    related_unit,
    log_status,
    logged_at
  )
  values (
    p_guard_user_id,
    v_log_title,
    v_log_details,
    trim(p_visitor_name),
    v_clean_unit,
    v_log_status,
    now()
  )
  returning id into v_log_id;

  return query
  select
    v_pass_id,
    v_log_id,
    trim(p_visitor_name),
    v_clean_unit,
    v_status,
    v_pin_code,
    v_qr_token;
end;
$$;

create or replace function public.process_guard_visitor_pass(
  p_guard_user_id uuid,
  p_pass_id uuid,
  p_decision text default 'approved'
)
returns table (
  pass_id uuid,
  log_id uuid,
  visitor_name text,
  unit_number text,
  status text
)
language plpgsql
security definer
set search_path = public
as $$
declare
  v_guard_name text;
  v_pass record;
  v_log_id uuid;
  v_decision text := lower(trim(coalesce(p_decision, 'approved')));
  v_status text;
  v_log_status text;
  v_log_title text;
  v_log_details text;
begin
  select full_name
  into v_guard_name
  from public.app_users
  where id = p_guard_user_id
    and role = 'guard'
  limit 1;

  if v_guard_name is null then
    raise exception 'Only a guard user can process visitor passes.';
  end if;

  select
    vp.id,
    vp.visitor_name,
    vp.status as current_status,
    resident.unit_number,
    resident.full_name as resident_name
  into v_pass
  from public.visitor_passes vp
  join public.app_users resident on resident.id = vp.resident_user_id
  where vp.id = p_pass_id
  limit 1;

  if v_pass.id is null then
    raise exception 'Visitor pass was not found.';
  end if;

  if lower(coalesce(v_pass.current_status, '')) not in ('approved', 'expected') then
    raise exception 'Visitor pass is not pending guard action.';
  end if;

  if v_decision in ('approved', 'approve', 'allow', 'allowed') then
    v_status := 'checked_in';
    v_log_status := 'completed';
    v_log_title := 'Visitor approved at gate';
    v_log_details :=
      format(
        '%s checked in %s for unit %s.',
        v_guard_name,
        v_pass.visitor_name,
        coalesce(v_pass.unit_number, '-')
      );
  elsif v_decision in ('denied', 'deny', 'rejected', 'reject') then
    v_status := 'denied';
    v_log_status := 'denied';
    v_log_title := 'Visitor denied at gate';
    v_log_details :=
      format(
        '%s denied entry for %s visiting unit %s.',
        v_guard_name,
        v_pass.visitor_name,
        coalesce(v_pass.unit_number, '-')
      );
  else
    raise exception 'Unsupported guard decision: %', p_decision;
  end if;

  update public.visitor_passes
  set status = v_status
  where id = p_pass_id;

  insert into public.guard_duty_logs (
    guard_user_id,
    title,
    details,
    related_visitor_name,
    related_unit,
    log_status,
    logged_at
  )
  values (
    p_guard_user_id,
    v_log_title,
    v_log_details,
    v_pass.visitor_name,
    v_pass.unit_number,
    v_log_status,
    now()
  )
  returning id into v_log_id;

  return query
  select
    v_pass.id,
    v_log_id,
    v_pass.visitor_name,
    v_pass.unit_number,
    v_status;
end;
$$;

create or replace function public.process_guard_qr_entry(
  p_guard_user_id uuid,
  p_code text,
  p_decision text default 'approved'
)
returns table (
  pass_id uuid,
  log_id uuid,
  visitor_name text,
  unit_number text,
  status text
)
language plpgsql
security definer
set search_path = public
as $$
declare
  v_pass_id uuid;
begin
  select id
  into v_pass_id
  from public.visitor_passes
  where qr_token = trim(p_code)
     or pin_code = trim(p_code)
  order by expected_arrival desc
  limit 1;

  if v_pass_id is null then
    raise exception 'No visitor pass matched that QR or PIN code.';
  end if;

  return query
  select *
  from public.process_guard_visitor_pass(
    p_guard_user_id,
    v_pass_id,
    p_decision
  );
end;
$$;

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
where vp.status in ('approved', 'expected')
order by vp.expected_arrival asc;

grant execute on function public.create_resident_app_user(text, text, text, text, public.resident_kind, text, text) to anon, authenticated;
grant execute on function public.create_visitor_pass(uuid, text, text, public.visitor_kind, timestamptz) to anon, authenticated;
grant execute on function public.create_resident_complaint(uuid, text, text, text, text) to anon, authenticated;
grant execute on function public.create_announcement(uuid, public.notice_kind, text, text, text, public.announcement_state, timestamptz) to anon, authenticated;
grant execute on function public.create_guard_visitor_entry(uuid, text, text, text, text, public.visitor_kind, text) to anon, authenticated;
grant execute on function public.process_guard_visitor_pass(uuid, uuid, text) to anon, authenticated;
grant execute on function public.process_guard_qr_entry(uuid, text, text) to anon, authenticated;

do $$
begin
  if not exists (
    select 1
    from pg_publication_tables
    where pubname = 'supabase_realtime'
      and schemaname = 'public'
      and tablename = 'notifications'
  ) then
    alter publication supabase_realtime add table public.notifications;
  end if;
exception
  when undefined_table or undefined_object then null;
end;
$$;
