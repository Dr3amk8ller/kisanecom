# myapp/views.py
from django.contrib.auth.models import User
from rest_framework import status
from rest_framework.authtoken.models import Token
from django.contrib.auth import authenticate
from rest_framework.response import Response
from rest_framework.views import APIView


# ...

class RegisterUser(APIView):
    def post(self, request):
        # Extract user data from the request
        username = request.data.get('username')
        password = request.data.get('password')

        # Create a new user in Django
        user = User.objects.create_user(username=username, password=password)

        # Create a token for the user
        token, _ = Token.objects.get_or_create(user=user)

        return Response({'token': token.key}, status=status.HTTP_201_CREATED)


class LoginUser(APIView):
    def post(self, request):
        # Extract user data from the request
        username = request.data.get('username')
        password = request.data.get('password')

        # Authenticate the user
        user = authenticate(username=username, password=password)

        if user is not None:
            # If authentication is successful, create a token
            token, _ = Token.objects.get_or_create(user=user)
            return Response({'token': token.key})
        else:
            return Response({'error': 'Authentication failed'}, status=status.HTTP_401_UNAUTHORIZED)
