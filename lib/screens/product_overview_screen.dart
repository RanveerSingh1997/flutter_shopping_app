import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/cart.dart';
import 'package:shopping_app/providers/products.dart';
import 'package:shopping_app/screens/cart_screen.dart';
import 'package:shopping_app/widgets/app_drawer.dart';
import 'package:shopping_app/widgets/badge.dart';
import 'package:shopping_app/widgets/product_grid.dart';

enum FilterOptions {
  FavouriteItems,
  AllItems,
}

class ProductOverviewScreen extends StatefulWidget {
  static final routName = '/product-screen';

  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  bool isFavourite = false;
  var isInit=true;
  var isLoading=false;
  @override
  void initState() {
//    Future.delayed(Duration.zero).then((_){
//      Provider.of<Products>(context).fetchAndSetProducts();
//    });
//    // TODO: implement initState
    super.initState();
  }


  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if(isInit) {
      setState(() {
        isLoading=true;
      });
       Provider.of<Products>(context).fetchAndSetProducts().then((_){
        setState(() {
          isLoading=false;
        });
      });
    }
    isInit=false;
    super.didChangeDependencies();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation:0.0,
        centerTitle: true,
        title: Text('Shopping'),
        actions: <Widget>[
          Consumer<Cart>(
            builder: (context, cart, child) => Badge(
                  child: child,
                  value: cart.item.toString(),
                ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                //Navigator.pushNamed(context, CartScreen.routName);
                Navigator.of(context).pushNamed(CartScreen.routName);
              },
            ),
          ),
          PopupMenuButton(
            onSelected: (FilterOptions options) {
              setState(() {
                if (options == FilterOptions.FavouriteItems) {
                  isFavourite = true;
                } else {
                  isFavourite = false;
                }
              });
            },
            itemBuilder: (_) => [
                  PopupMenuItem(
                    child: Text('Favourite Items'),
                    value: FilterOptions.FavouriteItems,
                  ),
                  PopupMenuItem(
                    child: Text('All Items'),
                    value: FilterOptions.AllItems,
                  ),
                ],
          ),
        ],
      ),
      drawer: AppDrawer(),
      body:isLoading?Center(child:CircularProgressIndicator(),): ProductGrid(isFavourite),
    );
  }
}
