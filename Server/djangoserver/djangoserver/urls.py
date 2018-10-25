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

from django.conf.urls import url, include
from django.contrib.auth.models import User
from rest_framework import serializers, viewsets, routers
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework import renderers
from django.utils.decorators import method_decorator
from rest_framework.decorators import api_view, renderer_classes

class PlainTextRenderer(renderers.BaseRenderer):
	media_type = 'text/plain'
	format = 'txt'
			
	def render(self, data, media_type=None, renderer_context=None):
		return data.encode(self.charset)

@api_view(['GET'])
@renderer_classes((PlainTextRenderer,))
def empty_view(request, format=None):
	return Response('')

s1024 = 'A' * 1024
s2048 = 'A' * 2048
s4096 = 'A' * 4096
s8192 = 'A' * 8192

@api_view(['GET'])
@renderer_classes((PlainTextRenderer,))
def s1024_view(request, format=None):
	return Response(s1024)

@api_view(['GET'])
@renderer_classes((PlainTextRenderer,))
def s2048_view(request, format=None):
	return Response(s2048)

@api_view(['GET'])
@renderer_classes((PlainTextRenderer,))
def s4096_view(request, format=None):
	return Response(s4096)

@api_view(['GET'])
@renderer_classes((PlainTextRenderer,))
def s8192_view(request, format=None):
	return Response(s8192)


# Wire up our API using automatic URL routing.
# Additionally, we include login URLs for the browsable API.
urlpatterns = [
			   url(r'^empty', empty_view),
			   url(r'^1024', s1024_view),
			   url(r'^2048', s2048_view),
			   url(r'^4096', s4096_view),
			   url(r'^8192', s8192_view),
#    url(r'^api-auth/', include('rest_framework.urls', namespace='rest_framework'))
]

