# Import library
from sqlalchemy.orm import sessionmaker
from sqlalchemy import create_engine, MetaData 
from sqlalchemy.ext.declarative import declarative_base

# Konfigurasi database
DATABASE_URL = "mysql+pymysql://root:@localhost/SITOGA_DB"  # MySQL Localhost

# Database PUBLIC InfinityFree
# DATABASE_URL = "mysql+pymysql://if0_37716966:ImamHanafi2004@sql210.infinityfree.com/if0_37716966_sitoga_db"

engine = create_engine(DATABASE_URL, echo=True)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

Base = declarative_base()
metadata = MetaData()

def get_db():
    db = SessionLocal() 
    try:
        yield db  
    finally:
        db.close() 
