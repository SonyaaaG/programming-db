\c lab4
SET search_path to lab4_app;

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
