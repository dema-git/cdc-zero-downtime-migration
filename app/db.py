#############################################################
# db.py
#
# This module initializes the SQLAlchemy engines and sessions
# for the legacy and clean PostgreSQL databases.
#############################################################

from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, DeclarativeBase
import os
from urllib.parse import quote_plus

##############
# LEGACY DB
##############

POSTGRES_LEGACY_USER = os.getenv("POSTGRES_LEGACY_USER")
POSTGRES_LEGACY_PASSWORD = quote_plus(os.getenv("POSTGRES_LEGACY_PASSWORD"))

DATABASE_URL = f"postgresql+psycopg2://{POSTGRES_LEGACY_USER}:{POSTGRES_LEGACY_PASSWORD}@db_legacy:5432/legacy"

legacy_engine = create_engine(
    DATABASE_URL,
    echo=False,
    pool_pre_ping=True,
)

LegacyDBSession = sessionmaker(bind=legacy_engine, autoflush=False, autocommit=False)


##############
# CLEAN DB
##############

POSTGRES_CLEAN_USER = os.getenv("POSTGRES_CLEAN_USER")
POSTGRES_CLEAN_PASSWORD = quote_plus(os.getenv("POSTGRES_CLEAN_PASSWORD"))

CLEAN_DATABASE_URL = f"postgresql+psycopg2://{POSTGRES_CLEAN_USER}:{POSTGRES_CLEAN_PASSWORD}@db_clean:5432/clean"

clean_engine = create_engine(
    CLEAN_DATABASE_URL,
    echo=False,
    pool_pre_ping=True,
)

CleanDBSession = sessionmaker(bind=clean_engine,autoflush=False, autocommit=False)




class Base(DeclarativeBase):
    pass
