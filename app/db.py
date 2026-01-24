#############################################################
# db.py
#
# This module initializes the SQLAlchemy engines and sessions
# for the legacy and clean PostgreSQL databases.
#############################################################

from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, DeclarativeBase

##############
# LEGACY DB
##############

DATABASE_URL = "postgresql+psycopg2://postgres:pass12345%401@db_legacy:5432/legacy"

legacy_engine = create_engine(
    DATABASE_URL,
    echo=False,
    pool_pre_ping=True,
)

LegacyDBSession = sessionmaker(bind=legacy_engine, autoflush=False, autocommit=False)


##############
# CLEAN DB
##############

CLEAN_DATABASE_URL = "postgresql+psycopg2://admin2:pass12345%402@db_clean:5432/clean"

clean_engine = create_engine(
    CLEAN_DATABASE_URL,
    echo=False,
    pool_pre_ping=True,
)

CleanDBSession = sessionmaker(bind=clean_engine,autoflush=False, autocommit=False)




class Base(DeclarativeBase):
    pass
