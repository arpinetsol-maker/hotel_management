-- Create profile in public.users when a new auth user is created.
-- Run this in Supabase SQL Editor (Dashboard → SQL Editor) so signup works with RLS.

-- Function: insert into public.users from auth.users new row (uses raw_user_meta_data from signUp data).
-- This function runs with elevated privileges (security definer) so it bypasses RLS.
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer set search_path = public
as $$
begin
  -- Insert into public.users with data from auth.users and metadata
  insert into public.users (
    id,
    email,
    full_name,
    phone,
    user_type,
    created_at,
    updated_at
  )
  values (
    new.id,
    coalesce(new.email, ''),
    coalesce(new.raw_user_meta_data->>'full_name', ''),
    nullif(new.raw_user_meta_data->>'phone', ''),
    coalesce(nullif(new.raw_user_meta_data->>'user_type', ''), 'user'),
    coalesce(new.created_at, now()),
    now()
  )
  on conflict (id) do nothing; -- Prevent duplicate inserts if trigger fires twice
  return new;
exception
  when others then
    -- Log error but don't fail the auth.users insert
    raise warning 'Failed to create user profile: %', SQLERRM;
    return new;
end;
$$;

-- Trigger: after insert on auth.users
drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();
