\c lab4
SET search_path to lab4_app;

CREATE OR REPLACE FUNCTION update_application_status() RETURNS TRIGGER AS $$
BEGIN
    UPDATE lab4_app.applications a
    SET is_current_application = FALSE
    WHERE a.applicant_id = NEW.applicant_id AND a.application_id != NEW.application_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_application_status
AFTER INSERT ON lab4_app.applications
FOR EACH ROW EXECUTE FUNCTION update_application_status();

-- Validate new exam marks
CREATE OR REPLACE FUNCTION validate_appeal_mark() RETURNS TRIGGER AS $$
BEGIN
    IF NEW.appeal_mark < NEW.exam_mark THEN
        RAISE EXCEPTION 'Appeal mark cannot be less than the original mark';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER trigger_validate_appeal_mark
BEFORE INSERT OR UPDATE ON lab4_app.examresults
FOR EACH ROW EXECUTE FUNCTION validate_appeal_mark();
