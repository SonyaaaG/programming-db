"""This module contains constants and connection engine used for DB operations."""
import os

CONNECTOR = 'postgresql+psycopg2'
USER = os.getenv('POSTGRES_USER')
PASSWORD = os.getenv('POSTGRES_PASSWORD')
DB_NAME = os.getenv('POSTGRES_DB')
PORT = '5432'

engine = f'{CONNECTOR}://{USER}:{PASSWORD}@db:{PORT}/{DB_NAME}'
