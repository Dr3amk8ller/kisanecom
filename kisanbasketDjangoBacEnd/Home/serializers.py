from abc import ABC
from urllib.parse import urljoin

from rest_framework import serializers

from Home.models import Content, PlaceOrder
from kisanbasket import settings


class ContentSerializer(serializers.ModelSerializer):
    class Meta:
        model = Content
        fields = '__all__'


def to_representation(self, instance):
    data = super().to_representation(instance)

    # Construct the image URL by joining MEDIA_URL and instance.image.url
    media_url = settings.MEDIA_URL.rstrip('/')
    image_url = instance.image.url

    # Check if the image URL already starts with a slash
    if not image_url.startswith('/'):
        image_url = '/' + image_url

    full_image_url = urljoin(media_url, image_url)

    data['image'] = full_image_url
    return data


class PlaceOrderSerializer(serializers.Serializer):
    name = serializers.CharField()
    email = serializers.EmailField()
    phone = serializers.CharField()
    state = serializers.CharField()
    city = serializers.CharField()
    address = serializers.CharField()
    total_value = serializers.DecimalField(max_digits=10, decimal_places=2)
    cart_items = serializers.JSONField()  # Assuming cart_items is a JSON field
