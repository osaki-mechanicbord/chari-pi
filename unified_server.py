"""
CHARI-PI 統合サーバー
Flutter Web + Admin Dashboard (静的) + Backend API (プロキシ)
ポート5060で全て提供
"""
from http.server import HTTPServer, SimpleHTTPRequestHandler
import urllib.request
import urllib.error
import json

FLUTTER_DIR = '/home/user/flutter_app/build/web'
API_HOST = 'http://localhost:5080'

class Handler(SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=FLUTTER_DIR, **kwargs)

    def end_headers(self):
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'GET,POST,PUT,DELETE,OPTIONS')
        self.send_header('Access-Control-Allow-Headers', 'Content-Type,Authorization')
        self.send_header('X-Frame-Options', 'ALLOWALL')
        self.send_header('Content-Security-Policy', 'frame-ancestors *')
        super().end_headers()

    def _proxy_api(self, method):
        """APIリクエストをバックエンドに転送"""
        url = f'{API_HOST}{self.path}'
        body = None
        if method in ('POST', 'PUT', 'DELETE'):
            cl = int(self.headers.get('Content-Length', 0))
            if cl > 0:
                body = self.rfile.read(cl)
        try:
            req = urllib.request.Request(url, data=body, method=method)
            req.add_header('Content-Type', self.headers.get('Content-Type', 'application/json'))
            auth = self.headers.get('Authorization')
            if auth:
                req.add_header('Authorization', auth)
            with urllib.request.urlopen(req, timeout=30) as resp:
                data = resp.read()
                self.send_response(resp.status)
                self.send_header('Content-Type', resp.headers.get('Content-Type', 'application/json'))
                self.send_header('Content-Length', str(len(data)))
                self.end_headers()
                self.wfile.write(data)
        except urllib.error.HTTPError as e:
            data = e.read()
            self.send_response(e.code)
            self.send_header('Content-Type', 'application/json')
            self.send_header('Content-Length', str(len(data)))
            self.end_headers()
            self.wfile.write(data)
        except Exception as e:
            err = json.dumps({'error': str(e)}).encode()
            self.send_response(502)
            self.send_header('Content-Type', 'application/json')
            self.send_header('Content-Length', str(len(err)))
            self.end_headers()
            self.wfile.write(err)

    def do_OPTIONS(self):
        self.send_response(200)
        self.end_headers()

    def do_GET(self):
        # APIリクエストはバックエンドに転送
        if self.path.startswith('/api/'):
            self._proxy_api('GET')
        else:
            # /admin/ と / は全て静的ファイルとして提供
            super().do_GET()

    def do_POST(self):
        self._proxy_api('POST')

    def do_PUT(self):
        self._proxy_api('PUT')

    def do_DELETE(self):
        self._proxy_api('DELETE')

    def log_message(self, fmt, *args):
        pass

if __name__ == '__main__':
    srv = HTTPServer(('0.0.0.0', 5060), Handler)
    srv.allow_reuse_address = True
    print('CHARI-PI server on 5060')
    srv.serve_forever()
