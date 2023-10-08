import 'package:velocity_x/velocity_x.dart';

import 'CartModel.dart';
import 'dialog.dart';

class MyStore extends VxStore {
  CatalogModel catalog;
  CartModel cart;

  MyStore()
      : catalog = CatalogModel(),
        cart = CartModel(CatalogModel()) {
    // Pass a CatalogModel instance to the CartModel constructor
    cart.catalog = catalog;
  }
}
