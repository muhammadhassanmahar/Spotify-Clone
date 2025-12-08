from pydantic import BaseModel, EmailStr, Field


# ----------------------------------------
# REGISTER USER SCHEMA
# ----------------------------------------
class RegisterSchema(BaseModel):
    username: str = Field(..., min_length=2, max_length=50)
    email: EmailStr
    password: str = Field(..., min_length=6)


# ----------------------------------------
# LOGIN USER SCHEMA
# ----------------------------------------
class LoginSchema(BaseModel):
    email: EmailStr
    password: str
