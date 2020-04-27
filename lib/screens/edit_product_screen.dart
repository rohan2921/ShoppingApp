import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppingapp/providers/products.dart';
import '../providers/product.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '\edit-product-screen';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageTextController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  var fav=false;
  var _emptyProduct = Product(
      id: '',
      title: '',
      description: '',
      price: 0,
      imageUrl: '');
  bool _firstTime=true;
  var _initialValues={
    'title':'',
    'descp':'',
    'imgUrl':'',
    'price':''
  };
  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }
 
  @override
  void didChangeDependencies() {

    if(_firstTime){
      final pid=ModalRoute.of(context).settings.arguments as String;
      if(pid!=null){
        _emptyProduct=Provider.of<Products>(context,listen: false).findById(pid);
      _initialValues={
        'title':_emptyProduct.title,
    'descp':_emptyProduct.description,
      //'imgUrl':_emptyProduct.imageUrl,
      'price':_emptyProduct.price.toString(),
      };
      fav=_emptyProduct.isFavourite;
      _imageTextController.text=_emptyProduct.imageUrl;
      }
      
    }
    _firstTime=false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageTextController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  void _saveForm() {
    final isValid = _formKey.currentState.validate();
    if (!isValid) return;
    if(_emptyProduct.id==null){
        Provider.of<Products>(context, listen: false).addProduct(_emptyProduct);
    }else{
      _emptyProduct.isFavourite=fav;
        Provider.of<Products>(context, listen: false).updateProduct(_emptyProduct.id,_emptyProduct);
    }
    
    _formKey.currentState.save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.save), onPressed: _saveForm),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  initialValue: _initialValues['title'],
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'please enter Text';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Title',
                  ),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_priceFocusNode);
                  },
                  onSaved: (value) {
                    _emptyProduct = Product(
                        id: _emptyProduct.id,
                        title: value,
                        description: _emptyProduct.description,
                        price: _emptyProduct.price,
                        imageUrl: _emptyProduct.imageUrl);
                  },
                ),
                TextFormField(
                  initialValue: _initialValues['price'],
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'please enter price';
                    }
                    if (double.parse(value) == null || double.parse(value) <= 0)
                      return 'Enter valid price';

                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Price',
                  ),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  focusNode: _priceFocusNode,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_descriptionFocusNode);
                  },
                  onSaved: (value) {
                    _emptyProduct = Product(
                        id: _emptyProduct.id,
                        title: _emptyProduct.title,
                        description: _emptyProduct.description,
                        price: double.parse(value),
                        imageUrl: _emptyProduct.imageUrl);
                  },
                ),
                TextFormField(
                  initialValue: _initialValues['descp'],
                  validator: (val) {
                    if (val.isEmpty) return 'Enter Description';
                    if (val.length < 10)
                      return 'Description must atleast be 10 characters';
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Description',
                  ),
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  focusNode: _descriptionFocusNode,
                  onFieldSubmitted: (_) =>
                      FocusScope.of(context).requestFocus(_imageUrlFocusNode),
                  onSaved: (value) {
                    _emptyProduct = Product(
                        id: _emptyProduct.id,
                        title: _emptyProduct.title,
                        description: value,
                        price: _emptyProduct.price,
                        imageUrl: _emptyProduct.imageUrl);
                  },
                ),
                Row(
                  children: <Widget>[
                    Container(
                      width: 100,
                      height: 100,
                      margin: EdgeInsets.only(top: 10, right: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          10,
                        ),
                        color: Colors.black,
                      ),
                      child: _imageTextController.text.isEmpty
                          ? Center(
                              child: Text('Enter a url',
                                  style: TextStyle(color: Colors.white)))
                          : FittedBox(
                              child: Image.network(_imageTextController.text,
                                  fit: BoxFit.cover)),
                    ),
                    Expanded(
                      child: TextFormField(
                        
                        validator: (val) {
                          if (!val.startsWith('http') &&
                              !val.startsWith('https'))
                            return 'Enter Valid url';
                          if (!val.endsWith('jpg') &&
                              !val.endsWith('.png') &&
                              !val.endsWith('.jpeg')) return 'Enter valid Url';
                          return null;
                        },
                        decoration: InputDecoration(labelText: 'Image URL'),
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.done,
                        controller: _imageTextController,
                        focusNode: _imageUrlFocusNode,
                        onFieldSubmitted: (_) {
                          _saveForm();
                        },
                        onSaved: (value) {
                          _emptyProduct = Product(
                              id: _emptyProduct.id,
                              title: _emptyProduct.title,
                              description: _emptyProduct.description,
                              price: _emptyProduct.price,
                              imageUrl: value);
                        },
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
