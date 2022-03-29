from fastapi.routing import APIRouter
from fastapi_versioning import versioned_api_route

router = APIRouter(route_class=versioned_api_route(1))

@router.get("/healthcheck")
async def healthcheck() -> dict:
    return {"status": "ok"}
