INSERT INTO faculty (faculty_name, openings_amount)
VALUES
    ('Комп`ютерних наук', 500),
    ('Комп`ютерної інженерії', 280),
    ('Інформаційно-аналітичних технологій і менеджменту', 199);

INSERT INTO department (department_name, faculty_id)
VALUES
    ('Штучного інтелекту', 1),
    ('Програмної інженерії', 1),
    ('Системотехніки', 1),
    ('Електронних обчислювальних машин', 2),
    ('Безпеки інформаційних технологій', 2),
    ('Інформатики', 3),
    ('Прикладної математики', 3);

INSERT INTO eventtypes (type_name)
VALUES
    ('Екзамен'),
    ('Консультація');

INSERT INTO stream (stream_name)
VALUES
    ('КН-1'),
    ('КІ-1'),
    ('ІАТМ-1');

INSERT INTO "Group" (group_name, stream_id)
VALUES
    ('КН-101', 1),
    ('КН-102', 1),
    ('КН-103', 1),
    ('КН-104', 1),
    ('КІ-201', 2),
    ('КІ-202', 2),
    ('КІ-203', 2),
    ('ІАТМ-301', 3),
    ('ІАТМ-302', 3),
    ('ІАТМ-303', 3);

INSERT INTO Event (event_name, subject_name, stream_id, event_start_datetime, event_audience, event_duration, event_type)
VALUES
    ('Екзамен з Програмування', 'Програмування', 1, '2024-08-10 09:00:00', 'І240', 120, 1),
    ('Консультація з Програмування', 'Програмування', 1, '2024-08-02 14:00:00','АУ100', 60, 2),
    ('Екзамен з Фізики', 'Фізика', 2, '2024-08-12 10:30:00', 'І317', 120, 1),
    ('Консультація з Фізики', 'Фізика', 2, '2024-08-05 12:30:00','АУ111', 90, 2),
    ('Консультація з Математики', 'Математика', 3, '2024-08-02 13:30:00','К440', 90, 2),
    ('Екзамен з Математики', 'Математика', 3, '2024-08-07 12:00:00','І241', 180, 1);

INSERT INTO Applicants (applicant_id, last_name, first_name, middle_name, id_series, graduated_institution_name, graduated_institution_city, graduated_date, has_medal)
VALUES
    ('ХА-12345', 'Сидоренко', 'Іван', 'Іванович', 'АВ123456', 'Школа №150', 'Харків', '2024-05-30', TRUE),
    ('ХА-12344', 'Коваленко', 'Марія', 'Олександрівна', 'ВГ654321', 'Гімназія "Знання"', 'Дніпро', '2024-06-01', FALSE),
    ('ХА-12343', 'Козлов', 'Олексій', 'Ігорович', 'ГД789012', 'Ліцей "Сонячний"', 'Харків', '2024-05-28', FALSE);

INSERT INTO Applications (applicant_id, department_id, group_id, is_current_application)
VALUES
    ('ХА-12345', 3, 5, TRUE),
    ('ХА-12345', 2, 1, FALSE),
    ('ХА-12344', 2, 4, TRUE),
    ('ХА-12343', 1, 3, TRUE);

INSERT INTO ExamResults (application_id, event_id, exam_mark, appeal_status, appeal_mark)
VALUES
    (1, 1, 99.7, NULL, NULL),
    (2, 1, 100.0, NULL, NULL),
    (3, 1, 67.0, TRUE, 75),
    (3, 3, 90, FALSE, NULL),
    (3, 6, 87, NULL, NULL),
    (4, 1, 66.0, FALSE, 66.0),
    (4, 3, 72.0, TRUE, 70),
    (4, 6, 92.5, NULL, NULL);
