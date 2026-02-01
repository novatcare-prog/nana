-- =====================================================
-- Ensure Patients Can View ALL Their Appointments
-- =====================================================

-- 1. Use the correct database/schema context (implicit in Supabase SQL Editor)

-- 2. Ensure health_worker_id column exists
ALTER TABLE appointments 
ADD COLUMN IF NOT EXISTS health_worker_id UUID REFERENCES auth.users(id);

-- 3. Ensure RLS is enabled
ALTER TABLE appointments ENABLE ROW LEVEL SECURITY;

-- 4. Re-create the SELECT policy for patients
-- This ensures they can view appointments linked to their Main Maternal Profile
DROP POLICY IF EXISTS "Patients can view own appointments" ON appointments;

CREATE POLICY "Patients can view own appointments"
  ON appointments FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM maternal_profiles mp
      WHERE mp.id = appointments.maternal_profile_id::uuid
        AND mp.auth_id = auth.uid()
    )
  );

-- 5. Create Trigger to automatically set health_worker_id from created_by
-- This ensures that even if the app only sends created_by, we populate the foreign key
CREATE OR REPLACE FUNCTION public.sync_appointment_created_by()
RETURNS TRIGGER AS $$
BEGIN
  -- If health_worker_id is null, but created_by is set, copy it
  -- (Assuming created_by holds the Auth UUID of the worker)
  IF NEW.health_worker_id IS NULL AND NEW.created_by IS NOT NULL THEN
    -- Verify if created_by looks like a UUID (simple check length)
    IF LENGTH(NEW.created_by) = 36 THEN
        BEGIN
            NEW.health_worker_id := NEW.created_by::uuid;
        EXCEPTION WHEN OTHERS THEN
            -- Ignore casting errors
        END;
    END IF;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS tr_sync_appointment_hw_id ON appointments;

CREATE TRIGGER tr_sync_appointment_hw_id
BEFORE INSERT ON appointments
FOR EACH ROW
EXECUTE FUNCTION public.sync_appointment_created_by();
