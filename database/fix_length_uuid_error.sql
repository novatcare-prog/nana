-- =====================================================
-- MCH Kenya - Fix length(uuid) Error
-- Run this in Supabase SQL Editor
-- =====================================================
-- ERROR: function length(uuid) does not exist
-- This happens when sync tries to insert appointments
-- =====================================================

-- STEP 1: Find triggers on the appointments table
-- =====================================================
SELECT 
  trigger_name,
  event_manipulation,
  action_statement
FROM information_schema.triggers 
WHERE event_object_table = 'appointments';

-- STEP 2: Find functions that might be calling length() on UUID
-- =====================================================
SELECT 
  routine_name,
  routine_definition
FROM information_schema.routines
WHERE routine_definition LIKE '%length%' 
  AND routine_schema = 'public';

-- STEP 3: Check if there's a validation function on id column
-- =====================================================
SELECT 
  column_name,
  column_default,
  data_type
FROM information_schema.columns 
WHERE table_name = 'appointments'
ORDER BY ordinal_position;

-- =====================================================
-- COMMON FIX: If you have a trigger that validates UUID format
-- using length(), you need to change it to use ::text cast
-- 
-- Wrong:  length(NEW.id) = 36
-- Right:  length(NEW.id::text) = 36
--
-- Or better, just remove the check since PostgreSQL validates
-- UUID format automatically for uuid columns.
-- =====================================================
