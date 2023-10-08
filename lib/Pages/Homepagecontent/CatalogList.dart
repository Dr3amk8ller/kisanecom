import 'package:flutter/material.dart';
import 'package:untitled/Pages/addtocart.dart';
import 'package:velocity_x/velocity_x.dart';

import '../dialog.dart';
import '../theme.dart';
import 'CatalogImage.dart';

class CatalogList extends StatelessWidget {
  const CatalogList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: CatalogModel.items.length,
      itemBuilder: (context, index) {
        final catalog = CatalogModel.items[index];
        return CatalogItem(
          catalog: catalog,
        );
      },
    );
  }
}

class CatalogItem extends StatelessWidget {
  final Item catalog;

  CatalogItem({Key? key, required this.catalog}) : super(key: key);

  final ButtonStyle customButtonStyle = ElevatedButton.styleFrom(
    shape: const StadiumBorder(),
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: VxBox(
        child: Row(
          children: [
            CatalogImage(image: catalog.image),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                      child: Column(
                        children: [
                          catalog.name.text.bold.lg
                              .color(context.accentColor)
                              .make(),
                          catalog.desc.text
                              .textStyle(context.captionStyle)
                              .make(),
                          10.heightBox,
                        ],
                      ),
                    ),
                    ButtonBar(
                      alignment: MainAxisAlignment.spaceBetween,
                      buttonPadding: EdgeInsets.zero,
                      children: [
                        "\₹${catalog.price}".text.bold.xl.make(),
                        AddToCart(catalog: catalog),
                      ],
                    ).pOnly(right: 8)
                  ],
                ),
              ),
            )
          ],
        ),
      ).color(context.cardColor).rounded.square(150).make(),
    );
  }
}
