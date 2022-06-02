import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopy_maxi/providers/products.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String id = ModalRoute.of(context)!.settings.arguments as String;
    var product = Provider.of<ProductsProvider>(context, listen: false)
        .getProductById(id);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(product.title),
      ),
      body: SizedBox(
          child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width,
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.fitWidth,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text('\$ ${product.price.toString()}',
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w600,
              )),
          const SizedBox(
            height: 10,
          ),
          Text(product.title,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w600,
              )),
        ],
      )),
    );
  }
}
