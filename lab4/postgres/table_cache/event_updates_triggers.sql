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
