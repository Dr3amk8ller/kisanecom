import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/Order.dart';

class OrderHistoryService {
  static const String _ordersKeyPrefix = 'orders_';

  // Get storage key for a specific user
  static String _getUserOrdersKey(String userId) {
    return '$_ordersKeyPrefix$userId';
  }

  // Save order to local storage
  static Future<bool> saveOrder(Order order) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userKey = _getUserOrdersKey(order.userId);
      
      // Get existing orders
      final existingOrdersJson = prefs.getString(userKey);
      List<Order> orders = [];
      
      if (existingOrdersJson != null) {
        final List<dynamic> ordersList = json.decode(existingOrdersJson);
        orders = ordersList.map((json) => Order.fromJson(json)).toList();
      }
      
      // Add new order
      orders.add(order);
      
      // Save back to storage
      final ordersJson = json.encode(
        orders.map((order) => order.toJson()).toList(),
      );
      
      return await prefs.setString(userKey, ordersJson);
    } catch (e) {
      print('Error saving order: $e');
      return false;
    }
  }

  // Get all orders for a user
  static Future<List<Order>> getOrders(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userKey = _getUserOrdersKey(userId);
      
      final ordersJson = prefs.getString(userKey);
      
      if (ordersJson == null) {
        return [];
      }
      
      final List<dynamic> ordersList = json.decode(ordersJson);
      return ordersList.map((json) => Order.fromJson(json)).toList()
        ..sort((a, b) => b.orderDate.compareTo(a.orderDate)); // Sort by date (newest first)
    } catch (e) {
      print('Error loading orders: $e');
      return [];
    }
  }

  // Clear all orders for a user (optional - for testing)
  static Future<bool> clearOrders(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userKey = _getUserOrdersKey(userId);
      return await prefs.remove(userKey);
    } catch (e) {
      print('Error clearing orders: $e');
      return false;
    }
  }
}

