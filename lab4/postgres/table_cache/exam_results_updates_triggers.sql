\c lab4
SET search_path to lab4_app;

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
