import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shopy_maxi/models/http_exception.dart';
import 'package:shopy_maxi/providers/product.dart';
import 'package:http/http.dart' as http;

class ProductsProvider with ChangeNotifier {
  final _url =
      'https://shopy-maxis-default-rtdb.asia-southeast1.firebasedatabase.app/products.json';

  // ignore: prefer_final_fields
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://cdn.shopify.com/s/files/1/0245/6845/products/Besos_December0055_1024x1024.jpg?v=1421333490',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  List<Product> get getfavouritesOnly {
    return _items.where((element) => element.isFavourite).toList();
  }

  int get itemsLength {
    return _items.length;
  }

  List<Product> get getAll {
    return [..._items];
  }

  Product getProductById(id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> updateProduct(String id, Product product) async {
    final index = _items.indexWhere((element) => element.id == id);
    String patchUrl =
        'https://shopy-maxis-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json';
    try {
      await http.patch(Uri.parse(patchUrl),
          body: json.encode({
            'title': product.title,
            'price': product.price,
            'description': product.description,
            'imageUrl': product.imageUrl,
          }));
    } catch (error) {
      rethrow;
    }
    _items[index] = product;
    notifyListeners();
  }

  Future<void> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse(_url));
      final loadedProducts = json.decode(response.body) as Map<String, dynamic>;
      if(loadedProducts.isEmpty)
      {
        return;
      }
      List<Product> loadedP = [];
      loadedProducts.forEach(
        (productID, lProduct) {
          Product product = Product(
            id: productID,
            title: lProduct['title'],
            description: lProduct['description'],
            price: lProduct['price'],
            imageUrl: lProduct['imageUrl'],
            isFavourite: lProduct['isFavourite']
          );
          loadedP.add(product);
        },
      );
      _items = loadedP;
      notifyListeners();
      // debugPrint(json.decode(response.body).toString());
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addProduct(Product item) async {
    try {
      final response = await http.post(
        Uri.parse(_url),
        body: json.encode(
          {
            'title': item.title,
            'price': item.price,
            'description': item.description,
            'imageUrl': item.imageUrl,
            'isFavourite': item.isFavourite,
          },
        ),
      );
      Product prod = Product(
        id: json.decode(response.body)['name'],
        title: item.title,
        price: item.price,
        description: item.description,
        imageUrl: item.imageUrl,
      );
      _items.add(prod);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> removeProduct(String id) async {
    String deleteUrl =
        'https://shopy-maxis-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json';
    final index = _items.indexWhere((element) => element.id == id);
    Product? deletedProduct = _items[index];
    _items.removeAt(index);
    notifyListeners();
    final response = await http.delete(Uri.parse(deleteUrl));
    if (response.statusCode >= 400) {
      _items.insert(index, deletedProduct);
      notifyListeners();
      throw HttpException('Could not Delete Product');
    }
    deletedProduct = null;
  }
}
