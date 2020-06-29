import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_app/models/httpException.dart';
import 'package:shopping_app/providers/product.dart';

class Products with ChangeNotifier {
  String authToken;
  String userId;
  List<Product> _items = [];

  List<Product> get items {
    return UnmodifiableListView(_items);
  }

  List<Product> get favouriteItems {
    return UnmodifiableListView(_items.where((prod) => prod.isFavourite))
        .toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Products(this.authToken,this._items,this.userId);

  Future<void> fetchAndSetProducts([bool filterByUser=false]) async{
    final filterString=filterByUser?'orderBy="creatorId"&equalTo="$userId"':'';
       var url = 'https://web-site-57e95.firebaseio.com/products.json?auth=$authToken&$filterString';
    try{
       final response=await http.get(url);
       final extractData=json.decode(response.body) as Map<String,dynamic>;
       if(extractData ==null){
         return ;
       }
       url = 'https://web-site-57e95.firebaseio.com/userFavorites/$userId.json?auth=$authToken';
       final favoriteResponse=await http.get(url);
       final favoriteData=json.decode(favoriteResponse.body);
       final List<Product> loadedProducts=[];
       extractData.forEach((prodId,prodData){
           loadedProducts.add(Product(
             id:prodId,
             title:prodData['title'],
             description:prodData['description'],
             price:prodData['price'],
             imageUrl:prodData['imageUrl'],
             isFavourite:favoriteData==null? false: favoriteData[prodId] ?? false,
           ));
       });
       _items=loadedProducts;
    }catch(error){
    }

  }

  Future<void> addProduct(Product product) async {
    final url = 'https://web-site-57e95.firebaseio.com/products.json?auth=$authToken';
    try{
    final response= await http.post(url,
            body: jsonEncode({
              'title': product.title,
              'description': product.description,
              'imageUrl': product.imageUrl,
              'price': product.price,
              'creatorId':userId
            }));

    final newProduct = Product(
          id:json.decode(response.body)['name'],
          title: product.title,
          price: product.price,
          description: product.description,
          imageUrl: product.imageUrl,
    );
      _items.add(newProduct);
      notifyListeners();
    }catch(error){
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async{
    final productIndex = _items.indexWhere((prod) => prod.id == id);
    if (productIndex >= 0) {
      final url = 'https://web-site-57e95.firebaseio.com/products/$id.json?auth=$authToken';
      await http.patch(url,body:jsonEncode({
        'title':newProduct.title,
        'description':newProduct.description,
        'price':newProduct.price,
        'imageUrl':newProduct.imageUrl
      }));

      _items[productIndex] = newProduct;
      notifyListeners();
    }
  }

  Future<void> deleteItem(String id) async{
    final url = 'https://web-site-57e95.firebaseio.com/products/$id.json?auth=$authToken';
    final existingProductIndex=_items.indexWhere((prod)=>prod.id==id);
    var existingProduct=_items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response= await http.delete(url);
      if(response.statusCode>=400){
        _items.insert(existingProductIndex, existingProduct);
        notifyListeners();
        throw HttpException('Could not delete Product');
      }
      existingProduct=null;
    }
}

