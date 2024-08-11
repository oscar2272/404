"""
Django admin customization.
"""
from django.contrib import admin
from django.contrib.auth.admin import UserAdmin as BaseUserAdmin
<<<<<<< Updated upstream

from core import models

class UserAdmin(BaseUserAdmin):
    """Define the admin pages for the custom user model."""
    ordering = ['id']
    list_display = ['email', 'name']

admin.site.register(models.User, UserAdmin)
=======
from . import models

class UserAdmin(BaseUserAdmin):
    """Define the admin pages for the custom user model."""
    ordering = ['id']
    list_display = ['email', 'nickname']

admin.site.register(models.User, UserAdmin)

>>>>>>> Stashed changes
