-- =====================================================
-- MCH Kenya - Complete Health Worker Appointment Access Fix
-- Run this entire script in Supabase SQL Editor
-- =====================================================

-- STEP 1: Drop all existing appointment policies for health workers
-- =====================================================
DROP POLICY IF EXISTS "Health workers can view appointments" ON appointments;
DROP POLICY IF EXISTS "Health workers can delete appointments" ON appointments;
DROP POLICY IF EXISTS "Health workers can update appointments" ON appointments;
DROP POLICY IF EXISTS "Health workers can insert appointments" ON appointments;
DROP POLICY IF EXISTS "Health workers can view appointments at their facility" ON appointments;
DROP POLICY IF EXISTS "Health workers can manage facility appointments" ON appointments;
DROP POLICY IF EXISTS "Health workers can create appointments at their facility" ON appointments;

-- STEP 2: Create proper health worker SELECT policy
-- =====================================================
CREATE POLICY "Health workers can view facility appointments"
  ON appointments FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM user_profiles
      WHERE user_profiles.id = auth.uid()
        AND user_profiles.role IN ('health_worker', 'admin')
        AND user_profiles.facility_id = appointments.facility_id
    )
  );

-- STEP 3: Create health worker INSERT policy
-- =====================================================
CREATE POLICY "Health workers can create facility appointments"
  ON appointments FOR INSERT
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM user_profiles
      WHERE user_profiles.id = auth.uid()
        AND user_profiles.role IN ('health_worker', 'admin')
        AND user_profiles.facility_id = appointments.facility_id
    )
  );

-- STEP 4: Create health worker UPDATE policy
-- =====================================================
CREATE POLICY "Health workers can update facility appointments"
  ON appointments FOR UPDATE
  USING (
    EXISTS (
      SELECT 1 FROM user_profiles
      WHERE user_profiles.id = auth.uid()
        AND user_profiles.role IN ('health_worker', 'admin')
        AND user_profiles.facility_id = appointments.facility_id
    )
  );

-- STEP 5: Create health worker DELETE policy
-- =====================================================
CREATE POLICY "Health workers can delete facility appointments"
  ON appointments FOR DELETE
  USING (
    EXISTS (
      SELECT 1 FROM user_profiles
      WHERE user_profiles.id = auth.uid()
        AND user_profiles.role IN ('health_worker', 'admin')
        AND user_profiles.facility_id = appointments.facility_id
    )
  );

-- STEP 6: Verify policies are created
-- =====================================================
SELECT policyname, cmd FROM pg_policies WHERE tablename = 'appointments';

-- STEP 7: Check your user's facility assignment
-- =====================================================
-- Make sure your health worker has a facility_id assigned
SELECT id, full_name, role, facility_id 
FROM user_profiles 
WHERE id = auth.uid();

-- STEP 8: Check if appointments have matching facility_id
-- =====================================================
SELECT 
  a.id,
  a.facility_id as appointment_facility,
  up.facility_id as your_facility,
  CASE WHEN a.facility_id = up.facility_id THEN '✓ Will show' ELSE '✗ Hidden' END as visibility
FROM appointments a
CROSS JOIN user_profiles up
WHERE up.id = auth.uid()
ORDER BY a.created_at DESC
LIMIT 10;
