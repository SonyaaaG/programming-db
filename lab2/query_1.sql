-- Перелік абітурієнтів на факультет комп`ютерних наук

SELECT
    a.*
FROM applicants a
    JOIN applications ap ON a.applicant_id = ap.applicant_id
    JOIN department d ON ap.department_id = d.department_id
    JOIN faculty f ON d.faculty_id = f.faculty_id
WHERE f.faculty_name = 'Комп`ютерних наук'
    AND ap.is_current_application = TRUE;