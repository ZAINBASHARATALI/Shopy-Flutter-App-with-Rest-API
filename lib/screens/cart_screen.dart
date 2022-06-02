import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopy_maxi/providers/cart.dart';
import 'package:shopy_maxi/providers/orders.dart';
// ignore: library_prefixes
import 'package:shopy_maxi/widgets/cartitem.dart' as CARTITEM;

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Your Cart'),
      ),
      body: Column(
        children: [
          Card(
            elevation: 3,
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'TOTAL',
                    style: TextStyle(
                      letterSpacing: 1.2,
                      color: Colors.black,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Chip(
                    label: Text(
                      '\$ ${cartProvider.totalAmount.toStringAsFixed(2)}',
                      style: const TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    backgroundColor: Colors.purple,
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  OrderNowButton(
                    cartProvider: cartProvider,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: cartProvider.itemsCount,
                itemBuilder: ((context, index) {
                  return CARTITEM.CartItem(
                    id: cartProvider.items.values.toList()[index].id,
                    price: cartProvider.items.values.toList()[index].price,
                    productId: cartProvider.items.keys.toList()[index],
                    quantity:
                        cartProvider.items.values.toList()[index].quantity,
                    title: cartProvider.items.values.toList()[index].title,
                  );
                })),
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class OrderNowButton extends StatefulWidget {
  OrderNowButton({Key? key, required this.cartProvider}) : super(key: key);
  CartProvider cartProvider;
  @override
  State<OrderNowButton> createState() => _OrderNowButtonState();
}

class _OrderNowButtonState extends State<OrderNowButton> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: (isLoading || widget.cartProvider.totalAmount <= 0)
          ? null
          : () {
              setState(() {
                isLoading = true;
              });
              Provider.of<OrderProvider>(context, listen: false).addOrder(
                widget.cartProvider.items.values.toList(),
                widget.cartProvider.totalAmount,
              );
              widget.cartProvider.clear();
              Navigator.pushNamed(context, '/orderpage');
            },
      child: isLoading
          ? const CircularProgressIndicator()
          :  widget.cartProvider.totalAmount>0? const Text(
              'ORDER NOW',
              style: TextStyle(
                color: Colors.purple,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ): const Text(
              'ORDER NOW',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
    );
  }
}
