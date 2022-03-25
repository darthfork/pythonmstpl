from fastapi.routing import APIRouter

router = APIRouter()

@router.get("/healthcheck")
async def healthcheck() -> dict:
    return {"status": "ok"}
