import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopy_maxi/widgets/app_drawer.dart';
import 'package:shopy_maxi/widgets/order_item.dart';

import '../providers/orders.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  bool _isLoading = false;
  @override
  void initState() {
    Future.delayed(const Duration(microseconds: 0)).then((value) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<OrderProvider>(context, listen: false).fetchOrders();
      setState(() {
        _isLoading = false;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<OrderProvider>(context);
    orderData.orders.reversed;
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: orderData.orders.length,
              itemBuilder: (ctx, i) => MyOrderItem(
                orderData.orders[i],
              ),
            ),
    );
  }
}
