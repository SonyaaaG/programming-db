"""Де, коли і з яких предметів проходитимуть іспити у заданої групи
 - група КН-101"""
import pandas as pd
from sqlalchemy.orm import sessionmaker

from lab3.engine import engine
from lab3.models import Stream, Group, Event, EventTypes


session = sessionmaker(bind=engine)()
query = (
    session.query(
        Group.group_name,
        Event.event_type,
        Event.subject_name,
        Event.event_start_datetime,
        Event.event_audience
    )
    .join(Stream, Group.stream_id == Stream.stream_id)
    .join(Event, Event.stream_id == Stream.stream_id)
    .join(EventTypes, EventTypes.type_id == Event.event_type)
    .filter(
        EventTypes.type_name == 'Іспит',
        Group.group_name == 'КН-101'
    )

)

df = pd.read_sql(query.statement, query.session.bind)
print(df)
