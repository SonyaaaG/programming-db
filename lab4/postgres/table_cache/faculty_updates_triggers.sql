\c lab4
SET search_path to lab4_app;

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
