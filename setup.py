from setuptools import setup, find_packages
from pythonmstpl.version import VERSION

PACKAGES = ["fastapi == 0.72.0",
            "gunicorn == 20.1.0",
            "uvicorn >= 0.17.0",
            "fastapi-versioning == 0.8.0"]

setup(
    name='pythonmstpl',
    version=VERSION,
    install_requires=PACKAGES,
    description='Python micro-service template app',
    packages=find_packages(),
)
