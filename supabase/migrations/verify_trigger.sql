-- Verification script: Check if trigger and function exist
-- Run this in Supabase SQL Editor to verify the trigger is set up correctly

-- Check if function exists
SELECT 
    proname as function_name,
    pg_get_functiondef(oid) as function_definition
FROM pg_proc
WHERE proname = 'handle_new_user';

-- Check if trigger exists
SELECT 
    tgname as trigger_name,
    tgrelid::regclass as table_name,
    tgenabled as enabled,
    pg_get_triggerdef(oid) as trigger_definition
FROM pg_trigger
WHERE tgname = 'on_auth_user_created';

-- Test: Check recent auth.users to see if corresponding public.users rows exist
SELECT 
    au.id,
    au.email,
    au.raw_user_meta_data,
    pu.id as profile_exists,
    pu.full_name,
    pu.user_type
FROM auth.users au
LEFT JOIN public.users pu ON au.id = pu.id
ORDER BY au.created_at DESC
LIMIT 10;
