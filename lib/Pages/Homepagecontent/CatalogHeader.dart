import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled/Pages/theme.dart';
import 'package:velocity_x/velocity_x.dart';

import '../routes.dart';

class CatalogHeader extends StatelessWidget {
  const CatalogHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 20.0), // Add horizontal padding
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              "Kisan Basket"
                  .text
                  .bold
                  .wider
                  .xl4
                  .color(Theme.of(context).brightness == Brightness.light
                      ? MyTheme.tale
                      : Colors.white70)
                  .make(),
              "Top trending Products"
                  .text
                  .xl
                  .color(Theme.of(context).brightness == Brightness.light
                      ? MyTheme.secondaryColorLight
                      : MyTheme.secondaryColorDark)
                  .overline
                  .semiBold
                  .make(),
            ],
          ),
          const Spacer(), // Add a spacer to separate the Column and the button
          FilledButton.icon(
            onPressed: () => logout(context),
            icon: Icon(Icons.logout_sharp),
            label: Text("Logout"),
          ),
        ],
      ),
    );
  }

  void logout(BuildContext context) {
    Navigator.pushNamed(context, MyRoutes.LoginPage);
  }
}
