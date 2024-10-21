"""Середній бал із кожного предмета на кожному факультеті"""
import pandas as pd
from sqlalchemy.orm import sessionmaker
from sqlalchemy import func

from lab3.engine import engine
from lab3.models import Applications, Department, Faculty, Event, ExamResults, EventTypes


session = sessionmaker(bind=engine)()
query = (
    session.query(
        Faculty.faculty_name,
        Event.subject_name,
        func.avg(func.coalesce(ExamResults.appeal_mark, ExamResults.exam_mark)).label('mean_mark')
    )
    .join(Department, Department.faculty_id == Faculty.faculty_id)
    .join(Applications, Applications.department_id == Department.department_id)
    .join(ExamResults, ExamResults.application_id == Applications.application_id)
    .join(Event, Event.event_id == ExamResults.event_id)
    .join(EventTypes, Event.event_type == EventTypes.type_id)
    .filter(EventTypes.type_name == 'Іспит')
    .group_by(Faculty.faculty_name, Event.subject_name)
)

df = pd.read_sql(query.statement, query.session.bind)
print(df)
