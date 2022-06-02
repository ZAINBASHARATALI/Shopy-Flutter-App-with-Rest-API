import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/orders.dart' as ord;

class MyOrderItem extends StatefulWidget {
  final ord.OrderItem order;

  // ignore: use_key_in_widget_constructors
  const  MyOrderItem(this.order);

  @override
  State<MyOrderItem> createState() => _MyOrderItemState();
}
bool expand = false;
class _MyOrderItemState extends State<MyOrderItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('\$${widget.order.amount}',style: const TextStyle(fontSize: 20),),
            subtitle: Text(
              DateFormat('dd-MM-yyyy   hh:mm').format(widget.order.dateTime),
            ),
            trailing: IconButton(
              icon:  Icon(!expand ? Icons.expand_more : Icons.expand_less),
              onPressed: () {
                setState(() {
                  
                });
                expand = !expand;
              },
            ),
          ),
          if(expand)
            SizedBox(
              height: min(widget.order.products.length+70,180),
              child: ListView(
                children: widget.order.products.map((e){
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 1,horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(e.title),
                        Text('${e.quantity} x'),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          
        ],
      ),
    );
  }
}
