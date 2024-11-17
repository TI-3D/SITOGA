# Import library
from sqlalchemy.orm import sessionmaker
from sqlalchemy import create_engine, MetaData 
from sqlalchemy.ext.declarative import declarative_base
# ??
# from dotenv import load_dotenv

# load_dotenv()
# import os

# Konfigurasi database
DATABASE_URL = "mysql+pymysql://root:@localhost/SITOGA_DB"  # MySQL Localhost
engine = create_engine(DATABASE_URL, echo=True)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

Base = declarative_base()
metadata = MetaData()