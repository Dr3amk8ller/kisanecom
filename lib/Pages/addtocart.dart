import 'package:flutter/material.dart';
import 'package:untitled/Pages/store.dart';
import 'package:untitled/Pages/theme.dart';

import 'package:velocity_x/velocity_x.dart';

import 'CartModel.dart';
import 'dialog.dart';

class AddToCart extends StatelessWidget {
  final Item catalog;

  const AddToCart({
    Key? key,
    required this.catalog,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    VxState.watch(context, on: [AddMutation, IncrementMutation]);
    final CartModel _cart = (VxState.store as MyStore).cart;
    final quantity = _cart.getQuantity(catalog);
    final isInCart = quantity > 0;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    
    return SizedBox(
      width: isSmallScreen ? 32 : 40,
      height: isSmallScreen ? 32 : 40,
      child: ElevatedButton(
        onPressed: () {
          // Always allow adding - will increment if already in cart
          AddMutation(catalog);
        },
        style: ButtonStyle(
            padding: WidgetStateProperty.all(EdgeInsets.zero),
            backgroundColor: WidgetStateProperty.all(
              (Theme.of(context).brightness == Brightness.light
                  ? MyTheme.darkBluishColor
                  : MyTheme.lightBluishColor),
            ),
            shape: WidgetStateProperty.all(
              const StadiumBorder(),
            )),
        child: isInCart 
            ? Stack(
                alignment: Alignment.center,
                children: [
                  Icon(Icons.done, size: isSmallScreen ? 16 : 20),
                  if (quantity > 1)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        constraints: BoxConstraints(
                          minWidth: isSmallScreen ? 10 : 12,
                          minHeight: isSmallScreen ? 10 : 12,
                        ),
                        child: Text(
                          "$quantity",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isSmallScreen ? 8 : 9,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              )
            : Icon(Icons.add_shopping_cart_outlined, size: isSmallScreen ? 16 : 20),
      ),
    );
  }
}
