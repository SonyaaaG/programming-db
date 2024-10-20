"""This module contains ORM models for DB."""

from sqlalchemy import (
    Column, String, Integer, Boolean, ForeignKey,
    Date, TIMESTAMP, Identity, VARCHAR, Float
)
from sqlalchemy.orm import declarative_base

Base = declarative_base()


class Faculty(Base):
    __tablename__ = 'faculty'
    faculty_id = Column(Integer, Identity(always=True), primary_key=True)
    faculty_name = Column(VARCHAR(50), nullable=False)
    openings_amount = Column(Integer, nullable=False)


class Department(Base):
    __tablename__ = 'department'
    department_id = Column(Integer, Identity(always=True), primary_key=True)
    department_name = Column(VARCHAR(100), nullable=False)
    faculty_id = Column(Integer, ForeignKey('faculty.faculty_id', ondelete="RESTRICT"))


class EventTypes(Base):
    __tablename__ = 'eventtypes'
    type_id = Column(Integer, Identity(always=True), primary_key=True)
    type_name = Column(VARCHAR(20), nullable=False)


class Stream(Base):
    __tablename__ = 'stream'
    stream_id = Column(Integer, Identity(always=True), primary_key=True)
    stream_name = Column(VARCHAR(20), nullable=False)


class Group(Base):
    __tablename__ = 'group'
    group_id = Column(Integer, Identity(always=True), primary_key=True)
    group_name = Column(VARCHAR(10), nullable=False)
    stream_id = Column(Integer, ForeignKey('stream.stream_id', ondelete="RESTRICT"))


class Event(Base):
    __tablename__ = 'event'
    event_id = Column(Integer, Identity(always=True), primary_key=True)
    event_name = Column(VARCHAR(30), nullable=False)
    subject_name = Column(VARCHAR(20), nullable=False)
    stream_id = Column(Integer, ForeignKey('stream.stream_id', ondelete="CASCADE"))
    event_start_datetime = Column(TIMESTAMP, nullable=False)
    event_audience = Column(VARCHAR(20), nullable=False)
    event_duration = Column(Integer, nullable=False)
    event_type = Column(Integer, ForeignKey('eventtypes.type_id', ondelete="RESTRICT"))


class Applicants(Base):
    __tablename__ = 'applicants'
    applicant_id = Column(String(10), primary_key=True, unique=True)
    last_name = Column(VARCHAR(30), nullable=False)
    first_name = Column(VARCHAR(30), nullable=False)
    middle_name = Column(VARCHAR(30), nullable=True)
    id_series = Column(VARCHAR(20), nullable=False)
    graduated_institution_name = Column(VARCHAR(100), nullable=True)
    graduated_institution_city = Column(VARCHAR(50), nullable=True)
    graduated_date = Column(Date, nullable=True)
    has_medal = Column(Boolean, nullable=True)


class Applications(Base):
    __tablename__ = 'applications'
    application_id = Column(Integer, Identity(always=True), primary_key=True)
    applicant_id = Column(String(10), ForeignKey('applicants.applicant_id', ondelete="CASCADE"))
    department_id = Column(Integer, ForeignKey('department.department_id', ondelete="RESTRICT"))
    group_id = Column(Integer, ForeignKey('group.group_id', ondelete="RESTRICT"))
    is_current_application = Column(Boolean, nullable=False)


class ExamResults(Base):
    __tablename__ = 'examresults'
    application_id = Column(
        Integer, ForeignKey('applications.application_id'),
        nullable=False, primary_key=True
    )
    event_id = Column(
        Integer, ForeignKey('event.event_id'),
        nullable=False, primary_key=True
    )
    exam_mark = Column(Float(precision=1), nullable=False)
    appeal_status = Column(Boolean)
    appeal_mark = Column(Float(precision=1))


if __name__ == '__main__':
    from engine import engine

    Base.metadata.create_all(engine)
