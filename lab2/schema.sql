DROP DATABASE IF EXISTS lab2;

CREATE ROLE testuser LOGIN;

CREATE DATABASE lab2 ENCODING 'UTF-8' LC_COLLATE 'en_US.UTF-8' LC_CTYPE 'en_US.UTF-8' TEMPLATE template0 OWNER testuser;

\c lab2

SET ROLE testuser;

CREATE TABLE Faculty(
    faculty_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    faculty_name VARCHAR(50) NOT NULL,
    openings_amount INT NOT NULL
);

CREATE TABLE Department(
    department_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL,
    faculty_id INT,
    FOREIGN KEY (faculty_id) REFERENCES Faculty(faculty_id)
                       ON DELETE SET NULL
);

CREATE TABLE EventTypes(
    type_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    type_name VARCHAR(20) NOT NULL
);

CREATE TABLE Stream(
    stream_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    stream_name VARCHAR(20) NOT NULL
);

CREATE TABLE "Group"(
    group_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    group_name VARCHAR(10) NOT NULL,
    stream_id INT,
    FOREIGN KEY (stream_id) REFERENCES Stream(stream_id)
                  ON DELETE SET NULL
);

CREATE TABLE Event(
    event_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    event_name VARCHAR(30) NOT NULL,
    subject_name VARCHAR(20) NOT NULL,
    stream_id INT,
    event_start_datetime TIMESTAMP NOT NULL,
    event_audience VARCHAR(20) NOT NULL,
    event_duration INT NOT NULL,
    event_type INT,
    FOREIGN KEY (stream_id) REFERENCES Stream(stream_id)
                  ON DELETE CASCADE,
    FOREIGN KEY (event_type) REFERENCES EventTypes(type_id)
                  ON DELETE SET NULL
);

CREATE TABLE Applicants(
    applicant_id VARCHAR(10) UNIQUE PRIMARY KEY,
    last_name VARCHAR(30) NOT NULL,
    first_name VARCHAR(30) NOT NULL,
    middle_name VARCHAR(30),
    id_series  VARCHAR(20) NOT NULL,
    graduated_institution_name VARCHAR(100),
    graduated_institution_city VARCHAR(50),
    graduated_date DATE,
    has_medal BOOLEAN
);

CREATE TABLE Applications (
    application_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    applicant_id VARCHAR(10),
    department_id INT,
    group_id INT,
    is_current_application BOOLEAN,
    FOREIGN KEY (applicant_id) REFERENCES Applicants(applicant_id)
                  ON DELETE CASCADE,
    FOREIGN KEY (department_id) REFERENCES Department(department_id)
                  ON DELETE SET NULL,
    FOREIGN KEY (group_id) REFERENCES "Group"(group_id)
                  ON DELETE SET NULL
);

CREATE TABLE ExamResults (
    application_id INT NOT NULL,
    event_id INT NOT NULL,
    exam_mark FLOAT NOT NULL,
    appeal_status BOOLEAN DEFAULT NULL,
    appeal_mark FLOAT DEFAULT NULL,
    PRIMARY KEY (application_id, event_id),
    FOREIGN KEY (application_id) REFERENCES Applications(application_id),
    FOREIGN KEY (event_id) REFERENCES Event(event_id)
);
