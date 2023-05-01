from setuptools import setup, find_packages
from pythonmstpl.version import VERSION

with open('requirements.txt') as f:
    install_requires = f.read().splitlines()

setup(
    name='pythonmstpl',
    version=VERSION,
    description='Python micro-service template app',
    packages=find_packages(exclude=["test"]),
    install_requires=install_requires,
)
