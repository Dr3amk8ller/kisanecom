import 'package:flutter/material.dart';
import 'package:untitled/Pages/store.dart';
import 'package:untitled/Pages/theme.dart';
import 'package:velocity_x/velocity_x.dart';

import 'CartModel.dart';
import 'Homepagecontent/PlaceOrder.dart';

class Cart extends StatelessWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    final isMediumScreen = screenWidth >= 360 && screenWidth < 600;
    final padding = isSmallScreen ? 8.0 : (isMediumScreen ? 16.0 : 24.0);

    return Scaffold(
        backgroundColor: context.canvasColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            "Cart",
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.light
                  ? MyTheme.tale
                  : Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: isSmallScreen ? 20 : (isMediumScreen ? 22 : 24),
              decoration: TextDecoration.underline,
            ),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            _CartList().p(padding).expand(),
            const Divider(height: 1),
            _CartTotal()
          ],
        ));
  }
}

class _CartList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    VxState.watch(context, on: [RemoveMutation, IncrementMutation, DecrementMutation]);
    final CartModel cart = (VxState.store as MyStore).cart;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    final isMediumScreen = screenWidth >= 360 && screenWidth < 600;

    return cart.items.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.shopping_cart_outlined,
                  size: isSmallScreen ? 64 : (isMediumScreen ? 80 : 100),
                  color: Colors.grey,
                ),
                SizedBox(height: isSmallScreen ? 16 : 24),
                Text(
                  "Your cart is empty",
                  style: TextStyle(
                    fontSize: isSmallScreen ? 18 : (isMediumScreen ? 20 : 24),
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Add items to get started",
                  style: TextStyle(
                    fontSize: isSmallScreen ? 14 : 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          )
        : ListView.builder(
            itemCount: cart.items.length,
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              final item = cart.items[index];
              final quantity = cart.getQuantity(item);
              final itemTotal = item.price * quantity;
              
              return Card(
                margin: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 4 : (isMediumScreen ? 6 : 8),
                  vertical: isSmallScreen ? 6 : 8,
                ),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: EdgeInsets.all(isSmallScreen ? 8 : (isMediumScreen ? 12 : 16)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Item name and remove button row
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              item.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: isSmallScreen ? 14 : (isMediumScreen ? 16 : 18),
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.delete_outline,
                              size: isSmallScreen ? 20 : 24,
                            ),
                            onPressed: () {
                              RemoveMutation(item);
                            },
                            color: Colors.red,
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(),
                          ),
                        ],
                      ),
                      SizedBox(height: isSmallScreen ? 6 : 8),
                      // Price per unit
                      Text(
                        "₹${item.price} each",
                        style: TextStyle(
                          fontSize: isSmallScreen ? 12 : 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: isSmallScreen ? 8 : 12),
                      // Quantity controls and total row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Quantity controls
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Theme.of(context).brightness == Brightness.light
                                    ? MyTheme.darkBluishColor
                                    : MyTheme.lightBluishColor,
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Decrement button
                                Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () => DecrementMutation(item),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(8),
                                      bottomLeft: Radius.circular(8),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(isSmallScreen ? 6 : 8),
                                      child: Icon(
                                        Icons.remove,
                                        size: isSmallScreen ? 16 : 18,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ),
                                // Quantity display
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: isSmallScreen ? 8 : 12,
                                    vertical: isSmallScreen ? 4 : 6,
                                  ),
                                  child: Text(
                                    "$quantity",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: isSmallScreen ? 14 : 16,
                                    ),
                                  ),
                                ),
                                // Increment button
                                Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () => IncrementMutation(item),
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(8),
                                      bottomRight: Radius.circular(8),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(isSmallScreen ? 6 : 8),
                                      child: Icon(
                                        Icons.add,
                                        size: isSmallScreen ? 16 : 18,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Item total
                          Text(
                            "₹$itemTotal",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: isSmallScreen ? 16 : (isMediumScreen ? 18 : 20),
                              color: Theme.of(context).brightness == Brightness.light
                                  ? MyTheme.darkBluishColor
                                  : MyTheme.lightBluishColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }
}

class _CartTotal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final CartModel cart = (VxState.store as MyStore).cart;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    final isMediumScreen = screenWidth >= 360 && screenWidth < 600;
    final padding = isSmallScreen ? 12.0 : (isMediumScreen ? 16.0 : 20.0);
    final safeAreaBottom = MediaQuery.of(context).padding.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(
        padding,
        padding,
        padding,
        padding + safeAreaBottom,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Summary section
            VxConsumer(
              builder: (context, store, status) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Total",
                            style: TextStyle(
                              fontSize: isSmallScreen ? 14 : 16,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "₹${cart.totalPrice.toStringAsFixed(2)}",
                            style: TextStyle(
                              fontSize: isSmallScreen ? 20 : (isMediumScreen ? 24 : 28),
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).brightness == Brightness.light
                                  ? MyTheme.darkBluishColor
                                  : MyTheme.lightBluishColor,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "${cart.totalItemCount} item${cart.totalItemCount != 1 ? 's' : ''}",
                            style: TextStyle(
                              fontSize: isSmallScreen ? 12 : 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: isSmallScreen ? 12 : 16),
                    // Place Order button
                    Expanded(
                      flex: isSmallScreen ? 2 : 1,
                      child: ElevatedButton(
                        onPressed: cart.items.isEmpty
                            ? null
                            : () {
                                final CartModel cart = (VxState.store as MyStore).cart;
                                final num totalValue = cart.totalPrice;

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PlaceOrder(
                                      totalValue: totalValue,
                                      cartItems: cart.items,
                                    ),
                                  ),
                                );
                              },
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                            EdgeInsets.symmetric(
                              vertical: isSmallScreen ? 14 : (isMediumScreen ? 16 : 18),
                            ),
                          ),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          backgroundColor: MaterialStateProperty.all(
                            cart.items.isEmpty
                                ? Colors.grey
                                : (Theme.of(context).brightness == Brightness.light
                                    ? MyTheme.darkBluishColor
                                    : MyTheme.lightBluishColor),
                          ),
                          elevation: MaterialStateProperty.all(2),
                        ),
                        child: Text(
                          "Place Order",
                          style: TextStyle(
                            fontSize: isSmallScreen ? 14 : (isMediumScreen ? 16 : 18),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
              mutations: {RemoveMutation, IncrementMutation, DecrementMutation},
            ),
          ],
        ),
      ),
    );
  }
}
