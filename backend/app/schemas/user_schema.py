from pydantic import BaseModel, EmailStr, Field


# ----------------------------------------
# UPDATE USER PROFILE SCHEMA
# ----------------------------------------
class UpdateUserSchema(BaseModel):
    username: str | None = Field(None, min_length=2, max_length=50)
    email: EmailStr | None = None
    profile_pic: str | None = None
