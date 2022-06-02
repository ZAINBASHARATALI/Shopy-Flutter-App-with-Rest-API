import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopy_maxi/providers/cart.dart';
import 'package:shopy_maxi/providers/product.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var product = Provider.of<Product>(context);
    var cart = Provider.of<CartProvider>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        footer: GridTileBar(
          backgroundColor: Colors.black87.withOpacity(0.7),
          leading: Consumer<Product>(
            builder: (context, value, child) => IconButton(
              // ignore: deprecated_member_use
              color: Colors.deepOrange, //Theme.of(context).accentColor,
              onPressed: () {
                value.toggleisFavorite();
              },
              icon: value.isFavourite
                  ? const Icon(Icons.favorite)
                  : const Icon(Icons.favorite_border),
            ),
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            // ignore: deprecated_member_use
            color: Theme.of(context).accentColor,
            onPressed: () {
              cart.addItem(product.id, product.price, product.title);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                 SnackBar(
                  content: const Text('Item Added to Cart.'),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  action: SnackBarAction(label: 'UNDO', onPressed: ()
                  {
                    cart.removeSingleItem(product.id);
                  },textColor: Colors.redAccent,),
                ),
              );
            },
            icon: const Icon(Icons.shopping_cart),
          ),
        ),
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, '/detailspage', arguments: product.id);
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
