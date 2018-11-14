"""djangoserver URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/2.1/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))

from django.contrib import admin
from django.urls import path

urlpatterns = [
    path('admin/', admin.site.urls),
]
"""
import json
from django.conf.urls import url, include
from django.contrib.auth.models import User
from rest_framework import serializers, viewsets, routers
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework import renderers
from django.utils.decorators import method_decorator
from rest_framework.decorators import api_view, renderer_classes
from django.http import JsonResponse

class PlainTextRenderer(renderers.BaseRenderer):
	media_type = 'text/plain'
	format = 'txt'
	def render(self, data, media_type=None, renderer_context=None):
		return data.encode(self.charset)

s2048 = 'A' * 2048
s8192 = 'A' * 8192
s32768 = 'A' * 32768

class CRUDUser:
	id = ""
	firstName = ""
	lastName = ""

@api_view(['GET'])
@renderer_classes((PlainTextRenderer,))
def empty_view(request, format=None):
	return Response('')

@api_view(['GET'])
@renderer_classes((PlainTextRenderer,))
def s2048_view(request, format=None):
	return Response(s2048)

@api_view(['GET'])
@renderer_classes((PlainTextRenderer,))
def s8192_view(request, format=None):
	return Response(s8192)

@api_view(['GET'])
@renderer_classes((PlainTextRenderer,))
def s32768_view(request, format=None):
	return Response(s32768)

# --

def char_range(c1, c2):
	"""Generates the characters from `c1` to `c2`, inclusive."""
	for c in range(ord(c1), ord(c2)+1):
		yield chr(c)

def read(args):
	prefix = 'abc'
	for c in char_range('a', 'z'):
		key = prefix + str(c)
		fetch = args.get(key)

@api_view(['GET'])
@renderer_classes((PlainTextRenderer,))
def getArgs_view(request, format=None):
	read(request.GET)
	return Response(s2048)

@api_view(['POST'])
@renderer_classes((PlainTextRenderer,))
def postArgs_view(request, format=None):
	read(request.POST)
	return Response(s2048)

@api_view(['POST'])
@renderer_classes((PlainTextRenderer,))
def postArgsMulti_view(request, format=None):
	read(request.POST)
	return Response(s2048)

@api_view(['POST'])
@renderer_classes((PlainTextRenderer,))
def json_view(request, format=None):
	new_data = request.body.decode("utf-8", "strict")
	json_data = json.loads(new_data)
	return JsonResponse(json_data)

# Wire up our API using automatic URL routing.
# Additionally, we include login URLs for the browsable API.
urlpatterns = [
			   url(r'^empty', empty_view),
			   url(r'^2048', s2048_view),
			   url(r'^8192', s8192_view),
			   url(r'^32768', s32768_view),
			   
			   url(r'^getArgs2048', getArgs_view),
			   url(r'^postArgs2048', postArgs_view),
			   url(r'^postArgsMulti2048', postArgsMulti_view),
			   url(r'^json', json_view),
#    url(r'^api-auth/', include('rest_framework.urls', namespace='rest_framework'))
]

