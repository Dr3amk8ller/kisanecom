from django.shortcuts import render

# Create your views here.
from rest_framework import generics, status
from rest_framework.parsers import MultiPartParser
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework.authentication import SessionAuthentication
from rest_framework.permissions import IsAuthenticated
import logging
from .models import Content, PlaceOrder
from .serializers import ContentSerializer, PlaceOrderSerializer

logger = logging.getLogger(__name__)


class ContentListCreateView(generics.ListCreateAPIView):
    queryset = Content.objects.all()
    serializer_class = ContentSerializer
    parser_classes = [MultiPartParser]


class ContentDetailView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Content.objects.all()
    serializer_class = ContentSerializer
    parser_classes = [MultiPartParser]


class PlaceOrderView(APIView):
    def post(self, request):
        print(request)
        logger.info("Received POST request data: {request.data}")
        serializer = PlaceOrderSerializer(data=request.data)
        if serializer.is_valid():
            try:
                # Create the order without checking authentication
                order = PlaceOrder.objects.create(
                    name=serializer.validated_data['name'],
                    email=serializer.validated_data['email'],
                    phone=serializer.validated_data['phone'],
                    state=serializer.validated_data['state'],
                    city=serializer.validated_data['city'],
                    address=serializer.validated_data['address'],
                    total_value=serializer.validated_data['total_value'],
                    cart_items=serializer.validated_data['cart_items'],
                )
                # You can set other order details here
                order.save()
                return Response({'message': 'Order placed successfully'}, status=status.HTTP_201_CREATED)
            except Exception as e:
                logger.error(f"Error processing order request: {str(e)}")
                return Response({'message': 'Error processing order request'},
                                status=status.HTTP_500_INTERNAL_SERVER_ERROR)
        else:
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
