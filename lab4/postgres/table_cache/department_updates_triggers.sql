\c lab4
SET search_path to lab4_app;

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
