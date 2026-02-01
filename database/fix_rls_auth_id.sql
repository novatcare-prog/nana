-- =====================================================
-- FIX: Update RLS Policies to use auth_id instead of user_id  
-- Run this in Supabase SQL Editor
-- =====================================================
-- The maternal_profiles table uses 'auth_id' to link to auth.users,
-- not 'user_id'. This script fixes all RLS policies.
-- =====================================================

-- 1. FIX: Appointments - Patients can view own appointments
DROP POLICY IF EXISTS "Patients can view own appointments" ON appointments;

CREATE POLICY "Patients can view own appointments"
  ON appointments FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM maternal_profiles WHERE auth_id = auth.uid()
      AND id = appointments.maternal_profile_id::uuid
    )
  );

-- 2. FIX: Appointments - Patients can insert appointments
DROP POLICY IF EXISTS "Patients can book own appointments" ON appointments;

CREATE POLICY "Patients can book own appointments"
  ON appointments FOR INSERT
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM maternal_profiles WHERE auth_id = auth.uid()
      AND id = maternal_profile_id::uuid
    )
  );

-- 3. FIX: Appointments - Patients can update own appointments  
DROP POLICY IF EXISTS "Patients can update own appointments" ON appointments;

CREATE POLICY "Patients can update own appointments"
  ON appointments FOR UPDATE
  USING (
    EXISTS (
      SELECT 1 FROM maternal_profiles mp
      WHERE mp.auth_id = auth.uid()
      AND mp.id = appointments.maternal_profile_id::uuid
    )
  );

-- 4. FIX: ANC Visits - Patients can view own visits (only if table exists)
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'anc_visits') THEN
    EXECUTE 'DROP POLICY IF EXISTS "Patients can view own anc_visits" ON anc_visits';
    EXECUTE '
      CREATE POLICY "Patients can view own anc_visits"
        ON anc_visits FOR SELECT
        USING (
          EXISTS (
            SELECT 1 FROM maternal_profiles mp
            WHERE mp.auth_id = auth.uid()
            AND mp.id = anc_visits.maternal_profile_id::uuid
          )
        )
    ';
  END IF;
END $$;

-- 5. FIX: Lab Results - Patients can view own results (only if table exists)
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'lab_results') THEN
    EXECUTE 'DROP POLICY IF EXISTS "Patients can view own lab results" ON lab_results';
    EXECUTE '
      CREATE POLICY "Patients can view own lab results"
        ON lab_results FOR SELECT
        USING (
          EXISTS (
            SELECT 1 FROM maternal_profiles mp
            WHERE mp.auth_id = auth.uid()
            AND mp.id = lab_results.maternal_profile_id::uuid
          )
        )
    ';
  END IF;
END $$;

-- Done! 
SELECT 'RLS policies updated to use auth_id instead of user_id' as status;
