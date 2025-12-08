from fastapi import APIRouter, HTTPException, Depends
from app.schemas.auth_schema import RegisterSchema, LoginSchema
from app.services.auth_service import AuthService
from app.utils.oauth2 import get_current_user

router = APIRouter(prefix="/auth", tags=["Authentication"])


# -------------------------------
# USER REGISTRATION
# -------------------------------
@router.post("/register")
async def register_user(payload: RegisterSchema):
    result = await AuthService.register_user(payload.dict())
    if not result:
        raise HTTPException(status_code=400, detail="User registration failed")
    return {"message": "User registered successfully"}


# -------------------------------
# USER LOGIN
# -------------------------------
@router.post("/login")
async def login_user(payload: LoginSchema):
    token = await AuthService.login_user(payload.email, payload.password)
    if not token:
        raise HTTPException(status_code=401, detail="Invalid credentials")
    return {"access_token": token, "token_type": "bearer"}


# -------------------------------
# GET LOGGED-IN USER
# -------------------------------
@router.get("/me")
async def get_me(user=Depends(get_current_user)):
    return user
