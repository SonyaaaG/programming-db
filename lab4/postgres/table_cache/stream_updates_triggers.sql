\c lab4
SET search_path to lab4_app;

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
