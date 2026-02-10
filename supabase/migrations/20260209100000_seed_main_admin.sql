-- Static main admin user for direct login
-- Email: arpi.netsol@gmail.com
-- Password: 123456
--
-- If this migration fails (e.g. auth.users schema differs), create the user manually:
--   1. Dashboard → Authentication → Users → Add user
--   2. Email: arpi.netsol@gmail.com, Password: 123456
--   3. User Metadata: {"user_type": "admin", "full_name": "Main Admin"}
--   4. Then run: UPDATE public.users SET user_type = 'admin', full_name = 'Main Admin' WHERE email = 'arpi.netsol@gmail.com';

-- Create extension for password hashing (if not exists)
create extension if not exists pgcrypto;

-- Insert main admin into auth.users only if email does not exist.
-- The trigger handle_new_user will create the corresponding row in public.users.
do $$
declare
  admin_id uuid := gen_random_uuid();
begin
  if not exists (select 1 from auth.users where email = 'arpi.netsol@gmail.com') then
    insert into auth.users (
      id,
      instance_id,
      aud,
      role,
      email,
      encrypted_password,
      email_confirmed_at,
      raw_user_meta_data,
      raw_app_meta_data,
      created_at,
      updated_at
    )
    values (
      admin_id,
      '00000000-0000-0000-0000-000000000000',
      'authenticated',
      'authenticated',
      'arpi.netsol@gmail.com',
      crypt('123456', gen_salt('bf')),
      now(),
      '{"user_type": "admin", "full_name": "Main Admin"}'::jsonb,
      '{"provider": "email", "providers": ["email"]}'::jsonb,
      now(),
      now()
    );
  end if;

  -- Ensure public.users has main admin (creates/updates after trigger or if user existed)
  insert into public.users (id, email, full_name, user_type, created_at, updated_at)
  select id, 'arpi.netsol@gmail.com', 'Main Admin', 'admin', now(), now()
  from auth.users
  where email = 'arpi.netsol@gmail.com'
  on conflict (id) do update set
    user_type = 'admin',
    full_name = 'Main Admin',
    updated_at = now();
end
$$;
