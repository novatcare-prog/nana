-- =====================================================
-- MCH Kenya - Fix Existing Patient Links & Data
-- Run this in Supabase SQL Editor
-- =====================================================

-- 1. BACKFILL LINKS for existing users
-- Matches auth.users to maternal_profiles by ID Number
-- ensuring previously registered patients get access to their data.

UPDATE maternal_profiles mp
SET auth_id = u.id
FROM auth.users u
WHERE mp.auth_id IS NULL -- Only link if currently unlinked
  AND (u.raw_user_meta_data->>'id_number') IS NOT NULL
  AND (u.raw_user_meta_data->>'id_number') <> ''
  AND mp.id_number = (u.raw_user_meta_data->>'id_number');

-- 2. DENORMALIZE Facility Name (if column exists)
-- Ensure facility_name is populated in maternal_profiles for easy fetching.
-- (This assumes the column exists. If not, it will be ignored or error, but safe to try if column exists)

DO $$ 
BEGIN 
    -- Check if column exists before trying to update
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'maternal_profiles' AND column_name = 'facility_name') THEN
        
        -- Corrected: Use 'facility_name' instead of 'name' for the facilities table
        UPDATE maternal_profiles mp
        SET facility_name = f.facility_name
        FROM facilities f
        WHERE mp.facility_id = f.id
          AND (mp.facility_name IS NULL OR mp.facility_name = '')
          AND f.facility_name IS NOT NULL;
          
    END IF;
END $$;
