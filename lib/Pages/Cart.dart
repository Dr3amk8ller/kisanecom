import 'package:flutter/material.dart';
import 'package:untitled/Pages/dialog.dart';
import 'package:untitled/Pages/routes.dart';
import 'package:untitled/Pages/store.dart';
import 'package:untitled/Pages/theme.dart';
import 'package:velocity_x/velocity_x.dart';

import 'CartModel.dart';
import 'Homepagecontent/PlaceOrder.dart';

class Cart extends StatelessWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: context.canvasColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            "Cart",
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.light
                  ? MyTheme
                      .tale // Assuming you want 'MyTheme.tale' for light theme
                  : Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 24,
              decoration: TextDecoration.underline,
            ),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            _CartList().p32().expand(),
            const Divider(),
            const _CartTotal()
          ],
        ));
  }
}

class _CartList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    VxState.watch(context, on: [RemoveMutation]);
    final CartModel cart = (VxState.store as MyStore).cart;
    return cart.items.isEmpty
        ? "Nothing to show".text.xl3.makeCentered()
        : ListView.builder(
            itemCount: cart.items.length,
            itemBuilder: (context, index) => ListTile(
              leading: const Icon(Icons.done),
              trailing: IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                onPressed: () {
                  RemoveMutation(cart.items[index]);
                },
              ),
              title: cart.items[index].name.text.make(),
            ),
          );
  }
}

class _CartTotal extends StatelessWidget {
  const _CartTotal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CartModel cart = (VxState.store as MyStore).cart;
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
      child: SizedBox(
        height: 200,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            VxConsumer(
                builder: (context, store, status) {
                  return "\$${cart.totalPrice}"
                      .text
                      .xl4
                      .color(context.accentColor)
                      .make();
                },
                mutations: {RemoveMutation}),
            50.widthBox,
            ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all(const StadiumBorder()),
                backgroundColor: MaterialStateProperty.all(
                  (Theme.of(context).brightness == Brightness.light
                      ? MyTheme.darkBluishColor
                      : MyTheme.lightBluishColor),
                ),
              ),
              onPressed: () {
                // Get the cart and total value
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
              child: const Text("Place Order"),
            ),
          ],
        ),
      ),
    );
  }
}
