import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopy_maxi/providers/cart.dart';
import 'package:shopy_maxi/providers/products.dart';
import 'package:shopy_maxi/widgets/app_drawer.dart';
import 'package:shopy_maxi/widgets/badge.dart';
import '../widgets/products_grid.dart';

enum FilterItems { favourites, all }

class ProductsOverviewScreen extends StatefulWidget {
  const ProductsOverviewScreen({Key? key}) : super(key: key);

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool isInit = true;
  bool isLoading = false;
  @override
  Future<void> didChangeDependencies() async {
    if (isInit) {
      setState(() {
        isLoading = true;
      });
      await Provider.of<ProductsProvider>(context).fetchProducts();
      setState(() {
        isLoading = false;
      });
      isInit = false;
    }
    super.didChangeDependencies();
  }

  bool _showFavourites = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        centerTitle: true,
        title: const Text('My Shop'),
        actions: [
          PopupMenuButton(
            onSelected: (FilterItems filter) {
              if (filter == FilterItems.favourites) {
                setState(() {
                  _showFavourites = true;
                });
              } else {
                setState(() {
                  _showFavourites = false;
                });
              }
            },
            icon: const Icon(Icons.more_vert),
            itemBuilder: (BuildContext context) {
              return const [
                PopupMenuItem(
                  value: FilterItems.favourites,
                  child: Text('Favourite Only'),
                ),
                PopupMenuItem(
                  value: FilterItems.all,
                  child: Text('All Items'),
                )
              ];
            },
          ),
          Consumer<CartProvider>(
              builder: (BuildContext context, value, Widget? child) {
            return Badge(
              value: value.itemsCount.toString(),
              color: Theme.of(context).colorScheme.secondary,
              child: IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/cartpage');
                  },
                  icon: const Icon(Icons.shopping_cart)),
            );
          }),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(
              showFavs: _showFavourites,
            ),
    );
  }
}
