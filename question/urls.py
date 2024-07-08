from django.urls import path
from . import views

urlpatterns = [
    path('', views.example_view, name='exampl_view'),  # 기본 URL
    #path('read-json/', views.read_json, name='read_json'),
]

