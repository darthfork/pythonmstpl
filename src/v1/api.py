from fastapi.routing import APIRouter
from fastapi_versioning import versioned_api_route
from fastapi import Response
from prometheus_client import generate_latest

from pythonmstpl.metrics import REQUEST_TIME, METRICS_MIME_TYPE

router = APIRouter(route_class=versioned_api_route(1))

@REQUEST_TIME.time()
@router.get("/healthcheck")
async def healthcheck() -> dict:
    return {"status": "ok"}

@REQUEST_TIME.time()
@router.get("/metrics")
async def metrics():
    return Response(content=generate_latest(), media_type=METRICS_MIME_TYPE)
