-- Де, коли і з яких предметів проходитимуть іспити у заданої групи - група ІАТМ-301

SELECT
    *
FROM
    "Group" g
JOIN stream s ON g.stream_id = s.stream_id
JOIN event ON s.stream_id = event.stream_id
JOIN eventtypes es ON event.event_type = es.type_id
WHERE type_name = 'Екзамен' AND group_name = 'КН-101';
