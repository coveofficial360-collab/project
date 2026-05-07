-- Demo login checks
select * from public.authenticate_app_user('user@gmail.com', 'user', 'resident');
select * from public.authenticate_app_user('admin@gmail.com', 'admin', 'admin');
select * from public.authenticate_app_user('guard@gmail.com', 'guard', 'guard');

-- Resident home screen
select full_name, unit_number, tower, role, status
from public.app_users
where email = 'user@gmail.com';

select code, title, provider, category, state, badge_text, amount_due, due_date, action_label
from public.bills
where user_id = (select id from public.app_users where email = 'user@gmail.com')
order by coalesce(due_date, current_date + 365);

select code, kind, title, body, action_label, posted_at
from public.notices
order by posted_at desc;

select kind, title, body, badge_label, action_label, is_unread, created_at
from public.notifications
where user_id = (select id from public.app_users where email = 'user@gmail.com')
order by created_at desc;

-- Amenities and bookings
select
  code,
  name,
  category,
  status_label,
  availability_text,
  occupancy_note,
  cta_label,
  capacity_percent,
  access_note,
  rules
from public.amenities
order by sort_order asc, name;

select
  public.amenities.name,
  public.amenity_bookings.booking_date,
  public.amenity_bookings.time_slot,
  public.amenity_bookings.guest_count,
  public.amenity_bookings.booking_status
from public.amenity_bookings
join public.amenities on public.amenities.id = public.amenity_bookings.amenity_id
where public.amenity_bookings.user_id = (
  select id from public.app_users where email = 'user@gmail.com'
)
order by public.amenity_bookings.booking_date desc;

-- Reset only this demo booking slot so this test block can be rerun safely.
update public.amenity_bookings
set booking_status = 'cancelled_demo_rerun'
where user_id = (select id from public.app_users where email = 'user@gmail.com')
  and amenity_id = (select id from public.amenities where code = 'modern-gym')
  and booking_date = current_date + 2
  and lower(trim(time_slot)) = lower(trim('18:00 - 19:00'))
  and booking_status in ('confirmed', 'pending');

select *
from public.create_amenity_booking(
  (select id from public.app_users where email = 'user@gmail.com'),
  (select id from public.amenities where code = 'modern-gym'),
  current_date + 2,
  '18:00 - 19:00',
  1
);

-- This duplicate should be blocked with a friendly validation notice.
do $$
begin
  perform *
  from public.create_amenity_booking(
    (select id from public.app_users where email = 'user@gmail.com'),
    (select id from public.amenities where code = 'modern-gym'),
    current_date + 2,
    '18:00 - 19:00',
    1
  );
exception
  when others then
    raise notice 'Expected duplicate booking validation: %', sqlerrm;
end $$;

-- Bills and payments
select
  code,
  title,
  category,
  state,
  amount_due,
  amount_paid,
  due_date,
  last_paid_on,
  badge_text
from public.bills
where user_id = (select id from public.app_users where email = 'user@gmail.com')
  and lower(category) = 'maintenance'
order by due_date asc nulls last, created_at desc;

select method_name, method_type, masked_value, note, is_primary
from public.payment_methods
where user_id = (select id from public.app_users where email = 'user@gmail.com')
order by is_primary desc, created_at asc;

select activity_title, activity_category, amount, status, activity_at
from public.payment_activity
where user_id = (select id from public.app_users where email = 'user@gmail.com')
order by activity_at desc;

-- Resident maintenance pay action
select *
from public.pay_maintenance_bill(
  (select id from public.app_users where email = 'user@gmail.com'),
  (
    select id
    from public.bills
    where user_id = (select id from public.app_users where email = 'user@gmail.com')
      and lower(category) = 'maintenance'
      and state <> 'paid'
    order by due_date asc nulls last, created_at desc
    limit 1
  ),
  'UPI',
  'TXN-DEMO-1001'
);

-- Complaints
select
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
  created_at,
  resolved_at
from public.complaints
where user_id = (select id from public.app_users where email = 'user@gmail.com')
order by created_at desc;

-- Complaint write actions
select *
from public.create_resident_complaint(
  (select id from public.app_users where email = 'user@gmail.com'),
  'electrical',
  'Balcony socket not working',
  'The balcony power socket stopped working after last night''s rain.',
  'Balcony',
  'normal',
  'Tomorrow after 5 PM',
  null,
  'electrical_services',
  '#E2E3E8'
);

select *
from public.update_complaint_admin_status(
  (select id from public.app_users where email = 'admin@gmail.com'),
  (
    select id
    from public.complaints
    where code = 'CMP-8895'
    limit 1
  ),
  'in_progress',
  'Maintenance Desk',
  'Assigned from admin complaint queue.',
  null
);

-- Profile
select full_name, email, phone, unit_number, tower, resident_kind, status
from public.app_users
where email = 'user@gmail.com';

select full_name, relation
from public.household_members
where user_id = (select id from public.app_users where email = 'user@gmail.com')
order by created_at asc;

select registration_number, vehicle_name, vehicle_type
from public.vehicles
where user_id = (select id from public.app_users where email = 'user@gmail.com');

-- Visitors
select visitor_name, phone, visitor_kind, expected_arrival, status, pin_code, qr_token
from public.visitor_passes
where resident_user_id = (select id from public.app_users where email = 'user@gmail.com')
order by expected_arrival asc;

-- Admin dashboard, announcements, and resident directory
select * from public.admin_dashboard_metrics_v;

select title, subtitle, amount, status, created_at
from public.admin_transactions
order by created_at desc;

select state, kind, title, target_audience, reads_count, scheduled_for, created_at
from public.announcements
order by created_at desc;

select
  code,
  category,
  title,
  description,
  location_label,
  urgency,
  preferred_access_time,
  photo_url,
  state,
  resident_name,
  unit_number,
  assigned_to,
  admin_notes,
  resolution_note,
  created_at
from public.admin_complaints_v;

-- Admin maintenance views and actions
select
  resident_name,
  unit_number,
  code,
  amount_due,
  due_date,
  payment_status,
  months_overdue
from public.admin_maintenance_resident_log_v;

do $$
declare
  v_admin_id uuid;
  v_bill_id uuid;
begin
  select id
  into v_admin_id
  from public.app_users
  where email = 'admin@gmail.com'
  limit 1;

  select bill_id
  into v_bill_id
  from public.admin_maintenance_resident_log_v
  where payment_status <> 'paid'
  order by due_date asc nulls last
  limit 1;

  if v_bill_id is null then
    raise notice 'No unpaid maintenance bill found. Skipping admin_mark_maintenance_paid demo call.';
    return;
  end if;

  perform *
  from public.admin_mark_maintenance_paid(
    v_admin_id,
    v_bill_id,
    'Marked paid from maintenance dashboard.',
    current_date
  );
end $$;

do $$
declare
  v_admin_id uuid;
  v_target_resident_ids uuid[];
begin
  select id
  into v_admin_id
  from public.app_users
  where email = 'admin@gmail.com'
  limit 1;

  select array_agg(target_rows.user_id)
  into v_target_resident_ids
  from (
    select user_id
    from public.admin_maintenance_resident_log_v
    where payment_status in ('pending', 'overdue')
    order by due_date asc nulls last
    limit 3
  ) target_rows;

  if coalesce(array_length(v_target_resident_ids, 1), 0) = 0 then
    raise notice 'No pending/overdue residents found. Skipping send_maintenance_alerts demo call.';
    return;
  end if;

  perform *
  from public.send_maintenance_alerts(
    v_admin_id,
    v_target_resident_ids,
    'Hi [Resident Name], your maintenance of ₹[Amount] for [Month] is due on [Due Date]. Please complete payment from the Cove app.',
    array['push', 'email']
  );
end $$;

select *
from public.upsert_admin_maintenance_notification_settings(
  (select id from public.app_users where email = 'admin@gmail.com'),
  true,
  4,
  true,
  true,
  'weekly',
  true,
  true,
  true,
  false,
  'Hi [Resident Name], your maintenance of ₹[Amount] for [Month] is due on [Due Date]. Please pay soon to avoid late reminders.'
);

select *
from public.admin_maintenance_notification_settings
where admin_user_id = (select id from public.app_users where email = 'admin@gmail.com');

-- Treasurer dashboard, vendors, expenses, and quotations
select * from public.admin_treasurer_dashboard_v;

select
  company_name,
  service_type,
  contact_name,
  monthly_cost,
  contract_end_date,
  contract_health
from public.admin_vendor_directory_v
order by company_name asc;

select
  expense_date,
  category,
  vendor_name,
  amount,
  approval_status
from public.admin_expense_management_v
order by expense_date desc, created_at desc;

select
  month_bucket,
  income_total,
  expense_total,
  net_total
from public.admin_financial_monthly_summary_v
order by month_bucket desc;

select
  request_title,
  company_name,
  service_type,
  quoted_amount,
  staff_offered,
  service_rating
from public.admin_vendor_comparison_v
order by request_title asc nulls last, company_name asc;

do $$
begin
  if exists (
    select 1
    from public.finance_vendors
    where lower(trim(company_name)) = lower(trim('BluePeak Fire Safety'))
  ) then
    raise notice 'Treasurer demo vendor already exists. Skipping create_finance_vendor demo call.';
    return;
  end if;

  perform *
  from public.create_finance_vendor(
    (select id from public.app_users where email = 'admin@gmail.com'),
    'BluePeak Fire Safety',
    'Rohan Mehta',
    '+91 99880 11223',
    'ops@bluepeak.example',
    'Tower B Service Annex',
    'Maintenance',
    'Fire alarm checks, extinguisher refill, and compliance audits.',
    null,
    null,
    28500,
    null,
    6,
    'active',
    current_date - 20,
    current_date + 345,
    null,
    'Demo vendor created from screen queries.'
  );
end $$;

do $$
declare
  v_vendor_id uuid;
begin
  select id
  into v_vendor_id
  from public.finance_vendors
  where lower(trim(company_name)) = lower(trim('BluePeak Fire Safety'))
  limit 1;

  if v_vendor_id is null then
    raise notice 'BluePeak Fire Safety vendor not found. Skipping create_treasurer_expense demo call.';
    return;
  end if;

  perform *
  from public.create_treasurer_expense(
    (select id from public.app_users where email = 'admin@gmail.com'),
    current_date,
    'Maintenance',
    v_vendor_id,
    null,
    12850,
    'Fire alarm preventive maintenance visit.',
    'bank_transfer',
    null,
    'approved'
  );
end $$;

do $$
declare
  v_vendor_ids uuid[];
begin
  select array_agg(id order by company_name asc)
  into v_vendor_ids
  from (
    select id, company_name
    from public.finance_vendors
    where lower(trim(service_type)) in ('security', 'maintenance', 'housekeeping')
    limit 3
  ) picked_vendors;

  if coalesce(array_length(v_vendor_ids, 1), 0) = 0 then
    raise notice 'No vendors available for RFQ demo. Skipping create_vendor_quotation_request demo call.';
    return;
  end if;

  perform *
  from public.create_vendor_quotation_request(
    (select id from public.app_users where email = 'admin@gmail.com'),
    'Clubhouse Operations Support',
    'Housekeeping',
    current_date + 21,
    '12 months',
    95000,
    8,
    'Daily cleaning, event reset, and weekend support coverage.',
    v_vendor_ids
  );
end $$;

do $$
declare
  v_vendor_id uuid;
begin
  select id
  into v_vendor_id
  from public.finance_vendors
  where lower(trim(company_name)) = lower(trim('Titan Protection'))
  limit 1;

  if v_vendor_id is null then
    raise notice 'Titan Protection vendor not found. Skipping renew_finance_vendor_contract demo call.';
    return;
  end if;

  perform *
  from public.renew_finance_vendor_contract(
    (select id from public.app_users where email = 'admin@gmail.com'),
    v_vendor_id,
    current_date,
    current_date + 365,
    68000,
    'Renewed for 12 months with event-day support retained.',
    'Critical response in 20 minutes and nightly perimeter checks.',
    5
  );
end $$;

-- Admin amenities, booking logs, and services
select
  code,
  name,
  category,
  location_label,
  status_label,
  capacity_percent,
  booking_required
from public.amenities
order by sort_order asc, created_at asc;

select
  amenity_name,
  resident_name,
  unit_number,
  booking_date,
  time_slot,
  guest_count,
  booking_status
from public.admin_amenity_bookings_v;

select
  full_name,
  specialty,
  phone,
  availability_status,
  rating,
  jobs_completed
from public.service_providers
order by created_at desc;

-- Reset demo amenity so this test block can be rerun safely.
delete from public.amenities
where code = lower(regexp_replace(trim('Podcast Studio'), '[^a-zA-Z0-9]+', '-', 'g'));

do $$
begin
  if exists (
    select 1
    from public.amenities
    where lower(trim(name)) = lower(trim('Podcast Studio'))
  ) then
    raise notice 'Podcast Studio already exists. Skipping create_admin_amenity demo call.';
    return;
  end if;

  perform *
  from public.create_admin_amenity(
    (select id from public.app_users where email = 'admin@gmail.com'),
    'Podcast Studio',
    'Entertainment',
    'Sound-treated studio for resident recordings and calls.',
    'Level 2 Media Wing',
    'OPEN',
    'Available 9 AM to 8 PM',
    'Low usage today',
    18,
    true,
    null,
    'Bring your resident ID.',
    array['Leave equipment powered off after use.', 'Food is not allowed inside.'],
    jsonb_build_array(
      jsonb_build_object('start_time', '09:00', 'end_time', '11:00', 'capacity', 10),
      jsonb_build_object('start_time', '17:00', 'end_time', '19:00', 'capacity', 12)
    )
  );
end $$;

select
  amenity.name as amenity_name,
  slot.start_time,
  slot.end_time,
  slot.slot_capacity,
  slot.sort_order
from public.amenity_time_slots slot
join public.amenities amenity on amenity.id = slot.amenity_id
where amenity.code = (
  select code
  from public.amenities
  where name = 'Podcast Studio'
  order by created_at desc
  limit 1
)
order by slot.sort_order asc, slot.start_time asc;

-- Reset demo service provider so this test block can be rerun safely.
delete from public.service_providers
where full_name = 'Priya Nair'
  and specialty = 'Housekeeping';

do $$
begin
  if exists (
    select 1
    from public.service_providers
    where lower(trim(full_name)) = lower(trim('Priya Nair'))
      and lower(trim(specialty)) = lower(trim('Housekeeping'))
  ) then
    raise notice 'Priya Nair already exists. Skipping create_admin_service_provider demo call.';
    return;
  end if;

  perform *
  from public.create_admin_service_provider(
    (select id from public.app_users where email = 'admin@gmail.com'),
    'Priya Nair',
    'Housekeeping',
    '+91 90000 12345',
    'Deep-clean specialist • 7 yrs exp.',
    'available',
    4.9,
    72,
    null,
    'Preferred for amenity turnover and common-area cleaning.'
  );
end $$;

-- Resident services directory and specialist profile
select
  id,
  full_name,
  specialty,
  service_category,
  short_tagline,
  rating,
  jobs_completed,
  starting_price,
  availability_status
from public.service_providers
order by is_featured desc, rating desc, jobs_completed desc;

select
  full_name,
  specialty,
  bio,
  years_experience,
  skills,
  starting_price,
  phone
from public.service_providers
order by is_featured desc, rating desc, jobs_completed desc
limit 1;

select full_name, email, unit_number, tower, resident_kind, status
from public.resident_directory_v;

-- Guard future data
select full_name, job_title, status
from public.app_users
where email = 'guard@gmail.com';

select *
from public.guard_gate_activity_v;

select title, details, related_visitor_name, related_unit, log_status, logged_at
from public.guard_duty_logs
where guard_user_id = (select id from public.app_users where email = 'guard@gmail.com')
order by logged_at desc;

select attendance_date, check_in_at, check_out_at, status, notes
from public.guard_attendance_logs
where guard_user_id = (select id from public.app_users where email = 'guard@gmail.com')
order by attendance_date desc;

select *
from public.set_guard_attendance(
  (select id from public.app_users where email = 'guard@gmail.com'),
  'check_in',
  'Shift started from main north gate.'
);

select *
from public.set_guard_attendance(
  (select id from public.app_users where email = 'guard@gmail.com'),
  'check_out',
  'Shift completed and handed over.'
);

-- Community feed, meetings, and support
select
  title,
  category,
  author_name,
  status,
  progress_percent,
  member_count,
  comment_count,
  created_at
from public.community_suggestion_feed_v
order by created_at desc;

select
  title,
  category,
  author_name,
  status,
  progress_percent,
  member_count,
  comment_count,
  created_at
from public.admin_community_suggestion_feed_v
order by created_at desc;

select
  full_name,
  unit_number,
  body,
  created_at
from public.community_suggestion_comments_v
where suggestion_id = (
  select id
  from public.community_suggestions
  order by created_at desc
  limit 1
);

select
  category,
  title,
  summary,
  meeting_date
from public.community_meetings
order by meeting_date desc;

select
  category,
  question,
  answer
from public.community_support_faqs
order by sort_order asc;
