import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
// import 'package:http/http.dart' as http; // Commented out: Using mock data instead of API
import 'package:untitled/Pages/firebaseconst.dart';
import 'package:untitled/Pages/CartModel.dart';
import 'package:untitled/Pages/store.dart';
import 'package:untitled/Pages/models/Order.dart';
import 'package:untitled/Pages/services/OrderHistoryService.dart';
import 'package:untitled/Pages/routes.dart';
import 'package:uuid/uuid.dart';
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

  // MOCK: Simulate placing order
  Future<void> _placeOrder() async {
    try {
      if (currentUser?.uid != null) {
        // Simulate network delay
        await Future.delayed(const Duration(seconds: 2));
        
        // Get cart to create order items with quantities
        final CartModel cart = (VxState.store as MyStore).cart;
        
        // Create order items from cart
        final List<OrderItem> orderItems = cart.items.map((item) {
          return OrderItem(
            itemId: item.id,
            itemName: item.name,
            price: item.price,
            quantity: cart.getQuantity(item),
          );
        }).toList();
        
        // Calculate delivery charge and final total
        final num deliveryCharge = 40 * cart.totalItemCount;
        final num finalTotal = widget.totalValue + deliveryCharge;
        
        // Create order
        final order = Order(
          orderId: const Uuid().v4(), // Generate unique order ID
          userId: currentUser!.uid,
          name: nameController.text,
          email: emailController.text,
          phone: phoneController.text,
          state: stateController.text,
          city: cityController.text,
          address: addressController.text,
          totalValue: widget.totalValue,
          deliveryCharge: deliveryCharge,
          finalTotal: finalTotal,
          items: orderItems,
          orderDate: DateTime.now(),
          paymentScreenshotPath: paymentScreenshot?.path,
        );
        
        // Save order to local storage
        final saved = await OrderHistoryService.saveOrder(order);
        
        if (saved) {
          print("MOCK: Order saved to local storage");
        } else {
          print("MOCK: Failed to save order to local storage");
        }
        
        // Mock successful order placement
        print("MOCK: Order placed successfully");
        print("Order ID: ${order.orderId}");
        print("Order Details:");
        print("Name: ${nameController.text}");
        print("Email: ${emailController.text}");
        print("Phone: ${phoneController.text}");
        print("State: ${stateController.text}");
        print("City: ${cityController.text}");
        print("Address: ${addressController.text}");
        print("Total Value: ${widget.totalValue}");
        print("Final Total: $finalTotal");
        print("Cart Items: ${orderItems.length} unique items, ${cart.totalItemCount} total items");
        print("Payment Screenshot: ${paymentScreenshot != null ? 'Uploaded' : 'Not uploaded'}");
        
        final snackBar = SnackBar(content: Text('Order Placed Successfully'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        
        // Clear cart after successful order
        ClearCartMutation();
        
        // Navigate to home and clear all routes (no back button)
        Navigator.pushNamedAndRemoveUntil(
          context,
          MyRoutes.HomePage,
          (route) => false, // Remove all previous routes
        );
      }
    } catch (error) {
      final snackBar = SnackBar(content: Text('Unknown Error: $error'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  // COMMENTED OUT: Actual API call to Django backend
  /* Future<void> _placeOrder() async {
    try {
      if (currentUser?.uid != null) {
        final request = http.MultipartRequest(
          'POST',
          Uri.parse('http://10.0.2.2:8000/place/order'),
        );

        String username = currentUser?.uid ?? "";

        request.fields.addAll({
          'name': nameController.text,
          'email': emailController.text,
          'phone': phoneController.text,
          'state': stateController.text,
          'city': cityController.text,
          'address': addressController.text,
          'total_value': widget.totalValue.toString(),
          'cart_items': jsonEncode(widget.cartItems),
          'username': username,
        });

        if (paymentScreenshot != null) {
          request.files.add(http.MultipartFile.fromBytes(
            'payment_screenshot',
            await paymentScreenshot!.readAsBytes(),
            filename: 'payment_screenshot.jpg',
          ));
        }

        final response = await request.send();

        if (response.statusCode == 200) {
          final snackBar = SnackBar(content: Text('Order Placed Successfully'));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else {
          final snackBar = SnackBar(content: Text('Order Placement Failed'));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      }
    } catch (error) {
      final snackBar = SnackBar(content: Text('Unknown Error'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  } */

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
    final CartModel cart = (VxState.store as MyStore).cart;
    final num deliveryCharge = 40 * cart.totalItemCount;
    final num totalCartValue = widget.totalValue + deliveryCharge;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
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
              Text(
                "Delivery Charge: \$${deliveryCharge.toStringAsFixed(2)}",
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Total Cart Value: \$${totalCartValue.toStringAsFixed(2)}",
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
                style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
              ),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
                style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
              ),
              TextFormField(
                controller: phoneController,
                decoration: InputDecoration(labelText: 'Phone Number'),
                style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
              ),
              TextFormField(
                controller: stateController,
                decoration: InputDecoration(labelText: 'State'),
                style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
              ),
              TextFormField(
                controller: cityController,
                decoration: InputDecoration(labelText: 'City'),
                style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
              ),
              TextFormField(
                controller: addressController,
                decoration: InputDecoration(labelText: 'Address'),
                style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
              ),
              SizedBox(height: 16),
              // Button to pick payment screenshot
              ElevatedButton(
                onPressed: _pickScreenshot,
                child: Text('Upload Payment Screenshot'),
              ),
              SizedBox(height: 16),
              // Display selected payment screenshot if available
              paymentScreenshot != null
                  ? Image.file(paymentScreenshot!)
                  : Image.asset(
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
