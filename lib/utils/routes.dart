
import 'package:flutter/cupertino.dart';
import 'package:shopy_maxi/screens/cart_screen.dart';
import 'package:shopy_maxi/screens/edit_product_screen.dart';
import 'package:shopy_maxi/screens/orders_screen.dart';
import 'package:shopy_maxi/screens/product_details_screen.dart';
import 'package:shopy_maxi/screens/products_overview.dart';
import 'package:shopy_maxi/screens/user_products_screen.dart';

class RoutingPages {
  static Map<String, Widget Function(BuildContext)> routes = {
    '/': (context) => const ProductsOverviewScreen(),
    '/detailspage': (context) => const ProductDetailsScreen(),
    '/cartpage': (context) => const CartScreen(),
    '/orderpage': (context) => const OrdersScreen(),
    '/userproductspage': (context) => const UserProductsScreen(),
    '/editproductscreen': (context) => const EditProductScreen(),
  };
}
