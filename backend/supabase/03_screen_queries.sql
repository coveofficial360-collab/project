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
select code, name, category, status_label, availability_text, occupancy_note, cta_label
from public.amenities
order by name;

select a.name, b.booking_date, b.time_slot, b.guest_count, b.booking_status
from public.amenity_bookings b
join public.amenities a on a.id = b.amenity_id
where b.user_id = (select id from public.app_users where email = 'user@gmail.com')
order by b.booking_date desc;

-- Bills and payments
select method_name, method_type, masked_value, note, is_primary
from public.payment_methods
where user_id = (select id from public.app_users where email = 'user@gmail.com')
order by is_primary desc, created_at asc;

select activity_title, activity_category, amount, status, activity_at
from public.payment_activity
where user_id = (select id from public.app_users where email = 'user@gmail.com')
order by activity_at desc;

-- Complaints
select code, title, description, state, assigned_to, meta_label, meta_value, created_at, resolved_at
from public.complaints
where user_id = (select id from public.app_users where email = 'user@gmail.com')
order by created_at desc;

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
