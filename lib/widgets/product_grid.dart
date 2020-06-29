import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/products.dart';
import 'package:shopping_app/widgets/product_item.dart';

class ProductGrid extends StatelessWidget {
  final bool isFav;
  ProductGrid(this.isFav);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products = isFav?productsData.favouriteItems:productsData.items;
    final width=MediaQuery.of(context).size.width;
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount:(width>1000)?5:(width<340)?1:(width>700)?4:2,
        childAspectRatio: width>600?3/2:1/1,
        crossAxisSpacing: 40.0,
        mainAxisSpacing: 20.0,
      ),
      itemBuilder: (context, index) => ChangeNotifierProvider.value(
        value:products[index],
        child:ProductItem(),
      )
    );
  }
}
