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

grant execute on function public.create_resident_app_user(text, text, text, text, public.resident_kind, text, text) to anon, authenticated;
grant execute on function public.create_visitor_pass(uuid, text, text, public.visitor_kind, timestamptz) to anon, authenticated;
grant execute on function public.create_resident_complaint(uuid, text, text, text, text) to anon, authenticated;
grant execute on function public.create_announcement(uuid, public.notice_kind, text, text, text, public.announcement_state, timestamptz) to anon, authenticated;

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
