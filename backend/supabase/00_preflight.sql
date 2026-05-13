do $$
begin
  alter type public.app_role add value if not exists 'super_user';
exception
  when duplicate_object then null;
end $$;
