import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/product.dart';
import 'package:shopping_app/providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static final routeName = '/edit-product-screen';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _editedProduct =
      Product(id: null, title: '', price: 0, description: '', imageUrl: '');
  var _initValues={
    "title":"",
    "description":"",
    "price":"",
    "imageUrl":""
  };
  var _isInit=true;
  var _isLoading=false;

  @override
  void didChangeDependencies() {
     if(_isInit){
          final productId=ModalRoute.of(context).settings.arguments as String;
          if(productId!=null){
            _editedProduct=Provider.of<Products>(context,listen:false).findById(productId);
            _initValues={
             "title":_editedProduct.title,
             "description":_editedProduct.description,
             "price":_editedProduct.price.toString(),
             "imageUrl":'',
           };
            _imageUrlController.text=_editedProduct.imageUrl;
         }
     }
      _isInit=false;
      super.didChangeDependencies();
  }

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_uploadImageUrl);
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_uploadImageUrl);
    _imageUrlFocusNode.dispose();
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  void _uploadImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    setState(() {
      _isLoading=true;
    });
    final _formValid=_form.currentState.validate();
    if(!_formValid){
      return ;
    }
    _form.currentState.save();
    if(_editedProduct.id != null){
      await Provider.of<Products>(context, listen: false).updateProduct(_editedProduct.id,_editedProduct);
    }else {
      try{
      await Provider.of<Products>(context, listen: false).addProduct(_editedProduct);
      } catch(error){
       await showDialog(context:context,
        builder:(ctx)=>AlertDialog(
          title:Text('An Error occurred'),
          content:Text('Something went wrong Up here'),
          actions: <Widget>[
            OutlineButton(
              color:Colors.grey,
              shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(10.0)),
              child:Text('OK'),
              onPressed:(){
                Navigator.of(context).pop();
              },
            )
          ],
        )
        );
      }
//      finally{
//        setState(() {
//          _isLoading=false;
//        });
//        Navigator.of(context).pop();
//      }
      setState(() {
        _isLoading=false;
      });
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Edit Screen'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          )
        ],
      ),
      body:_isLoading?Center(child:CircularProgressIndicator(),) :Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: ListView(
            children: <Widget>[
              TextFormField(
                initialValue:_initValues['title'],
                decoration: InputDecoration(labelText: 'Title'),
                textInputAction: TextInputAction.next,
                validator:(value){
                  return value.isEmpty?'Please Enter some title':null;
                },
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                onSaved: (value) {
                  _editedProduct = Product(
                      id:_editedProduct.id,
                      isFavourite:_editedProduct.isFavourite,
                      title: value,
                      description: _editedProduct.description,
                      price: _editedProduct.price,
                      imageUrl: _editedProduct.imageUrl);
                },
              ),
              TextFormField(
                initialValue:_initValues['price'],
                decoration: InputDecoration(labelText: 'Price'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
                validator:(value){
                  if(double.tryParse(value)==null){
                    return 'Please Enter valid number';
                  }
                  if(double.parse(value)<=0){
                    return 'Please Enter valid number';
                  }
                  return value.isEmpty?'Enter valid price':null;
                },
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                onSaved: (value) {
                  _editedProduct = Product(
                      id:_editedProduct.id,
                      isFavourite:_editedProduct.isFavourite,
                      title: _editedProduct.title,
                      description: _editedProduct.description,
                      price: double.parse(value),
                      imageUrl: _editedProduct.imageUrl);
                },
              ),
              TextFormField(
                initialValue:_initValues['description'],
                decoration: InputDecoration(labelText: 'description'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                focusNode: _descriptionFocusNode,
                validator:(value){
                  return value.isEmpty?'Enter valid description':null;
                },
                onSaved: (value) {
                  _editedProduct = Product(
                      id:_editedProduct.id,
                      isFavourite:_editedProduct.isFavourite,
                      title: _editedProduct.title,
                      description: value,
                      price: _editedProduct.price,
                      imageUrl: _editedProduct.imageUrl);
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 10.0, right: 10.0),
                    width: 100.0,
                    height: 100.0,
                    decoration: BoxDecoration(
                      border: Border.all(width: 1.0, color: Colors.grey),
                    ),
                    child: _imageUrlController.text.isEmpty
                        ? Text(
                            'No Image',
                            textAlign: TextAlign.center,
                          )
                        : FittedBox(
                            child: Image.network(
                              _imageUrlController.text,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Image Url'),
                      controller: _imageUrlController,
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      focusNode: _imageUrlFocusNode,
                      onFieldSubmitted: (_) {
                        _saveForm();
                      },
                      validator:(value){
                        return value.isEmpty?'Enter valid url':null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                            id:_editedProduct.id,
                            isFavourite:_editedProduct.isFavourite,
                            title: _editedProduct.title,
                            description: _editedProduct.description,
                            price: _editedProduct.price,
                            imageUrl:value);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
