import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/order.dart';
import 'package:shopping_app/widgets/app_drawer.dart';
import 'package:shopping_app/widgets/order_item.dart';

class OrderScreen extends StatelessWidget {
  static final routName = '/order-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation:0.0,
        centerTitle:true,
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
          future: Provider.of<Orders>(context,listen: false).fetchAndSetOrders(),
          builder: (ctx, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }else if(dataSnapshot.error !=null){
                 return Center(child: Text('No Data is There'));
            }else{
              return Consumer<Orders>(
                builder:(ctx,orderData,child)=> ListView.builder(
                itemCount: orderData.orders.length,
                itemBuilder: (context, index) =>OrderItemLayout(order:orderData.orders[index],),
              ),
              );
            }
          }),
    );
  }
}
