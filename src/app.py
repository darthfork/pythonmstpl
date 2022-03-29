from fastapi import FastAPI
from fastapi_versioning import VersionedFastAPI

from pythonmstpl.v1 import api as v1

app = FastAPI(title='pythonmstpl')

app.include_router(v1.router)

app = VersionedFastAPI(app,
                       version_format='{major}',
                       prefix_format='/v{major}')
