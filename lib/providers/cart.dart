import 'package:flutter/cupertino.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final String imageUrl;
  final double price;

  CartItem({this.id, this.title, this.quantity, this.price, this.imageUrl});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return _items;
  }

  int get item {
    return _items.length;
  }

  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void addItem(String productId, double price, String title, String imageUrl) {
    if (_items.containsKey(productId)) {
      //increase quantity of product
      _items.update(
          productId,
          (existingItem) => CartItem(
              id: existingItem.id,
              title: existingItem.title,
              price: existingItem.price,
              imageUrl: existingItem.imageUrl,
              quantity: existingItem.quantity + 1));
    } else {
      _items.putIfAbsent(
          productId,
          () => CartItem(
              id: DateTime.now().toString(),
              title: title,
              price: price,
              imageUrl: imageUrl,
              quantity: 1));
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void removingSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }

    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (existingProductItem) => CartItem(
              id: existingProductItem.id,
              title: existingProductItem.title,
              quantity: existingProductItem.quantity - 1,
              imageUrl: existingProductItem.imageUrl,
              price: existingProductItem.price,
            ),
      );
    } else {
      _items.remove(productId);
    }

    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }

}
