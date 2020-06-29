import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/order.dart' as ord;

class OrderItemLayout extends StatefulWidget {
  final ord.OrderItem order;

  OrderItemLayout({this.order});

  @override
  _OrderItemLayoutState createState() => _OrderItemLayoutState();
}

class _OrderItemLayoutState extends State<OrderItemLayout> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('\$${widget.order.amount.toString()}'),
            subtitle: Text(
                DateFormat('dd/MM yyyy hh:mm').format(widget.order.dateTime)),
            trailing: IconButton(
              icon: Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
            ),
          ),
          _isExpanded == true
              ? Container(
                  width: double.infinity,
                  height: min(widget.order.products.length * 50 + 10.0, 100.0),
                  child: ListView(
                    children: widget.order.products
                        .map((prod) =>Padding(padding:EdgeInsets.all(10.0),child:Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          prod.title,
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold),
                        ),

                        Text(
                          '${prod.quantity}x ' + ' \$${prod.price}',
                          style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),))
                        .toList(),
                  ),
                )
              : SizedBox(
                  height: 0.0,
                  width: double.infinity,
                ),
        ],
      ),
    );
  }
}
