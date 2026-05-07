truncate table
  public.vendor_contract_history,
  public.vendor_quotations,
  public.vendor_quotation_request_vendors,
  public.vendor_quotation_requests,
  public.treasurer_expenses,
  public.finance_vendors,
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
  public.service_providers,
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
    'Primary resident testing account for the Cove app.'
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
    'Primary admin testing account for Cove operations.'
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
  booking_required,
  capacity_percent,
  access_note,
  rules,
  sort_order
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
    true,
    42,
    'Digital ID required at pool entrance.',
    array['Carry your resident ID.', 'No glassware near the pool.', 'Cancel at least 2 hours before your slot.'],
    1
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
    true,
    80,
    'Peak usage between 5 PM and 8 PM.',
    array['Wipe equipment after use.', 'Sports shoes required.', 'Maximum 60 minute peak-hour session.'],
    2
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
    true,
    25,
    'Approval required for private events.',
    array['Noise limits apply after 10 PM.', 'Outside catering requires prior approval.'],
    3
  );

insert into public.service_providers (
  full_name,
  specialty,
  phone,
  experience_label,
  availability_status,
  rating,
  jobs_completed,
  service_category,
  short_tagline,
  bio,
  starting_price,
  years_experience,
  skills,
  is_featured,
  image_url,
  notes
)
values
  (
    'Marcus Thorne',
    'Electrician',
    '+1 (555) 012-9938',
    'Certified Master Electrician • 12 yrs exp.',
    'available',
    4.9,
    184,
    'Electrical',
    'Electrician & Energy Systems Specialist',
    'Marcus handles preventive electrical checks, emergency outages, smart-switch retrofits, and high-load balancing for larger apartments.',
    799,
    12,
    array['Wiring', 'Load balancing', 'Smart systems'],
    true,
    'https://lh3.googleusercontent.com/aida-public/AB6AXuC8-jrEr6t09tGy9wMO0aspsXA7tT1pRZvKKajKZHuhQUS9BDyMBj89ftbLCqfklXBvcYzNGcOkR2hUy7sSGaaRBjoKfr1SqWHzlaDRW3_04vucVCCZ_K3OixZIrSmU9qAc5nHwgoBqzlK01jJUiQIN2MHOKlzPL145qPf35pK0vQaWz-ci1rKvU2Tiqm3TnvfGnsPpbmaJt3GmHTSbhLGT9vV9QY8wEX8yNaSQNqDC023gsgzsPYmLnOTxh1p2Pngv3dv2Bo1BlQ',
    'Preferred for electrical complaints and preventive checks.'
  ),
  (
    'Elena Rodriguez',
    'Plumber',
    '+1 (555) 098-4421',
    'High-pressure systems specialist',
    'busy',
    4.8,
    139,
    'Plumbing',
    'Leakage & pressure-line expert',
    'Elena is best known for fast response on leakage complaints, pressure-balancing fixes, and bathroom fixture replacements.',
    699,
    10,
    array['Pipelines', 'Leak control', 'Fixture replacement'],
    true,
    'https://lh3.googleusercontent.com/aida-public/AB6AXuB6sjdPffzza9Y9UPGnyFo6Vxn7fhNJAQhtyt1pet6qnVuXOtRSxzKSAZyLQ8ohsmC359Lr6h7MvpPcLLoXT2Ss_6onSJvQ52WueVZ-TqdqgQq52HepgxfV0EeRIPToKFiY3KZaOBg1NNe0R2c1JYpcmcOgN3ePJEOjy0wxu2DMzro-YO4x7Tp1ohRvOUudR3YPaQhxUItMpoXa3m9EMS1iux_THhY3yRPQHG7xzGjili4j4Ne5hNfgmTGrRUqYcVr3SnPJaX3FGg',
    'Handles plumbing and leakage escalations.'
  ),
  (
    'Naina Kapoor',
    'Private Chef',
    '+91 98100 88776',
    'Luxury dining consultant • 8 yrs exp.',
    'available',
    4.9,
    91,
    'Lifestyle',
    'Private Culinary Specialist',
    'Naina curates small-format private dinners, healthy meal plans, and event tasting menus for residents who want at-home hospitality support.',
    2499,
    8,
    array['Meal planning', 'Live dining', 'Event menus'],
    true,
    'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=800&q=80',
    'Popular for private dining, brunch setups, and festive menus.'
  ),
  (
    'Arjun Sethi',
    'Housekeeping',
    '+91 98222 55110',
    'Deep-clean lead • 6 yrs exp.',
    'available',
    4.7,
    127,
    'Cleaning',
    'Move-in and deep cleaning support',
    'Arjun focuses on deep-cleaning, sofa and carpet restoration, and turnover preparation before guest arrivals or move-ins.',
    1199,
    6,
    array['Deep clean', 'Carpet care', 'Move-in prep'],
    true,
    'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=800&q=80',
    'Highly rated for move-in and post-renovation cleaning jobs.'
  );

insert into public.finance_vendors (
  company_name,
  contact_name,
  phone,
  email,
  address,
  service_type,
  service_scope,
  gstin,
  license_number,
  monthly_cost,
  hourly_rate,
  staff_count,
  onboarding_status,
  contract_start_date,
  contract_end_date,
  service_agreement_url,
  service_rating,
  response_time_hours,
  is_preferred,
  notes,
  created_by
)
select
  vendor_seed.company_name,
  vendor_seed.contact_name,
  vendor_seed.phone,
  vendor_seed.email,
  vendor_seed.address,
  vendor_seed.service_type,
  vendor_seed.service_scope,
  vendor_seed.gstin,
  vendor_seed.license_number,
  vendor_seed.monthly_cost,
  vendor_seed.hourly_rate,
  vendor_seed.staff_count,
  vendor_seed.onboarding_status,
  vendor_seed.contract_start_date,
  vendor_seed.contract_end_date,
  vendor_seed.service_agreement_url,
  vendor_seed.service_rating,
  vendor_seed.response_time_hours,
  vendor_seed.is_preferred,
  vendor_seed.notes,
  admin_user.id
from public.app_users admin_user
cross join (
  values
    (
      'Titan Protection',
      'Rohit Malhotra',
      '+91 98989 34343',
      'ops@titanprotection.in',
      'Cyber City, Gurugram',
      'Security Services',
      '24/7 society access control and event staffing',
      '07AABCT1001Z9',
      'SEC-2025-8801',
      4800::numeric,
      650::numeric,
      12,
      'active',
      current_date - 220,
      current_date + 24,
      'https://example.com/contracts/titan.pdf',
      4.7::numeric,
      2,
      true,
      'Current lead security vendor with strongest response SLA.'
    ),
    (
      'Evergreen Landscapes',
      'Meera Bansal',
      '+91 97777 12000',
      'care@evergreen.co',
      'Noida Extension',
      'Landscaping',
      'Garden upkeep, seasonal planting, irrigation checks',
      '09AABCE2002L1',
      'LAN-2025-4422',
      2900::numeric,
      420::numeric,
      7,
      'active',
      current_date - 180,
      current_date + 52,
      'https://example.com/contracts/evergreen.pdf',
      4.5::numeric,
      6,
      false,
      'Strong seasonal work quality and water-saving plan.'
    ),
    (
      'Sparkle Co.',
      'Priyansh Arora',
      '+91 96666 44110',
      'hello@sparkleco.in',
      'Sector 62, Noida',
      'Housekeeping',
      'Daily housekeeping and periodic deep cleaning',
      '09AABCS4040D2',
      'HKG-2025-1190',
      3600::numeric,
      350::numeric,
      10,
      'active',
      current_date - 120,
      current_date + 12,
      'https://example.com/contracts/sparkle.pdf',
      4.9::numeric,
      4,
      true,
      'Best resident satisfaction score among cleaning partners.'
    ),
    (
      'Shield Guard',
      'Amit Saini',
      '+91 95555 90909',
      'desk@shieldguard.in',
      'Dwarka, New Delhi',
      'Security Services',
      'Night shift coverage and visitor logging support',
      '07AABCS9898Q1',
      'SEC-2025-9988',
      5200::numeric,
      700::numeric,
      11,
      'active',
      current_date - 300,
      current_date - 5,
      'https://example.com/contracts/shield.pdf',
      4.2::numeric,
      3,
      false,
      'Contract recently expired and queued for renewal review.'
    )
) as vendor_seed(
  company_name,
  contact_name,
  phone,
  email,
  address,
  service_type,
  service_scope,
  gstin,
  license_number,
  monthly_cost,
  hourly_rate,
  staff_count,
  onboarding_status,
  contract_start_date,
  contract_end_date,
  service_agreement_url,
  service_rating,
  response_time_hours,
  is_preferred,
  notes
)
where admin_user.email = 'admin@gmail.com';

insert into public.treasurer_expenses (
  expense_date,
  category,
  vendor_id,
  vendor_name,
  amount,
  description,
  payment_mode,
  receipt_url,
  approval_status,
  recorded_by
)
select
  current_date - expense_seed.days_ago,
  expense_seed.category,
  vendor.id,
  vendor.company_name,
  expense_seed.amount,
  expense_seed.description,
  expense_seed.payment_mode,
  expense_seed.receipt_url,
  expense_seed.approval_status,
  admin_user.id
from public.app_users admin_user
join (
  values
    (3, 'Utilities', 'Titan Protection', 4200::numeric, 'Monthly perimeter and access desk staffing.', 'bank_transfer', 'https://example.com/receipts/titan-may.pdf', 'approved'),
    (7, 'Maintenance', 'Sparkle Co.', 2150::numeric, 'Common area deep-clean and lobby polish cycle.', 'upi', 'https://example.com/receipts/sparkle-cycle.pdf', 'approved'),
    (11, 'Landscaping', 'Evergreen Landscapes', 1850::numeric, 'Irrigation repair and planting refresh for south garden.', 'bank_transfer', 'https://example.com/receipts/evergreen-irrigation.pdf', 'approved'),
    (16, 'Security', 'Shield Guard', 5100::numeric, 'Final invoice before renewal review.', 'cheque', 'https://example.com/receipts/shield-april.pdf', 'pending')
) as expense_seed(
  days_ago,
  category,
  vendor_company_name,
  amount,
  description,
  payment_mode,
  receipt_url,
  approval_status
) on true
join public.finance_vendors vendor on vendor.company_name = expense_seed.vendor_company_name
where admin_user.email = 'admin@gmail.com';

insert into public.vendor_quotation_requests (
  request_title,
  service_type,
  requested_start_date,
  contract_duration,
  estimated_budget,
  staff_required,
  requirements,
  status,
  selected_vendor_id,
  created_by
)
select
  'North Tower Security Renewal',
  'Security Services',
  current_date + 12,
  '12 Months',
  50000,
  8,
  '24/7 desk coverage, visitor logging, CCTV coordination, and event surge support.',
  'sent',
  best_vendor.id,
  admin_user.id
from public.app_users admin_user
join public.finance_vendors best_vendor on best_vendor.company_name = 'Titan Protection'
where admin_user.email = 'admin@gmail.com';

insert into public.vendor_quotation_request_vendors (request_id, vendor_id)
select
  request.id,
  vendor.id
from public.vendor_quotation_requests request
join public.finance_vendors vendor on vendor.company_name in (
  'Titan Protection',
  'Shield Guard',
  'Sparkle Co.'
)
where request.request_title = 'North Tower Security Renewal';

insert into public.vendor_quotations (
  request_id,
  vendor_id,
  quoted_amount,
  contract_term_months,
  response_time_hours,
  staff_offered,
  warranty_note,
  quote_status,
  is_best_value
)
select
  request.id,
  vendor.id,
  quote_seed.quoted_amount,
  quote_seed.contract_term_months,
  quote_seed.response_time_hours,
  quote_seed.staff_offered,
  quote_seed.warranty_note,
  'received',
  quote_seed.is_best_value
from public.vendor_quotation_requests request
join (
  values
    ('Titan Protection', 47000::numeric, 12, 2, 10, 'Priority event deployment included.', true),
    ('Shield Guard', 45500::numeric, 12, 3, 9, 'Night-supervisor add-on billed separately.', false),
    ('Sparkle Co.', 44200::numeric, 10, 5, 8, 'Cross-trained housekeeping/security hybrid crew.', false)
) as quote_seed(
  company_name,
  quoted_amount,
  contract_term_months,
  response_time_hours,
  staff_offered,
  warranty_note,
  is_best_value
) on true
join public.finance_vendors vendor on vendor.company_name = quote_seed.company_name
where request.request_title = 'North Tower Security Renewal';

insert into public.vendor_contract_history (
  vendor_id,
  start_date,
  end_date,
  monthly_amount,
  terms_summary,
  sla_summary,
  quality_rating,
  status,
  renewed_by
)
select
  vendor.id,
  history_seed.start_date,
  history_seed.end_date,
  history_seed.monthly_amount,
  history_seed.terms_summary,
  history_seed.sla_summary,
  history_seed.quality_rating,
  history_seed.status,
  admin_user.id
from public.app_users admin_user
join (
  values
    ('Titan Protection', current_date - 580, current_date - 220, 4300::numeric, 'Initial annual contract for desk security and patrol support.', 'Supervisor on-call within 30 minutes.', 4, 'completed'),
    ('Titan Protection', current_date - 220, current_date + 24, 4800::numeric, 'Renewed contract with event staffing add-on.', 'Critical incident supervisor arrival within 15 minutes.', 5, 'active'),
    ('Shield Guard', current_date - 300, current_date - 5, 5200::numeric, 'Interim contract for secondary gate operations.', 'Night supervisor required on weekends.', 3, 'expired')
) as history_seed(
  company_name,
  start_date,
  end_date,
  monthly_amount,
  terms_summary,
  sla_summary,
  quality_rating,
  status
) on true
join public.finance_vendors vendor on vendor.company_name = history_seed.company_name
where admin_user.email = 'admin@gmail.com';

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
select id, 'maintenance-q2', 'Quarterly Maintenance', 'Cove', 'maintenance', 'due', 'Due in 3 days', 2200, null, current_date + 3, null, 'Pay Now'
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
