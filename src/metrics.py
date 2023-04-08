from prometheus_client import Summary

REQUEST_TIME = Summary('request_processing_seconds', 'Time spent processing request')
METRICS_MIME_TYPE = str('text/plain; version=0.0.4; charset=utf-8')
