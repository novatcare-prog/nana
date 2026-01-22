-- =====================================================
-- MCH Kenya - Sample Facilities for Testing
-- Run this in Supabase SQL Editor
-- =====================================================

-- Insert sample facilities from major counties
INSERT INTO facilities (facility_name, kmhfl_code, county, sub_county) VALUES
-- Nairobi
('Kenyatta National Hospital', '10001', 'Nairobi', 'Westlands'),
('Nairobi Hospital', '10002', 'Nairobi', 'Dagoretti'),
('Mbagathi Hospital', '10003', 'Nairobi', 'Langata'),
('Mama Lucy Kibaki Hospital', '10004', 'Nairobi', 'Embakasi'),
('Pumwani Maternity Hospital', '10005', 'Nairobi', 'Eastleigh'),
('Mathare National Teaching Hospital', '10006', 'Nairobi', 'Mathare'),
('Dandora Health Centre', '10007', 'Nairobi', 'Embakasi'),
('Kayole Health Centre', '10008', 'Nairobi', 'Embakasi'),

-- Kiambu
('Thika Level 5 Hospital', '10101', 'Kiambu', 'Thika'),
('Kiambu Level 5 Hospital', '10102', 'Kiambu', 'Kiambu'),
('Gatundu Level 5 Hospital', '10103', 'Kiambu', 'Gatundu North'),
('Ruiru Sub-County Hospital', '10104', 'Kiambu', 'Ruiru'),
('Limuru Sub-County Hospital', '10105', 'Kiambu', 'Limuru'),
('Juja Health Centre', '10106', 'Kiambu', 'Juja'),
('Kikuyu Hospital', '10107', 'Kiambu', 'Kikuyu'),

-- Mombasa
('Coast General Teaching Hospital', '10201', 'Mombasa', 'Mvita'),
('Likoni Sub-County Hospital', '10202', 'Mombasa', 'Likoni'),
('Tudor Sub-County Hospital', '10203', 'Mombasa', 'Mvita'),
('Changamwe Health Centre', '10204', 'Mombasa', 'Changamwe'),
('Port Reitz Sub-County Hospital', '10205', 'Mombasa', 'Changamwe'),

-- Kisumu
('Jaramogi Oginga Odinga Teaching Hospital', '10301', 'Kisumu', 'Kisumu Central'),
('Kisumu County Hospital', '10302', 'Kisumu', 'Kisumu Central'),
('Nyahera Sub-County Hospital', '10303', 'Kisumu', 'Kisumu West'),
('Kombewa Sub-County Hospital', '10304', 'Kisumu', 'Seme'),
('Ahero Sub-County Hospital', '10305', 'Kisumu', 'Nyando'),

-- Nakuru
('Nakuru Level 5 Hospital', '10401', 'Nakuru', 'Nakuru Town East'),
('Naivasha Sub-County Hospital', '10402', 'Nakuru', 'Naivasha'),
('Gilgil Sub-County Hospital', '10403', 'Nakuru', 'Gilgil'),
('Molo Sub-County Hospital', '10404', 'Nakuru', 'Molo'),
('Elburgon Sub-County Hospital', '10405', 'Nakuru', 'Molo'),

-- Machakos
('Machakos Level 5 Hospital', '10501', 'Machakos', 'Machakos Town'),
('Kangundo Level 4 Hospital', '10502', 'Machakos', 'Kangundo'),
('Athi River Health Centre', '10503', 'Machakos', 'Athi River'),
('Matuu Sub-County Hospital', '10504', 'Machakos', 'Yatta'),
('Kathiani Health Centre', '10505', 'Machakos', 'Kathiani'),

-- Nyeri
('Nyeri County Referral Hospital', '10601', 'Nyeri', 'Nyeri Central'),
('Karatina Sub-County Hospital', '10602', 'Nyeri', 'Mathira'),
('Othaya District Hospital', '10603', 'Nyeri', 'Othaya'),
('Mukurweini Sub-County Hospital', '10604', 'Nyeri', 'Mukurweini'),
('Tetu Sub-County Hospital', '10605', 'Nyeri', 'Tetu'),

-- Meru
('Meru Level 5 Hospital', '10701', 'Meru', 'Imenti North'),
('Nkubu Level 4 Hospital', '10702', 'Meru', 'Imenti South'),
('Maua Level 4 Hospital', '10703', 'Meru', 'Igembe South'),
('Kianjai Health Centre', '10704', 'Meru', 'Tigania West'),
('Mikinduri Health Centre', '10705', 'Meru', 'Tigania East'),

-- Kakamega
('Kakamega County Referral Hospital', '10801', 'Kakamega', 'Lurambi'),
('Malava Sub-County Hospital', '10802', 'Kakamega', 'Malava'),
('Butere Sub-County Hospital', '10803', 'Kakamega', 'Butere'),
('Mumias Sub-County Hospital', '10804', 'Kakamega', 'Mumias East'),
('Khwisero Health Centre', '10805', 'Kakamega', 'Khwisero')

ON CONFLICT (kmhfl_code) DO NOTHING;

-- Verify the insert
SELECT county, COUNT(*) as count 
FROM facilities 
GROUP BY county 
ORDER BY count DESC;

SELECT COUNT(*) as total_facilities FROM facilities;
