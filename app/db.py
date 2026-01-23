#############################################################
# db.py
#
# This module initializes the SQLAlchemy engine and session
# for the legacy PostgreSQL database.
#############################################################

from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, DeclarativeBase

DATABASE_URL = "postgresql+psycopg2://postgres:pass12345%401@db_legacy:5432/legacy"

engine = create_engine(
    DATABASE_URL,
    echo=False,
    pool_pre_ping=True,
)

SessionLocal = sessionmaker(bind=engine, autoflush=False, autocommit=False)


class Base(DeclarativeBase):
    pass
