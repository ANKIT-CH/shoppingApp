import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_class.dart';
import '../providers/products_provider.dart';

class EditProductsPage extends StatefulWidget {
  static const routeName = '/edit_products_page';
  @override
  _EditProductsPageState createState() => _EditProductsPageState();
}

class _EditProductsPageState extends State<EditProductsPage> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusController = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
    id: null,
    title: '',
    price: 0,
    description: '',
    imageUrl: '',
  );

  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };
  var _isInit = true;
  var _isLoading = false;
  @override
  void initState() {
    _imageUrlFocusController.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initValues['title'] = _editedProduct.title;
        _initValues['price'] = _editedProduct.price.toString();
        _initValues['description'] = _editedProduct.description;
        // _initValues['imageUrl'] = _editedProduct.imageUrl;
        _initValues['imageUrl'] = '';
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusController.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusController.hasFocus) {
      if (_imageUrlController.text.isEmpty) return;
      if (!_imageUrlController.text.startsWith('http') &&
          !_imageUrlController.text.startsWith('https')) return;
      if (!_imageUrlController.text.endsWith('.png') &&
          !_imageUrlController.text.endsWith('.jpg') &&
          !_imageUrlController.text.endsWith('.jpeg')) return;
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final _isValid = _form.currentState.validate();
    if (_isValid) {
      _form.currentState.save();
      setState(() {
        _isLoading = true;
      });
      print(_editedProduct.title);
      print(_editedProduct.description);
      print(_editedProduct.price);
      print(_editedProduct.imageUrl);
      if (_editedProduct.id != null) {
        await Provider.of<Products>(context, listen: false)
            .editProduct(_editedProduct.id, _editedProduct);
        // setState(() {
        //   _isLoading = false;
        // });
        // Navigator.of(context).pop();
      } else {
        try {
          await Provider.of<Products>(context, listen: false)
              .addProduct(_editedProduct);
        } catch (error) {
          await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text('An error occured'),
              content: Text('something wrong happened in app'),
              actions: [
                FloatingActionButton(
                  child: Text('Ok!!'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
          );
        }
        //  finally {
        //   Navigator.of(context).pop();
        //   setState(() {
        //     _isLoading = false;
        //   });
        // }
      }
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('EDIT PRODUCTS'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(15),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      initialValue: _initValues['title'],
                      decoration: InputDecoration(
                        labelText: 'title',
                      ),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) return ('provide a value');
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          title: value,
                          price: _editedProduct.price,
                          description: _editedProduct.description,
                          imageUrl: _editedProduct.imageUrl,
                          isFavourite: _editedProduct.isFavourite,
                          id: _editedProduct.id,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['price'],
                      decoration: InputDecoration(
                        labelText: 'price',
                      ),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) return ('provide a value');
                        if (double.tryParse(value) == null)
                          return ('provide a valid number value');
                        if (double.parse(value) <= 0)
                          return ('provide a valid number > 0');

                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          title: _editedProduct.title,
                          price: double.parse(value),
                          description: _editedProduct.description,
                          imageUrl: _editedProduct.imageUrl,
                          isFavourite: _editedProduct.isFavourite,
                          id: _editedProduct.id,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['description'],
                      decoration: InputDecoration(
                        labelText: 'description',
                      ),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      // textInputAction: TextInputAction.next,
                      // focusNode: _priceFocusNode,
                      validator: (value) {
                        if (value.isEmpty) return ('provide a descriptiom');
                        if (value.length <= 10)
                          return ('provide a description with more than 10 characters');
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          title: _editedProduct.title,
                          price: _editedProduct.price,
                          description: value,
                          imageUrl: _editedProduct.imageUrl,
                          isFavourite: _editedProduct.isFavourite,
                          id: _editedProduct.id,
                        );
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          height: 120,
                          width: 120,
                          margin: EdgeInsets.only(
                            right: 5,
                            top: 5,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 2,
                              color: Colors.black,
                            ),
                          ),
                          child: Container(
                            child: _imageUrlController.text.isEmpty
                                ? Text('Enter Image URL')
                                : FittedBox(
                                    child:
                                        Image.network(_imageUrlController.text),
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'Image URL'),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageUrlController,
                            onFieldSubmitted: (_) {
                              _saveForm();
                            },
                            validator: (value) {
                              return null;
                            },
                            onSaved: (value) {
                              _editedProduct = Product(
                                title: _editedProduct.title,
                                price: _editedProduct.price,
                                description: _editedProduct.description,
                                imageUrl: value,
                                isFavourite: _editedProduct.isFavourite,
                                id: _editedProduct.id,
                              );
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
