-- Enable UUID extension if not already enabled
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 1. Create table for temporary access codes
CREATE TABLE IF NOT EXISTS public.patient_access_codes (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    patient_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    code TEXT NOT NULL,
    expires_at TIMESTAMP WITH TIME ZONE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    CONSTRAINT patient_access_codes_code_check CHECK (length(code) = 6)
);

-- Index for fast lookup
CREATE INDEX IF NOT EXISTS idx_patient_access_codes_code ON public.patient_access_codes(code);

-- 2. Enable RLS
ALTER TABLE public.patient_access_codes ENABLE ROW LEVEL SECURITY;

-- 3. RLS Policies
-- Patient can insert their own codes
CREATE POLICY "Patients can insert own access codes"
    ON public.patient_access_codes
    FOR INSERT
    TO authenticated
    WITH CHECK (auth.uid() = patient_id);

-- Patient can view their own codes (optional)
CREATE POLICY "Patients can view own access codes"
    ON public.patient_access_codes
    FOR SELECT
    TO authenticated
    USING (auth.uid() = patient_id);

-- Nobody else can access this table directly (Health workers use RPC)

-- 4. Secure RPC Function to fetch data
CREATE OR REPLACE FUNCTION public.get_shared_patient_data(input_code TEXT)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER -- Runs with superuser privileges to bypass RLS
AS $$
DECLARE
    found_patient_id UUID;
    patient_profile JSONB;
    recent_visits JSONB;
    vitals JSONB;
BEGIN
    -- 1. Validate Code
    SELECT patient_id INTO found_patient_id
    FROM public.patient_access_codes
    WHERE code = input_code
      AND expires_at > NOW();

    IF found_patient_id IS NULL THEN
        RAISE EXCEPTION 'Invalid or expired access code';
    END IF;

    -- 2. Fetch Maternal Profile (Clinical Data)
    -- We join user_profiles to find the linked maternal_profile_id
    SELECT to_jsonb(mp) INTO patient_profile
    FROM public.user_profiles u
    JOIN public.maternal_profiles mp ON u.maternal_profile_id = mp.id
    WHERE u.id = found_patient_id;

    IF patient_profile IS NULL THEN
        RAISE EXCEPTION 'No clinical profile found for this user';
    END IF;

    -- 3. Fetch Recent Visits (Limit 5)
    -- Assuming visits happen via 'appointments' or another table. 
    SELECT jsonb_agg(t) INTO recent_visits
    FROM (
        SELECT id, appointment_date, status, notes
        FROM public.appointments
        WHERE patient_id = found_patient_id
        ORDER BY appointment_date DESC
        LIMIT 5
    ) t;

    -- 4. Fetch User Vitals
    vitals := '[]'::jsonb;

    -- 5. Return Constructed JSON
    RETURN jsonb_build_object(
        'profile', patient_profile,
        'recentVisits', COALESCE(recent_visits, '[]'::jsonb),
        'vitals', vitals,
        'accessedAt', NOW()
    );
END;
$$;
