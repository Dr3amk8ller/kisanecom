from django.urls import path
from .views import ContentListCreateView, ContentDetailView, PlaceOrderView

urlpatterns = [
    path('api/content/', ContentListCreateView.as_view(), name='content-list-create'),
    path('api/content/<int:pk>/', ContentDetailView.as_view(), name='content-detail'),
    path('', ContentListCreateView.as_view()),
    path('order', PlaceOrderView.as_view(), name='place-order'),
]
