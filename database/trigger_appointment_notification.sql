-- =====================================================
-- Trigger: Notify Patient on New Appointment
-- Run in Supabase SQL Editor
-- =====================================================

CREATE OR REPLACE FUNCTION public.notify_patient_on_appointment()
RETURNS TRIGGER AS $$
DECLARE
  v_user_id UUID;
  v_facility_name TEXT;
BEGIN
  -- Get the auth_id (user_id) of the patient
  SELECT auth_id, facility_name INTO v_user_id, v_facility_name
  FROM maternal_profiles
  WHERE id = NEW.maternal_profile_id::uuid;

  -- Default facility name if missing
  IF v_facility_name IS NULL OR v_facility_name = '' THEN
    v_facility_name := 'Health Facility';
  END IF;

  -- Only notify if we found a linked user
  IF v_user_id IS NOT NULL THEN
    INSERT INTO notifications (user_id, title, body, type, metadata)
    VALUES (
      v_user_id,
      'New Appointment Scheduled',
      'New appointment at ' || v_facility_name || ' on ' || to_char(NEW.appointment_date, 'Dy, DD Mon at HH24:MI'),
      'appointment_booked',
      jsonb_build_object('appointment_id', NEW.id)
    );
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Drop trigger if exists to avoid duplication
DROP TRIGGER IF EXISTS on_appointment_created ON appointments;

CREATE TRIGGER on_appointment_created
AFTER INSERT ON appointments
FOR EACH ROW
EXECUTE FUNCTION public.notify_patient_on_appointment();
