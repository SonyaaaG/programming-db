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
    ('Іспит'),
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
    ('КІ-201', 2),
    ('КІ-202', 2),
    ('КІ-203', 2),
    ('ІАТМ-301', 3),
    ('ІАТМ-302', 3),
    ('ІАТМ-303', 3),
    ('ІАТМ-304', 3);

INSERT INTO Event (event_name, subject_name, stream_id, event_start_datetime, event_audience, event_duration, event_type)
VALUES
    ('Іспит з Програмування', 'Програмування', 1, '2024-08-10 09:00:00', 'І240', 120, 1),
    ('Консультація з Програмування', 'Програмування', 1, '2024-08-02 14:00:00','АУ100', 60, 2),
    ('Іспит з Фізики', 'Фізика', 1, '2024-08-12 10:30:00', 'І317', 120, 1),
    ('Консультація з Фізики', 'Фізика', 1, '2024-08-05 12:30:00','АУ111', 90, 2),
    ('Консультація з Математики', 'Математика', 1, '2024-08-02 13:30:00','К440', 90, 2),
    ('Іспит з Математики', 'Математика', 1, '2024-08-07 12:00:00','І241', 180, 1),
    ('Іспит з Програмування', 'Програмування', 2, '2024-08-11 09:00:00', 'І120', 120, 1),
    ('Іспит з Математики', 'Математика', 2, '2024-08-08 12:00:00','І241', 180, 1),
    ('Іспит з Фізики', 'Фізика', 2, '2024-08-14 10:30:00', 'І541', 120, 1),
    ('Іспит з Програмування', 'Програмування', 3, '2024-08-12 09:00:00', 'І0', 120, 1),
    ('Іспит з Математики', 'Математика', 3, '2024-08-09 12:00:00','І211', 180, 1),
    ('Іспит з Фізики', 'Фізика', 3, '2024-08-15 10:30:00', 'І317', 120, 1);

INSERT INTO Applicants (applicant_id, last_name, first_name, middle_name, id_series, graduated_institution_name, graduated_institution_city, graduated_date, has_medal)
VALUES
    ('ХА-12345', 'Сидоренко', 'Іван', 'Іванович', 'АВ123456', 'Школа №150', 'Харків', '2024-05-30', TRUE),
    ('ХА-12344', 'Коваленко', 'Марія', 'Олександрівна', 'ВГ654321', 'Гімназія "Знання"', 'Дніпро', '2024-06-01', FALSE),
    ('ХА-12343', 'Козлов', 'Олексій', 'Ігорович', 'ГД789012', 'Ліцей "Сонячний"', 'Харків', '2024-05-28', FALSE),
    ('ХА-12346', 'Гончаренко', 'Ольга', 'Михайлівна', 'АА123321', 'Школа №122', 'Харків', '2024-05-30', FALSE),
    ('ХА-12347', 'Деревянко', 'Василь', 'Петрович', 'ВВ654123', 'Школа №3"', 'Полтава', '2024-06-01', TRUE),
    ('ХА-12348', 'Тарасенко', 'Андрій', 'Олександрович', 'ГГ789098', 'Гімназія №5', 'Харків', '2024-05-28', FALSE),
    ('ХА-12349', 'Петренко', 'Олександр', 'Васильович', 'АВ153922', 'Школа №172', 'Харків', '2024-05-30', FALSE),
    ('ХА-12350', 'Іванова', 'Катерина', 'Ігорівна', 'ББ256333', 'Ліцей №59', 'Харків', '2024-06-01', TRUE),
    ('ХА-12351', 'Мельник', 'Олена', 'Петрівна', 'ВВ392441', 'Гімназія №23', 'Харків', '2024-05-28', FALSE),
    ('ХА-12352', 'Савченко', 'Дмитро', 'Андрійович', 'ГГ442557', 'Школа №45', 'Харків', '2024-05-29', TRUE);

INSERT INTO Applications (applicant_id, department_id, group_id, is_current_application)
VALUES
    ('ХА-12345', 3, 1, TRUE),-- фак. Комп`ютерних наук
    ('ХА-12345', 2, 2, FALSE), -- фак. Комп`ютерних наук
    ('ХА-12344', 2, 2, TRUE), -- фак. Комп`ютерних наук
    ('ХА-12343', 1, 3, TRUE), -- фак. Комп`ютерних наук
    ('ХА-12346', 4, 4, TRUE), -- фак. Комп`ютерної інженерії
    ('ХА-12347', 5, 5, TRUE), -- фак.Комп`ютерної інженерії
    ('ХА-12348', 5, 6, TRUE), -- фак.Комп`ютерної інженерії
    ('ХА-12349', 7, 7, TRUE),  -- фак. Інформаційно-аналітичних технологій і менеджменту
    ('ХА-12350', 7, 8, TRUE),  -- фак. Інформаційно-аналітичних технологій і менеджменту
    ('ХА-12351', 6, 9, TRUE),  -- фак. Інформаційно-аналітичних технологій і менеджменту
    ('ХА-12352', 6, 10, TRUE);  -- фак. Інформаційно-аналітичних технологій і менеджменту


INSERT INTO ExamResults (application_id, event_id, exam_mark, appeal_status, appeal_mark)
VALUES
    (1, 1, 99.7, NULL, NULL),
    (3, 1, 67.0, TRUE, 75),
    (3, 3, 90, FALSE, NULL),
    (3, 6, 87, NULL, NULL),
    (4, 1, 66.0, FALSE, 66.0),
    (4, 3, 72.0, TRUE, 70),
    (4, 6, 92.5, NULL, NULL),
    (5, 7, 85.5, FALSE, NULL),
    (5, 8, 92.0, TRUE, 95),
    (5, 9, 78.0, NULL, NULL),
    (6, 8, 97.0, FALSE, NULL),
    (7, 7, 99.5, FALSE, NULL),
    (7, 8, 91.0, NULL, NULL),
    (7, 9, 89.5, TRUE, 92),
    (8, 10, 68.5, FALSE, NULL),
    (8, 11, 62.0, NULL, NULL),
    (8, 12, 77.5, NULL, NULL),
    (9, 12, 93.5, FALSE, NULL),
    (10, 10, 78.0, TRUE, 80),
    (10, 11, 95.0, NULL, NULL),
    (10, 12, 82.0, FALSE, NULL),
    (11, 12, 96.0, FALSE, NULL);
