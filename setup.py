from setuptools import setup
from flask_uwsgi_docker.version import VERSION

setup(
    name='flask_uwsgi_docker',
    version=VERSION,
    description='Flask UWSGI Docker Skeleton app',
    packages=['flask_uwsgi_docker']
)
