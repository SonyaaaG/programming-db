"""Коли та в якій аудиторії буде консультація та іспит y
заданого абітурієнта із зазначеного предмета"""
import pandas as pd
from sqlalchemy.orm import sessionmaker

from lab3.engine import engine
from lab3.models import Applications, Event, Group, Stream

session = sessionmaker(bind=engine)()
query = (
    session.query(
        Applications.applicant_id,
        Event.event_name,
        Event.event_start_datetime,
        Event.event_audience,
        Event.subject_name
    )
    .join(Group, Applications.group_id == Group.group_id)
    .join(Stream, Group.stream_id == Stream.stream_id)
    .join(Event, Stream.stream_id == Event.stream_id)
    .filter(
        Applications.is_current_application == True,
        Applications.applicant_id == 'ХА-12345',
        Event.subject_name == 'Фізика'
    ))

df = pd.read_sql(query.statement, query.session.bind)
print(df)
