"""
Django admin customization.
"""
from django.contrib import admin
from django.contrib.auth.admin import UserAdmin as BaseUserAdmin
from . import models



admin.site.register(models.User)
admin.site.register(models.Bookmark)