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

drop function if exists public.create_admin_amenity(uuid, text, text, text, text, text, text, text, integer, boolean, text, text, text[]);

create or replace function public.create_admin_amenity(
  p_admin_user_id uuid,
  p_name text,
  p_category text,
  p_description text,
  p_location_label text,
  p_status_label text default 'OPEN',
  p_availability_text text default null,
  p_occupancy_note text default null,
  p_capacity_percent integer default 0,
  p_booking_required boolean default true,
  p_image_url text default null,
  p_access_note text default null,
  p_rules text[] default '{}',
  p_time_slots jsonb default '[]'::jsonb
)
returns table (
  amenity_id uuid,
  code text,
  name text,
  status_label text
)
language plpgsql
security definer
set search_path = public
as $$
declare
  v_admin_exists boolean;
  v_amenity_id uuid;
  v_code text := lower(regexp_replace(trim(p_name), '[^a-zA-Z0-9]+', '-', 'g'));
  v_slot_record jsonb;
  v_slot_order bigint;
  v_start_text text;
  v_end_text text;
  v_capacity_text text;
  v_capacity integer;
begin
  select exists (
    select 1
    from public.app_users
    where id = p_admin_user_id
      and role = 'admin'
  )
  into v_admin_exists;

  if not v_admin_exists then
    raise exception 'Only an admin user can create amenities.';
  end if;

  v_code := trim(both '-' from v_code);
  if v_code = '' then
    v_code := 'amenity-' || lower(substr(replace(gen_random_uuid()::text, '-', ''), 1, 8));
  end if;

  if exists (
    select 1
    from public.amenities amenity_record
    where amenity_record.code = v_code
  ) then
    raise exception 'An amenity named "%" already exists. Choose a different name.', trim(p_name);
  end if;

  insert into public.amenities (
    code,
    name,
    category,
    description,
    location_label,
    availability_text,
    occupancy_note,
    status_label,
    cta_label,
    image_url,
    available_now,
    booking_required,
    capacity_percent,
    access_note,
    rules,
    sort_order,
    created_at
  )
  values (
    v_code,
    trim(p_name),
    trim(p_category),
    trim(p_description),
    trim(p_location_label),
    nullif(trim(coalesce(p_availability_text, '')), ''),
    nullif(trim(coalesce(p_occupancy_note, '')), ''),
    upper(trim(coalesce(p_status_label, 'OPEN'))),
    case when coalesce(p_booking_required, true) then 'Reserve' else 'View Details' end,
    nullif(trim(coalesce(p_image_url, '')), ''),
    upper(trim(coalesce(p_status_label, 'OPEN'))) in ('OPEN', 'AVAILABLE', 'ACTIVE'),
    coalesce(p_booking_required, true),
    greatest(0, least(100, coalesce(p_capacity_percent, 0))),
    nullif(trim(coalesce(p_access_note, '')), ''),
    coalesce(p_rules, '{}'),
    99,
    now()
  )
  returning id into v_amenity_id;

  for v_slot_record, v_slot_order in
    select slot_record, slot_order
    from jsonb_array_elements(coalesce(p_time_slots, '[]'::jsonb)) with ordinality as slot_data(slot_record, slot_order)
  loop
    v_start_text := trim(coalesce(v_slot_record->>'start_time', ''));
    v_end_text := trim(coalesce(v_slot_record->>'end_time', ''));
    v_capacity_text := trim(coalesce(v_slot_record->>'capacity', '1'));

    if v_start_text = '' or v_end_text = '' then
      continue;
    end if;

    if v_start_text !~ '^([01][0-9]|2[0-3]):[0-5][0-9]$'
       or v_end_text !~ '^([01][0-9]|2[0-3]):[0-5][0-9]$' then
      raise exception 'Invalid time slot format. Use HH:MM values, for example 08:00.';
    end if;

    if v_capacity_text !~ '^[0-9]+$' then
      raise exception 'Invalid slot capacity. Use numeric values only.';
    end if;

    v_capacity := greatest(1, least(200, v_capacity_text::integer));

    insert into public.amenity_time_slots (
      amenity_id,
      start_time,
      end_time,
      slot_capacity,
      is_active,
      sort_order,
      created_at
    )
    values (
      v_amenity_id,
      v_start_text::time,
      v_end_text::time,
      v_capacity,
      true,
      greatest(v_slot_order::integer - 1, 0),
      now()
    );
  end loop;

  return query
  select
    v_amenity_id,
    v_code,
    trim(p_name),
    upper(trim(coalesce(p_status_label, 'OPEN')));
end;
$$;

create or replace function public.update_admin_amenity(
  p_admin_user_id uuid,
  p_amenity_id uuid,
  p_name text,
  p_category text,
  p_description text,
  p_location_label text,
  p_status_label text default 'OPEN',
  p_availability_text text default null,
  p_occupancy_note text default null,
  p_capacity_percent integer default 0,
  p_booking_required boolean default true,
  p_image_url text default null,
  p_access_note text default null,
  p_rules text[] default '{}',
  p_time_slots jsonb default '[]'::jsonb
)
returns table (
  amenity_id uuid,
  code text,
  name text,
  status_label text
)
language plpgsql
security definer
set search_path = public
as $$
declare
  v_admin_exists boolean;
  v_amenity public.amenities%rowtype;
  v_slot_record jsonb;
  v_slot_order bigint;
  v_start_text text;
  v_end_text text;
  v_capacity_text text;
  v_capacity integer;
  v_status text := upper(trim(coalesce(p_status_label, 'OPEN')));
begin
  select exists (
    select 1
    from public.app_users
    where id = p_admin_user_id
      and role = 'admin'
  )
  into v_admin_exists;

  if not v_admin_exists then
    raise exception 'Only an admin user can update amenities.';
  end if;

  select *
  into v_amenity
  from public.amenities
  where id = p_amenity_id
  limit 1;

  if v_amenity.id is null then
    raise exception 'Amenity was not found.';
  end if;

  update public.amenities
  set
    name = trim(p_name),
    category = trim(p_category),
    description = trim(p_description),
    location_label = trim(p_location_label),
    availability_text = nullif(trim(coalesce(p_availability_text, '')), ''),
    occupancy_note = nullif(trim(coalesce(p_occupancy_note, '')), ''),
    status_label = v_status,
    cta_label = case when coalesce(p_booking_required, true) then 'Reserve' else 'View Details' end,
    image_url = nullif(trim(coalesce(p_image_url, '')), ''),
    available_now = v_status in ('OPEN', 'AVAILABLE', 'ACTIVE'),
    booking_required = coalesce(p_booking_required, true),
    capacity_percent = greatest(0, least(100, coalesce(p_capacity_percent, 0))),
    access_note = nullif(trim(coalesce(p_access_note, '')), ''),
    rules = coalesce(p_rules, '{}')
  where id = p_amenity_id;

  delete from public.amenity_time_slots time_slot_record
  where time_slot_record.amenity_id = p_amenity_id;

  for v_slot_record, v_slot_order in
    select slot_record, slot_order
    from jsonb_array_elements(coalesce(p_time_slots, '[]'::jsonb)) with ordinality as slot_data(slot_record, slot_order)
  loop
    v_start_text := trim(coalesce(v_slot_record->>'start_time', ''));
    v_end_text := trim(coalesce(v_slot_record->>'end_time', ''));
    v_capacity_text := trim(coalesce(v_slot_record->>'capacity', '1'));

    if v_start_text = '' or v_end_text = '' then
      continue;
    end if;

    if v_start_text !~ '^([01][0-9]|2[0-3]):[0-5][0-9]$'
       or v_end_text !~ '^([01][0-9]|2[0-3]):[0-5][0-9]$' then
      raise exception 'Invalid time slot format. Use HH:MM values, for example 08:00.';
    end if;

    if v_capacity_text !~ '^[0-9]+$' then
      raise exception 'Invalid slot capacity. Use numeric values only.';
    end if;

    v_capacity := greatest(1, least(200, v_capacity_text::integer));

    insert into public.amenity_time_slots (
      amenity_id,
      start_time,
      end_time,
      slot_capacity,
      is_active,
      sort_order,
      created_at
    )
    values (
      p_amenity_id,
      v_start_text::time,
      v_end_text::time,
      v_capacity,
      true,
      greatest(v_slot_order::integer - 1, 0),
      now()
    );
  end loop;

  return query
  select
    updated_amenity.id,
    updated_amenity.code,
    updated_amenity.name,
    updated_amenity.status_label
  from public.amenities updated_amenity
  where updated_amenity.id = p_amenity_id;
end;
$$;

create or replace function public.update_admin_amenity_status(
  p_admin_user_id uuid,
  p_amenity_id uuid,
  p_status_label text
)
returns table (
  amenity_id uuid,
  code text,
  name text,
  status_label text
)
language plpgsql
security definer
set search_path = public
as $$
declare
  v_admin_exists boolean;
  v_status text := upper(trim(coalesce(p_status_label, 'OPEN')));
begin
  select exists (
    select 1
    from public.app_users
    where id = p_admin_user_id
      and role = 'admin'
  )
  into v_admin_exists;

  if not v_admin_exists then
    raise exception 'Only an admin user can update amenities.';
  end if;

  if not exists (
    select 1
    from public.amenities
    where id = p_amenity_id
  ) then
    raise exception 'Amenity was not found.';
  end if;

  update public.amenities
  set
    status_label = v_status,
    available_now = v_status in ('OPEN', 'AVAILABLE', 'ACTIVE')
  where id = p_amenity_id;

  return query
  select
    updated_amenity.id,
    updated_amenity.code,
    updated_amenity.name,
    updated_amenity.status_label
  from public.amenities updated_amenity
  where updated_amenity.id = p_amenity_id;
end;
$$;

create or replace function public.create_admin_service_provider(
  p_admin_user_id uuid,
  p_full_name text,
  p_specialty text,
  p_phone text,
  p_experience_label text default null,
  p_availability_status text default 'available',
  p_rating numeric default 4.8,
  p_jobs_completed integer default 0,
  p_image_url text default null,
  p_notes text default null
)
returns table (
  service_provider_id uuid,
  full_name text,
  specialty text,
  availability_status text
)
language plpgsql
security definer
set search_path = public
as $$
declare
  v_admin_exists boolean;
  v_provider_id uuid;
begin
  select exists (
    select 1
    from public.app_users
    where id = p_admin_user_id
      and role = 'admin'
  )
  into v_admin_exists;

  if not v_admin_exists then
    raise exception 'Only an admin user can create service providers.';
  end if;

  insert into public.service_providers (
    full_name,
    specialty,
    phone,
    experience_label,
    availability_status,
    rating,
    jobs_completed,
    image_url,
    notes,
    created_at
  )
  values (
    trim(p_full_name),
    trim(p_specialty),
    trim(p_phone),
    nullif(trim(coalesce(p_experience_label, '')), ''),
    lower(trim(coalesce(p_availability_status, 'available'))),
    coalesce(p_rating, 4.8),
    greatest(coalesce(p_jobs_completed, 0), 0),
    nullif(trim(coalesce(p_image_url, '')), ''),
    nullif(trim(coalesce(p_notes, '')), ''),
    now()
  )
  returning id into v_provider_id;

  return query
  select
    v_provider_id,
    trim(p_full_name),
    trim(p_specialty),
    lower(trim(coalesce(p_availability_status, 'available')));
end;
$$;

drop function if exists public.create_amenity_booking(uuid, uuid, date, text, integer);

create or replace function public.create_amenity_booking(
  p_user_id uuid,
  p_amenity_id uuid,
  p_booking_date date,
  p_time_slot text,
  p_guest_count integer default 1
)
returns table (
  booking_id uuid,
  amenity_id uuid,
  booking_date date,
  time_slot text,
  booking_status text
)
language plpgsql
security definer
set search_path = public
as $$
declare
  v_booking_id uuid;
  v_user_is_resident boolean;
  v_amenity record;
  v_clean_time_slot text := trim(coalesce(p_time_slot, ''));
  v_guest_count integer := coalesce(p_guest_count, 1);
begin
  if p_user_id is null then
    raise exception 'Please sign in before booking an amenity.';
  end if;

  select exists (
    select 1
    from public.app_users
    where id = p_user_id
      and role = 'resident'
      and status = 'active'
  )
  into v_user_is_resident;

  if not v_user_is_resident then
    raise exception 'Only active residents can book amenities.';
  end if;

  select
    a.id,
    a.name,
    a.available_now,
    a.booking_required,
    a.status_label
  into v_amenity
  from public.amenities a
  where a.id = p_amenity_id
  limit 1;

  if v_amenity.id is null then
    raise exception 'Amenity was not found.';
  end if;

  if not coalesce(v_amenity.booking_required, true) then
    raise exception '% does not require booking.', v_amenity.name;
  end if;

  if not coalesce(v_amenity.available_now, false)
     or lower(coalesce(v_amenity.status_label, '')) in ('maintenance', 'closed', 'reserved') then
    raise exception '% is not available for booking right now.', v_amenity.name;
  end if;

  if p_booking_date < current_date then
    raise exception 'Please choose today or a future date.';
  end if;

  if p_booking_date > current_date + 30 then
    raise exception 'Amenity bookings can only be made up to 30 days in advance.';
  end if;

  if v_clean_time_slot = '' then
    raise exception 'Please choose a time slot.';
  end if;

  if v_guest_count < 0 or v_guest_count > 4 then
    raise exception 'Guest count must be between 0 and 4.';
  end if;

  if exists (
    select 1
    from public.amenity_bookings booking
    where booking.user_id = p_user_id
      and booking.amenity_id = p_amenity_id
      and booking.booking_date = p_booking_date
      and lower(trim(booking.time_slot)) = lower(v_clean_time_slot)
      and booking.booking_status in ('confirmed', 'pending')
  ) then
    raise exception 'You already booked this amenity for the selected date and time.';
  end if;

  insert into public.amenity_bookings (
    user_id,
    amenity_id,
    booking_date,
    time_slot,
    guest_count,
    booking_status,
    booking_fee,
    created_at
  )
  values (
    p_user_id,
    p_amenity_id,
    p_booking_date,
    v_clean_time_slot,
    v_guest_count,
    'confirmed',
    0,
    now()
  )
  returning id into v_booking_id;

  return query
  select
    v_booking_id,
    p_amenity_id,
    p_booking_date,
    v_clean_time_slot,
    'confirmed';
exception
  when unique_violation then
    raise exception 'You already booked this amenity for the selected date and time.';
end;
$$;

drop function if exists public.create_resident_complaint(uuid, text, text, text, text);

create or replace function public.create_resident_complaint(
  p_user_id uuid,
  p_category text,
  p_title text,
  p_description text,
  p_location_label text default null,
  p_urgency text default 'normal',
  p_preferred_access_time text default null,
  p_photo_url text default null,
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
  v_category text := lower(trim(coalesce(p_category, 'other')));
  v_urgency text := lower(trim(coalesce(p_urgency, 'normal')));
begin
  if v_urgency not in ('low', 'normal', 'urgent') then
    v_urgency := 'normal';
  end if;

  insert into public.complaints (
    user_id,
    code,
    category,
    title,
    description,
    location_label,
    urgency,
    preferred_access_time,
    photo_url,
    state,
    assigned_to,
    admin_notes,
    resolution_note,
    meta_label,
    meta_value,
    icon_name,
    accent_hex,
    created_at,
    updated_at,
    resolved_at
  )
  values (
    p_user_id,
    v_code,
    v_category,
    trim(p_title),
    trim(p_description),
    nullif(trim(coalesce(p_location_label, '')), ''),
    v_urgency,
    nullif(trim(coalesce(p_preferred_access_time, '')), ''),
    nullif(trim(coalesce(p_photo_url, '')), ''),
    'pending',
    null,
    null,
    null,
    'STATUS',
    'Awaiting Assignment',
    p_icon_name,
    p_accent_hex,
    now(),
    now(),
    null
  )
  returning id into v_complaint_id;

  return query
  select
    v_complaint_id,
    v_code,
    trim(p_title),
    'pending'::public.complaint_state;
end;
$$;

create or replace function public.update_complaint_admin_status(
  p_admin_user_id uuid,
  p_complaint_id uuid,
  p_state public.complaint_state,
  p_assigned_to text default null,
  p_admin_notes text default null,
  p_resolution_note text default null
)
returns table (
  complaint_id uuid,
  code text,
  state public.complaint_state,
  assigned_to text
)
language plpgsql
security definer
set search_path = public
as $$
declare
  v_admin_name text;
  v_complaint record;
  v_assigned_to text := nullif(trim(coalesce(p_assigned_to, '')), '');
  v_admin_notes text := nullif(trim(coalesce(p_admin_notes, '')), '');
  v_resolution_note text := nullif(trim(coalesce(p_resolution_note, '')), '');
  v_meta_label text;
  v_meta_value text;
  v_resolved_at timestamptz;
begin
  select full_name
  into v_admin_name
  from public.app_users
  where id = p_admin_user_id
    and role = 'admin'
  limit 1;

  if v_admin_name is null then
    raise exception 'Only an admin user can review complaints.';
  end if;

  select
    c.id,
    c.code,
    c.user_id,
    c.title,
    c.assigned_to
  into v_complaint
  from public.complaints c
  where c.id = p_complaint_id
  limit 1;

  if v_complaint.id is null then
    raise exception 'Complaint was not found.';
  end if;

  if p_state = 'in_progress' then
    v_meta_label := 'ASSIGNED TO';
    v_meta_value := coalesce(v_assigned_to, v_complaint.assigned_to, 'Maintenance Team');
    v_resolved_at := null;
  elsif p_state = 'resolved' then
    v_meta_label := 'RESOLVED BY';
    v_meta_value := coalesce(v_assigned_to, v_complaint.assigned_to, v_admin_name);
    v_resolved_at := now();
  elsif p_state = 'pending' then
    v_meta_label := 'STATUS';
    v_meta_value := 'Awaiting Assignment';
    v_resolved_at := null;
  else
    raise exception 'Unsupported complaint state: %', p_state;
  end if;

  update public.complaints c
  set
    state = p_state,
    assigned_to = case
      when p_state = 'pending' then null
      else coalesce(v_assigned_to, c.assigned_to, v_meta_value)
    end,
    admin_notes = coalesce(v_admin_notes, c.admin_notes),
    resolution_note = case
      when p_state = 'resolved' then coalesce(v_resolution_note, c.resolution_note)
      else c.resolution_note
    end,
    meta_label = v_meta_label,
    meta_value = v_meta_value,
    resolved_at = v_resolved_at
  where c.id = p_complaint_id;

  insert into public.notifications (
    user_id,
    kind,
    title,
    body,
    badge_label,
    action_label,
    image_url,
    is_unread,
    created_at
  )
  values (
    v_complaint.user_id,
    'complaint',
    'Complaint ' || v_complaint.code || ' updated',
    case
      when p_state = 'resolved' then 'Your complaint "' || v_complaint.title || '" has been resolved.'
      when p_state = 'in_progress' then 'Your complaint "' || v_complaint.title || '" is now assigned to ' || v_meta_value || '.'
      else 'Your complaint "' || v_complaint.title || '" is back under review.'
    end,
    upper(replace(p_state::text, '_', ' ')),
    'VIEW COMPLAINT',
    null,
    true,
    now()
  );

  return query
  select
    c.id,
    c.code,
    c.state,
    c.assigned_to
  from public.complaints c
  where c.id = p_complaint_id;
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

drop function if exists public.create_community_suggestion(uuid, text, text, text, text, text, boolean, integer, text, text, text);

create or replace function public.create_community_suggestion(
  p_user_id uuid,
  p_title text,
  p_category text,
  p_summary text,
  p_details text,
  p_audience_scope text default 'all_residents',
  p_poll_enabled boolean default true,
  p_target_votes integer default 24,
  p_cover_image_url text default null,
  p_icon_name text default 'lightbulb',
  p_accent_hex text default '#005BBF',
  p_selected_resident_ids uuid[] default '{}'
)
returns table (
  suggestion_id uuid,
  title text,
  category text,
  status text
)
language plpgsql
security definer
set search_path = public
as $$
declare
  v_suggestion_id uuid;
  v_audience_scope text := lower(trim(coalesce(p_audience_scope, 'all_residents')));
  v_selected_count integer;
begin
  if v_audience_scope = 'selected_residents' then
    v_selected_count := coalesce(array_length(p_selected_resident_ids, 1), 0);
    if v_selected_count = 0 then
      raise exception 'Select at least one resident for a selected audience suggestion.';
    end if;
  end if;

  insert into public.community_suggestions (
    created_by,
    title,
    category,
    summary,
    details,
    audience_scope,
    icon_name,
    accent_hex,
    cover_image_url,
    poll_enabled,
    target_votes,
    votes_in_favor,
    votes_needs_review,
    status,
    created_at
  )
  values (
    p_user_id,
    trim(p_title),
    trim(p_category),
    trim(p_summary),
    trim(p_details),
    v_audience_scope,
    trim(coalesce(p_icon_name, 'lightbulb')),
    coalesce(p_accent_hex, '#005BBF'),
    nullif(trim(coalesce(p_cover_image_url, '')), ''),
    coalesce(p_poll_enabled, true),
    greatest(coalesce(p_target_votes, 24), 1),
    0,
    0,
    'review',
    now()
  )
  returning id into v_suggestion_id;

  if v_audience_scope = 'selected_residents' then
    if exists (
      select 1
      from unnest(p_selected_resident_ids) resident_id
      left join public.app_users resident
        on resident.id = resident_id
      where resident.id is null
         or resident.role <> 'resident'
    ) then
      raise exception 'One or more selected residents are invalid.';
    end if;

    insert into public.community_suggestion_target_residents (
      suggestion_id,
      resident_user_id,
      created_at
    )
    select
      v_suggestion_id,
      resident_id,
      now()
    from unnest(p_selected_resident_ids) resident_id
    on conflict on constraint community_suggestion_target_residents_pkey do nothing;
  end if;

  return query
  select
    v_suggestion_id,
    trim(p_title),
    trim(p_category),
    'review';
end;
$$;

create or replace function public.review_community_suggestion(
  p_admin_user_id uuid,
  p_suggestion_id uuid,
  p_decision text default 'published'
)
returns table (
  suggestion_id uuid,
  title text,
  status text,
  reviewed_at timestamptz
)
language plpgsql
security definer
set search_path = public
as $$
declare
  v_admin_name text;
  v_status text := lower(trim(coalesce(p_decision, 'published')));
  v_reviewed_at timestamptz := now();
  v_suggestion_id uuid;
  v_title text;
begin
  select full_name
  into v_admin_name
  from public.app_users
  where id = p_admin_user_id
    and role = 'admin'
  limit 1;

  if v_admin_name is null then
    raise exception 'Only an admin user can review community suggestions.';
  end if;

  if v_status in ('publish', 'published', 'approve', 'approved', 'active') then
    v_status := 'published';
  elsif v_status in ('reject', 'rejected', 'decline', 'declined') then
    v_status := 'rejected';
  else
    raise exception 'Unsupported community review decision: %', p_decision;
  end if;

  update public.community_suggestions
  set
    status = v_status,
    reviewed_by = p_admin_user_id,
    reviewed_at = v_reviewed_at,
    published_at = case
      when v_status = 'published' then v_reviewed_at
      else public.community_suggestions.published_at
    end
  where id = p_suggestion_id
    and public.community_suggestions.status in (
      'review',
      'published',
      'active',
      'rejected'
    )
  returning id, public.community_suggestions.title
  into v_suggestion_id, v_title;

  if v_suggestion_id is null then
    raise exception 'Community suggestion not found.';
  end if;

  if v_status = 'published' then
    insert into public.community_suggestion_members (
      suggestion_id,
      user_id,
      joined_at
    )
    select
      s.id,
      s.created_by,
      v_reviewed_at
    from public.community_suggestions s
    join public.app_users creator on creator.id = s.created_by
    where s.id = v_suggestion_id
      and creator.role = 'resident'
      and creator.status = 'active'
    on conflict on constraint community_suggestion_members_pkey do nothing;
  end if;

  return query
  select
    v_suggestion_id,
    v_title,
    v_status,
    v_reviewed_at;
end;
$$;

create or replace function public.join_community_suggestion(
  p_user_id uuid,
  p_suggestion_id uuid
)
returns table (
  suggestion_id uuid,
  user_id uuid,
  joined_at timestamptz
)
language plpgsql
security definer
set search_path = public
as $$
declare
  v_joined_at timestamptz := now();
begin
  if not exists (
    select 1
    from public.app_users
    where id = p_user_id
      and role = 'resident'
      and status = 'active'
  ) then
    raise exception 'Only an active resident can join community suggestions.';
  end if;

  if not exists (
    select 1
    from public.community_suggestions
    where id = p_suggestion_id
      and status in ('published', 'active')
  ) then
    raise exception 'Community suggestion is not open for joining.';
  end if;

  insert into public.community_suggestion_members (
    suggestion_id,
    user_id,
    joined_at
  )
  values (
    p_suggestion_id,
    p_user_id,
    v_joined_at
  )
  on conflict on constraint community_suggestion_members_pkey
  do update set joined_at = public.community_suggestion_members.joined_at
  returning
    public.community_suggestion_members.suggestion_id,
    public.community_suggestion_members.user_id,
    public.community_suggestion_members.joined_at
  into suggestion_id, user_id, joined_at;

  return next;
end;
$$;

create or replace function public.vote_community_suggestion(
  p_user_id uuid,
  p_suggestion_id uuid,
  p_vote_kind text default 'in_favor'
)
returns table (
  suggestion_id uuid,
  vote_kind text,
  votes_in_favor integer,
  votes_needs_review integer,
  total_votes integer,
  support_percent integer
)
language plpgsql
security definer
set search_path = public
as $$
declare
  v_vote_kind text := lower(trim(coalesce(p_vote_kind, 'in_favor')));
  v_existing_vote text;
  v_votes_in_favor integer;
  v_votes_needs_review integer;
begin
  if v_vote_kind in ('support', 'in_favor', 'favor', 'yes') then
    v_vote_kind := 'in_favor';
  elsif v_vote_kind in ('needs_review', 'review', 'no') then
    v_vote_kind := 'needs_review';
  else
    raise exception 'Unsupported vote kind: %', p_vote_kind;
  end if;

  if not exists (
    select 1
    from public.app_users
    where id = p_user_id
      and role = 'resident'
      and status = 'active'
  ) then
    raise exception 'Only an active resident can vote on community suggestions.';
  end if;

  if not exists (
    select 1
    from public.community_suggestions
    where id = p_suggestion_id
      and status in ('published', 'active')
      and poll_enabled = true
  ) then
    raise exception 'Community suggestion is not open for voting.';
  end if;

  if not exists (
    select 1
    from public.community_suggestion_members member_record
    where member_record.suggestion_id = p_suggestion_id
      and member_record.user_id = p_user_id
  ) then
    raise exception 'Join this community suggestion before voting.';
  end if;

  select vote_record.vote_kind
  into v_existing_vote
  from public.community_suggestion_votes vote_record
  where vote_record.suggestion_id = p_suggestion_id
    and vote_record.user_id = p_user_id;

  insert into public.community_suggestion_votes (
    suggestion_id,
    user_id,
    vote_kind,
    created_at,
    updated_at
  )
  values (
    p_suggestion_id,
    p_user_id,
    v_vote_kind,
    now(),
    now()
  )
  on conflict on constraint community_suggestion_votes_pkey
  do update set
    vote_kind = excluded.vote_kind,
    updated_at = now();

  update public.community_suggestions
  set
    votes_in_favor = greatest(
      public.community_suggestions.votes_in_favor
      + case
        when v_vote_kind = 'in_favor' and coalesce(v_existing_vote, '') <> 'in_favor' then 1
        else 0
      end
      - case
        when v_existing_vote = 'in_favor' and v_vote_kind <> 'in_favor' then 1
        else 0
      end,
      0
    ),
    votes_needs_review = greatest(
      public.community_suggestions.votes_needs_review
      + case
        when v_vote_kind = 'needs_review' and coalesce(v_existing_vote, '') <> 'needs_review' then 1
        else 0
      end
      - case
        when v_existing_vote = 'needs_review' and v_vote_kind <> 'needs_review' then 1
        else 0
      end,
      0
    )
  where id = p_suggestion_id
  returning
    public.community_suggestions.votes_in_favor,
    public.community_suggestions.votes_needs_review
  into v_votes_in_favor, v_votes_needs_review;

  return query
  select
    p_suggestion_id,
    v_vote_kind,
    v_votes_in_favor,
    v_votes_needs_review,
    (v_votes_in_favor + v_votes_needs_review),
    case
      when (v_votes_in_favor + v_votes_needs_review) = 0 then 0
      else round((v_votes_in_favor::numeric / (v_votes_in_favor + v_votes_needs_review)::numeric) * 100)::integer
    end;
end;
$$;

create or replace function public.add_community_suggestion_comment(
  p_user_id uuid,
  p_suggestion_id uuid,
  p_body text
)
returns table (
  comment_id uuid,
  suggestion_id uuid,
  body text,
  created_at timestamptz
)
language plpgsql
security definer
set search_path = public
as $$
declare
  v_comment_id uuid;
  v_created_at timestamptz := now();
begin
  if not exists (
    select 1
    from public.app_users
    where id = p_user_id
      and role = 'resident'
      and status = 'active'
  ) then
    raise exception 'Only an active resident can comment on community suggestions.';
  end if;

  if not exists (
    select 1
    from public.community_suggestions
    where id = p_suggestion_id
      and status in ('published', 'active')
  ) then
    raise exception 'Community suggestion is not open for comments.';
  end if;

  if not exists (
    select 1
    from public.community_suggestion_members member_record
    where member_record.suggestion_id = p_suggestion_id
      and member_record.user_id = p_user_id
  ) then
    raise exception 'Join this community suggestion before commenting.';
  end if;

  insert into public.community_suggestion_comments (
    suggestion_id,
    user_id,
    body,
    created_at
  )
  values (
    p_suggestion_id,
    p_user_id,
    trim(p_body),
    v_created_at
  )
  returning id into v_comment_id;

  return query
  select
    v_comment_id,
    p_suggestion_id,
    trim(p_body),
    v_created_at;
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

create or replace function public.set_guard_attendance(
  p_guard_user_id uuid,
  p_action text,
  p_notes text default null
)
returns table (
  attendance_id uuid,
  guard_user_id uuid,
  attendance_date date,
  check_in_at timestamptz,
  check_out_at timestamptz,
  status text,
  notes text
)
language plpgsql
security definer
set search_path = public
as $$
declare
  v_action text := lower(trim(coalesce(p_action, '')));
  v_today date := current_date;
  v_attendance_id uuid;
  v_check_in_at timestamptz;
  v_check_out_at timestamptz;
  v_status text;
  v_notes text;
begin
  if not exists (
    select 1
    from public.app_users guard_user
    where guard_user.id = p_guard_user_id
      and guard_user.role = 'guard'
      and guard_user.status = 'active'
  ) then
    raise exception 'Only an active guard can mark attendance.';
  end if;

  if v_action not in ('check_in', 'check_out') then
    raise exception 'Unsupported attendance action: %', p_action;
  end if;

  insert into public.guard_attendance_logs (
    guard_user_id,
    attendance_date,
    check_in_at,
    check_out_at,
    status,
    notes,
    created_at,
    updated_at
  )
  values (
    p_guard_user_id,
    v_today,
    case when v_action = 'check_in' then now() else null end,
    null,
    case when v_action = 'check_in' then 'present' else 'pending' end,
    nullif(trim(coalesce(p_notes, '')), ''),
    now(),
    now()
  )
  on conflict on constraint guard_attendance_logs_unique_guard_day
  do update set
    check_in_at = case
      when v_action = 'check_in' and public.guard_attendance_logs.check_in_at is null then now()
      else public.guard_attendance_logs.check_in_at
    end,
    check_out_at = case
      when v_action = 'check_out' then now()
      else public.guard_attendance_logs.check_out_at
    end,
    status = case
      when v_action = 'check_out' then 'completed'
      when public.guard_attendance_logs.check_in_at is not null then public.guard_attendance_logs.status
      else 'present'
    end,
    notes = coalesce(
      nullif(trim(coalesce(p_notes, '')), ''),
      public.guard_attendance_logs.notes
    ),
    updated_at = now()
  returning
    id,
    public.guard_attendance_logs.check_in_at,
    public.guard_attendance_logs.check_out_at,
    public.guard_attendance_logs.status,
    public.guard_attendance_logs.notes
  into v_attendance_id, v_check_in_at, v_check_out_at, v_status, v_notes;

  if v_action = 'check_out' and v_check_in_at is null then
    raise exception 'Check-in is required before check-out.';
  end if;

  return query
  select
    v_attendance_id,
    p_guard_user_id,
    v_today,
    v_check_in_at,
    v_check_out_at,
    v_status,
    v_notes;
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
grant execute on function public.create_admin_amenity(uuid, text, text, text, text, text, text, text, integer, boolean, text, text, text[], jsonb) to anon, authenticated;
grant execute on function public.update_admin_amenity(uuid, uuid, text, text, text, text, text, text, text, integer, boolean, text, text, text[], jsonb) to anon, authenticated;
grant execute on function public.update_admin_amenity_status(uuid, uuid, text) to anon, authenticated;
grant execute on function public.create_admin_service_provider(uuid, text, text, text, text, text, numeric, integer, text, text) to anon, authenticated;
grant execute on function public.create_amenity_booking(uuid, uuid, date, text, integer) to anon, authenticated;
grant execute on function public.create_resident_complaint(uuid, text, text, text, text, text, text, text, text, text) to anon, authenticated;
grant execute on function public.update_complaint_admin_status(uuid, uuid, public.complaint_state, text, text, text) to anon, authenticated;
grant execute on function public.create_announcement(uuid, public.notice_kind, text, text, text, public.announcement_state, timestamptz) to anon, authenticated;
grant execute on function public.create_community_suggestion(uuid, text, text, text, text, text, boolean, integer, text, text, text, uuid[]) to anon, authenticated;
grant execute on function public.review_community_suggestion(uuid, uuid, text) to anon, authenticated;
grant execute on function public.join_community_suggestion(uuid, uuid) to anon, authenticated;
grant execute on function public.vote_community_suggestion(uuid, uuid, text) to anon, authenticated;
grant execute on function public.add_community_suggestion_comment(uuid, uuid, text) to anon, authenticated;
grant execute on function public.create_guard_visitor_entry(uuid, text, text, text, text, public.visitor_kind, text) to anon, authenticated;
grant execute on function public.process_guard_visitor_pass(uuid, uuid, text) to anon, authenticated;
grant execute on function public.process_guard_qr_entry(uuid, text, text) to anon, authenticated;
grant execute on function public.set_guard_attendance(uuid, text, text) to anon, authenticated;

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
