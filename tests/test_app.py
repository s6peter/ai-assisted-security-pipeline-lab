import json
import threading
import unittest
from urllib.request import urlopen
from http.server import ThreadingHTTPServer
from app.server import Handler

class AppTest(unittest.TestCase):
    def test_health(self):
        server = ThreadingHTTPServer(("127.0.0.1", 0), Handler)
        thread = threading.Thread(target=server.serve_forever, daemon=True)
        thread.start()
        try:
            with urlopen(f"http://127.0.0.1:{server.server_port}/health") as response:
                self.assertEqual(response.status, 200)
                self.assertEqual(json.load(response)["message"], "Hello Peter")
        finally:
            server.shutdown()
            server.server_close()
