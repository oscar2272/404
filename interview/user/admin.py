"""
Django admin customization.
"""
from django.contrib import admin
from django.contrib.auth.admin import UserAdmin as BaseUserAdmin
from . import models

class UserAdmin(BaseUserAdmin):
    """Define the admin pages for the custom user model."""
    ordering = ['id']
    list_display = ['email', 'nickname']

admin.site.register(models.User, UserAdmin)
