# Import library
from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker

# ??
# from dotenv import load_dotenv

# load_dotenv()
# import os

# Konfigurasi database
DATABASE_URL = "mysql+pymysql://root:@localhost/SITOGA_DB"  # MySQL Localhost
engine = create_engine(DATABASE_URL, echo=True)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

Base = declarative_base()