-- ============================================
-- Q&A Feature: Patient ↔ Health Worker
-- Anonymous patient questions with health worker responses
-- ============================================

-- 1. Health Questions Table
CREATE TABLE IF NOT EXISTS health_questions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    patient_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    question_text TEXT NOT NULL,
    category TEXT NOT NULL DEFAULT 'general' CHECK (
        category IN ('general', 'pregnancy', 'child_health', 'nutrition', 'family_planning', 'emergency')
    ),
    is_urgent BOOLEAN NOT NULL DEFAULT FALSE,
    status TEXT NOT NULL DEFAULT 'open' CHECK (
        status IN ('open', 'answered', 'closed')
    ),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 2. Question Answers Table
CREATE TABLE IF NOT EXISTS question_answers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    question_id UUID NOT NULL REFERENCES health_questions(id) ON DELETE CASCADE,
    responder_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    responder_name TEXT NOT NULL DEFAULT '',
    answer_text TEXT NOT NULL,
    is_urgent_flag BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 3. Indexes for performance
CREATE INDEX IF NOT EXISTS idx_health_questions_patient_id ON health_questions(patient_id);
CREATE INDEX IF NOT EXISTS idx_health_questions_status ON health_questions(status);
CREATE INDEX IF NOT EXISTS idx_health_questions_category ON health_questions(category);
CREATE INDEX IF NOT EXISTS idx_health_questions_created_at ON health_questions(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_question_answers_question_id ON question_answers(question_id);

-- 4. Auto-update updated_at trigger
CREATE OR REPLACE FUNCTION update_health_question_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_health_question_updated_at
    BEFORE UPDATE ON health_questions
    FOR EACH ROW
    EXECUTE FUNCTION update_health_question_updated_at();

-- 5. Auto-update question status when answer is inserted
CREATE OR REPLACE FUNCTION update_question_status_on_answer()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE health_questions
    SET status = 'answered',
        is_urgent = CASE WHEN NEW.is_urgent_flag THEN TRUE ELSE is_urgent END
    WHERE id = NEW.question_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_question_on_answer
    AFTER INSERT ON question_answers
    FOR EACH ROW
    EXECUTE FUNCTION update_question_status_on_answer();

-- ============================================
-- RLS Policies
-- ============================================

ALTER TABLE health_questions ENABLE ROW LEVEL SECURITY;
ALTER TABLE question_answers ENABLE ROW LEVEL SECURITY;

-- PATIENTS: Can insert their own questions
CREATE POLICY "patients_insert_own_questions" ON health_questions
    FOR INSERT
    WITH CHECK (auth.uid() = patient_id);

-- PATIENTS: Can view their own questions
CREATE POLICY "patients_view_own_questions" ON health_questions
    FOR SELECT
    USING (auth.uid() = patient_id);

-- PATIENTS: Can close their own questions
CREATE POLICY "patients_update_own_questions" ON health_questions
    FOR UPDATE
    USING (auth.uid() = patient_id)
    WITH CHECK (auth.uid() = patient_id);

-- HEALTH WORKERS: Can view ALL questions (they see all questions)
-- Note: The app code intentionally excludes patient_id from the SELECT columns
CREATE POLICY "health_workers_view_all_questions" ON health_questions
    FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM user_profiles
            WHERE user_profiles.id = auth.uid()
            AND user_profiles.role IN ('health_worker', 'admin')
        )
    );

-- HEALTH WORKERS: Can update question status/urgency
CREATE POLICY "health_workers_update_questions" ON health_questions
    FOR UPDATE
    USING (
        EXISTS (
            SELECT 1 FROM user_profiles
            WHERE user_profiles.id = auth.uid()
            AND user_profiles.role IN ('health_worker', 'admin')
        )
    );

-- ANSWERS: Health workers can insert answers
CREATE POLICY "health_workers_insert_answers" ON question_answers
    FOR INSERT
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM user_profiles
            WHERE user_profiles.id = auth.uid()
            AND user_profiles.role IN ('health_worker', 'admin')
        )
    );

-- ANSWERS: Health workers can view all answers
CREATE POLICY "health_workers_view_answers" ON question_answers
    FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM user_profiles
            WHERE user_profiles.id = auth.uid()
            AND user_profiles.role IN ('health_worker', 'admin')
        )
    );

-- ANSWERS: Patients can view answers to their own questions
CREATE POLICY "patients_view_answers_to_own_questions" ON question_answers
    FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM health_questions
            WHERE health_questions.id = question_answers.question_id
            AND health_questions.patient_id = auth.uid()
        )
    );

-- Enable realtime for both tables
ALTER PUBLICATION supabase_realtime ADD TABLE health_questions;
ALTER PUBLICATION supabase_realtime ADD TABLE question_answers;
