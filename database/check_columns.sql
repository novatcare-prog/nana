-- Check columns of maternal_profiles table
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'maternal_profiles'
ORDER BY ordinal_position;
