from sphinx.util.console import blink
from sqlalchemy import create_engine
from  sqlalchemy.orm import  sessionmaker
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.util.preloaded import engine_url

URL_DATABASE = 'postgresql://postgres:24122004@localhost:5432/postgres'

engine = create_engine(URL_DATABASE)

SessionLocal = sessionmaker(autocommit=False , autoflush=False , bind=engine)

Base = declarative_base()