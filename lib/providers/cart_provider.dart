import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/seafood_models.dart';

class CartItem {
  final SeafoodProduct product;
  final String selectedWeight;
  int quantity;

  CartItem({
    required this.product,
    required this.selectedWeight,
    this.quantity = 1,
  });

  double get totalPrice {
    final multiplier = product.weightMultipliers[selectedWeight] ?? 1.0;
    final unitPrice = product.discountPrice ?? product.price;
    return unitPrice * multiplier * quantity;
  }

  Map<String, dynamic> toJson() => {
        'product': {
          'id': product.id,
          'name': product.name,
          'price': product.price,
          'discountPrice': product.discountPrice,
          'images': product.images,
          'weightMultipliers': product.weightMultipliers,
        },
        'selectedWeight': selectedWeight,
        'quantity': quantity,
      };
}

class CartProvider with ChangeNotifier {
  List<CartItem> _items = [];
  bool _isInitialized = false;

  List<CartItem> get items => _items;

  int get totalItems => _items.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal => _items.fold(0, (sum, item) => sum + item.totalPrice);
  
  double get deliveryFee => subtotal > 100 ? 0 : 5.0;

  double get total => subtotal + deliveryFee;

  CartProvider() {
    _loadCart();
  }

  void addItem(SeafoodProduct product, String weight) {
    final existingIndex = _items.indexWhere(
      (item) => item.product.id == product.id && item.selectedWeight == weight,
    );

    if (existingIndex >= 0) {
      _items[existingIndex].quantity++;
    } else {
      _items.add(CartItem(product: product, selectedWeight: weight));
    }
    _saveCart();
    notifyListeners();
  }

  void removeItem(String productId, String weight) {
    _items.removeWhere(
      (item) => item.product.id == productId && item.selectedWeight == weight,
    );
    _saveCart();
    notifyListeners();
  }

  void updateQuantity(String productId, String weight, int quantity) {
    final index = _items.indexWhere(
      (item) => item.product.id == productId && item.selectedWeight == weight,
    );
    if (index >= 0) {
      if (quantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index].quantity = quantity;
      }
      _saveCart();
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    _saveCart();
    notifyListeners();
  }

  Future<void> _saveCart() async {
    final prefs = await SharedPreferences.getInstance();
    final cartData = _items.map((item) => item.toJson()).toList();
    await prefs.setString('cart', json.encode(cartData));
  }

  Future<void> _loadCart() async {
    if (_isInitialized) return;
    final prefs = await SharedPreferences.getInstance();
    final cartStr = prefs.getString('cart');
    if (cartStr != null) {
      // Note: This is a simplified load. In a real app, 
      // we'd fetch full product data from the API to ensure fresh prices.
      // For MVP, we'll keep it simple.
    }
    _isInitialized = true;
    notifyListeners();
  }
}
