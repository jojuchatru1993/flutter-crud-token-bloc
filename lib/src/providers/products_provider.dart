import 'dart:convert';
import 'dart:io';

import 'package:form/src/shared_preferences/user_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import 'package:form/src/models/product_model.dart';

import 'package:mime_type/mime_type.dart';

class ProductsProviders {
  final String _url = 'https://flutter-form-827ab-default-rtdb.firebaseio.com';
  final _preferences = new UserPreferences();

  Future<bool> createProduct(ProductModel product) async {
    final url = Uri.parse('$_url/products.json?auth=${_preferences.token}');
    final request = await http.post(url, body: productModelToJson(product));

    final decodeData = json.decode(request.body);

    print(decodeData);

    return true;
  }

  Future<List<ProductModel>> getProducts() async {
    final url = Uri.parse('$_url/products.json?auth=${_preferences.token}');
    final request = await http.get(url);

    final Map<String, dynamic> decodeData = json.decode(request.body);
    final List<ProductModel> products = [];

    if (decodeData == null) {
      return [];
    }

    if (decodeData['error'] != null) {
      return [];
    }

    decodeData.forEach((id, product) {
      final productsTemp = ProductModel.fromJson(product);
      productsTemp.id = id;

      products.add(productsTemp);
    });

    return products;
  }

  Future<int> deleteProduct(String id) async {
    final url = Uri.parse('$_url/products/$id.json?auth=${_preferences.token}');
    final request = await http.delete(url);

    print(json.decode(request.body));

    return 1;
  }

  Future<bool> updateProduct(ProductModel product) async {
    final url = Uri.parse(
        '$_url/products/${product.id}.json?auth=${_preferences.token}');
    final request = await http.put(url, body: productModelToJson(product));

    final decodeData = json.decode(request.body);

    print(decodeData);

    return true;
  }

  Future<String> loadImage(File image) async {
    final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/dldn19so1/image/upload?upload_preset=v8d8xmts');

    final mimeType = mime(image.path).split('/');

    final requestImage = http.MultipartRequest('POST', url);

    final file = await http.MultipartFile.fromPath('file', image.path,
        contentType: MediaType(mimeType[0], mimeType[1]));

    requestImage.files.add(file);

    final streamResponse = await requestImage.send();
    final request = await http.Response.fromStream(streamResponse);

    if (request.statusCode != 200 && request.statusCode != 201) {
      print('Wrong');
      print(request.body);
      return null;
    }

    final decodeData = json.decode(request.body);

    return decodeData['secure_url'];
  }
}
