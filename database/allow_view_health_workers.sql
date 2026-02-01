-- =====================================================
-- Allow Patients to View Health Workers
-- Run this in Supabase SQL Editor
-- =====================================================

-- This policy allows any authenticated user (including patients)
-- to view the profiles of health workers. This is necessary for
-- the "Book Appointment" feature where patients browse doctors.

CREATE POLICY "Users can view health workers"
  ON user_profiles FOR SELECT
  USING (role = 'health_worker');
