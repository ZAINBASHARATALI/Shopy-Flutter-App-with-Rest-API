import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopy_maxi/providers/product.dart';
import 'package:shopy_maxi/providers/products.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  bool isInit = true;
  bool isLoading = false;

  final priceFocusNode = FocusNode();
  final descriptionFocusNode = FocusNode();
  final imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _formkey = GlobalKey<FormState>();
  Product _editedProduct = Product(
    id: '',
    title: '',
    description: '',
    price: 0.0,
    imageUrl: '',
  );
  var _initValues = {
    'title': '',
    'price': 0.0,
    'description': '',
    'imageUrl': ''
  };

  Future<void> saveForm() async {
    bool isValid = _formkey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formkey.currentState!.save();
    setState(() {
      isLoading = true;
    });
    if (_editedProduct.id.isNotEmpty) {
      try {
        await Provider.of<ProductsProvider>(context, listen: false)
            .updateProduct(_editedProduct.id, _editedProduct);
      } catch (error) {
        await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Error‼️'),
                content: const Text('Something went wrong😟'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Okay'),
                  )
                ],
              );
            });
      } finally {
        setState(() {
          isLoading = false;
        });
        Navigator.of(context).pop();
      }
    } else {
      try {
        await Provider.of<ProductsProvider>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (error) {
        await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Error‼️'),
                content: const Text('Something went wrong😟'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Okay'),
                  )
                ],
              );
            });
      } finally {
        isLoading = false;
        setState(() {
          isLoading = false;
        });
        Navigator.of(context).pop();
      }
    }
  }

  @override
  void didChangeDependencies() {
    if (isInit) {
      final id = ModalRoute.of(context)!.settings.arguments;
      if (id != null) {
        _editedProduct = Provider.of<ProductsProvider>(context, listen: false)
            .getProductById(id);
        _initValues = {
          'title': _editedProduct.title,
          'price': _editedProduct.price,
          'description': _editedProduct.description,
          'imageUrl': ''
        };
        imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    isInit = false;
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _imageUrlFocusNode.addListener(imageUrlFunction);
    super.initState();
  }

  void imageUrlFunction() {
    if (!_imageUrlFocusNode.hasFocus) {
      if ((!imageUrlController.text.startsWith('http') &&
              !imageUrlController.text.startsWith('https')) ||
          (!imageUrlController.text.endsWith('.png') &&
              !imageUrlController.text.endsWith('.jpg') &&
              !imageUrlController.text.endsWith('.jpeg'))) {
        return;
      }
    }
    setState(() {});
  }

  @override
  void dispose() {
    priceFocusNode.dispose();
    _imageUrlFocusNode.removeListener(imageUrlFunction);
    descriptionFocusNode.dispose();
    imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size msize = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Edit Products'),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.all(msize.height * 0.03),
              child: Form(
                key: _formkey,
                child: ListView(
                  children: [
                    SizedBox(
                      height: msize.height * 0.1,
                      child: TextFormField(
                        initialValue: _initValues['title'] as String,
                        decoration: const InputDecoration(labelText: 'Title'),
                        autofocus: true,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(priceFocusNode);
                        },
                        textInputAction: TextInputAction.next,
                        onSaved: (value) {
                          _editedProduct = Product(
                            id: _editedProduct.id,
                            isFavourite: _editedProduct.isFavourite,
                            title: value!,
                            description: _editedProduct.description,
                            price: _editedProduct.price,
                            imageUrl: _editedProduct.imageUrl,
                          );
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter a title";
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    // SizedBox(
                    //   height: msize.height * 0.01,
                    // ),
                    SizedBox(
                      height: msize.height * 0.1,
                      child: TextFormField(
                        initialValue: (_initValues['price'] as double == 0.0
                                ? ''
                                : _initValues['price'] as double)
                            .toString(),
                        decoration: const InputDecoration(labelText: 'Price'),
                        textInputAction: TextInputAction.next,
                        focusNode: priceFocusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(descriptionFocusNode);
                        },
                        keyboardType: TextInputType.number,
                        onSaved: (value) {
                          _editedProduct = Product(
                            id: _editedProduct.id,
                            isFavourite: _editedProduct.isFavourite,
                            title: _editedProduct.title,
                            description: _editedProduct.description,
                            price: value!.isEmpty ? 0.0 : double.parse(value),
                            imageUrl: _editedProduct.imageUrl,
                          );
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter a price";
                          }
                          if (double.tryParse(value) == null) {
                            return "Please enter a valid number";
                          }
                          if (double.parse(value) <= 0) {
                            return "Please enter a number greater than 0";
                          }
                          return null;
                        },
                      ),
                    ),
                    // SizedBox(
                    //   height: msize.height * 0.01,
                    // ),
                    SizedBox(
                      height: msize.height * 0.1,
                      child: TextFormField(
                        initialValue: _initValues['description'] as String,
                        decoration:
                            const InputDecoration(labelText: 'Description'),
                        maxLines: 3,
                        focusNode: descriptionFocusNode,
                        keyboardType: TextInputType.multiline,
                        onSaved: (value) {
                          _editedProduct = Product(
                            id: _editedProduct.id,
                            isFavourite: _editedProduct.isFavourite,
                            title: _editedProduct.title,
                            description: value!,
                            price: _editedProduct.price,
                            imageUrl: _editedProduct.imageUrl,
                          );
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter some Description";
                          }
                          if (value.length <= 10) {
                            return "Please enter atleast 10 characters";
                          }
                          return null;
                        },
                      ),
                    ),
                    // SizedBox(
                    //   height: msize.height * 0.01,
                    // ),
                    Container(
                      margin: EdgeInsets.only(top: msize.height * 0.02),
                      height: msize.height * 0.15,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: TextFormField(
                                keyboardType: TextInputType.url,
                                controller: imageUrlController,
                                textInputAction: TextInputAction.done,
                                focusNode: _imageUrlFocusNode,
                                decoration: const InputDecoration(
                                    labelText: 'Image Url'),
                                onSaved: (value) {
                                  _editedProduct = Product(
                                    id: _editedProduct.id,
                                    isFavourite: _editedProduct.isFavourite,
                                    title: _editedProduct.title,
                                    description: _editedProduct.description,
                                    price: _editedProduct.price,
                                    imageUrl: value!,
                                  );
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Please enter an Image Url";
                                  }
                                  if (!value.startsWith('http') &&
                                      !value.startsWith('https')) {
                                    return "Please enter a valid Url";
                                  }
                                  if (!value.endsWith('.png') &&
                                      !value.endsWith('.jpg') &&
                                      !value.endsWith('.jpeg')) {
                                    return "Please enter valid Image Url";
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            width: msize.height * 0.15,
                            height: msize.height * 0.15,
                            decoration: BoxDecoration(
                              border: Border.all(width: 0.5),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: imageUrlController.text.isEmpty
                                ? const Center(
                                    child: Text(
                                    'Enter valid Url',
                                    style: TextStyle(
                                        fontSize: 13, color: Colors.red),
                                  ))
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child:
                                        Image.network(imageUrlController.text),
                                  ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: msize.height * 0.30,
                    ),
                    SizedBox(
                      height: msize.height * 0.05,
                      width: msize.width * 0.65,
                      child: ElevatedButton(
                        onPressed: saveForm,
                        child: const Text(
                          'SAVE',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.1),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
