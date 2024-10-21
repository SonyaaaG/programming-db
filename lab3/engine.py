"""This module contains constants and connection engine used for DB operations."""
from sqlalchemy import create_engine


CONNECTOR = 'postgresql+psycopg2'
USER = 'postgres'
PASSWORD = 'postgres'
DB_NAME = 'lab3'
PORT = '5434'

engine = create_engine(f'{CONNECTOR}://{USER}:{PASSWORD}@localhost:{PORT}/{DB_NAME}')
