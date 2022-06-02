import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopy_maxi/providers/products.dart';
import 'package:shopy_maxi/widgets/app_drawer.dart';
import 'package:shopy_maxi/widgets/user_product_item.dart';

class UserProductsScreen extends StatelessWidget {
  const UserProductsScreen({Key? key}) : super(key: key);

Future<void> _refreshProducts(BuildContext context) async
{
  await Provider.of<ProductsProvider>(context,listen: false).fetchProducts();
}
  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<ProductsProvider>(context);
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Your Product'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/editproductscreen');
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: ()=>_refreshProducts(context),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView.builder(
              itemCount: productData.itemsLength,
              itemBuilder: ((context, index) {
                return Column(
                  children: [
                    UserProductItem(
                      id: productData.getAll[index].id,
                      title: productData.getAll[index].title,
                      imageUrl: productData.getAll[index].imageUrl,
                    ),
                    const Divider()
                  ],
                );
              })),
        ),
      ),
    );
  }
}
