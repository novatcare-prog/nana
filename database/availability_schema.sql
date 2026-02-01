-- =====================================================
-- Health Worker Availability Schema
-- Run this in Supabase SQL Editor
-- =====================================================

-- 1. Create the availability table
CREATE TABLE IF NOT EXISTS health_worker_availability (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  day_of_week INTEGER NOT NULL CHECK (day_of_week BETWEEN 1 AND 7), -- 1=Monday, 7=Sunday
  start_time TIME NOT NULL DEFAULT '08:00:00',
  end_time TIME NOT NULL DEFAULT '17:00:00',
  is_available BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, day_of_week)
);

-- 2. Enable RLS
ALTER TABLE health_worker_availability ENABLE ROW LEVEL SECURITY;

-- 3. Policies

-- Health workers manage their own availability
CREATE POLICY "Health workers manage own availability"
  ON health_worker_availability
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- Patients (and everyone else) can view availability
CREATE POLICY "Public view availability"
  ON health_worker_availability FOR SELECT
  USING (true);

-- 4. Initial seed for defaults (Optional Trigger)
-- Alternatively, the app handles "no record" as "not available" or "default available".
