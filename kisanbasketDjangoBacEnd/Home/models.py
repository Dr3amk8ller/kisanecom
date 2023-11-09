from django.db import models
from django.contrib.auth.models import User


# Create your models here.
class Content(models.Model):
    name = models.CharField(max_length=100)
    desc = models.CharField(max_length=100)
    price = models.IntegerField(max_length=100000)
    color = models.CharField(max_length=100, default='#00ac51')
    image = models.ImageField(upload_to='content_images/')


class PlaceOrder(models.Model):
    username = models.ForeignKey(User, on_delete=models.CASCADE)
    name = models.CharField(max_length=255)
    email = models.EmailField()
    phone = models.CharField(max_length=15)
    state = models.CharField(max_length=100)
    city = models.CharField(max_length=100)
    address = models.TextField()
    total_value = models.DecimalField(max_digits=10, decimal_places=2)
    cart_items = models.TextField()
    payment_screenshot = models.ImageField(upload_to='payment_screenshots/', null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.name
