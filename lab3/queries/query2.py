"""Всі оцінки з іспитів для певного абітурієнта"""
import pandas as pd
from sqlalchemy import func
from sqlalchemy.orm import sessionmaker

from lab3.engine import engine
from lab3.models import Applications, Event, ExamResults

session = sessionmaker(bind=engine)()
query = (
    session.query(
        Applications.applicant_id,
        Event.event_name,
        func.coalesce(ExamResults.appeal_mark, ExamResults.exam_mark).label('final_mark')
    )
    .join(ExamResults, Applications.application_id == ExamResults.application_id)
    .join(Event, ExamResults.event_id == Event.event_id)
    .filter(
        Applications.applicant_id == 'ХА-12343',
        Applications.is_current_application == True,
        Event.event_type == 1
    ))

df = pd.read_sql(query.statement, query.session.bind)
print(df)
