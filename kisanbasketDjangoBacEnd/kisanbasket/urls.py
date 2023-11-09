from django.contrib import admin
from django.urls import path, include
from django.conf import settings
from django.conf.urls.static import static  # Import the 'static' function

from kisanbasket import views

urlpatterns = [
    path('admin/', admin.site.urls),
    path('', include('Home.urls')),
    path('api/register/', views.RegisterUser.as_view(), name='register'),
    path('login', views.LoginUser.as_view(), name='login'),
    path('place/', include('Home.urls'))
]

# Conditionally include the 'static' URL patterns when DEBUG is True
if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
