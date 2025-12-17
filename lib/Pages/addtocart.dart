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
    VxState.watch(context, on: [AddMutation, RemoveMutation]);
    final CartModel _cart = (VxState.store as MyStore).cart;
    bool isInCart = _cart.items.contains(catalog);
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    
    return SizedBox(
      width: isSmallScreen ? 32 : 40,
      height: isSmallScreen ? 32 : 40,
      child: ElevatedButton(
        onPressed: () {
          if (!isInCart) {
            AddMutation(catalog);
          }
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
            ? Icon(Icons.done, size: isSmallScreen ? 16 : 20)
            : Icon(Icons.add_shopping_cart_outlined, size: isSmallScreen ? 16 : 20),
      ),
    );
  }
}
