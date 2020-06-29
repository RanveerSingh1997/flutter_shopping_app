Thimport 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final String imageUrl;
  final String title;
  final double price;
  final int quantity;

  CartItem({this.productId,this.id,this.imageUrl,this.title,this.price,this.quantity});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key:ValueKey(id),
      direction:DismissDirection.endToStart,
      confirmDismiss:(direction){
        return showDialog(
          context:context,
          builder:(ctx)=>AlertDialog(
            title:Text('Are You Sure ?'),
            content:Text('Do You Want to remove The Item from Cart'),
            actions: <Widget>[
              FlatButton(
                child:Text('No'),
                onPressed:(){
                  Navigator.of(context).pop(false);
                },
              ),
              FlatButton(
                color:Theme.of(context).accentColor,
                child:Text('Yes'),
                onPressed:(){
                      Navigator.of(context).pop(true);
                },
              ),
            ],
          )
        );
      },
      onDismissed:(direction){
        Provider.of<Cart>(context,listen:false).removeItem(productId);
      },
      background:Container(
        margin:EdgeInsets.all(8.0),
        padding:EdgeInsets.only(right:20.0),
        color:Theme.of(context).errorColor,
        child:Icon(Icons.delete,
          color:Colors.white,
          size:40.0,
        ),
          alignment:Alignment.centerRight,
        ),
      child: Card(
        margin:EdgeInsets.all(10.0),
        child: ListTile(
          leading:CircleAvatar(
            backgroundImage:NetworkImage(imageUrl),
          ),
          title:Text(title),
          subtitle:Text(price.toStringAsFixed(2).toString(),softWrap:true,overflow:TextOverflow.clip),
          trailing:Text( '${quantity.toString()} x' ),
        ),
      ),
    );
  }
}
