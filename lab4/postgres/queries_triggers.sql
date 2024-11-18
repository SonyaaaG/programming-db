\c lab4
SET search_path to lab4_app;

-- query 6
CREATE OR REPLACE FUNCTION cache_applicant_exam_results(applicant_id_inc TEXT) RETURNS VOID AS $$
DECLARE
    cache_key TEXT;
    cache_value JSONB;
BEGIN
    cache_key := '/applicant_exam_results_' || applicant_id_inc;

    SELECT COALESCE(
                jsonb_agg(
                    jsonb_build_object(
                        'applicant_id', a.applicant_id,
                        'event_name', ev.event_name,
                        'final_mark', COALESCE(e.appeal_mark, e.exam_mark)
                    )
                ),
                '[]'::jsonb  -- Return an empty array if there are no results
            )
    INTO cache_value
    FROM applications a
        JOIN examresults e ON a.application_id = e.application_id
        JOIN event ev ON e.event_id = ev.event_id
    WHERE a.applicant_id = applicant_id_inc
        AND a.is_current_application = TRUE
        AND ev.event_type = 1;

    RAISE NOTICE 'Cached applicant exam results for %: %', applicant_id_inc, cache_value;

    PERFORM memcache_set(cache_key, cache_value::text);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_applicant_exam_cache() RETURNS TRIGGER AS $$
BEGIN
    PERFORM cache_applicant_exam_results(NEW.applicant_id);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_applicant_examres_cache() RETURNS TRIGGER AS $$
DECLARE
    applicant_id_out TEXT;
BEGIN
    SELECT a.applicant_id
    INTO applicant_id_out
    FROM applications a
    WHERE a.application_id = NEW.application_id;

    PERFORM cache_applicant_exam_results(applicant_id_out);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION invalidate_applicant_exam_cache() RETURNS TRIGGER AS $$
BEGIN
    PERFORM memcache_delete('/applicant_exam_results_' || OLD.applicant_id);
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION invalidate_applicant_examres_cache() RETURNS TRIGGER AS $$
DECLARE
    applicant_id_out TEXT;
BEGIN
    SELECT a.applicant_id
    INTO applicant_id_out
    FROM applications a
    WHERE a.application_id = OLD.application_id;

    PERFORM memcache_delete('/applicant_exam_results_' || applicant_id_out);
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_applicant_exam_cache
AFTER INSERT OR UPDATE ON lab4_app.applications
FOR EACH ROW
EXECUTE FUNCTION update_applicant_exam_cache();

CREATE TRIGGER trigger_update_examresults_cache
AFTER INSERT OR UPDATE ON lab4_app.examresults
FOR EACH ROW
EXECUTE FUNCTION update_applicant_examres_cache();

CREATE TRIGGER trigger_invalidate_applicant_exam_cache
AFTER DELETE ON lab4_app.applications
FOR EACH ROW
EXECUTE FUNCTION invalidate_applicant_exam_cache();

CREATE TRIGGER trigger_invalidate_examresults_cache
AFTER DELETE ON lab4_app.examresults
FOR EACH ROW
EXECUTE FUNCTION invalidate_applicant_examres_cache();

-- query 1
CREATE OR REPLACE FUNCTION cache_computer_science_applicants() RETURNS VOID AS $$
DECLARE
    cache_key TEXT;
    cache_value JSONB;
BEGIN
    cache_key := '/faculty_computer_science_applicants';

    SELECT jsonb_agg(a)
    INTO cache_value
    FROM applicants a
    JOIN applications ap ON a.applicant_id = ap.applicant_id
    JOIN department d ON ap.department_id = d.department_id
    JOIN faculty f ON d.faculty_id = f.faculty_id
    WHERE f.faculty_name = 'Комп`ютерних наук'
      AND ap.is_current_application = TRUE;

    PERFORM memcache_set(cache_key, cache_value::text);

    RAISE NOTICE 'Cached result for faculty "Комп`ютерних наук": %', cache_value;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION invalidate_computer_science_cache_applicant() RETURNS TRIGGER AS $$
BEGIN
    PERFORM cache_computer_science_applicants();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_invalidate_computer_science_cache_applicant
AFTER INSERT OR UPDATE ON lab4_app.applicants
EXECUTE FUNCTION invalidate_computer_science_cache_applicant();

CREATE TRIGGER trigger_invalidate_computer_science_cache_applications
AFTER INSERT OR UPDATE ON lab4_app.applications
EXECUTE FUNCTION invalidate_computer_science_cache_applicant();

CREATE TRIGGER trigger_invalidate_computer_science_cache_department
AFTER INSERT OR UPDATE ON lab4_app.department
EXECUTE FUNCTION invalidate_computer_science_cache_applicant();

CREATE TRIGGER trigger_invalidate_computer_science_cache_faculty
AFTER INSERT OR UPDATE ON lab4_app.faculty
EXECUTE FUNCTION invalidate_computer_science_cache_applicant();

-- query 5
CREATE OR REPLACE FUNCTION cache_faculty_openings() RETURNS VOID AS $$
DECLARE
    cache_key TEXT;
    cache_value JSONB;
BEGIN
    cache_key := '/faculty_openings';
    SELECT jsonb_agg(
            jsonb_build_object(
                'faculty_name', f.faculty_name,
                'openings_amount', f.openings_amount
            )
        )
    INTO cache_value
    FROM lab4_app.faculty f;
    PERFORM memcache_set(cache_key, cache_value::text);
    RAISE NOTICE 'Cached faculty openings: %', cache_value;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION invalidate_faculty_openings_cache() RETURNS TRIGGER AS $$
BEGIN
    PERFORM cache_faculty_openings();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_invalidate_faculty_openings_cache
AFTER INSERT OR UPDATE OR DELETE ON lab4_app.faculty
EXECUTE FUNCTION invalidate_faculty_openings_cache();
