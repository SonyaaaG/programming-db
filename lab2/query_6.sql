-- Середній бал із кожного предмета на кожному факультеті

WITH final_results AS (
    SELECT
        application_id,
        event_id,
        COALESCE(appeal_mark, exam_mark) as final_mark
    FROM examresults er
)
SELECT
    f.faculty_name,
    e.subject_name,
    AVG(fr.final_mark) as mean_mark
FROM event e
JOIN eventtypes et ON e.event_type = et.type_id
JOIN final_results fr ON e.event_id = fr.event_id
JOIN applications a ON fr.application_id = a.application_id
JOIN department d ON a.department_id = d.department_id
JOIN faculty f on d.faculty_id = f.faculty_id
WHERE et.type_name = 'Екзамен'
GROUP BY f.faculty_name, e.subject_name;
