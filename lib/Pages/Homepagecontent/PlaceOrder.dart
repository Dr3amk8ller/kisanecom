import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:untitled/Pages/firebaseconst.dart';
import 'package:untitled/Pages/theme.dart';
import 'package:velocity_x/velocity_x.dart';
import '../dialog.dart';

class PlaceOrder extends StatefulWidget {
  final num totalValue;
  final List<Item> cartItems;

  PlaceOrder({
    Key? key,
    required this.totalValue,
    required this.cartItems,
  }) : super(key: key);

  @override
  _PlaceOrderState createState() => _PlaceOrderState();
}

String cartItemsToString(List<Item> cartItems) {
  // Assuming 'Item' is a class representing your cart items
  final List<Map<String, dynamic>> cartItemsJson = cartItems.map((item) {
    // Convert each item to a Map
    return {
      'itemName': item.name, // Replace with your actual property names
      'itemPrice': item.price,
      // Add other properties as needed
    };
  }).toList();

  // Encode the list of maps as a JSON string
  final jsonString = json.encode(cartItemsJson);

  return jsonString;
}

class _PlaceOrderState extends State<PlaceOrder> {
  File? paymentScreenshot;

  Future<void> _pickScreenshot() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        paymentScreenshot = File(result.files.first.path!);
      });
    }
  }

  Future<void> _placeOrder() async {
    try {
      if (currentUser?.uid != null) {
        // Create a multipart request
        final request = http.MultipartRequest(
          'POST',
          Uri.parse('http://10.0.2.2:8000/place/order'),
        );
        // Assuming 'user' is the Firebase user object

        String username = currentUser?.uid ?? "";

        // Add text fields (name, email, phone, state, city, address)
        request.fields.addAll({
          'name': nameController.text,
          'email': emailController.text,
          'phone': phoneController.text,
          'state': stateController.text,
          'city': cityController.text,
          'address': addressController.text,
          'total_value': widget.totalValue.toString(),
          // 'cart_items': cartItemsToString(), // Convert cartItems to a string
          //  'cart_items': cartItemsToString(widget.cartItems),
          'cart_items':
              jsonEncode(widget.cartItems), // Convert the list to a JSON array

          'username': username,
        });

        // Add payment screenshot if available
        if (paymentScreenshot != null) {
          request.files.add(http.MultipartFile.fromBytes(
            'payment_screenshot',
            await paymentScreenshot!.readAsBytes(),
            filename: 'payment_screenshot.jpg',
          ));
        }

        final response = await request.send();

        if (response.statusCode == 200) {
          // Handle a successful response here
          final snackBar = SnackBar(content: Text('Order Placed Succesfully'));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else {
          // Handle an unsuccessful response here
          final snackBar = SnackBar(content: Text('Order Placement Failed'));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      }
    } catch (error) {
      // Handle any exceptions that occur during the request
      final snackBar = SnackBar(content: Text('Unknown Error'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  // Define TextEditingController for each TextFormField
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  // Helper function to convert cartItems to a string (customize as needed)

  @override
  void dispose() {
    // Dispose of the controllers when the widget is disposed
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    stateController.dispose();
    cityController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final num deliveryCharge = 40 * widget.cartItems.length;
    final num totalCartValue = (widget.totalValue ?? 0) + deliveryCharge;

    return Scaffold(
      backgroundColor: MyTheme.creamColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Place Order",
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.black
                : Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
            decoration: TextDecoration.underline,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Delivery Charge: \$${deliveryCharge.toStringAsFixed(2)}"),
              Text("Total Cart Value: \$${totalCartValue.toStringAsFixed(2)}"),
              SizedBox(height: 16),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              TextFormField(
                controller: phoneController,
                decoration: InputDecoration(labelText: 'Phone Number'),
              ),
              TextFormField(
                controller: stateController,
                decoration: InputDecoration(labelText: 'State'),
              ),
              TextFormField(
                controller: cityController,
                decoration: InputDecoration(labelText: 'City'),
              ),
              TextFormField(
                controller: addressController,
                decoration: InputDecoration(labelText: 'Address'),
              ),
              SizedBox(height: 16),
              // Button to pick payment screenshot
              ElevatedButton(
                onPressed: _pickScreenshot,
                child: Text('Upload Payment Screenshot'),
              ),
              SizedBox(height: 16),
              // Display selected payment screenshot if available
              Image.asset(
                  'Assests/images/WhatsApp Image 2023-09-27 at 18.53.21.jpeg'),
              SizedBox(height: 16),
              // Add 'Paid' button
              ElevatedButton(
                onPressed: _placeOrder,
                child: Text('Paid'),
              ).centered(),
            ],
          ),
        ),
      ),
    );
  }
}
