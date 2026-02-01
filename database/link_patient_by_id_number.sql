-- =====================================================
-- MCH Kenya - Link Patient Profile by ID Number
-- Run this in Supabase SQL Editor
-- =====================================================

-- 1. Update the handle_new_user function to link maternal_profiles
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
DECLARE
  v_role TEXT;
  v_id_number TEXT;
  v_full_name TEXT;
  v_facility_id UUID;
  v_existing_profile_id UUID;
BEGIN
  v_role := COALESCE(NEW.raw_user_meta_data->>'role', 'patient');
  v_id_number := NEW.raw_user_meta_data->>'id_number';
  v_full_name := COALESCE(NEW.raw_user_meta_data->>'full_name', '');
  
  -- parse facility_id safely
  BEGIN
    v_facility_id := (NEW.raw_user_meta_data->>'facility_id')::uuid;
  EXCEPTION WHEN OTHERS THEN
    v_facility_id := NULL;
  END;

  -- 1. Create entry in user_profiles (standard for all users)
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
    v_full_name,
    v_role,
    v_facility_id,
    NOW(),
    NOW()
  )
  ON CONFLICT (id) DO NOTHING;

  -- 2. If user is a PATIENT, try to link or create maternal_profile
  IF v_role = 'patient' THEN
      
      IF v_id_number IS NOT NULL AND length(v_id_number) > 0 THEN
          
          -- A. Try to find existing profile by ID Number (that isn't claimed yet)
          -- We assume the column is 'auth_id' based on the app code. 
          -- If 'user_id' is the column, this needs adjustment. 
          -- We check if auth_id is NULL or empty to allow claiming.
          
          UPDATE maternal_profiles
          SET auth_id = NEW.id
          WHERE id_number = v_id_number 
            AND (auth_id IS NULL OR auth_id = NEW.id)
          RETURNING id INTO v_existing_profile_id;

          -- B. If no profile found (or already claimed by someone else?), create new one
          -- Note: If already claimed by SOMEONE ELSE, we don't touch it (security).
          
          IF v_existing_profile_id IS NULL THEN
             
             -- Check if it is claimed by someone else
             PERFORM 1 FROM maternal_profiles WHERE id_number = v_id_number;
             
             IF NOT FOUND THEN
                 -- Profile doesn't exist at all, create new one
                 INSERT INTO maternal_profiles (
                    auth_id, 
                    client_name, 
                    id_number, 
                    facility_id, -- Might be null if self-registered
                    created_at,
                    updated_at
                 )
                 VALUES (
                    NEW.id, 
                    v_full_name, 
                    v_id_number, 
                    v_facility_id,
                    NOW(),
                    NOW()
                 );
             END IF;
          END IF;
      END IF;
  END IF;

  RETURN NEW;
EXCEPTION
  WHEN OTHERS THEN
    -- Log error but don't fail the signup
    RAISE WARNING 'Error in handle_new_user: %', SQLERRM;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 2. Re-create the trigger (just in case)
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();
