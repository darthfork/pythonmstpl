from fastapi import FastAPI
from fastapi_versioning import VersionedFastAPI, version

from pythonmstpl import v1

app = FastAPI(title='pythonmstpl')

app.include_router(v1.router)

app = VersionedFastAPI(app,
                       version_format='{major}',
                       prefix_format='/v{major}')
