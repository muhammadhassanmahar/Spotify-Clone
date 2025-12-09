from fastapi import APIRouter, UploadFile, File
from app.services.upload_service import save_uploaded_file

router = APIRouter(prefix="/upload", tags=["Upload"])


# ----------------------------------------
# UPLOAD IMAGE OR AUDIO FILE
# ----------------------------------------
@router.post("/")
async def upload_file(file: UploadFile = File(...)):
    return await save_uploaded_file(file)
