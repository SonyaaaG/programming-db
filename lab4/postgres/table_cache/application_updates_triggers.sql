\c lab4
SET search_path to lab4_app;

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
