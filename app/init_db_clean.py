import os
from urllib.parse import quote_plus
from sqlalchemy import create_engine
from models import Base

print("Checking tables in database...")


POSTGRES_USER = os.getenv("POSTGRES_CLEAN_USER")
POSTGRES_PASSWORD = os.getenv("POSTGRES_CLEAN_PASSWORD")
POSTGRES_DB = os.getenv("POSTGRES_DB", "clean")
POSTGRES_HOST = os.getenv("POSTGRES_HOST", "db_clean")
POSTGRES_PORT = os.getenv("POSTGRES_CLEAN_PORT", "5432")

POSTGRES_PASSWORD = quote_plus(POSTGRES_PASSWORD)

DATABASE_URL = f"postgresql+psycopg2://{POSTGRES_USER}:{POSTGRES_PASSWORD}@{POSTGRES_HOST}:{POSTGRES_PORT}/{POSTGRES_DB}"

engine = create_engine(DATABASE_URL, echo=True)

Base.metadata.create_all(engine)

print(f"✅ Tables in database '{POSTGRES_DB}' are created (if they didn't exist)")