-- Де, коли і з яких предметів проходитимуть іспити у заданої групи - група КН-101

SELECT
    g.group_name,
    e.event_name,
    e.subject_name,
    e.event_start_datetime,
    e.event_audience
FROM
    "Group" g
JOIN stream s ON g.stream_id = s.stream_id
JOIN event e ON s.stream_id = e.stream_id
JOIN eventtypes es ON e.event_type = es.type_id
WHERE type_name = 'Іспит' AND group_name = 'КН-101';
