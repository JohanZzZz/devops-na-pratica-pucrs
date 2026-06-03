import os
import platform
from datetime import datetime, timezone

from flask import Flask, jsonify

app = Flask(__name__)

START_TIME = datetime.now(timezone.utc)


@app.route("/")
def health_check():
    return jsonify({
        "status": "healthy",
        "timestamp": datetime.now(timezone.utc).isoformat()
    })


@app.route("/api/status")
def status():
    uptime = datetime.now(timezone.utc) - START_TIME
    return jsonify({
        "application": "devops-na-pratica",
        "status": "running",
        "uptime_seconds": int(uptime.total_seconds()),
        "environment": os.getenv("FLASK_ENV", "production")
    })


@app.route("/api/info")
def info():
    return jsonify({
        "application": "devops-na-pratica",
        "version": "1.0.0",
        "python_version": platform.python_version(),
        "platform": platform.system(),
        "architecture": platform.machine()
    })


if __name__ == "__main__":
    port = int(os.getenv("PORT", 5000))
    debug = os.getenv("FLASK_ENV") == "development"
    app.run(host="0.0.0.0", port=port, debug=debug)
