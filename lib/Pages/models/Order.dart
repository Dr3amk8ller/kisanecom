class Order {
  final String orderId;
  final String userId;
  final String name;
  final String email;
  final String phone;
  final String state;
  final String city;
  final String address;
  final num totalValue;
  final num deliveryCharge;
  final num finalTotal;
  final List<OrderItem> items;
  final DateTime orderDate;
  final String? paymentScreenshotPath;

  Order({
    required this.orderId,
    required this.userId,
    required this.name,
    required this.email,
    required this.phone,
    required this.state,
    required this.city,
    required this.address,
    required this.totalValue,
    required this.deliveryCharge,
    required this.finalTotal,
    required this.items,
    required this.orderDate,
    this.paymentScreenshotPath,
  });

  Map<String, dynamic> toJson() => {
        'orderId': orderId,
        'userId': userId,
        'name': name,
        'email': email,
        'phone': phone,
        'state': state,
        'city': city,
        'address': address,
        'totalValue': totalValue,
        'deliveryCharge': deliveryCharge,
        'finalTotal': finalTotal,
        'items': items.map((item) => item.toJson()).toList(),
        'orderDate': orderDate.toIso8601String(),
        'paymentScreenshotPath': paymentScreenshotPath,
      };

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        orderId: json['orderId'],
        userId: json['userId'],
        name: json['name'],
        email: json['email'],
        phone: json['phone'],
        state: json['state'],
        city: json['city'],
        address: json['address'],
        totalValue: json['totalValue'],
        deliveryCharge: json['deliveryCharge'],
        finalTotal: json['finalTotal'],
        items: (json['items'] as List)
            .map((item) => OrderItem.fromJson(item))
            .toList(),
        orderDate: DateTime.parse(json['orderDate']),
        paymentScreenshotPath: json['paymentScreenshotPath'],
      );
}

class OrderItem {
  final int itemId;
  final String itemName;
  final int price;
  final int quantity;

  OrderItem({
    required this.itemId,
    required this.itemName,
    required this.price,
    required this.quantity,
  });

  Map<String, dynamic> toJson() => {
        'itemId': itemId,
        'itemName': itemName,
        'price': price,
        'quantity': quantity,
      };

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        itemId: json['itemId'],
        itemName: json['itemName'],
        price: json['price'],
        quantity: json['quantity'],
      );
}

