-- =====================================================
-- MCH Kenya - Debug Empty Appointments Screen
-- Run this in Supabase SQL Editor
-- =====================================================

-- STEP 1: Check what appointments exist and their facility_id
-- =====================================================
SELECT 
  id,
  maternal_profile_id,
  facility_id,
  appointment_date,
  status,
  created_by,
  health_worker_id,
  created_at
FROM appointments
ORDER BY created_at DESC
LIMIT 20;

-- STEP 2: Check your user's facility_id
-- =====================================================
-- Replace 'your-user-id' with your actual auth.uid() or run:
SELECT id, full_name, role, facility_id 
FROM user_profiles 
WHERE role = 'health_worker' OR role = 'admin';

-- STEP 3: Check current RLS policies on appointments
-- =====================================================
SELECT policyname, cmd, qual, with_check
FROM pg_policies 
WHERE tablename = 'appointments';

-- STEP 4: Check if facilities match
-- =====================================================
-- This shows appointments that SHOULD be visible to health workers
SELECT 
  a.id as appointment_id,
  a.facility_id as apt_facility,
  up.facility_id as user_facility,
  CASE WHEN a.facility_id = up.facility_id THEN 'MATCH' ELSE 'NO MATCH' END as status
FROM appointments a
CROSS JOIN user_profiles up
WHERE up.role IN ('health_worker', 'admin')
LIMIT 50;
