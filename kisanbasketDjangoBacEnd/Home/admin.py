# Register your models here.
from django.contrib import admin
from django.contrib.auth.admin import UserAdmin
from django.contrib.auth.models import User

from .models import Content

admin.site.register(Content)


class CustomUserAdmin(UserAdmin):
    list_display = (
        'username', 'email', 'is_staff', 'date_joined', 'password')  # Customize the fields you want to display
    list_filter = ('is_staff',)  # Add a filter for is_staff
    search_fields = ('username',)  # Add a search field for username


# Unregister the default User admin and register with the custom admin class
admin.site.unregister(User)
admin.site.register(User, CustomUserAdmin)
