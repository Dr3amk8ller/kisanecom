import 'package:flutter/cupertino.dart';
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
    bool isInCart = _cart.items.contains(catalog) ?? false;
    return ElevatedButton(
      onPressed: () {
        if (!isInCart) {
          AddMutation(catalog);
        }
      },
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            (Theme.of(context).brightness == Brightness.light
                ? MyTheme.darkBluishColor
                : MyTheme.lightBluishColor),
          ),
          shape: MaterialStateProperty.all(
            StadiumBorder(),
          )),
      child:
          isInCart ? Icon(Icons.done) : Icon(Icons.add_shopping_cart_outlined),
    );
  }
}
