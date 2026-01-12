-- =====================================================
-- MCH Kenya - KMHFL Facilities Import Script
-- Using Staging Table Approach
-- =====================================================

-- STEP 1: Create staging table that matches the CSV columns exactly
-- =====================================================
DROP TABLE IF EXISTS facilities_import;

CREATE TABLE facilities_import (
    "OBJECTID" INTEGER,
    "Facility_N" VARCHAR(255),
    "Type" VARCHAR(100),
    "Owner" VARCHAR(100),
    "County" VARCHAR(100),
    "Sub_County" VARCHAR(100),
    "Division" VARCHAR(100),
    "Location" VARCHAR(100),
    "Sub_Locati" VARCHAR(100),
    "Constituen" VARCHAR(100),
    "Nearest_To" VARCHAR(100),
    "Latitude" DECIMAL(10, 8),
    "Longitude" DECIMAL(11, 8)
);

-- =====================================================
-- STEP 2: Import CSV into facilities_import table
-- =====================================================
-- Go to Supabase > Table Editor > facilities_import
-- Click "Import data from CSV"
-- Select the healthcare_facilities.csv file
-- =====================================================

-- STEP 3: After CSV import, run this to copy data to facilities table
-- =====================================================

-- First verify the import worked
SELECT COUNT(*) as total_imported FROM facilities_import;
SELECT * FROM facilities_import LIMIT 10;

-- =====================================================
-- STEP 4: Transfer data to facilities table
-- =====================================================
INSERT INTO facilities (facility_name, kmhfl_code, county, sub_county)
SELECT 
    "Facility_N" as facility_name,
    "OBJECTID"::TEXT as kmhfl_code,
    "County" as county,
    "Sub_County" as sub_county
FROM facilities_import
WHERE "Facility_N" IS NOT NULL
ON CONFLICT (kmhfl_code) DO NOTHING;

-- =====================================================
-- STEP 5: Verify the transfer
-- =====================================================
SELECT 
    county, 
    COUNT(*) as facility_count 
FROM facilities 
GROUP BY county 
ORDER BY facility_count DESC;

SELECT COUNT(*) as total_facilities FROM facilities;

-- =====================================================
-- STEP 6: Clean up (optional - run after verifying data)
-- =====================================================
-- DROP TABLE facilities_import;
