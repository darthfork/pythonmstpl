import json

from flask import Flask

app = Flask(__name__)

@app.route("/healthcheck")
def healthcheck():
    return json.dumps({"status": "ok"})
