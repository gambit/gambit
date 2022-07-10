#!/usr/bin/env python2
import os, sys
import BaseHTTPServer
import CGIHTTPServer
import cgitb; cgitb.enable() # enable CGI error reporting
import ssl
server = BaseHTTPServer.HTTPServer
handler = CGIHTTPServer.CGIHTTPRequestHandler
server_address = ("localhost", 4443)
handler.cgi_directories = ["/cgi-bin"]
os.chdir(".")
srvobj = server(server_address, handler)
srvobj.socket = ssl.wrap_socket(srvobj.socket, certfile="https-server-certificate.pem", server_side=True)
handler.have_fork = False # to use ssl, fork must not be used
srvobj.serve_forever()
