import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/auth.dart';
import 'package:shopping_app/screens/order_screen.dart';
import 'package:shopping_app/screens/product_overview_screen.dart';
import 'package:shopping_app/screens/user_product_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0.0,
      child: Column(
        children: <Widget>[
          AppBar(
            elevation: 0.0,
            leading: IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            bottomOpacity: 0.4,
            automaticallyImplyLeading: true,
            backgroundColor: Theme.of(context).primaryColor,
          ),

          ListTile(
            leading: Icon(Icons.shop),
            title: Text('Shop'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(ProductOverviewScreen.routName);
            },
          ),
          Divider(thickness:1.0,),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Orders'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(OrderScreen.routName);
            },
          ),
          Divider(thickness:1.0,),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Manage Products'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(UserProductScreen.routName);
            },
          ),
          Divider(thickness:1.0,),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () {
              Navigator.of(context).pop();
              Provider.of<Auth>(context,listen:false).logout();
            },
          ),
        ],
      ),
    );
  }
}
