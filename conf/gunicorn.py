from multiprocessing import cpu_count

worker_class = 'uvicorn.workers.UvicornWorker'
bind = "0.0.0.0:5000"
workers = cpu_count() * 2
threads = 8
accesslog='-'
loglevel='info'
