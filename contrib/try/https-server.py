#!/usr/bin/env python3
import os, sys
import http.server
import ssl
#import cgitb; cgitb.enable(display=0, logdir=".") # Deprecated

PORT = 4443
CERTFILE = "https-server-certificate.pem"
SERVER_ADDRESS = ("localhost", PORT)
handler = http.server.CGIHTTPRequestHandler
handler.cgi_directories = ["/cgi-bin"]
httpd = http.server.HTTPServer(SERVER_ADDRESS, handler)
context = ssl.SSLContext(ssl.PROTOCOL_TLS_SERVER)
context.load_cert_chain(certfile=CERTFILE)
httpd.socket = context.wrap_socket(httpd.socket, server_side=True)
print(f"Server started successfully.")
print(f"Serving HTTPS on https://{SERVER_ADDRESS[0]}:{SERVER_ADDRESS[1]}")
httpd.serve_forever()
