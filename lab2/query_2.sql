-- Всі оцінки з іспитів для певного абітурієнта

SELECT
    a.applicant_id,
    ev.event_name,
    e.exam_mark
FROM applications a
    JOIN examresults e ON a.application_id = e.application_id
    JOIN event ev ON e.event_id = ev.event_id
WHERE a.applicant_id = 'ХА-12343'
    AND a.is_current_application = TRUE
    AND ev.event_type = 1;