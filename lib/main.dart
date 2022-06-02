import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopy_maxi/providers/cart.dart';
import 'package:shopy_maxi/providers/orders.dart';
import 'package:shopy_maxi/providers/products.dart';
import 'package:shopy_maxi/utils/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProductsProvider()),
        ChangeNotifierProvider(create: (context) => CartProvider()),
        ChangeNotifierProvider(create: (create) => OrderProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: RoutingPages.routes,
        theme: ThemeData(
            fontFamily: 'Lato',
            primarySwatch: Colors.pink,
            // ignore: deprecated_member_use
            accentColor: Colors.deepOrange),
        //home: const ProductsOverviewScreen(),
      ),
    );
  }
}
