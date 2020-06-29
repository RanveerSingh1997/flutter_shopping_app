import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/products.dart';
import 'package:shopping_app/screens/edit_product_screen.dart';
import 'package:shopping_app/screens/user_product_item.dart';
import 'package:shopping_app/widgets/app_drawer.dart';

class UserProductScreen extends StatelessWidget {
  static final routName = '/user-product-screen';

  Future<void> _refreshProduct(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: const Text('Your Products'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          )
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshProduct(context),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshProduct(context),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Consumer<Products>(
                        builder: (ctx, productData, _) => ListView.builder(
                            itemCount: productData.items.length,
                            itemBuilder: (_, i) => Column(
                                  children: [
                                    UserProductItem(
                                      id: productData.items[i].id,
                                      title: productData.items[i].title,
                                      imageUrl: productData.items[i].imageUrl,
                                    ),
                                    Divider(
                                      thickness: 1.0,
                                    ),
                                  ],
                                )),
                      ),
                    ),
                  ),
      ),
    );
  }
}
