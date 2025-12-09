from fastapi import HTTPException, Depends
from passlib.context import CryptContext
from datetime import datetime, timedelta
from jose import jwt

from app.database import users_collection
from app.schemas.auth_schema import RegisterSchema, LoginSchema
from app.config import settings


pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")


# ----------------------------------------
# HASH PASSWORD
# ----------------------------------------
def hash_password(password: str):
    return pwd_context.hash(password)


# ----------------------------------------
# VERIFY PASSWORD
# ----------------------------------------
def verify_password(plain: str, hashed: str):
    return pwd_context.verify(plain, hashed)


# ----------------------------------------
# GENERATE JWT TOKEN
# ----------------------------------------
def create_access_token(data: dict, expires_in: int = 60 * 24):
    payload = data.copy()
    expire = datetime.utcnow() + timedelta(minutes=expires_in)
    payload.update({"exp": expire})

    token = jwt.encode(payload, settings.JWT_SECRET, algorithm=settings.JWT_ALGORITHM)
    return token


# ----------------------------------------
# USER REGISTER
# ----------------------------------------
async def register_user(data: RegisterSchema):
    existing_user = await users_collection.find_one({"email": data.email})
    if existing_user:
        raise HTTPException(status_code=400, detail="Email already registered")

    hashed_pw = hash_password(data.password)

    user_dict = {
        "username": data.username,
        "email": data.email,
        "password": hashed_pw,
        "profile_pic": None,
    }

    await users_collection.insert_one(user_dict)

    return {"message": "User registered successfully"}


# ----------------------------------------
# USER LOGIN
# ----------------------------------------
async def login_user(data: LoginSchema):
    user = await users_collection.find_one({"email": data.email})
    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    if not verify_password(data.password, user["password"]):
        raise HTTPException(status_code=400, detail="Invalid password")

    token = create_access_token({"user_id": str(user["_id"])})

    return {"access_token": token, "token_type": "bearer"}
