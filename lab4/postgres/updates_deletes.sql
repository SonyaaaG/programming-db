\c lab4
SET search_path to lab4_app;

CREATE OR REPLACE FUNCTION update_event_cache() RETURNS TRIGGER AS $$
DECLARE
    cache_key TEXT;
    cache_value JSONB;
BEGIN

    cache_key := '/event_' || NEW.event_id;
    cache_value := jsonb_build_object(
        'event_name', NEW.event_name,
        'subject_name', NEW.subject_name,
        'stream_id', NEW.stream_id,
        'event_start_datetime', NEW.event_start_datetime,
        'event_audience', NEW.event_audience,
        'event_duration', NEW.event_duration,
        'event_type', NEW.event_type
    );

    RAISE NOTICE 'Cache key: %, Cache value: %', cache_key, cache_value;
    PERFORM memcache_set(cache_key, cache_value::text);

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_event_cache
AFTER INSERT OR UPDATE ON lab4_app.event
FOR EACH ROW EXECUTE FUNCTION update_event_cache();

CREATE OR REPLACE FUNCTION update_application_cache() RETURNS TRIGGER AS $$
DECLARE
    cache_key TEXT;
    cache_value JSONB;
BEGIN
    cache_key := '/application_' || NEW.application_id;
    cache_value := jsonb_build_object(
        'applicant_id', NEW.applicant_id,
        'department_id', NEW.department_id,
        'group_id', NEW.group_id,
        'is_current_application', NEW.is_current_application
    );

    RAISE NOTICE 'Cache key: %, Cache value: %', cache_key, cache_value;
    PERFORM memcache_set(cache_key, cache_value::text);

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_application_cache
AFTER INSERT OR UPDATE ON lab4_app.applications
FOR EACH ROW EXECUTE FUNCTION update_application_cache();

CREATE OR REPLACE FUNCTION update_exam_result_cache() RETURNS TRIGGER AS $$
DECLARE
    cache_key TEXT;
    cache_value JSONB;
BEGIN
    cache_key := '/examresult_' || NEW.application_id || '_' || NEW.event_id;
    cache_value := jsonb_build_object(
        'application_id', NEW.application_id,
        'event_id', NEW.event_id,
        'exam_mark', NEW.exam_mark,
        'appeal_status', NEW.appeal_status,
        'appeal_mark', NEW.appeal_mark
    );

    RAISE NOTICE 'Cache key: %, Cache value: %', cache_key, cache_value;
    PERFORM memcache_set(cache_key, cache_value::text);

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_exam_result_cache
AFTER INSERT OR UPDATE ON lab4_app.examresults
FOR EACH ROW EXECUTE FUNCTION update_exam_result_cache();

CREATE OR REPLACE FUNCTION update_faculty_cache() RETURNS TRIGGER AS $$
DECLARE
    cache_key TEXT;
    cache_value JSONB;
BEGIN
    cache_key := '/faculty_' || NEW.faculty_id;
    cache_value := jsonb_build_object(
        'faculty_name', NEW.faculty_name,
        'openings_amount', NEW.openings_amount
    );

    RAISE NOTICE 'Cache key: %, Cache value: %', cache_key, cache_value;
    PERFORM memcache_set(cache_key, cache_value::text);

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_faculty_cache
AFTER INSERT OR UPDATE ON lab4_app.faculty
FOR EACH ROW EXECUTE FUNCTION update_faculty_cache();

CREATE OR REPLACE FUNCTION update_department_cache() RETURNS TRIGGER AS $$
DECLARE
    cache_key TEXT;
    cache_value JSONB;
BEGIN
    cache_key := '/department_' || NEW.department_id;
    cache_value := jsonb_build_object(
        'department_name', NEW.department_name,
        'faculty_id', NEW.faculty_id
    );

    RAISE NOTICE 'Cache key: %, Cache value: %', cache_key, cache_value;
    PERFORM memcache_set(cache_key, cache_value::text);

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_department_cache
AFTER INSERT OR UPDATE ON lab4_app.department
FOR EACH ROW EXECUTE FUNCTION update_department_cache();

CREATE OR REPLACE FUNCTION update_event_type_cache() RETURNS TRIGGER AS $$
DECLARE
    cache_key TEXT;
    cache_value JSONB;
BEGIN
    cache_key := '/eventtype_' || NEW.type_id;
    cache_value := jsonb_build_object(
        'type_name', NEW.type_name
    );

    RAISE NOTICE 'Cache key: %, Cache value: %', cache_key, cache_value;
    PERFORM memcache_set(cache_key, cache_value::text);

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_event_type_cache
AFTER INSERT OR UPDATE ON lab4_app.eventtypes
FOR EACH ROW EXECUTE FUNCTION update_event_type_cache();

CREATE OR REPLACE FUNCTION update_stream_cache() RETURNS TRIGGER AS $$
DECLARE
    cache_key TEXT;
    cache_value JSONB;
BEGIN
    cache_key := '/stream_' || NEW.stream_id;
    cache_value := jsonb_build_object(
        'stream_name', NEW.stream_name
    );

    RAISE NOTICE 'Cache key: %, Cache value: %', cache_key, cache_value;
    PERFORM memcache_set(cache_key, cache_value::text);

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_stream_cache
AFTER INSERT OR UPDATE ON lab4_app.stream
FOR EACH ROW EXECUTE FUNCTION update_stream_cache();

CREATE OR REPLACE FUNCTION update_group_cache() RETURNS TRIGGER AS $$
DECLARE
    cache_key TEXT;
    cache_value JSONB;
BEGIN
    cache_key := '/group_' || NEW.group_id;
    cache_value := jsonb_build_object(
        'group_name', NEW.group_name,
        'stream_id', NEW.stream_id
    );

    RAISE NOTICE 'Cache key: %, Cache value: %', cache_key, cache_value;
    PERFORM memcache_set(cache_key, cache_value::text);

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_group_cache
AFTER INSERT OR UPDATE ON lab4_app."Group"
FOR EACH ROW EXECUTE FUNCTION update_group_cache();


CREATE OR REPLACE FUNCTION update_applicant_cache() RETURNS TRIGGER AS $$
DECLARE
    cache_key TEXT;
    cache_value JSONB;
BEGIN
    cache_key := '/applicant_' || NEW.applicant_id;
    cache_value := jsonb_build_object(
        'last_name', NEW.last_name,
        'first_name', NEW.first_name,
        'middle_name', NEW.middle_name,
        'id_series', NEW.id_series,
        'graduated_institution_name', NEW.graduated_institution_name,
        'graduated_institution_city', NEW.graduated_institution_city,
        'graduated_date', NEW.graduated_date,
        'has_medal', NEW.has_medal
    );

    RAISE NOTICE 'Cache key: %, Cache value: %', cache_key, cache_value;
    PERFORM memcache_set(cache_key, cache_value::text);

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_applicant_cache
AFTER INSERT OR UPDATE ON lab4_app.applicants
FOR EACH ROW EXECUTE FUNCTION update_applicant_cache();

CREATE OR REPLACE FUNCTION delete_cache() RETURNS TRIGGER AS $$
DECLARE
    cache_key TEXT;
    column_value TEXT;
BEGIN
    EXECUTE format('SELECT ($1).%I', TG_ARGV[0]) INTO column_value USING OLD;

    cache_key := '/' || TG_TABLE_NAME || '_' || column_value;

    RAISE NOTICE 'Deleting cache key: %', cache_key;

    PERFORM memcache_delete(cache_key);

    RETURN OLD;
END;
$$ LANGUAGE plpgsql;


-- Delete trigger for faculty table
CREATE TRIGGER trigger_delete_faculty_cache
AFTER DELETE ON lab4_app.faculty
FOR EACH ROW EXECUTE FUNCTION delete_cache('faculty_id');

-- Delete trigger for department table
CREATE TRIGGER trigger_delete_department_cache
AFTER DELETE ON lab4_app.department
FOR EACH ROW EXECUTE FUNCTION delete_cache('department_id');

-- Delete trigger for eventtypes table
CREATE TRIGGER trigger_delete_eventtype_cache
AFTER DELETE ON lab4_app.eventtypes
FOR EACH ROW EXECUTE FUNCTION delete_cache('type_id');

-- Delete trigger for stream table
CREATE TRIGGER trigger_delete_stream_cache
AFTER DELETE ON lab4_app.stream
FOR EACH ROW EXECUTE FUNCTION delete_cache('stream_id');

-- Delete trigger for group table
CREATE TRIGGER trigger_delete_group_cache
AFTER DELETE ON lab4_app."Group"
FOR EACH ROW EXECUTE FUNCTION delete_cache('group_id');

-- Delete trigger for applicants table
CREATE TRIGGER trigger_delete_applicant_cache
AFTER DELETE ON lab4_app.applicants
FOR EACH ROW EXECUTE FUNCTION delete_cache('applicant_id');

-- Delete trigger for applications table
CREATE TRIGGER trigger_delete_application_cache
AFTER DELETE ON lab4_app.applications
FOR EACH ROW EXECUTE FUNCTION delete_cache('application_id');

-- Delete trigger for events table
CREATE TRIGGER trigger_delete_event_cache
AFTER DELETE ON lab4_app.event
FOR EACH ROW EXECUTE FUNCTION delete_cache('event_id');
