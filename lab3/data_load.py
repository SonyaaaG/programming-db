"""This module loads initial data into the postgres database."""
from datetime import datetime

from sqlalchemy.orm import sessionmaker, Session

from engine import engine
from models import (
    Faculty, Department, EventTypes, Group,
    Stream, Applicants, Applications, ExamResults, Event
)


def insert_data(session: Session, data: list) -> None:
    session.add_all(data)
    session.commit()


# faculty
faculty_entries = [
    Faculty(faculty_name='Комп`ютерних наук', openings_amount=500),
    Faculty(faculty_name='Комп`ютерної інженерії', openings_amount=280),
    Faculty(faculty_name='Інформаційно-аналітичних технологій і менеджменту', openings_amount=199),
]


# Department
department_entries = [
    Department(department_name='Штучного інтелекту', faculty_id=1),
    Department(department_name='Програмної інженерії', faculty_id=1),
    Department(department_name='Системотехніки', faculty_id=1),
    Department(department_name='Електронних обчислювальних машин', faculty_id=2),
    Department(department_name='Безпеки інформаційних технологій', faculty_id=2),
    Department(department_name='Інформатики', faculty_id=3),
    Department(department_name='Прикладної математики', faculty_id=3),
]


# EventTypes
event_types_entries = [
    EventTypes(type_name='Іспит'),
    EventTypes(type_name='Консультація'),
]


# Stream
stream_entries = [
    Stream(stream_name='КН-1'),
    Stream(stream_name='КІ-1'),
    Stream(stream_name='ІАТМ-1'),
]


# Group
group_entries = [
    Group(group_name='КН-101', stream_id=1),
    Group(group_name='КН-102', stream_id=1),
    Group(group_name='КН-103', stream_id=1),
    Group(group_name='КІ-201', stream_id=2),
    Group(group_name='КІ-202', stream_id=2),
    Group(group_name='КІ-203', stream_id=2),
    Group(group_name='ІАТМ-301', stream_id=3),
    Group(group_name='ІАТМ-302', stream_id=3),
    Group(group_name='ІАТМ-303', stream_id=3),
    Group(group_name='ІАТМ-304', stream_id=3),
]


# Event
events = [
    Event(event_name='Іспит з Програмування', subject_name='Програмування', stream_id=1,
          event_start_datetime=datetime(2024, 8, 10, 9, 0, 0),
          event_audience='І240', event_duration=120, event_type=1),
    Event(event_name='Консультація з Програмування', subject_name='Програмування', stream_id=1,
          event_start_datetime=datetime(2024, 8, 2, 14, 0, 0),
          event_audience='АУ100', event_duration=60, event_type=2),
    Event(event_name='Іспит з Фізики', subject_name='Фізика', stream_id=1,
          event_start_datetime=datetime(2024, 8, 12, 10, 30, 0)
          , event_audience='І317', event_duration=120, event_type=1),
    Event(event_name='Консультація з Фізики', subject_name='Фізика', stream_id=1,
          event_start_datetime=datetime(2024, 8, 5, 12, 30, 0),
          event_audience='АУ111', event_duration=90, event_type=2),
    Event(event_name='Консультація з Математики', subject_name='Математика', stream_id=1,
          event_start_datetime=datetime(2024, 8, 2, 13, 30, 0),
          event_audience='К440', event_duration=90, event_type=2),
    Event(event_name='Іспит з Математики', subject_name='Математика', stream_id=1,
          event_start_datetime=datetime(2024, 8, 7, 12, 0, 0),
          event_audience='І241', event_duration=180, event_type=1),
    Event(event_name='Іспит з Програмування', subject_name='Програмування', stream_id=2,
          event_start_datetime=datetime(2024, 8, 11, 9, 0, 0),
          event_audience='І120', event_duration=120, event_type=1),
    Event(event_name='Іспит з Математики', subject_name='Математика', stream_id=2,
          event_start_datetime=datetime(2024, 8, 8, 10, 0, 0),
          event_audience='І241', event_duration=180, event_type=1),
    Event(event_name='Іспит з Фізики', subject_name='Фізика', stream_id=2,
          event_start_datetime=datetime(2024, 8, 14, 10, 30, 0),
          event_audience='І541', event_duration=120, event_type=1),
    Event(event_name='Іспит з Програмування', subject_name='Програмування', stream_id=3,
          event_start_datetime=datetime(2024, 8, 12, 9, 0, 0),
          event_audience='І0', event_duration=120, event_type=1),
    Event(event_name='Іспит з Математики', subject_name='Математика', stream_id=3,
          event_start_datetime=datetime(2024, 8, 9, 12, 0, 0),
          event_audience='І211', event_duration=180, event_type=1),
    Event(event_name='Іспит з Фізики', subject_name='Фізика', stream_id=3,
          event_start_datetime=datetime(2024, 8, 15, 10, 30, 0),
          event_audience='І317', event_duration=120, event_type=1)
]


# Applicants
applicants = [
    Applicants(applicant_id='ХА-12345', last_name='Сидоренко', first_name='Іван', middle_name='Іванович',
               id_series='АВ123456', graduated_institution_name='Школа №150', graduated_institution_city='Харків',
               graduated_date='2024-05-30', has_medal=True),
    Applicants(applicant_id='ХА-12344', last_name='Коваленко', first_name='Марія', middle_name='Олександрівна',
               id_series='ВГ654321', graduated_institution_name='Гімназія "Знання"',
               graduated_institution_city='Дніпро',
               graduated_date='2024-06-01', has_medal=False),
    Applicants(applicant_id='ХА-12343', last_name='Козлов', first_name='Олексій', middle_name='Ігорович',
               id_series='ГД789012', graduated_institution_name='Ліцей "Сонячний"', graduated_institution_city='Харків',
               graduated_date='2024-05-28', has_medal=False),
    Applicants(applicant_id='ХА-12346', last_name='Гончаренко', first_name='Ольга', middle_name='Михайлівна',
               id_series='АА123321', graduated_institution_name='Школа №122', graduated_institution_city='Харків',
               graduated_date='2024-05-30', has_medal=False),
    Applicants(applicant_id='ХА-12347', last_name='Деревянко', first_name='Василь', middle_name='Петрович',
               id_series='ВВ654123', graduated_institution_name='Школа №3"', graduated_institution_city='Полтава',
               graduated_date='2024-06-01', has_medal=True),
    Applicants(applicant_id='ХА-12348', last_name='Тарасенко', first_name='Андрій', middle_name='Олександрович',
               id_series='ГГ789098', graduated_institution_name='Гімназія №5', graduated_institution_city='Харків',
               graduated_date='2024-05-28', has_medal=False),
    Applicants(applicant_id='ХА-12349', last_name='Петренко', first_name='Олександр', middle_name='Васильович',
               id_series='АВ153922', graduated_institution_name='Школа №172', graduated_institution_city='Харків',
               graduated_date='2024-05-30', has_medal=False),
    Applicants(applicant_id='ХА-12350', last_name='Іванова', first_name='Катерина', middle_name='Ігорівна',
               id_series='ББ256333', graduated_institution_name='Ліцей №59', graduated_institution_city='Харків',
               graduated_date='2024-06-01', has_medal=True),
    Applicants(applicant_id='ХА-12351', last_name='Мельник', first_name='Олена', middle_name='Петрівна',
               id_series='ВВ392441', graduated_institution_name='Гімназія №23', graduated_institution_city='Харків',
               graduated_date='2024-05-28', has_medal=False),
    Applicants(applicant_id='ХА-12352', last_name='Савченко', first_name='Дмитро', middle_name='Андрійович',
               id_series='ГГ442557', graduated_institution_name='Школа №45', graduated_institution_city='Харків',
               graduated_date='2024-05-29', has_medal=True)
]


# Applications
applications = [
    Applications(applicant_id='ХА-12345', department_id=3, group_id=1, is_current_application=True),
    Applications(applicant_id='ХА-12345', department_id=2, group_id=2, is_current_application=False),
    Applications(applicant_id='ХА-12344', department_id=2, group_id=2, is_current_application=True),
    Applications(applicant_id='ХА-12343', department_id=1, group_id=3, is_current_application=True),
    Applications(applicant_id='ХА-12346', department_id=4, group_id=4, is_current_application=True),
    Applications(applicant_id='ХА-12347', department_id=5, group_id=5, is_current_application=True),
    Applications(applicant_id='ХА-12348', department_id=5, group_id=6, is_current_application=True),
    Applications(applicant_id='ХА-12349', department_id=7, group_id=7, is_current_application=True),
    Applications(applicant_id='ХА-12350', department_id=7, group_id=8, is_current_application=True),
    Applications(applicant_id='ХА-12351', department_id=6, group_id=9, is_current_application=True),
    Applications(applicant_id='ХА-12352', department_id=6, group_id=10, is_current_application=True)
]


# ExamResults
exam_results = [
    ExamResults(application_id=1, event_id=1, exam_mark=99.7, appeal_status=None, appeal_mark=None),
    ExamResults(application_id=3, event_id=1, exam_mark=67.0, appeal_status=True, appeal_mark=75),
    ExamResults(application_id=3, event_id=3, exam_mark=90, appeal_status=False, appeal_mark=None),
    ExamResults(application_id=3, event_id=6, exam_mark=87, appeal_status=None, appeal_mark=None),
    ExamResults(application_id=4, event_id=1, exam_mark=66.0, appeal_status=False, appeal_mark=66.0),
    ExamResults(application_id=4, event_id=3, exam_mark=72.0, appeal_status=True, appeal_mark=70),
    ExamResults(application_id=4, event_id=6, exam_mark=92.5, appeal_status=None, appeal_mark=None),
    ExamResults(application_id=5, event_id=7, exam_mark=85.5, appeal_status=False, appeal_mark=None),
    ExamResults(application_id=5, event_id=8, exam_mark=92.0, appeal_status=True, appeal_mark=95),
    ExamResults(application_id=5, event_id=9, exam_mark=78.0, appeal_status=None, appeal_mark=None),
    ExamResults(application_id=6, event_id=8, exam_mark=97.0, appeal_status=False, appeal_mark=None),
    ExamResults(application_id=7, event_id=7, exam_mark=99.5, appeal_status=False, appeal_mark=None),
    ExamResults(application_id=7, event_id=8, exam_mark=91.0, appeal_status=None, appeal_mark=None),
    ExamResults(application_id=7, event_id=9, exam_mark=89.5, appeal_status=True, appeal_mark=92),
    ExamResults(application_id=8, event_id=10, exam_mark=68.5, appeal_status=False, appeal_mark=None),
    ExamResults(application_id=8, event_id=11, exam_mark=62.0, appeal_status=None, appeal_mark=None),
    ExamResults(application_id=8, event_id=12, exam_mark=77.5, appeal_status=None, appeal_mark=None),
    ExamResults(application_id=9, event_id=12, exam_mark=93.5, appeal_status=False, appeal_mark=None),
    ExamResults(application_id=10, event_id=10, exam_mark=78.0, appeal_status=True, appeal_mark=80),
    ExamResults(application_id=10, event_id=11, exam_mark=95.0, appeal_status=None, appeal_mark=None),
    ExamResults(application_id=10, event_id=12, exam_mark=82.0, appeal_status=False, appeal_mark=None),
    ExamResults(application_id=11, event_id=12, exam_mark=96.0, appeal_status=False, appeal_mark=None),
]

if __name__ == '__main__':
    Session = sessionmaker(bind=engine)
    session = Session()
    for data in [
        faculty_entries, department_entries, event_types_entries,
        stream_entries, group_entries, events, applicants, applications,
        exam_results
    ]:
        insert_data(session, data)
