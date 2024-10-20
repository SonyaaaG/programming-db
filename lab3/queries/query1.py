"""Перелік абітурієнтів на факультет комп`ютерних наук"""
import pandas as pd
from sqlalchemy.orm import sessionmaker

from lab3.engine import engine
from lab3.models import Applications, Department, Faculty, Applicants


session = sessionmaker(bind=engine)()
query = (
    session.query(Applicants)
    .join(Applications)
    .join(Department)
    .join(Faculty)
    .filter(Faculty.faculty_name == 'Комп`ютерних наук')
    .filter(Applications.is_current_application == True)
)

df = pd.read_sql(query.statement, query.session.bind)
print(df)
