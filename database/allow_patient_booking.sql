-- =====================================================
-- Allow Patients to Book Appointments + Fix Schema
-- Run this in Supabase SQL Editor
-- =====================================================

-- 1. Ensure 'health_worker_id' column exists (Postgres 9.6+)
ALTER TABLE appointments 
ADD COLUMN IF NOT EXISTS health_worker_id UUID REFERENCES auth.users(id);

-- 2. Enable RLS (safe to re-run)
ALTER TABLE appointments ENABLE ROW LEVEL SECURITY;

-- 3. Drop existing policies to avoid "already exists" errors
DROP POLICY IF EXISTS "Patients can book appointments" ON appointments;
DROP POLICY IF EXISTS "Patients can update own appointments" ON appointments;

-- 4. Policy: Allow Patients to INSERT (Book) Appointments
-- They can only insert if the maternal_profile_id belongs to them
CREATE POLICY "Patients can book appointments"
  ON appointments FOR INSERT
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM maternal_profiles mp
      WHERE mp.id = CAST(maternal_profile_id AS UUID)
        AND mp.auth_id = auth.uid()
    )
  );

-- 5. Policy: Allow Patients to UPDATE their appointments (e.g. cancel/reschedule)
CREATE POLICY "Patients can update own appointments"
  ON appointments FOR UPDATE
  USING (
    EXISTS (
      SELECT 1 FROM maternal_profiles mp
      WHERE mp.id = CAST(maternal_profile_id AS UUID)
        AND mp.auth_id = auth.uid()
    )
  );
