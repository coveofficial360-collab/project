truncate table
  public.guard_duty_logs,
  public.announcements,
  public.admin_transactions,
  public.visitor_passes,
  public.notifications,
  public.notices,
  public.complaints,
  public.payment_activity,
  public.payment_methods,
  public.bills,
  public.amenity_bookings,
  public.amenities,
  public.vehicles,
  public.household_members,
  public.app_users
restart identity cascade;

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
  job_title,
  avatar_url,
  bio
)
values
  (
    'user@gmail.com',
    extensions.crypt('user', extensions.gen_salt('bf')),
    'resident',
    'Aditya Sharma',
    'Aditya',
    '+91 98765 43210',
    'B-204',
    'Tower B',
    'owner',
    'active',
    null,
    'https://lh3.googleusercontent.com/aida-public/AB6AXuBg0i9YM5IEGdzLL17BoAjodnNcI3uMuhlrCCaBsSoWkHRuSTvuGGhC3LFb4q5Ebhr6wd0gKAU0tpfQsVa1Ys8kTPY4dwv5W1Rl_zaSIuSjTYx65EmI1873v2bqyYHmUjy10zff8OscnqTSqj6qLPrCX_mFqd5jOt4dcplv9SyfqD-xCFPkQzuakDhkKqvAvyELUbJ6nDQNQZ1YOlcDG4zOTMzbqZJzpihPXVJGtaro8oaY97tXbO0iD3P0D494f5t46VwIZa9jS5-3',
    'Primary resident testing account for the Avenue360 app.'
  ),
  (
    'admin@gmail.com',
    extensions.crypt('admin', extensions.gen_salt('bf')),
    'admin',
    'Marcus Sterling',
    'Marcus',
    '+91 98111 11111',
    null,
    null,
    null,
    'active',
    'Estate Manager',
    'https://lh3.googleusercontent.com/aida-public/AB6AXuAZdFL4zMKpNZY3_fSbha5C3gXuInFJaXecNCbr8iBFFz3_w2bT1u7sKXRKA_mGeEYUQRsvR6eYozhpVULtvbYT9UoajJMm5eOURoEbprw28WXIA5zbhb5Ox0YHGWo9VHVwLVgRHuFVLggQJLb9hR6m_XYNdwFDr9tpKVicHa-zB3dRt8pemssN2VpGkDJUE_Wkh91T9sEPQPUAyMjsHT_EyPel3i6My0wSuuSYWr8hb2rsuudulKvCjbBKLoNIPvgf9YXQ-CcHEEQ',
    'Primary admin testing account for Avenue360 operations.'
  ),
  (
    'guard@gmail.com',
    extensions.crypt('guard', extensions.gen_salt('bf')),
    'guard',
    'Rakesh Verma',
    'Rakesh',
    '+91 98222 22222',
    null,
    'Main Gate',
    null,
    'active',
    'Security Guard',
    null,
    'Guard testing account for visitor verification and gate operations.'
  ),
  (
    'alexander.sterling@gmail.com',
    extensions.crypt('resident', extensions.gen_salt('bf')),
    'resident',
    'Alexander Sterling',
    'Alexander',
    '+91 90000 10001',
    '1402',
    'Tower A',
    'owner',
    'active',
    null,
    'https://lh3.googleusercontent.com/aida-public/AB6AXuC32Kqzc8hRfEl30abJX8cYdzhotEi9MmUJpFNRfh95XicxdQKc65kyv7gtwjGRV_qoCzJkMDLsJ0n5yaDEJJFOZRIigb8ghLEmzdzV-TH7b-ih7qkJHPsk2Pc58vSBg3RsNIBENYD9_NvrLjRTu1xKz7Hz7o8-3NWuVhBBooJKrKEOrJ22auh1kWg2Irl4Bhuhc2UOPTTkB3ifRkGCJgeC4BlKG4Zf-uMWwRWzW2z-9ZM5fqUtHkCWxbjqUek-xK5--3hWARc-kvE',
    null
  ),
  (
    'elena.rodriguez@gmail.com',
    extensions.crypt('resident', extensions.gen_salt('bf')),
    'resident',
    'Elena Rodriguez',
    'Elena',
    '+91 90000 10002',
    '0805',
    'Tower B',
    'owner',
    'pending',
    null,
    'https://lh3.googleusercontent.com/aida-public/AB6AXuA22ac2iJWFcfipaGs-c_Rh30BWOTzg9N9cBDeQU0pwEq3wCxZQKBhpwz08kbzesBHABsDFYdg1zKvI4HKwUTEDpqcude1pLlyppDQbZqqzRH6nf4BzMC9lnqgFSYnl1cFtX3bNyLVw66iNU5pf0wtiqs80ZL8CsrcAVZetJ39TAoWGzoXl4neGMTh-TRgidTL0F-WabmXN7alGEWcmTcx_5LECQWI3EWdJo7MalI76xHTM_R9s78y_Z6OMAaz3GTbg0hCk9gdl8H0',
    null
  ),
  (
    'marcus.wainwright@gmail.com',
    extensions.crypt('resident', extensions.gen_salt('bf')),
    'resident',
    'Marcus Wainwright',
    'Marcus W.',
    '+91 90000 10003',
    '2201',
    'PH',
    'owner',
    'active',
    null,
    null,
    null
  ),
  (
    'jameson.chen@gmail.com',
    extensions.crypt('resident', extensions.gen_salt('bf')),
    'resident',
    'Jameson Chen',
    'Jameson',
    '+91 90000 10004',
    '0411',
    'Tower A',
    'tenant',
    'active',
    null,
    'https://lh3.googleusercontent.com/aida-public/AB6AXuDhQGZkrWHLcYz22-wvqHsQysY6YWsLEvmsTYrZ-g0tXR5xLwRHapYKISw-LJEhUuvaSlvK658_qUXUkbuwp7_UAHiqssa_JZtCVzkaL1BTvqWcyRW2Jiafwtw-ttIlgFiEuGUqOCR1nQ33EDJTWI3khAPanZtT2Py-pHw6sJrdMQpA1DhotH37AbP9lrgbcV3lfMnfMFmxexpJ_DpWHDGJ5Dor2zaGPFyRUJfK10xrgpIG1opaunVb39f2BWv6ypDJ5QF8NSzUdxI',
    null
  ),
  (
    'sarah.jenkins@gmail.com',
    extensions.crypt('resident', extensions.gen_salt('bf')),
    'resident',
    'Sarah Jenkins',
    'Sarah',
    '+91 90000 10005',
    '1109',
    'Tower C',
    'tenant',
    'expired',
    null,
    'https://lh3.googleusercontent.com/aida-public/AB6AXuAa9Fcyhcd6jceLaLL5PsHjvHDigIiKR46attnbZW4Cx7tpYziXKIJUmrePKwm0eVqUW4n7wgUl28pwTIDKrwH9usdM4C_FUAGnwmVcb4T7f0XO5fg0FsB7Sa2hBElLEYyt1CrZ4YBP6pfKRrCEOfbb_clPt5S2VvSD5MwTNs7Fb2ksNkXUi6I_tc1JXlQxULaY6tPmruzpP_oswQ0M6gAMJAUmHIg9alhUcskNQgPNhmFFa6jIXoqXKKWW47nT7JM-W0tQbjtIpvE',
    null
  );

insert into public.household_members (user_id, full_name, relation, avatar_url)
select id, 'Priya', 'Spouse', 'https://lh3.googleusercontent.com/aida-public/AB6AXuD3Uk5EaMJ3WGJLsCQIg0a8LodV8CLG2W9bMsn7CcIyoqx9U7LcfG4_VR-DfkFaZPR34SnVXHP4vBab2ZWDLOQbcCR_hElFK_EaI4SlnnL0R9rQxf11fdtxaN9chpV9j_h1PgVHoSMHdzduyg0Gd-Ya4jg2l56D-g8OxQeLhfgT_3TgQcJYCIe7Y_109_0DS4xIKG8TA2X5uKoQ4NDEz8vwaeglPMmejbSzALb6wnlkQU3nrQF8yIk1Wc79aE2fGc6Qv6GyN8TPoAPW'
from public.app_users
where email = 'user@gmail.com';

insert into public.household_members (user_id, full_name, relation, avatar_url)
select id, 'Arjun', 'Son', 'https://lh3.googleusercontent.com/aida-public/AB6AXuAkRLFKvKweGErGZn82oznlhjf66TuhSQlDOmesGonInjMpTkI4dBf5XvJUaVdAAEEifC4jUzTK4I1OyDBQH5zkBReluC3cu9yzWyzbPz48dj7AhmHfjmV5D9OCJJ1CVKi8pxPnpQ0IC2ajf-9jemSErS3MdXE7m4KF2NJoJj9RbzrvlJtf6ml7Xq0oKbZoChNiiT_gbSkVuqexUsAVzEdjvWMx3G4JEDBKqV_b4pd-6JdFnk5RTb2y8M5_682IlIM1r7RIDoscfnJ3'
from public.app_users
where email = 'user@gmail.com';

insert into public.vehicles (user_id, registration_number, vehicle_name, vehicle_type)
select id, 'KA 01 MG 1234', 'White SUV', 'Car'
from public.app_users
where email = 'user@gmail.com';

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
  booking_required
)
values
  (
    'infinity-pool',
    'Infinity Pool',
    'Popular',
    'Luxury rooftop infinity pool overlooking the skyline.',
    'Rooftop Terrace, North Tower',
    'Available till 9 PM',
    'Low occupancy this evening',
    'OPEN',
    'Book Now',
    'https://lh3.googleusercontent.com/aida-public/AB6AXuBxzm-dGnr-qUg3CunB_AYuyZuRG37ek0vFJXPFvgBu9IsZxGmlsT2ZZLza2KHK_VyptCVsa6goNGYiVM5iVQKh2OoXgJynnq17ZycQz0mx8QAYHbEF0hJ_3gItSrmGv3HmW8MqICkRx8gCK72ehyb5pMt1QXRPhq6nN-ZLuoPXiDD3AQhXTveXvWkmKzAO_rxNGKCqQr1Lw2wRnscP3PZDO8GW1hI4UrxhOgefXRQh2dksJSD1hHW8b67QYBbSIpOA0mNo3gLzDq0',
    true,
    true
  ),
  (
    'modern-gym',
    'Modern Gym',
    'Wellness',
    'State-of-the-art fitness center with cardio, weights, and yoga area.',
    'Level 4 Fitness Deck',
    'Open daily 6 AM to 10 PM',
    '4 people there',
    'BUSY',
    'View Details',
    'https://lh3.googleusercontent.com/aida-public/AB6AXuBWTTQ3UiXvD57t3y9l3xUZ6A7KeczByka3Xq2UojS4x44ReWHVyDmubL-CWJdb92iI2_iul9NP715Lo5AEkuYEu5dVcMtl2zeBkEsip6MvgrHMiAPxkZbbklk1MPOkK-KfWusX6tiNrBDemlRUUiOky0JZU0DExSaYFrEpEQ_wOFWUIvuh1QvGxVU74XYTBZ0U9H0Ay5rnnPJkaURiBg_cddNE8CFalkWpo38jzdNFFKtfsxN4kJKY9i7prr1n-dTnHdHtAQgXCWA',
    true,
    true
  ),
  (
    'rooftop-lounge',
    'Rooftop Lounge',
    'Entertainment',
    'Private events and gatherings under ambient skyline lighting.',
    'Sky Deck, Tower C',
    'Private events & gatherings',
    'Booking required',
    'BOOKING REQUIRED',
    'Book Now',
    'https://lh3.googleusercontent.com/aida-public/AB6AXuBDq3lh2XEgyajN8zt4b-iBTuyGgfLZ9xixqax5xpr6ARMb_IM08URqgsQP3JJMAkGmCteSoVbiCQxeizU-wbEAdOHx6Py9gwomw7roFtjmjp-e1DLYSHphrozp2e3ONAn6Ydf0L9KPF98xFHcwt8jrotPoIX8WKusFNIR27KVZ6tcLGyY87Qy9Z5mykcaifpD29m4gm9oLN1n7ax8_fiVOek9gGTivFz_CntCiTQq7BXrVqpdz2s1cSb7WdeUQNZ-411uOLfrM9Bk',
    true,
    true
  );

insert into public.amenity_bookings (user_id, amenity_id, booking_date, time_slot, guest_count, booking_status, booking_fee)
select
  public.app_users.id,
  public.amenities.id,
  current_date + 1,
  '10:00 - 12:00',
  2,
  'confirmed',
  0
from public.app_users
join public.amenities on public.amenities.code = 'infinity-pool'
where public.app_users.email = 'user@gmail.com';

insert into public.bills (
  user_id,
  code,
  title,
  provider,
  category,
  state,
  badge_text,
  amount_due,
  amount_paid,
  due_date,
  last_paid_on,
  action_label
)
select id, 'maintenance-q2', 'Quarterly Maintenance', 'Avenue360', 'maintenance', 'due', 'Due in 3 days', 2200, null, current_date + 3, null, 'Pay Now'
from public.app_users
where email = 'user@gmail.com';

insert into public.bills (user_id, code, title, provider, category, state, badge_text, amount_due, amount_paid, due_date, last_paid_on, action_label)
select id, 'jio-mobile', 'Jio - 98765 43210', 'Jio', 'mobile', 'due', 'Due in 2 days', 719, null, current_date + 2, null, 'Pay Now'
from public.app_users
where email = 'user@gmail.com';

insert into public.bills (user_id, code, title, provider, category, state, badge_text, amount_due, amount_paid, due_date, last_paid_on, action_label)
select id, 'bses-electricity', 'BSES Yamuna', 'BSES Yamuna', 'electricity', 'paid', 'Paid on 02 Jun', null, 1280, null, current_date - 18, null
from public.app_users
where email = 'user@gmail.com';

insert into public.bills (user_id, code, title, provider, category, state, badge_text, amount_due, amount_paid, due_date, last_paid_on, action_label)
select id, 'tata-play', 'Tata Play', 'Tata Play', 'dth', 'expiring', 'Expiring today', 450, null, current_date, null, 'Recharge'
from public.app_users
where email = 'user@gmail.com';

insert into public.bills (user_id, code, title, provider, category, state, badge_text, amount_due, amount_paid, due_date, last_paid_on, action_label)
select id, 'djb-water', 'DJB', 'Delhi Jal Board', 'water', 'paid', 'Paid on 20 May', null, 650, null, current_date - 30, null
from public.app_users
where email = 'user@gmail.com';

insert into public.payment_methods (user_id, method_name, method_type, masked_value, note, is_primary)
select id, 'HDFC BANK', 'card', '**** 4589', 'Expires 12/26', true
from public.app_users
where email = 'user@gmail.com';

insert into public.payment_methods (user_id, method_name, method_type, masked_value, note, is_primary)
select id, 'SBI UPI', 'upi', 'user@sbi', 'Verified', false
from public.app_users
where email = 'user@gmail.com';

insert into public.payment_activity (user_id, activity_title, activity_category, amount, status, activity_at)
select id, 'BSES Yamuna', 'Electricity', -1280, 'PAID', now() - interval '17 days'
from public.app_users
where email = 'user@gmail.com';

insert into public.payment_activity (user_id, activity_title, activity_category, amount, status, activity_at)
select id, 'Airtel Broadband', 'Internet', -999, 'PAID', now() - interval '22 days'
from public.app_users
where email = 'user@gmail.com';

insert into public.payment_activity (user_id, activity_title, activity_category, amount, status, activity_at)
select id, 'DJB', 'Water', -650, 'PAID', now() - interval '30 days'
from public.app_users
where email = 'user@gmail.com';

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
  resolved_at
)
select
  id,
  'CMP-8902',
  'water',
  'Master Bathroom Leak',
  'Continuous water dripping from the ceiling above the shower area. It started yesterday and seems to be getting worse.',
  'Master bathroom',
  'urgent',
  'Today after 6 PM',
  null,
  'in_progress',
  'Mike (Plumbing)',
  'Resident requested access after work hours.',
  null,
  'ASSIGNED TO',
  'Mike (Plumbing)',
  'water_drop',
  '#FFB018',
  now() - interval '6 hours',
  null
from public.app_users
where email = 'user@gmail.com';

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
  resolved_at
)
select
  id,
  'CMP-8895',
  'electrical',
  'Hallway Light Flickering',
  'The main light fixture in the entryway hallway is flickering constantly when turned on. Needs bulb replacement or wiring check.',
  'Entry hallway',
  'normal',
  'Weekdays 10 AM to 1 PM',
  null,
  'pending',
  null,
  null,
  null,
  'STATUS',
  'Awaiting Assignment',
  'electrical_services',
  '#E2E3E8',
  now() - interval '3 days',
  null
from public.app_users
where email = 'user@gmail.com';

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
  resolved_at
)
select
  id,
  'CMP-8801',
  'plumbing',
  'Kitchen Sink Blockage',
  'Drain line was cleaned and water flow has been restored. Please monitor the sink for the next 24 hours.',
  'Kitchen',
  'low',
  'Anytime',
  null,
  'resolved',
  'Raj (Maintenance)',
  'Resolved during the morning maintenance round.',
  'Drain line cleared and tested with normal water flow.',
  'CLOSED BY',
  'Raj (Maintenance)',
  'plumbing',
  '#D8E2FF',
  now() - interval '9 days',
  now() - interval '7 days'
from public.app_users
where email = 'user@gmail.com';

insert into public.notices (code, kind, title, body, action_label, audience, posted_at, event_date, image_url)
values
  (
    'notice-elevator-maintenance',
    'urgent',
    'Elevator Maintenance: Block B',
    'Emergency repairs are being conducted on the primary elevator in Block B. Expected downtime is approximately 4 hours. Please use the service elevator or stairs.',
    'TAKE ACTION',
    'All Residents',
    now() - interval '2 minutes',
    null,
    null
  ),
  (
    'notice-rooftop-soiree',
    'event',
    'Annual Rooftop Soirée',
    'Join us for an evening gathering on the rooftop terrace with live music, refreshments, and skyline views.',
    'RSVP',
    'All Residents',
    now() - interval '1 day',
    current_date + 7,
    'https://lh3.googleusercontent.com/aida-public/AB6AXuDkmW20f9rTZrHOuu7ObTips3uRMBnVQPCCNmagXZxn0n3ku8HbWnWmXuOwAF8Y_LhThFupg86DxIu0i-bpgwqeGrmvsU-U8_cQLVm8FFqi0FCcWHp22zgRb6gurG3qqVPTrFfc73xUUOfBnBD7bg38b4dam-35LIYLWqwkHSH2TZTn_Erwce7_FRIvkwaCZgUtcS9RrYf7Weps72sFqzQwIZ86taaWhbApvWXJC-k5IgOqr8zLBVHYNHyTQpG40ssJWoqPel6lh0wg'
  ),
  (
    'notice-water-cleaning',
    'general',
    'Water Tank Cleaning Schedule',
    'Routine cleaning of the main water tanks is scheduled for this weekend. There may be minor pressure fluctuations between 10 AM and 2 PM.',
    'READ MORE',
    'All Residents',
    now() - interval '1 day',
    null,
    null
  ),
  (
    'notice-ev-stations',
    'facility',
    'New Electric Charging Stations',
    'Four new Level 2 EV charging stations have been installed in the lower basement parking. They are now operational and available for resident use.',
    null,
    'All Residents',
    now() - interval '5 days',
    null,
    null
  );

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
select id, 'payment', 'Maintenance due in 3 days', 'Your quarterly maintenance fee of $450 is due soon.', null, 'PAY NOW', null, true, now() - interval '10 minutes'
from public.app_users
where email = 'user@gmail.com';

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
select id, 'maintenance', 'Elevator maintenance scheduled for Block B tomorrow', null, 'URGENT', null, null, true, now() - interval '2 hours'
from public.app_users
where email = 'user@gmail.com';

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
select id, 'visitor', 'Guest Arrived: John Doe at Main Gate', null, null, null, 'https://lh3.googleusercontent.com/aida-public/AB6AXuAkrCaO4iRaep9vrU3FOtilMA7koGYVNB_3T1RY_imWxBxtmpiFaBC0lxc8NhAj4ZDYILwhiu8Z0_zR3h9tpaUkd4y3blt_r43WSXxUzp5pMRHf6gWhjOaz1laMK0sXdVs9PxpOyWApWuz4jtkeMxie5Ro_ClQxNfBumcnipFGy7FFKHUjgAWbI6p_xlXO2WdjdhcAlHpb7vuU8hb8jyNcglngUGexJ27oNBjt7a4b88QkjnqSLwN2UZBR-AJ2fEeOLcgnJdGNq-Bwe', false, now() - interval '1 day'
from public.app_users
where email = 'user@gmail.com';

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
select id, 'event', 'Join us for the Annual Rooftop Soirée this Friday!', null, null, null, 'https://lh3.googleusercontent.com/aida-public/AB6AXuCT84Dnqvr_05ufLKIEan25BSCHd0RlyUjmdnEESu2sMLINldbznBfhhEfbydwEQe-nH3OsMX3HFyr6_aLPhypPQYTb_LHLUKT1p3RX-z8pqFi-ceajA06k5JEO_vCPjxnmsPLazeZisAyTzry5IFExOkO7FUrdjdKjnd6VGeJMF4CX3IxjecTXOA-N-pv3plwQ5F-yGZPs6Z_EEgFRqTWy_vnkqnd23piPX6xDIzG_TjNVmLX5xu4LDTkY7CLfOnplnVQwQKp3Vl75', false, now() - interval '2 days'
from public.app_users
where email = 'user@gmail.com';

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
select id, 'Jane Doe', '+91 99887 77665', 'guest', now() + interval '4 hours', 'approved', '4821', 'QR-JANE-4821'
from public.app_users
where email = 'user@gmail.com';

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
select id, 'Blinkit Delivery', '+91 70000 00001', 'delivery', now() + interval '30 minutes', 'expected', '1034', 'QR-DEL-1034'
from public.app_users
where email = 'user@gmail.com';

insert into public.admin_transactions (title, subtitle, amount, status, icon_name, icon_bg_hex, created_at)
values
  ('Maintenance - Unit 402', 'Today, 10:45 AM', 450.00, 'SUCCESS', 'receipt_long', '#FFF0C7', now() - interval '4 hours'),
  ('Utility - Common Area', 'Yesterday', -2120.50, 'AUTO-PAID', 'flash_on', '#E8F0FF', now() - interval '1 day');

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
select id, 'sent', 'urgent', 'Water Supply Interruption - Block B', 'Emergency repairs are being carried out on the main line. Water supply will be unavailable from 2:00 PM to 5:00 PM today...', 'Residents, Owners', 412, null, now() - interval '2 hours'
from public.app_users
where email = 'admin@gmail.com';

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
select id, 'sent', 'general', 'New Waste Disposal Guidelines', 'To improve our community recycling efforts, we have updated the disposal schedule for different types of household waste...', 'All Residents', 385, null, now() - interval '1 day'
from public.app_users
where email = 'admin@gmail.com';

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
select id, 'sent', 'event', 'Annual Garden Tea Party', 'Join us for an afternoon of community bonding at the North Pavilion. Refreshments will be served and kids'' activities planned...', 'All Residents', 290, null, now() - interval '10 days'
from public.app_users
where email = 'admin@gmail.com';

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
select
  id,
  'Community Composting Program',
  'Environmental',
  'Proposal to install three industrial-grade composting bins in the South Garden to reduce building waste by up to 40%.',
  'The suggestion recommends placing clearly labelled composting stations near the South Garden and partnering with a local processing service. Residents would receive simple instructions on household waste segregation, and the finished compost could be used for the tower landscaping beds.',
  'all_residents',
  'compost',
  '#2E8B57',
  null,
  true,
  16,
  12,
  0,
  'published',
  now() - interval '2 days'
from public.app_users
where email = 'user@gmail.com';

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
select
  id,
  'Extended Gym Hours',
  'Lifestyle',
  'Extend rooftop gym access from 10 PM to 12 AM for residents with flexible work schedules.',
  'Several residents have asked for later gym access after work hours. Extending the slot by two hours would better support shift workers and remote professionals, while still allowing housekeeping and security checks to happen before midnight.',
  'all_residents',
  'fitness_center',
  '#1A73E8',
  null,
  true,
  22,
  11,
  0,
  'published',
  now() - interval '5 days'
from public.app_users
where email = 'user@gmail.com';

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
select
  id,
  'Bicycle Storage Upgrade',
  'Infrastructure',
  'Install secure vertical racks and a repair station in the basement garage to accommodate 20 more bikes.',
  'The basement bicycle corner is close to capacity. This proposal adds vertical racks, better lighting, and a compact repair stand for quick maintenance. It would make cycling more practical and reduce clutter near the parking access ramp.',
  'all_residents',
  'directions_bike',
  '#D97706',
  null,
  true,
  10,
  9,
  0,
  'published',
  now() - interval '7 days'
from public.app_users
where email = 'user@gmail.com';

insert into public.community_suggestion_members (
  suggestion_id,
  user_id,
  joined_at
)
select
  s.id,
  member.id,
  least(s.created_at + interval '1 hour', now())
from public.community_suggestions s
cross join public.app_users member
where s.status in ('published', 'active')
  and member.email = 'user@gmail.com'
on conflict (suggestion_id, user_id) do nothing;

insert into public.community_suggestion_comments (
  suggestion_id,
  user_id,
  body,
  created_at
)
select
  s.id,
  commenter.id,
  'I''m fully supportive. If we do this, we should also publish a simple schedule for maintenance volunteers so the upkeep feels manageable.',
  now() - interval '3 hours'
from public.community_suggestions s
cross join public.app_users commenter
where s.title = 'Community Composting Program'
  and commenter.email = 'admin@gmail.com';

insert into public.community_suggestion_comments (
  suggestion_id,
  user_id,
  body,
  created_at
)
select
  s.id,
  commenter.id,
  'Later gym access would really help residents who only return home after 9 PM. I support this if security rounds remain in place.',
  now() - interval '1 day'
from public.community_suggestions s
cross join public.app_users commenter
where s.title = 'Extended Gym Hours'
  and commenter.email = 'user@gmail.com';

insert into public.community_suggestion_comments (
  suggestion_id,
  user_id,
  body,
  created_at
)
select
  s.id,
  commenter.id,
  'A repair station would be a great addition. It might also reduce bicycles being parked near the fire exit landing.',
  now() - interval '2 days'
from public.community_suggestions s
cross join public.app_users commenter
where s.title = 'Bicycle Storage Upgrade'
  and commenter.email = 'admin@gmail.com';

insert into public.community_meetings (
  category,
  title,
  summary,
  executive_summary,
  minutes_body,
  location,
  duration_label,
  attendee_count,
  quorum_reached,
  image_url,
  meeting_date,
  created_at
)
values
  (
    'Finance',
    'Annual Budget Review',
    'The committee finalized the allocation for the upcoming fiscal year, prioritizing the renovation of the central park area and upgrading the community gym facilities.',
    'The annual budget review focused on stabilizing long-term finances while progressing essential upgrades. Reserve contributions were increased by 5% to prepare for large maintenance projects and energy-efficiency improvements.',
    'Agenda: Review FY2023 financial performance, discuss reserve planning, and approve 2024 capital projects. Outcome: reserve fund increase approved, smart-lighting rollout greenlit, and park renovation moved into the next quarter planning window.',
    'Community Hall',
    '1h 45m',
    15,
    true,
    'https://lh3.googleusercontent.com/aida-public/AB6AXuAe-ZVyZpLah3RTkNc5kkvqAvBEnSjgd19CGGj6GSW_JD8h70M7KBc-0j2yz-Q9iTYArokGOOxIeNM6j5xykUeMDo-tEwd5LOrboiQH164N8QNGuD5xnj99gXjegVU2QUj_aAMOVStFAcj0mNN99kRV55K8VVeJ6Q_wKqRqtIDX1C9nSoCppGdBDBA1r69gKYJi7maiHYctWfN8SoROv_VUaI-gHwxKRm4rd1GZ_9laBHue0KZvqPt3x0HXONGqUoEYVYukIH5iNw',
    current_date - 12,
    now() - interval '12 days'
  ),
  (
    'Social',
    'Summer Social Planning',
    'Residents discussed ideas for the Summer Solstice block party, including food trucks, an outdoor cinema, and children''s programming.',
    'The social committee aligned on the event direction, approved a family-friendly format, and assigned vendor scouting and permit coordination to a subcommittee.',
    'Agenda: shortlist event concepts, vendor mix, and children''s activities. Outcome: outdoor cinema approved, food truck outreach assigned, and fireworks dropped in favor of a live acoustic performance due to noise guidelines.',
    'North Pavilion',
    '1h 10m',
    11,
    true,
    'https://lh3.googleusercontent.com/aida-public/AB6AXuBLBoZ5E8e4wWZbBMiTqyY0oGxGplzwUYT1i-Y61gGZCXKb-SwFqeD9HRwyhmtKmYrXde-aldud--sfpaGN6i_xfk9d59LVnAwKzSwBOFKaXMVnx8WyPK7lpx8MXJjMLXX2LmTpZrODTb6dgEiqptct8_vPAe1UZYYULRPqAWyptPYB4mjI_5e685Mya21Y1W5bLoepN11RMyKdRLy--oDzYkxsHrlrA6nAXy8fXkkWwFWNyQU1nMk8r0Pv9v85UXyDRmsSP-oEfA',
    current_date - 25,
    now() - interval '25 days'
  ),
  (
    'Projects',
    'Infrastructure & Safety',
    'The meeting addressed new LED street lighting for the West Wing and confirmed the resurfacing schedule for the internal access road.',
    'The safety review prioritized improved nighttime visibility and smoother traffic movement. Installation sequencing was approved to reduce disruption during weekday commute hours.',
    'Agenda: lighting proposal, road resurfacing schedule, and temporary traffic diversions. Outcome: motion-sensor LED package approved, resurfacing windows announced, and resident advisory notices scheduled for release two weeks before work begins.',
    'Tower A Board Room',
    '58m',
    9,
    true,
    'https://lh3.googleusercontent.com/aida-public/AB6AXuB7oDy3smo6bIUAk6DTACUcQrPXJdA_s_-iHa79_3-CyBnNlW68ekEwHtQrlS0M8IIAQFy9XobR8IjvFSCVRRYv02lhW1wQKIZ-1Fb1S2unoqk8E98IG8nmPL863uZMVD1DfbWeG7UuYfZAQCmj503rmd9gXUmQY8PHl26cWcZYQDn93ahPrl9ftHqiErRVVwa0aisQvzEjD7uaH9wUEpzNI8TNcUuJcLz-kwE9mbA8hRnD5PeIQQfPyJYK93k8l1zCFA7d48XYVw',
    current_date - 39,
    now() - interval '39 days'
  );

insert into public.community_support_faqs (
  category,
  question,
  answer,
  sort_order,
  created_at
)
values
  ('Maintenance', 'How do I report a maintenance issue after hours?', 'Use the resident app complaint flow for non-emergencies. For urgent water, power, or lock issues, call security immediately so the on-call technician can be dispatched.', 1, now() - interval '6 days'),
  ('Billing', 'Where can I find my monthly statement?', 'Open Bills in the resident app to view the current quarter summary, previous payments, and due dates. Detailed payment activity is listed below your saved payment methods.', 2, now() - interval '6 days'),
  ('Amenities', 'What are the gym operating hours?', 'The rooftop gym is open from 5:30 AM to 10:00 PM every day. Equipment sanitization happens between 2:00 PM and 2:30 PM.', 3, now() - interval '6 days'),
  ('Security', 'How do I request a new key fob?', 'Submit a support request through the concierge desk or contact security. Replacement key fobs are usually activated within one working day after identity verification.', 4, now() - interval '6 days'),
  ('Maintenance', 'How do I book the guest suite?', 'Guest suite bookings are handled through amenities once the resident office confirms the requested date is available. Reach out to support if you need approval status.', 5, now() - interval '6 days'),
  ('Security', 'How do I let a delivery rider in late at night?', 'Create a visitor pass in the visitor module and mark it as delivery. The guard queue will show the rider as expected, and the gate team can verify the PIN or QR code on arrival.', 6, now() - interval '6 days');

insert into public.guard_duty_logs (
  guard_user_id,
  title,
  details,
  related_visitor_name,
  related_unit,
  log_status,
  logged_at
)
select id, 'Visitor approved at gate', 'Jane Doe matched the pre-approved access pass and was allowed entry.', 'Jane Doe', 'B-204', 'completed', now() - interval '30 minutes'
from public.app_users
where email = 'guard@gmail.com';

insert into public.guard_duty_logs (
  guard_user_id,
  title,
  details,
  related_visitor_name,
  related_unit,
  log_status,
  logged_at
)
select id, 'Delivery expected', 'Blinkit delivery rider is expected at the main gate shortly for unit B-204.', 'Blinkit Delivery', 'B-204', 'watch', now() - interval '10 minutes'
from public.app_users
where email = 'guard@gmail.com';
