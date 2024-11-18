\c lab4
SET search_path to lab4_app;

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