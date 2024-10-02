-- Коли та в якій аудиторії буде консультація та іспит y
-- заданого абітурієнта із зазначеного предмета

SELECT
    a.applicant_id,
    e.event_name,
    e.event_start_datetime,
    e.event_audience,
    e.subject_name
FROM applications a
    JOIN "Group" g ON a.group_id = g.group_id
    JOIN stream s ON g.stream_id = s.stream_id
    JOIN event e ON s.stream_id = e.stream_id
WHERE
    a.is_current_application = TRUE
    AND a.applicant_id = 'ХА-12345'
    AND e.subject_name = 'Фізика';
