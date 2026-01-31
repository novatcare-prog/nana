-- =====================================================
-- MCH Kenya - Fix Patient Appointment Access
-- Run this in Supabase SQL Editor
-- =====================================================
-- PROBLEM: The current RLS policy uses patient_id = auth.uid()
-- but appointments are linked via maternal_profile_id, not patient_id.
-- 
-- FIX: Check if the maternal_profile's auth_id matches the logged-in user.
-- =====================================================

-- STEP 1: Drop the old broken policy
-- =====================================================
DROP POLICY IF EXISTS "Patients can view own appointments" ON appointments;

-- STEP 2: Create the correct policy
-- =====================================================
-- This checks if the appointment's maternal_profile_id belongs to the 
-- logged-in user (via the auth_id column in maternal_profiles)

CREATE POLICY "Patients can view own appointments"
  ON appointments FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM maternal_profiles mp
      WHERE mp.id = appointments.maternal_profile_id::uuid
        AND mp.auth_id = auth.uid()
    )
  );

-- =====================================================
-- STEP 3: Verify the policy was created
-- =====================================================
-- Run this to check:
-- SELECT * FROM pg_policies WHERE tablename = 'appointments';

-- =====================================================
-- HOW IT WORKS:
-- 1. When a patient logs in, auth.uid() returns their user ID
-- 2. The patient has a maternal_profile with auth_id = their user ID
-- 3. This policy allows SELECT on appointments where:
--    appointment.maternal_profile_id → maternal_profiles.auth_id = logged-in user
-- =====================================================
