import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:form/src/blocs/provider.dart';

import 'package:form/src/models/product_model.dart';

import 'package:form/src/utils/utils.dart' as utils;

class ProductPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  ProductsBloc productsBloc;

  ProductModel product = new ProductModel();

  bool _saving = false;
  File photo;

  @override
  Widget build(BuildContext context) {
    productsBloc = Provider.productsBloc(context);

    final ProductModel prodData = ModalRoute.of(context).settings.arguments;

    if (prodData != null) {
      product = prodData;
    }

    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Text('Product'),
          actions: [
            IconButton(
                icon: Icon(Icons.photo_size_select_actual),
                onPressed: _selectPhoto),
            IconButton(
              icon: Icon(Icons.camera_alt),
              onPressed: _takePhoto,
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(15.0),
            child: Form(
              key: formKey,
              child: Column(children: [
                _showPhoto(),
                _createName(),
                _createPrice(),
                _createAvailable(),
                _createButton()
              ]),
            ),
          ),
        ));
  }

  Widget _createName() {
    return TextFormField(
      initialValue: product.title,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(labelText: 'Product'),
      onSaved: (value) => product.title = value,
      validator: (value) {
        if (value.length < 3) {
          return 'Write product name';
        } else {
          return null;
        }
      },
    );
  }

  Widget _createPrice() {
    return TextFormField(
      initialValue: product.value.toString(),
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: 'Price'),
      onSaved: (value) => product.value = double.parse(value),
      validator: (value) {
        if (utils.isNumeric(value)) {
          return null;
        } else {
          return 'Only numbers';
        }
      },
    );
  }

  Widget _createButton() {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        primary: Colors.deepPurple,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      ),
      icon: Icon(Icons.save),
      onPressed: (_saving) ? null : _submit,
      label: Text('Save'),
    );
  }

  void _submit() async {
    if (!formKey.currentState.validate()) {
      return;
    }

    formKey.currentState.save();

    setState(() {
      _saving = true;
    });

    if (photo != null) {
      product.photoUrl = await productsBloc.loadPhoto(photo);
    }

    if (product.id == null) {
      productsBloc.createProduct(product);
    } else {
      productsBloc.updateProduct(product);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Item save'),
      ),
    );

    Navigator.pop(context);
  }

  _createAvailable() {
    return SwitchListTile(
        value: product.available,
        title: Text('Available'),
        activeColor: Colors.deepPurple,
        onChanged: (value) => setState(() {
              product.available = value;
            }));
  }

  _showPhoto() {
    if (product.photoUrl != null) {
      return FadeInImage(
          placeholder: AssetImage('assets/jar-loading.gif'),
          image: NetworkImage(product.photoUrl),
          height: 300.0,
          fit: BoxFit.contain);
    } else {
      return Image(
        image: photo != null
            ? FileImage(photo)
            : AssetImage('assets/no-image.png'),
        height: 300.0,
        fit: BoxFit.cover,
      );
    }
  }

  _selectPhoto() async {
    _processImage(ImageSource.gallery);
  }

  _takePhoto() async {
    _processImage(ImageSource.camera);
  }

  _processImage(ImageSource origin) async {
    final _picker = ImagePicker();

    final pickedFile = await _picker.getImage(
      source: origin,
    );

    photo = File(pickedFile.path);

    if (photo != null) {
      product.photoUrl = null;
    }

    setState(() {});
  }
}
