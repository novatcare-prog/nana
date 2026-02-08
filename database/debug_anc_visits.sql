-- =====================================================
-- MCH Kenya - Debug ANC Visits Not Loading
-- Run this in Supabase SQL Editor
-- =====================================================

-- STEP 1: Check if ANC visits exist for this patient
-- =====================================================
SELECT id, maternal_profile_id, visit_date, contact_number, gestation_weeks
FROM anc_visits
WHERE maternal_profile_id = 'acee5d8a-5a2b-462d-b5bf-890935ba4dd1'
ORDER BY visit_date DESC;

-- STEP 2: Check all ANC visits in the system
-- =====================================================
SELECT id, maternal_profile_id, visit_date, contact_number
FROM anc_visits
ORDER BY created_at DESC
LIMIT 10;

-- STEP 3: Check RLS policies on anc_visits table
-- =====================================================
SELECT policyname, cmd, qual
FROM pg_policies
WHERE tablename = 'anc_visits';

-- STEP 4: If no visits, create a test visit
-- =====================================================
-- Uncomment and run this if no visits exist:
/*
INSERT INTO anc_visits (
  maternal_profile_id,
  facility_id,
  visit_date,
  contact_number,
  gestation_weeks,
  weight_kg,
  blood_pressure,
  foetal_heart_rate,
  created_at
) VALUES (
  'acee5d8a-5a2b-462d-b5bf-890935ba4dd1',
  '2a2e26b1-704a-44da-86a4-79c215754af3',
  NOW() - INTERVAL '7 days',
  1,
  12,
  58.5,
  '120/80',
  145,
  NOW()
);
*/
