import 'package:untitled/Pages/store.dart';
import 'package:velocity_x/velocity_x.dart';

import 'dialog.dart';

class CartModel {
  // catalog field
  CatalogModel _catalog;

  CartModel(this._catalog);

  // Map of item ID to quantity - store quantities of each item
  final Map<int, int> _itemQuantities = {};

  // Get Catalog
  CatalogModel get catalog => _catalog;

  set catalog(CatalogModel newCatalog) {
    _catalog = newCatalog;
  }

  // Get items in the cart (unique items)
  List<Item> get items => _itemQuantities.keys.map((id) => _catalog.getById(id)).toList();

  // Get quantity of a specific item
  int getQuantity(Item item) => _itemQuantities[item.id] ?? 0;

  // Get total number of items (sum of all quantities)
  int get totalItemCount => _itemQuantities.values.fold(0, (sum, qty) => sum + qty);

  // Get total price (considering quantities)
  num get totalPrice => _itemQuantities.entries.fold(
      0,
      (total, entry) => total + (_catalog.getById(entry.key).price * entry.value));

  // Clear all items from cart
  void clear() {
    _itemQuantities.clear();
  }
}

class AddMutation extends VxMutation<MyStore> {
  final Item item;

  AddMutation(this.item);

  @override
  perform() {
    final cart = store?.cart;
    if (cart != null) {
      cart._itemQuantities[item.id] = (cart._itemQuantities[item.id] ?? 0) + 1;
    }
  }
}

class RemoveMutation extends VxMutation<MyStore> {
  final Item item;

  RemoveMutation(this.item);

  @override
  perform() {
    final cart = store?.cart;
    if (cart != null) {
      cart._itemQuantities.remove(item.id);
    }
  }
}

class IncrementMutation extends VxMutation<MyStore> {
  final Item item;

  IncrementMutation(this.item);

  @override
  perform() {
    final cart = store?.cart;
    if (cart != null) {
      cart._itemQuantities[item.id] = (cart._itemQuantities[item.id] ?? 0) + 1;
    }
  }
}

class DecrementMutation extends VxMutation<MyStore> {
  final Item item;

  DecrementMutation(this.item);

  @override
  perform() {
    final cart = store?.cart;
    if (cart != null) {
      final currentQty = cart._itemQuantities[item.id] ?? 0;
      if (currentQty > 1) {
        cart._itemQuantities[item.id] = currentQty - 1;
      } else {
        // Remove item if quantity becomes 0
        cart._itemQuantities.remove(item.id);
      }
    }
  }
}

class ClearCartMutation extends VxMutation<MyStore> {
  @override
  perform() {
    store?.cart.clear();
  }
}
