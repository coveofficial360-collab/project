-- Guard write actions
select *
from public.create_guard_visitor_entry(
  (select id from public.app_users where email = 'guard@gmail.com'),
  'Walk-in Courier',
  'B-204',
  'Package delivery',
  '+91 99999 11111',
  'delivery',
  'approved'
);

select *
from public.process_guard_qr_entry(
  (select id from public.app_users where email = 'guard@gmail.com'),
  'QR-DEL-1034',
  'approved'
);

-- Community write actions
select *
from public.create_community_suggestion(
  (select id from public.app_users where email = 'user@gmail.com'),
  'Add a weekend yoga deck',
  'Wellness',
  'Convert a small corner of the terrace into a quiet yoga deck for morning classes.',
  'A dedicated deck would support small resident wellness sessions and create another reason to use the rooftop outside peak gym hours.',
  'all_residents',
  true,
  18,
  null,
  'self_improvement',
  '#7C3AED'
);

select *
from public.review_community_suggestion(
  (select id from public.app_users where email = 'admin@gmail.com'),
  (
    select id
    from public.community_suggestions
    where title = 'Add a weekend yoga deck'
    limit 1
  ),
  'published'
);

select *
from public.vote_community_suggestion(
  (select id from public.app_users where email = 'user@gmail.com'),
  (
    select id
    from public.community_suggestions
    where status in ('published', 'active')
    order by created_at desc
    limit 1
  ),
  'in_favor'
);

select *
from public.join_community_suggestion(
  (select id from public.app_users where email = 'user@gmail.com'),
  (
    select id
    from public.community_suggestions
    where title = 'Community Composting Program'
    limit 1
  )
);

select *
from public.add_community_suggestion_comment(
  (select id from public.app_users where email = 'user@gmail.com'),
  (
    select id
    from public.community_suggestions
    where title = 'Community Composting Program'
    limit 1
  ),
  'This looks promising. We should also identify a vendor for the first three months of onboarding.'
);
