-- =====================================================
-- Fix: Ensure Parents Can View Children Added by Health Workers
-- Run this in Supabase SQL Editor
-- =====================================================

-- This script ensures that when a health worker adds a child for a mother,
-- that child will appear in the mother's patient app

-- STEP 1: Verify the child_profiles table structure
-- =====================================================
-- Check if maternal_profile_id column exists and is properly indexed
-- (Run this manually to inspect, not part of the fix)
-- SELECT column_name, data_type 
-- FROM information_schema.columns 
-- WHERE table_name = 'child_profiles' 
-- AND column_name = 'maternal_profile_id';

-- STEP 2: Ensure is_active column exists
-- =====================================================
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'child_profiles' 
        AND column_name = 'is_active'
    ) THEN
        ALTER TABLE child_profiles ADD COLUMN is_active BOOLEAN DEFAULT TRUE;
        COMMENT ON COLUMN child_profiles.is_active IS 'Soft delete flag - false means child record is inactive';
    END IF;
END $$;

-- STEP 3: Update any existing  children to be active by default
-- =====================================================
UPDATE child_profiles
SET is_active = TRUE
WHERE is_active IS NULL;

-- STEP 4: Re-create the patient view policy (most important)
-- ===================================================== 
-- This is the policy that allows parents to see their children
DROP POLICY IF EXISTS "Parents can view own children" ON child_profiles;

CREATE POLICY "Parents can view own children"
ON child_profiles FOR SELECT
USING (
  is_active = TRUE
  AND maternal_profile_id IN (
    SELECT mp.id FROM maternal_profiles mp
    WHERE mp.auth_id = auth.uid()
  )
);

-- STEP 5: Verify health worker can insert children policy exists
-- =====================================================
-- Recreate to ensure it's current
DROP POLICY IF EXISTS "Health workers can insert children" ON child_profiles;

CREATE POLICY "Health workers can insert children"
ON child_profiles FOR INSERT
WITH CHECK (
  maternal_profile_id IN (
    SELECT mp.id FROM maternal_profiles mp
    WHERE mp.facility_id IN (
      SELECT up.facility_id FROM user_profiles up
      WHERE up.id = auth.uid() 
      AND up.role IN ('health_worker', 'admin')
    )
  )
);

-- STEP 6: Verify health worker can view children policy
-- =====================================================
DROP POLICY IF EXISTS "Health workers can view facility children" ON child_profiles;

CREATE POLICY "Health workers can view facility children"
ON child_profiles FOR SELECT
USING (
  maternal_profile_id IN (
    SELECT mp.id FROM maternal_profiles mp
    WHERE mp.facility_id IN (
      SELECT up.facility_id FROM user_profiles up
      WHERE up.id = auth.uid() 
      AND up.role IN ('health_worker', 'admin')
    )
  )
);

-- STEP 7: Create database function to help debug
-- =====================================================
CREATE OR REPLACE FUNCTION public.debug_child_visibility(
  p_child_id UUID
)
RETURNS TABLE (
  child_id UUID,
  child_name TEXT,
  maternal_profile_id UUID,
  mother_auth_id UUID,
  mother_name TEXT,
  is_active BOOLEAN,
  can_view_as_patient BOOLEAN,
  current_user_id UUID
) 
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  RETURN QUERY
  SELECT 
    cp.id,
    cp.child_name,
    cp.maternal_profile_id::UUID,
    mp.auth_id,
    mp.client_name,
    cp.is_active,
    (mp.auth_id = auth.uid()) AS can_view_as_patient,
    auth.uid() AS current_user_id
  FROM child_profiles cp
  LEFT JOIN maternal_profiles mp ON mp.id = cp.maternal_profile_id
  WHERE cp.id = p_child_id;
END;
$$;

COMMENT ON FUNCTION public.debug_child_visibility IS 
'Helper function to debug why a child may not be visible to a patient. 
Call this as a health worker or admin to see the linking details.';

-- STEP 8: Create a helper view for testing (optional)
-- =====================================================
CREATE OR REPLACE VIEW public.v_child_parent_link AS
SELECT 
  cp.id AS child_id,
  cp.child_name,
  cp.maternal_profile_id,
  cp.is_active AS child_is_active,
  mp.id AS maternal_profile_id_actual,
  mp.auth_id AS mother_auth_id,
  mp.client_name AS mother_name,
  mp.facility_id
FROM child_profiles cp
LEFT JOIN maternal_profiles mp ON cp.maternal_profile_id = mp.id
WHERE cp.is_active = TRUE;

COMMENT ON VIEW public.v_child_parent_link IS 
'View showing the relationship between children and their mothers. 
Useful for debugging visibility issues.';

-- STEP 9: Verification Queries (run these manually after applying the fix)
-- =====================================================
-- To test as a specific user, you can use:
-- 
-- 1. Check if a specific child is linked correctly:
--    SELECT * FROM public.debug_child_visibility('<child_id>');
--
-- 2. See all children and their maternal profile links:
--    SELECT * FROM public.v_child_parent_link LIMIT 20;
--
-- 3. Count children per maternal profile:
--    SELECT maternal_profile_id, COUNT(*) as child_count
--    FROM child_profiles 
--    WHERE is_active = TRUE
--    GROUP BY maternal_profile_id;

-- =====================================================
-- DONE! 
-- =====================================================
-- After running this script:
-- 1. Health workers can add children for mothers
-- 2. Those children will automatically appear in the mother's patient app
-- 3. The child must be linked to the mother's maternal_profile_id  
-- 4. The child must have is_active = TRUE
