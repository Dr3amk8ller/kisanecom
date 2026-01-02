import 'package:flutter/material.dart';
import 'package:untitled/Pages/firebaseconst.dart';
import 'package:untitled/Pages/services/OrderHistoryService.dart';
import 'package:untitled/Pages/models/Order.dart';
import 'package:untitled/Pages/theme.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:intl/intl.dart';

class OrderHistory extends StatefulWidget {
  const OrderHistory({Key? key}) : super(key: key);

  @override
  State<OrderHistory> createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  List<Order> orders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    if (currentUser?.uid != null) {
      final loadedOrders = await OrderHistoryService.getOrders(currentUser!.uid);
      setState(() {
        orders = loadedOrders;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.canvasColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Order History",
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.light
                ? MyTheme.tale
                : Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
            decoration: TextDecoration.underline,
          ),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : currentUser == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.login, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        "Please login to view order history",
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : orders.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.shopping_bag_outlined,
                              size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            "No orders yet",
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Your order history will appear here",
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _loadOrders,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: orders.length,
                        itemBuilder: (context, index) {
                          final order = orders[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            child: ExpansionTile(
                              leading: Icon(Icons.receipt_long,
                                  color: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? MyTheme.darkBluishColor
                                      : MyTheme.lightBluishColor),
                              title: Text(
                                "Order #${order.orderId.substring(0, 8)}",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 4),
                                  Text(
                                    DateFormat('MMM dd, yyyy • hh:mm a')
                                        .format(order.orderDate),
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    "₹${order.finalTotal.toStringAsFixed(2)}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Theme.of(context).brightness ==
                                              Brightness.light
                                          ? MyTheme.darkBluishColor
                                          : MyTheme.lightBluishColor,
                                    ),
                                  ),
                                ],
                              ),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildDetailRow("Name", order.name),
                                      _buildDetailRow("Email", order.email),
                                      _buildDetailRow("Phone", order.phone),
                                      _buildDetailRow("Location",
                                          "${order.city}, ${order.state}"),
                                      _buildDetailRow("Address",
                                          order.address),
                                      const Divider(),
                                      Text("Items:",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16)),
                                      const SizedBox(height: 8),
                                      ...order.items.map((item) => Padding(
                                            padding: const EdgeInsets.only(
                                                left: 16, bottom: 6),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    "• ${item.itemName} x${item.quantity}",
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  "₹${(item.price * item.quantity).toStringAsFixed(2)}",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )),
                                      const Divider(),
                                      _buildDetailRow("Subtotal",
                                          "₹${order.totalValue.toStringAsFixed(2)}"),
                                      _buildDetailRow("Delivery Charge",
                                          "₹${order.deliveryCharge.toStringAsFixed(2)}"),
                                      _buildDetailRow("Total",
                                          "₹${order.finalTotal.toStringAsFixed(2)}",
                                          isBold: true),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: isBold ? 16 : 14,
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                fontSize: isBold ? 16 : 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

