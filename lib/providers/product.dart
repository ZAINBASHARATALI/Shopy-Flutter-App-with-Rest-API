import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavourite;
  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavourite = false,
  });

  Future<void> toggleisFavorite() async {
    bool oldFavValue = isFavourite;
    isFavourite = !isFavourite;
    notifyListeners();
    String url =
        'https://shopy-maxis-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json';
    try {
      final response = await http.patch(Uri.parse(url),
          body: json.encode({'isFavourite': isFavourite}));
      if (response.statusCode >= 400) {
        isFavourite = oldFavValue;
        notifyListeners();
      }
    } catch (error) {
      isFavourite = oldFavValue;
      notifyListeners();
    }
  }
}
