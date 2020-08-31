import os

from waitress import serve
from pyramid.config import Configurator
from pyramid.response import Response
import redis

r = redis.Redis(host=os.getenv("REDIS_HOSTNAME"))
r.set("mykey", "0")

def hello_world(request):
    print('Incoming request')
    return Response('<body><h1>Hello World! %s</h1></body>' % r.incr("mykey"))


if __name__ == '__main__':
    with Configurator() as config:
        config.add_route('hello', '/')
        config.add_view(hello_world, route_name='hello')
        app = config.make_wsgi_app()
    serve(app, host='0.0.0.0', port=6543)
