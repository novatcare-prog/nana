-- =====================================================
-- MCH Kenya - Comprehensive RLS Policies
-- Run this in Supabase SQL Editor
-- =====================================================

-- =====================================================
-- STEP 1: Enable RLS on ALL tables
-- =====================================================

ALTER TABLE user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE maternal_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE anc_visits ENABLE ROW LEVEL SECURITY;
ALTER TABLE childbirth_records ENABLE ROW LEVEL SECURITY;
ALTER TABLE postnatal_visits ENABLE ROW LEVEL SECURITY;
ALTER TABLE maternal_immunizations ENABLE ROW LEVEL SECURITY;
ALTER TABLE nutrition_records ENABLE ROW LEVEL SECURITY;
ALTER TABLE malaria_prevention_records ENABLE ROW LEVEL SECURITY;
ALTER TABLE child_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE child_immunization_records ENABLE ROW LEVEL SECURITY;
ALTER TABLE developmental_milestones ENABLE ROW LEVEL SECURITY;
ALTER TABLE deworming_records ENABLE ROW LEVEL SECURITY;
ALTER TABLE growth_records ENABLE ROW LEVEL SECURITY;
ALTER TABLE vitamin_a_supplementation ENABLE ROW LEVEL SECURITY;
ALTER TABLE muac_measurements ENABLE ROW LEVEL SECURITY;
ALTER TABLE appointments ENABLE ROW LEVEL SECURITY;
ALTER TABLE lab_results ENABLE ROW LEVEL SECURITY;
ALTER TABLE facilities ENABLE ROW LEVEL SECURITY;

-- =====================================================
-- STEP 2: Create helper function to check user role
-- =====================================================

CREATE OR REPLACE FUNCTION get_user_role()
RETURNS TEXT AS $$
  SELECT role FROM user_profiles WHERE id = auth.uid()
$$ LANGUAGE sql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION get_user_facility_id()
RETURNS UUID AS $$
  SELECT facility_id FROM user_profiles WHERE id = auth.uid()
$$ LANGUAGE sql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION is_admin()
RETURNS BOOLEAN AS $$
  SELECT EXISTS (
    SELECT 1 FROM user_profiles 
    WHERE id = auth.uid() AND role = 'admin'
  )
$$ LANGUAGE sql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION is_health_worker()
RETURNS BOOLEAN AS $$
  SELECT EXISTS (
    SELECT 1 FROM user_profiles 
    WHERE id = auth.uid() AND role IN ('health_worker', 'admin')
  )
$$ LANGUAGE sql SECURITY DEFINER;

-- =====================================================
-- STEP 3: user_profiles policies
-- =====================================================

-- Users can view their own profile
CREATE POLICY "Users can view own profile"
  ON user_profiles FOR SELECT
  USING (auth.uid() = id);

-- Health workers can view profiles in their facility
CREATE POLICY "Health workers can view facility users"
  ON user_profiles FOR SELECT
  USING (
    is_health_worker() AND 
    facility_id = get_user_facility_id()
  );

-- Admins can view all profiles
CREATE POLICY "Admins can view all profiles"
  ON user_profiles FOR SELECT
  USING (is_admin());

-- Users can update their own profile (limited fields via app)
CREATE POLICY "Users can update own profile"
  ON user_profiles FOR UPDATE
  USING (auth.uid() = id);

-- Only admins can insert new profiles (via signup trigger or admin)
CREATE POLICY "Admins can insert profiles"
  ON user_profiles FOR INSERT
  WITH CHECK (is_admin() OR auth.uid() = id);

-- =====================================================
-- STEP 4: maternal_profiles policies
-- =====================================================

-- Patients can view their own maternal profile
CREATE POLICY "Patients can view own maternal profile"
  ON maternal_profiles FOR SELECT
  USING (user_id = auth.uid());

-- Health workers can view maternal profiles in their facility
CREATE POLICY "Health workers can view facility maternal profiles"
  ON maternal_profiles FOR SELECT
  USING (
    is_health_worker() AND 
    facility_id = get_user_facility_id()
  );

-- Admins can view all
CREATE POLICY "Admins can view all maternal profiles"
  ON maternal_profiles FOR SELECT
  USING (is_admin());

-- Health workers can insert/update for their facility
CREATE POLICY "Health workers can insert maternal profiles"
  ON maternal_profiles FOR INSERT
  WITH CHECK (
    is_health_worker() AND 
    facility_id = get_user_facility_id()
  );

CREATE POLICY "Health workers can update maternal profiles"
  ON maternal_profiles FOR UPDATE
  USING (
    is_health_worker() AND 
    facility_id = get_user_facility_id()
  );

-- =====================================================
-- STEP 5: anc_visits policies
-- =====================================================

-- Patients can view their own ANC visits (via maternal_profile)
CREATE POLICY "Patients can view own ANC visits"
  ON anc_visits FOR SELECT
  USING (
    maternal_profile_id IN (
      SELECT id FROM maternal_profiles WHERE user_id = auth.uid()
    )
  );

-- Health workers can view/manage ANC visits for their facility
CREATE POLICY "Health workers can view facility ANC visits"
  ON anc_visits FOR SELECT
  USING (
    is_health_worker() AND 
    maternal_profile_id IN (
      SELECT id FROM maternal_profiles WHERE facility_id = get_user_facility_id()
    )
  );

CREATE POLICY "Health workers can insert ANC visits"
  ON anc_visits FOR INSERT
  WITH CHECK (
    is_health_worker() AND 
    maternal_profile_id IN (
      SELECT id FROM maternal_profiles WHERE facility_id = get_user_facility_id()
    )
  );

CREATE POLICY "Health workers can update ANC visits"
  ON anc_visits FOR UPDATE
  USING (
    is_health_worker() AND 
    maternal_profile_id IN (
      SELECT id FROM maternal_profiles WHERE facility_id = get_user_facility_id()
    )
  );

-- Admins can do everything
CREATE POLICY "Admins can manage all ANC visits"
  ON anc_visits FOR ALL
  USING (is_admin());

-- =====================================================
-- STEP 6: child_profiles policies
-- =====================================================

-- Parents can view their children's profiles
CREATE POLICY "Parents can view own children"
  ON child_profiles FOR SELECT
  USING (
    mother_id IN (
      SELECT id FROM maternal_profiles WHERE user_id = auth.uid()
    )
  );

-- Health workers can view children in their facility
CREATE POLICY "Health workers can view facility children"
  ON child_profiles FOR SELECT
  USING (
    is_health_worker() AND 
    facility_id = get_user_facility_id()
  );

-- Health workers can manage children in their facility
CREATE POLICY "Health workers can insert children"
  ON child_profiles FOR INSERT
  WITH CHECK (
    is_health_worker() AND 
    facility_id = get_user_facility_id()
  );

CREATE POLICY "Health workers can update children"
  ON child_profiles FOR UPDATE
  USING (
    is_health_worker() AND 
    facility_id = get_user_facility_id()
  );

-- Admins can do everything
CREATE POLICY "Admins can manage all children"
  ON child_profiles FOR ALL
  USING (is_admin());

-- =====================================================
-- STEP 7: Generic pattern for child-related records
-- (Apply similar pattern to these tables)
-- =====================================================

-- child_immunization_records
CREATE POLICY "Parents can view own child immunizations"
  ON child_immunization_records FOR SELECT
  USING (
    child_id IN (
      SELECT cp.id FROM child_profiles cp
      JOIN maternal_profiles mp ON cp.mother_id = mp.id
      WHERE mp.user_id = auth.uid()
    )
  );

CREATE POLICY "Health workers can manage child immunizations"
  ON child_immunization_records FOR ALL
  USING (
    is_health_worker() AND 
    child_id IN (
      SELECT id FROM child_profiles WHERE facility_id = get_user_facility_id()
    )
  );

CREATE POLICY "Admins can manage all child immunizations"
  ON child_immunization_records FOR ALL
  USING (is_admin());

-- growth_records
CREATE POLICY "Parents can view own child growth"
  ON growth_records FOR SELECT
  USING (
    child_id IN (
      SELECT cp.id FROM child_profiles cp
      JOIN maternal_profiles mp ON cp.mother_id = mp.id
      WHERE mp.user_id = auth.uid()
    )
  );

CREATE POLICY "Health workers can manage growth records"
  ON growth_records FOR ALL
  USING (
    is_health_worker() AND 
    child_id IN (
      SELECT id FROM child_profiles WHERE facility_id = get_user_facility_id()
    )
  );

CREATE POLICY "Admins can manage all growth records"
  ON growth_records FOR ALL
  USING (is_admin());

-- developmental_milestones
CREATE POLICY "Parents can view own child milestones"
  ON developmental_milestones FOR SELECT
  USING (
    child_id IN (
      SELECT cp.id FROM child_profiles cp
      JOIN maternal_profiles mp ON cp.mother_id = mp.id
      WHERE mp.user_id = auth.uid()
    )
  );

CREATE POLICY "Health workers can manage milestones"
  ON developmental_milestones FOR ALL
  USING (
    is_health_worker() AND 
    child_id IN (
      SELECT id FROM child_profiles WHERE facility_id = get_user_facility_id()
    )
  );

CREATE POLICY "Admins can manage all milestones"
  ON developmental_milestones FOR ALL
  USING (is_admin());

-- =====================================================
-- STEP 8: facilities (public read, admin write)
-- =====================================================

-- Authenticated users can read facilities list
CREATE POLICY "Anyone can view facilities"
  ON facilities FOR SELECT
  USING (true);

-- Allow unauthenticated users to view facilities (needed for registration)
CREATE POLICY "Anon users can view facilities"
  ON facilities FOR SELECT
  TO anon
  USING (true);

-- Only admins can modify facilities
CREATE POLICY "Admins can manage facilities"
  ON facilities FOR ALL
  USING (is_admin());

-- =====================================================
-- STEP 9: appointments policies
-- =====================================================

-- Patients can view their own appointments
CREATE POLICY "Patients can view own appointments"
  ON appointments FOR SELECT
  USING (patient_id = auth.uid());

-- Health workers can view/manage appointments for their facility
CREATE POLICY "Health workers can manage facility appointments"
  ON appointments FOR ALL
  USING (
    is_health_worker() AND 
    facility_id = get_user_facility_id()
  );

-- Admins can do everything
CREATE POLICY "Admins can manage all appointments"
  ON appointments FOR ALL
  USING (is_admin());

-- =====================================================
-- STEP 10: lab_results policies (HIGH SENSITIVITY)
-- =====================================================

-- Patients can view their own lab results
CREATE POLICY "Patients can view own lab results"
  ON lab_results FOR SELECT
  USING (
    maternal_profile_id IN (
      SELECT id FROM maternal_profiles WHERE user_id = auth.uid()
    )
  );

-- Health workers can view/manage lab results for their facility
CREATE POLICY "Health workers can manage lab results"
  ON lab_results FOR ALL
  USING (
    is_health_worker() AND 
    maternal_profile_id IN (
      SELECT id FROM maternal_profiles WHERE facility_id = get_user_facility_id()
    )
  );

-- Admins can do everything
CREATE POLICY "Admins can manage all lab results"
  ON lab_results FOR ALL
  USING (is_admin());

-- =====================================================
-- NOTE: Repeat similar patterns for remaining tables:
-- - postnatal_visits
-- - childbirth_records
-- - maternal_immunizations
-- - nutrition_records
-- - malaria_prevention_records
-- - deworming_records
-- - vitamin_a_supplementation
-- - muac_measurements
--
-- They all follow the same pattern:
-- 1. Patient can view own (via maternal_profile or child_profile)
-- 2. Health worker can view/manage for their facility
-- 3. Admin can do everything
-- =====================================================
