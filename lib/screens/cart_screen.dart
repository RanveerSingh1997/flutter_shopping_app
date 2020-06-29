import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/cart.dart' show Cart;
import 'package:shopping_app/providers/order.dart';
import 'package:shopping_app/widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static final routName = '/cart-screen';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Your Cart'),
      ),
      body: Column(
        children: <Widget>[
          ListView.builder(
              physics: ScrollPhysics(),
              shrinkWrap: true,
              itemCount: cart.items.length,
              itemBuilder: (context, index) {
                return CartItem(
                  productId: cart.items.keys.toList()[index],
                  id: cart.items.values.toList()[index].title,
                  title: cart.items.values.toList()[index].title,
                  price: cart.items.values.toList()[index].price,
                  quantity: cart.items.values.toList()[index].quantity,
                  imageUrl: cart.items.values.toList()[index].imageUrl,
                );
              }),
          Card(
            margin: EdgeInsets.all(10.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Text(
                    'Total: ',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$ ${cart.totalAmount.toString()}',
                    ),
                    backgroundColor: Theme.of(context).accentColor,
                  ),
                  new OrderButton(cart: cart),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  @override
  Widget build(BuildContext context) {
    var _isLoading=false;
    return FlatButton(
      child:_isLoading?CircularProgressIndicator(): Text('Order Now'),
      onPressed:(widget.cart.totalAmount<=0 || _isLoading)?null : () async{
        setState(() {
          _isLoading=true;
        });
       await Provider.of<Orders>(context,listen:false).addOrder(
          widget.cart.items.values.toList(),
          widget.cart.totalAmount,
        );

       setState(() {
         _isLoading=false;
       });
       widget.cart.clear();
      },
    );
  }
}
