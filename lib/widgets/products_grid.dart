import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopy_maxi/providers/product.dart';
import 'package:shopy_maxi/providers/products.dart';

import 'product_item.dart';

class ProductsGrid extends StatelessWidget {
  const ProductsGrid({
    required this.showFavs,
    Key? key,
  }) : super(key: key);
  final bool showFavs;
  @override
  Widget build(BuildContext context) {
    var productProvider = Provider.of<ProductsProvider>(context);
    final productItems =
        showFavs ? productProvider.getfavouritesOnly : productProvider.getAll;
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 3 / 2,
        crossAxisCount: 2,
      ),
      itemBuilder: (context, index) {
        return ChangeNotifierProvider.value(
          value: productItems[index],
          child: const ProductItem(),
        );
      },
      itemCount: productItems.length,
      padding: const EdgeInsets.all(10),
    );
  }
}
