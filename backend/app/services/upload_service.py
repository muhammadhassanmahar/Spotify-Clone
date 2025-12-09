import os
from fastapi import UploadFile
from uuid import uuid4

UPLOAD_FOLDER = "uploads"


# -------------------------------------------------
# Ensure upload folder exists
# -------------------------------------------------
if not os.path.exists(UPLOAD_FOLDER):
    os.makedirs(UPLOAD_FOLDER)


# -------------------------------------------------
# Save uploaded file (image/audio)
# -------------------------------------------------
async def save_uploaded_file(file: UploadFile):
    try:
        file_extension = file.filename.split(".")[-1]
        file_name = f"{uuid4()}.{file_extension}"
        file_path = os.path.join(UPLOAD_FOLDER, file_name)

        # Save file
        with open(file_path, "wb") as f:
            f.write(await file.read())

        return {
            "success": True,
            "message": "File uploaded successfully",
            "file_name": file_name,
            "file_path": file_path
        }

    except Exception as e:
        return {
            "success": False,
            "message": f"Upload failed: {str(e)}"
        }
