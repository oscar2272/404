from django.shortcuts import render
from django.conf import settings
import os, json, psycopg2

#
def example_view(request):
    return render(request, 'question/example.html')


