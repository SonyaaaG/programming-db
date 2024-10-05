-- Середній бал із кожного предмета на кожному факультеті

SELECT
    f.faculty_name,
    e.subject_name,
    AVG(COALESCE(er.appeal_mark, er.exam_mark)) AS mean_mark
FROM event e
JOIN eventtypes et ON e.event_type = et.type_id
JOIN examresults er ON e.event_id = er.event_id
JOIN applications a ON er.application_id = a.application_id
JOIN department d ON a.department_id = d.department_id
JOIN faculty f on d.faculty_id = f.faculty_id
WHERE et.type_name = 'Іспит'
GROUP BY f.faculty_name, e.subject_name;
