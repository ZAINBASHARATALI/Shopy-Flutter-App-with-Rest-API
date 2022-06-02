import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopy_maxi/providers/products.dart';

// ignore: must_be_immutable
class UserProductItem extends StatelessWidget {
  UserProductItem({
    Key? key,
    required this.id,
    required this.title,
    required this.imageUrl,
  }) : super(key: key);
  String title;
  String id;
  String imageUrl;
  @override
  Widget build(BuildContext context) {
    final scfmsngr = ScaffoldMessenger.of(context);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed('/editproductscreen', arguments: id);
              },
              icon: const Icon(
                Icons.edit,
                color: Colors.black,
              ),
            ),
            IconButton(
              onPressed: () async {
                try {
                  await Provider.of<ProductsProvider>(context, listen: false)
                      .removeProduct(id);
                } catch (error) {
                  scfmsngr.showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Could not Delete Product 😢',
                        textAlign: TextAlign.center,
                      ),
                      duration: Duration(milliseconds: 1000),
                    ),
                  );
                }
              },
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
