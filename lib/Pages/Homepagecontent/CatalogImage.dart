import 'package:flutter/cupertino.dart';
import 'package:velocity_x/velocity_x.dart';

class CatalogImage extends StatelessWidget {
  final String image;

  const CatalogImage({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.network(image)
        .box
        .rounded
        .color(const Color(
          0xFFF0F0F0,
        ))
        .py8
        .make()
        .p16()
        .w40(context);
  }
}
