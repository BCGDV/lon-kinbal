from flask import Flask
import os
import time

app = Flask(__name__)


@app.route("/service/info")
def service():
    return {
        "service": 'service-3',
        "res": f"Request received on {int(time.time())}"
    }


@app.route("/ping")
def hello():
    return {
        "service": 'service-3',
        "res": 'PONG'
    }


if __name__ == "__main__":
    port = int(os.environ.get("PORT", 5000))
    app.run(debug=True, host='0.0.0.0', port=port)
