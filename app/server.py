"""Local-only teaching app; no external services, accounts, or secrets."""
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
import json
import os

class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        body = json.dumps({"message": "Hello Peter", "lab": "AI-assisted security"}).encode()
        self.send_response(200 if self.path in ("/", "/health") else 404)
        self.send_header("Content-Type", "application/json")
        # Exercise: add security headers and compare ZAP reports before/after.
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

if __name__ == "__main__":
    ThreadingHTTPServer(("127.0.0.1", int(os.environ.get("LAB_PORT", "18765"))), Handler).serve_forever()
