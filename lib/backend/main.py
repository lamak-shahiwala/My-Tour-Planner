from fastapi import FastAPI , HTTPException , Depends
from pydantic import BaseModel
from typing import List , Annotated
from database import engine , SessionLocal
from sqlalchemy.orm import Session
from sqlalchemy import text
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()

def get_db():
    db=SessionLocal()
    try:
        yield db
    finally:
        db.close()


db_dependency = Annotated[Session, Depends(get_db)]


app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credntials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# @app.get("/test-db")
# def test_db_connection(db: db_dependency):
#     try:
#         # Use text() function to wrap your SQL query
#         result = db.execute(text("SELECT 1 AS test")).fetchone()
#         if result and result[0] == 1:  # Access by index instead of attribute
#             return {"status": "success", "message": "Database connection working!"}
#         else:
#             return {"status": "error", "message": "Query failed"}
#     except Exception as e:
#         raise HTTPException(status_code=500, detail=f"Database error: {str(e)}")

