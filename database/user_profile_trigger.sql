-- =====================================================
-- MCH Kenya - User Profile Creation Trigger
-- Run this in Supabase SQL Editor
-- =====================================================
-- This trigger automatically creates a user_profiles row
-- when a new user signs up, copying the facility_id from
-- user metadata to enable RLS-based facility filtering.
-- =====================================================

-- STEP 1: Create the trigger function
-- =====================================================

CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.user_profiles (
    id,
    email,
    full_name,
    role,
    facility_id,
    created_at,
    updated_at
  )
  VALUES (
    NEW.id,
    NEW.email,
    COALESCE(NEW.raw_user_meta_data->>'full_name', ''),
    COALESCE(NEW.raw_user_meta_data->>'role', 'patient'),
    (NEW.raw_user_meta_data->>'facility_id')::uuid,
    NOW(),
    NOW()
  );
  RETURN NEW;
EXCEPTION
  WHEN unique_violation THEN
    -- Profile already exists, just return
    RETURN NEW;
  WHEN OTHERS THEN
    -- Log error but don't fail the signup
    RAISE WARNING 'Failed to create user profile: %', SQLERRM;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- =====================================================
-- STEP 2: Create the trigger on auth.users
-- =====================================================

-- Drop existing trigger if it exists
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;

-- Create new trigger
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- =====================================================
-- STEP 3: Verify the setup
-- =====================================================
-- Run this to check if trigger exists:
-- SELECT tgname FROM pg_trigger WHERE tgname = 'on_auth_user_created';

-- =====================================================
-- NOTES:
-- - This trigger fires AFTER a new user is inserted in auth.users
-- - It copies facility_id from user metadata to user_profiles
-- - The RLS function get_user_facility_id() reads from user_profiles
-- - This enables facility-based patient filtering
-- =====================================================
