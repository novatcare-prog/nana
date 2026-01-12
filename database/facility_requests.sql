-- =====================================================
-- MCH Kenya - Facility Requests Table
-- For hybrid facility management
-- =====================================================

-- Create facility_requests table for pending facility submissions
CREATE TABLE IF NOT EXISTS facility_requests (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    facility_name VARCHAR(255) NOT NULL,
    kmhfl_code VARCHAR(50),
    county VARCHAR(100) NOT NULL,
    sub_county VARCHAR(100),
    requested_by UUID REFERENCES auth.users(id),
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected')),
    admin_notes TEXT,
    reviewed_by UUID REFERENCES auth.users(id),
    reviewed_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE facility_requests ENABLE ROW LEVEL SECURITY;

-- Policies: Health workers can insert, admins can manage
CREATE POLICY "Health workers can request facilities"
    ON facility_requests FOR INSERT
    WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "Users can view their own requests"
    ON facility_requests FOR SELECT
    USING (requested_by = auth.uid());

CREATE POLICY "Admins can view all requests"
    ON facility_requests FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM user_profiles 
            WHERE id = auth.uid() AND role = 'admin'
        )
    );

CREATE POLICY "Admins can update requests"
    ON facility_requests FOR UPDATE
    USING (
        EXISTS (
            SELECT 1 FROM user_profiles 
            WHERE id = auth.uid() AND role = 'admin'
        )
    );

-- Function to approve a facility request (creates actual facility)
CREATE OR REPLACE FUNCTION approve_facility_request(request_id UUID)
RETURNS void AS $$
DECLARE
    req RECORD;
    new_kmhfl_code VARCHAR;
BEGIN
    -- Get the request
    SELECT * INTO req FROM facility_requests WHERE id = request_id AND status = 'pending';
    
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Request not found or already processed';
    END IF;
    
    -- Generate KMHFL code if not provided
    new_kmhfl_code := COALESCE(req.kmhfl_code, 'CUSTOM-' || SUBSTRING(request_id::text, 1, 8));
    
    -- Create the facility
    INSERT INTO facilities (facility_name, kmhfl_code, county, sub_county)
    VALUES (req.facility_name, new_kmhfl_code, req.county, req.sub_county)
    ON CONFLICT (kmhfl_code) DO NOTHING;
    
    -- Update the request status
    UPDATE facility_requests 
    SET status = 'approved',
        reviewed_by = auth.uid(),
        reviewed_at = NOW(),
        updated_at = NOW()
    WHERE id = request_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to reject a facility request
CREATE OR REPLACE FUNCTION reject_facility_request(request_id UUID, notes TEXT DEFAULT NULL)
RETURNS void AS $$
BEGIN
    UPDATE facility_requests 
    SET status = 'rejected',
        admin_notes = notes,
        reviewed_by = auth.uid(),
        reviewed_at = NOW(),
        updated_at = NOW()
    WHERE id = request_id AND status = 'pending';
    
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Request not found or already processed';
    END IF;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Index for faster queries
CREATE INDEX idx_facility_requests_status ON facility_requests(status);
CREATE INDEX idx_facility_requests_requested_by ON facility_requests(requested_by);
