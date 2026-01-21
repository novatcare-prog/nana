-- =====================================================
-- MCH Kenya - Tightened RLS Policies for Child Data
-- Run in Supabase SQL Editor
-- =====================================================

-- STEP 1: Drop existing permissive policies on child-related tables
-- =====================================================

-- child_profiles
DROP POLICY IF EXISTS "Allow authenticated users to delete child profiles" ON child_profiles;
DROP POLICY IF EXISTS "Allow authenticated users to insert child profiles" ON child_profiles;
DROP POLICY IF EXISTS "Allow authenticated users to update child profiles" ON child_profiles;
DROP POLICY IF EXISTS "Allow authenticated users to view child profiles" ON child_profiles;

-- child_immunizations
DROP POLICY IF EXISTS "Health workers can delete immunization records" ON child_immunizations;
DROP POLICY IF EXISTS "Health workers can insert immunization records" ON child_immunizations;
DROP POLICY IF EXISTS "Health workers can update immunization records" ON child_immunizations;
DROP POLICY IF EXISTS "Health workers can view immunization records" ON child_immunizations;

-- growth_monitoring
DROP POLICY IF EXISTS "Allow authenticated users to delete growth records" ON growth_monitoring;
DROP POLICY IF EXISTS "Allow authenticated users to insert growth records" ON growth_monitoring;
DROP POLICY IF EXISTS "Allow authenticated users to update growth records" ON growth_monitoring;
DROP POLICY IF EXISTS "Allow authenticated users to view growth records" ON growth_monitoring;

-- developmental_milestones
DROP POLICY IF EXISTS "Health workers can delete developmental milestones" ON developmental_milestones;
DROP POLICY IF EXISTS "Health workers can insert developmental milestones" ON developmental_milestones;
DROP POLICY IF EXISTS "Health workers can update developmental milestones" ON developmental_milestones;
DROP POLICY IF EXISTS "Health workers can view developmental milestones" ON developmental_milestones;

-- deworming
DROP POLICY IF EXISTS "Health workers can delete deworming records" ON deworming;
DROP POLICY IF EXISTS "Health workers can insert deworming records" ON deworming;
DROP POLICY IF EXISTS "Health workers can update deworming records" ON deworming;
DROP POLICY IF EXISTS "Health workers can view deworming records" ON deworming;

-- vitamin_a_supplementation
DROP POLICY IF EXISTS "Health workers can delete vitamin A records" ON vitamin_a_supplementation;
DROP POLICY IF EXISTS "Health workers can insert vitamin A records" ON vitamin_a_supplementation;
DROP POLICY IF EXISTS "Health workers can update vitamin A records" ON vitamin_a_supplementation;
DROP POLICY IF EXISTS "Health workers can view vitamin A records" ON vitamin_a_supplementation;

-- postnatal_visits
DROP POLICY IF EXISTS "Health workers can delete postnatal visits" ON postnatal_visits;
DROP POLICY IF EXISTS "Health workers can insert postnatal visits" ON postnatal_visits;
DROP POLICY IF EXISTS "Health workers can update postnatal visits" ON postnatal_visits;
DROP POLICY IF EXISTS "Health workers can view postnatal visits" ON postnatal_visits;

-- childbirth_records
DROP POLICY IF EXISTS "Allow authenticated users to delete childbirth records" ON childbirth_records;
DROP POLICY IF EXISTS "Allow authenticated users to insert childbirth records" ON childbirth_records;
DROP POLICY IF EXISTS "Allow authenticated users to update childbirth records" ON childbirth_records;
DROP POLICY IF EXISTS "Allow authenticated users to view childbirth records" ON childbirth_records;


-- =====================================================
-- STEP 2: Create new properly-scoped policies
-- =====================================================

-- =====================================================
-- child_profiles
-- =====================================================

-- Parents can view their own children
CREATE POLICY "Parents can view own children"
ON child_profiles FOR SELECT
USING (
  maternal_profile_id IN (
    SELECT mp.id FROM maternal_profiles mp
    WHERE mp.auth_id = auth.uid()
  )
);

-- Health workers can view children in their facility
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

-- Health workers can insert children for their facility
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

-- Health workers can update children in their facility
CREATE POLICY "Health workers can update children"
ON child_profiles FOR UPDATE
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

-- Health workers can delete children in their facility
CREATE POLICY "Health workers can delete children"
ON child_profiles FOR DELETE
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

-- =====================================================
-- child_immunizations
-- =====================================================

-- Parents can view their children's immunizations
CREATE POLICY "Parents can view own child immunizations"
ON child_immunizations FOR SELECT
USING (
  child_profile_id IN (
    SELECT cp.id FROM child_profiles cp
    JOIN maternal_profiles mp ON cp.maternal_profile_id = mp.id
    WHERE mp.auth_id = auth.uid()
  )
);

-- Health workers can view immunizations in their facility
CREATE POLICY "Health workers can view facility immunizations"
ON child_immunizations FOR SELECT
USING (
  child_profile_id IN (
    SELECT cp.id FROM child_profiles cp
    JOIN maternal_profiles mp ON cp.maternal_profile_id = mp.id
    WHERE mp.facility_id IN (
      SELECT up.facility_id FROM user_profiles up
      WHERE up.id = auth.uid() AND up.role IN ('health_worker', 'admin')
    )
  )
);

-- Health workers can insert immunizations
CREATE POLICY "Health workers can insert immunizations"
ON child_immunizations FOR INSERT
WITH CHECK (
  child_profile_id IN (
    SELECT cp.id FROM child_profiles cp
    JOIN maternal_profiles mp ON cp.maternal_profile_id = mp.id
    WHERE mp.facility_id IN (
      SELECT up.facility_id FROM user_profiles up
      WHERE up.id = auth.uid() AND up.role IN ('health_worker', 'admin')
    )
  )
);

-- Health workers can update immunizations
CREATE POLICY "Health workers can update immunizations"
ON child_immunizations FOR UPDATE
USING (
  child_profile_id IN (
    SELECT cp.id FROM child_profiles cp
    JOIN maternal_profiles mp ON cp.maternal_profile_id = mp.id
    WHERE mp.facility_id IN (
      SELECT up.facility_id FROM user_profiles up
      WHERE up.id = auth.uid() AND up.role IN ('health_worker', 'admin')
    )
  )
);

-- Health workers can delete immunizations
CREATE POLICY "Health workers can delete immunizations"
ON child_immunizations FOR DELETE
USING (
  child_profile_id IN (
    SELECT cp.id FROM child_profiles cp
    JOIN maternal_profiles mp ON cp.maternal_profile_id = mp.id
    WHERE mp.facility_id IN (
      SELECT up.facility_id FROM user_profiles up
      WHERE up.id = auth.uid() AND up.role IN ('health_worker', 'admin')
    )
  )
);

-- =====================================================
-- growth_monitoring
-- =====================================================

-- Parents can view their children's growth records
CREATE POLICY "Parents can view own child growth"
ON growth_monitoring FOR SELECT
USING (
  child_profile_id IN (
    SELECT cp.id FROM child_profiles cp
    JOIN maternal_profiles mp ON cp.maternal_profile_id = mp.id
    WHERE mp.auth_id = auth.uid()
  )
);

-- Health workers can view growth records in their facility
CREATE POLICY "Health workers can view facility growth"
ON growth_monitoring FOR SELECT
USING (
  child_profile_id IN (
    SELECT cp.id FROM child_profiles cp
    JOIN maternal_profiles mp ON cp.maternal_profile_id = mp.id
    WHERE mp.facility_id IN (
      SELECT up.facility_id FROM user_profiles up
      WHERE up.id = auth.uid() AND up.role IN ('health_worker', 'admin')
    )
  )
);

-- Health workers can insert growth records
CREATE POLICY "Health workers can insert growth"
ON growth_monitoring FOR INSERT
WITH CHECK (
  child_profile_id IN (
    SELECT cp.id FROM child_profiles cp
    JOIN maternal_profiles mp ON cp.maternal_profile_id = mp.id
    WHERE mp.facility_id IN (
      SELECT up.facility_id FROM user_profiles up
      WHERE up.id = auth.uid() AND up.role IN ('health_worker', 'admin')
    )
  )
);

-- Health workers can update growth records
CREATE POLICY "Health workers can update growth"
ON growth_monitoring FOR UPDATE
USING (
  child_profile_id IN (
    SELECT cp.id FROM child_profiles cp
    JOIN maternal_profiles mp ON cp.maternal_profile_id = mp.id
    WHERE mp.facility_id IN (
      SELECT up.facility_id FROM user_profiles up
      WHERE up.id = auth.uid() AND up.role IN ('health_worker', 'admin')
    )
  )
);

-- Health workers can delete growth records
CREATE POLICY "Health workers can delete growth"
ON growth_monitoring FOR DELETE
USING (
  child_profile_id IN (
    SELECT cp.id FROM child_profiles cp
    JOIN maternal_profiles mp ON cp.maternal_profile_id = mp.id
    WHERE mp.facility_id IN (
      SELECT up.facility_id FROM user_profiles up
      WHERE up.id = auth.uid() AND up.role IN ('health_worker', 'admin')
    )
  )
);

-- =====================================================
-- developmental_milestones
-- =====================================================

-- Parents can view their children's milestones
CREATE POLICY "Parents can view own child milestones"
ON developmental_milestones FOR SELECT
USING (
  child_profile_id IN (
    SELECT cp.id FROM child_profiles cp
    JOIN maternal_profiles mp ON cp.maternal_profile_id = mp.id
    WHERE mp.auth_id = auth.uid()
  )
);

-- Health workers can view milestones in their facility
CREATE POLICY "Health workers can view facility milestones"
ON developmental_milestones FOR SELECT
USING (
  child_profile_id IN (
    SELECT cp.id FROM child_profiles cp
    JOIN maternal_profiles mp ON cp.maternal_profile_id = mp.id
    WHERE mp.facility_id IN (
      SELECT up.facility_id FROM user_profiles up
      WHERE up.id = auth.uid() AND up.role IN ('health_worker', 'admin')
    )
  )
);

-- Health workers can insert milestones
CREATE POLICY "Health workers can insert milestones"
ON developmental_milestones FOR INSERT
WITH CHECK (
  child_profile_id IN (
    SELECT cp.id FROM child_profiles cp
    JOIN maternal_profiles mp ON cp.maternal_profile_id = mp.id
    WHERE mp.facility_id IN (
      SELECT up.facility_id FROM user_profiles up
      WHERE up.id = auth.uid() AND up.role IN ('health_worker', 'admin')
    )
  )
);

-- Health workers can update milestones
CREATE POLICY "Health workers can update milestones"
ON developmental_milestones FOR UPDATE
USING (
  child_profile_id IN (
    SELECT cp.id FROM child_profiles cp
    JOIN maternal_profiles mp ON cp.maternal_profile_id = mp.id
    WHERE mp.facility_id IN (
      SELECT up.facility_id FROM user_profiles up
      WHERE up.id = auth.uid() AND up.role IN ('health_worker', 'admin')
    )
  )
);

-- Health workers can delete milestones
CREATE POLICY "Health workers can delete milestones"
ON developmental_milestones FOR DELETE
USING (
  child_profile_id IN (
    SELECT cp.id FROM child_profiles cp
    JOIN maternal_profiles mp ON cp.maternal_profile_id = mp.id
    WHERE mp.facility_id IN (
      SELECT up.facility_id FROM user_profiles up
      WHERE up.id = auth.uid() AND up.role IN ('health_worker', 'admin')
    )
  )
);

-- =====================================================
-- deworming
-- =====================================================

-- Parents can view their children's deworming records
CREATE POLICY "Parents can view own child deworming"
ON deworming FOR SELECT
USING (
  child_profile_id IN (
    SELECT cp.id FROM child_profiles cp
    JOIN maternal_profiles mp ON cp.maternal_profile_id = mp.id
    WHERE mp.auth_id = auth.uid()
  )
);

-- Health workers can view deworming in their facility
CREATE POLICY "Health workers can view facility deworming"
ON deworming FOR SELECT
USING (
  child_profile_id IN (
    SELECT cp.id FROM child_profiles cp
    JOIN maternal_profiles mp ON cp.maternal_profile_id = mp.id
    WHERE mp.facility_id IN (
      SELECT up.facility_id FROM user_profiles up
      WHERE up.id = auth.uid() AND up.role IN ('health_worker', 'admin')
    )
  )
);

-- Health workers can insert deworming
CREATE POLICY "Health workers can insert deworming"
ON deworming FOR INSERT
WITH CHECK (
  child_profile_id IN (
    SELECT cp.id FROM child_profiles cp
    JOIN maternal_profiles mp ON cp.maternal_profile_id = mp.id
    WHERE mp.facility_id IN (
      SELECT up.facility_id FROM user_profiles up
      WHERE up.id = auth.uid() AND up.role IN ('health_worker', 'admin')
    )
  )
);

-- Health workers can update deworming
CREATE POLICY "Health workers can update deworming"
ON deworming FOR UPDATE
USING (
  child_profile_id IN (
    SELECT cp.id FROM child_profiles cp
    JOIN maternal_profiles mp ON cp.maternal_profile_id = mp.id
    WHERE mp.facility_id IN (
      SELECT up.facility_id FROM user_profiles up
      WHERE up.id = auth.uid() AND up.role IN ('health_worker', 'admin')
    )
  )
);

-- Health workers can delete deworming
CREATE POLICY "Health workers can delete deworming"
ON deworming FOR DELETE
USING (
  child_profile_id IN (
    SELECT cp.id FROM child_profiles cp
    JOIN maternal_profiles mp ON cp.maternal_profile_id = mp.id
    WHERE mp.facility_id IN (
      SELECT up.facility_id FROM user_profiles up
      WHERE up.id = auth.uid() AND up.role IN ('health_worker', 'admin')
    )
  )
);

-- =====================================================
-- vitamin_a_supplementation
-- =====================================================

-- Parents can view their children's vitamin A records
CREATE POLICY "Parents can view own child vitamin A"
ON vitamin_a_supplementation FOR SELECT
USING (
  child_profile_id IN (
    SELECT cp.id FROM child_profiles cp
    JOIN maternal_profiles mp ON cp.maternal_profile_id = mp.id
    WHERE mp.auth_id = auth.uid()
  )
);

-- Health workers can view vitamin A in their facility
CREATE POLICY "Health workers can view facility vitamin A"
ON vitamin_a_supplementation FOR SELECT
USING (
  child_profile_id IN (
    SELECT cp.id FROM child_profiles cp
    JOIN maternal_profiles mp ON cp.maternal_profile_id = mp.id
    WHERE mp.facility_id IN (
      SELECT up.facility_id FROM user_profiles up
      WHERE up.id = auth.uid() AND up.role IN ('health_worker', 'admin')
    )
  )
);

-- Health workers can insert vitamin A
CREATE POLICY "Health workers can insert vitamin A"
ON vitamin_a_supplementation FOR INSERT
WITH CHECK (
  child_profile_id IN (
    SELECT cp.id FROM child_profiles cp
    JOIN maternal_profiles mp ON cp.maternal_profile_id = mp.id
    WHERE mp.facility_id IN (
      SELECT up.facility_id FROM user_profiles up
      WHERE up.id = auth.uid() AND up.role IN ('health_worker', 'admin')
    )
  )
);

-- Health workers can update vitamin A
CREATE POLICY "Health workers can update vitamin A"
ON vitamin_a_supplementation FOR UPDATE
USING (
  child_profile_id IN (
    SELECT cp.id FROM child_profiles cp
    JOIN maternal_profiles mp ON cp.maternal_profile_id = mp.id
    WHERE mp.facility_id IN (
      SELECT up.facility_id FROM user_profiles up
      WHERE up.id = auth.uid() AND up.role IN ('health_worker', 'admin')
    )
  )
);

-- Health workers can delete vitamin A
CREATE POLICY "Health workers can delete vitamin A"
ON vitamin_a_supplementation FOR DELETE
USING (
  child_profile_id IN (
    SELECT cp.id FROM child_profiles cp
    JOIN maternal_profiles mp ON cp.maternal_profile_id = mp.id
    WHERE mp.facility_id IN (
      SELECT up.facility_id FROM user_profiles up
      WHERE up.id = auth.uid() AND up.role IN ('health_worker', 'admin')
    )
  )
);

-- =====================================================
-- postnatal_visits (linked via maternal_profile_id)
-- =====================================================

-- Patients can view their own postnatal visits
CREATE POLICY "Patients can view own postnatal visits"
ON postnatal_visits FOR SELECT
USING (
  maternal_profile_id IN (
    SELECT mp.id FROM maternal_profiles mp
    WHERE mp.auth_id = auth.uid()
  )
);

-- Health workers can view postnatal visits in their facility
CREATE POLICY "Health workers can view facility postnatal visits"
ON postnatal_visits FOR SELECT
USING (
  maternal_profile_id IN (
    SELECT mp.id FROM maternal_profiles mp
    WHERE mp.facility_id IN (
      SELECT up.facility_id FROM user_profiles up
      WHERE up.id = auth.uid() AND up.role IN ('health_worker', 'admin')
    )
  )
);

-- Health workers can insert postnatal visits
CREATE POLICY "Health workers can insert postnatal visits"
ON postnatal_visits FOR INSERT
WITH CHECK (
  maternal_profile_id IN (
    SELECT mp.id FROM maternal_profiles mp
    WHERE mp.facility_id IN (
      SELECT up.facility_id FROM user_profiles up
      WHERE up.id = auth.uid() AND up.role IN ('health_worker', 'admin')
    )
  )
);

-- Health workers can update postnatal visits
CREATE POLICY "Health workers can update postnatal visits"
ON postnatal_visits FOR UPDATE
USING (
  maternal_profile_id IN (
    SELECT mp.id FROM maternal_profiles mp
    WHERE mp.facility_id IN (
      SELECT up.facility_id FROM user_profiles up
      WHERE up.id = auth.uid() AND up.role IN ('health_worker', 'admin')
    )
  )
);

-- Health workers can delete postnatal visits
CREATE POLICY "Health workers can delete postnatal visits"
ON postnatal_visits FOR DELETE
USING (
  maternal_profile_id IN (
    SELECT mp.id FROM maternal_profiles mp
    WHERE mp.facility_id IN (
      SELECT up.facility_id FROM user_profiles up
      WHERE up.id = auth.uid() AND up.role IN ('health_worker', 'admin')
    )
  )
);

-- =====================================================
-- childbirth_records (linked via maternal_profile_id)
-- =====================================================

-- Patients can view their own childbirth records
CREATE POLICY "Patients can view own childbirth records"
ON childbirth_records FOR SELECT
USING (
  maternal_profile_id IN (
    SELECT mp.id FROM maternal_profiles mp
    WHERE mp.auth_id = auth.uid()
  )
);

-- Health workers can view childbirth records in their facility
CREATE POLICY "Health workers can view facility childbirth"
ON childbirth_records FOR SELECT
USING (
  maternal_profile_id IN (
    SELECT mp.id FROM maternal_profiles mp
    WHERE mp.facility_id IN (
      SELECT up.facility_id FROM user_profiles up
      WHERE up.id = auth.uid() AND up.role IN ('health_worker', 'admin')
    )
  )
);

-- Health workers can insert childbirth records
CREATE POLICY "Health workers can insert childbirth"
ON childbirth_records FOR INSERT
WITH CHECK (
  maternal_profile_id IN (
    SELECT mp.id FROM maternal_profiles mp
    WHERE mp.facility_id IN (
      SELECT up.facility_id FROM user_profiles up
      WHERE up.id = auth.uid() AND up.role IN ('health_worker', 'admin')
    )
  )
);

-- Health workers can update childbirth records
CREATE POLICY "Health workers can update childbirth"
ON childbirth_records FOR UPDATE
USING (
  maternal_profile_id IN (
    SELECT mp.id FROM maternal_profiles mp
    WHERE mp.facility_id IN (
      SELECT up.facility_id FROM user_profiles up
      WHERE up.id = auth.uid() AND up.role IN ('health_worker', 'admin')
    )
  )
);

-- Health workers can delete childbirth records
CREATE POLICY "Health workers can delete childbirth"
ON childbirth_records FOR DELETE
USING (
  maternal_profile_id IN (
    SELECT mp.id FROM maternal_profiles mp
    WHERE mp.facility_id IN (
      SELECT up.facility_id FROM user_profiles up
      WHERE up.id = auth.uid() AND up.role IN ('health_worker', 'admin')
    )
  )
);

-- =====================================================
-- Done! Verify with:
-- SELECT tablename, policyname FROM pg_policies 
-- WHERE schemaname = 'public' ORDER BY tablename;
-- =====================================================
