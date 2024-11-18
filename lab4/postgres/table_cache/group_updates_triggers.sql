\c lab4
SET search_path to lab4_app;

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
