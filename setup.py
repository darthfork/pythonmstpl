from setuptools import setup

def get_version():
    with open('version') as version_file:
        for line in version_file:
            if line.startswith("VERSION"):
                version = line.strip().split('=')[1]
                break
        return version

setup(
    name='flask_uwsgi_docker',
    version=get_version(),
    description='Flask UWSGI Docker Skeleton app',
    packages=['flask_uwsgi_docker']
)
