from setuptools import setup, find_packages
from pythonmstpl.version import VERSION

setup(
    name='pythonmstpl',
    version=VERSION,
    description='Python micro-service template app',
    packages=find_packages(),
)
