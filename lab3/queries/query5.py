"""Конкурс на кожний факультет"""
import pandas as pd
from sqlalchemy.orm import sessionmaker

from lab3.engine import engine
from lab3.models import Faculty


session = sessionmaker(bind=engine)()
query = (
    session.query(
        Faculty.faculty_name,
        Faculty.openings_amount
    )
)

df = pd.read_sql(query.statement, query.session.bind)
print(df)
