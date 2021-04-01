import 'dart:io';

import 'package:form/src/providers/products_provider.dart';
import 'package:rxdart/rxdart.dart';

import 'package:form/src/models/product_model.dart';

class ProductsBloc {
  final _productsController = new BehaviorSubject<List<ProductModel>>();
  final _loadController = new BehaviorSubject<bool>();

  final _productsProvider = new ProductsProviders();

  Stream<List<ProductModel>> getProductsStream() => _productsController.stream;
  Stream<bool> getLoad() => _loadController.stream;

  void loadProducts() async {
    final products = await _productsProvider.getProducts();

    _productsController.sink.add(products);
  }

  void createProduct(ProductModel product) async {
    _loadController.sink.add(true);
    await _productsProvider.createProduct(product);
    _loadController.sink.add(false);
  }

  Future<String> loadPhoto(File photo) async {
    _loadController.sink.add(true);
    final photoUrl = await _productsProvider.loadImage(photo);
    _loadController.sink.add(false);

    return photoUrl;
  }

  void updateProduct(ProductModel product) async {
    _loadController.sink.add(true);
    await _productsProvider.updateProduct(product);
    _loadController.sink.add(false);
  }

  void deleteProduct(String id) async {
    await _productsProvider.deleteProduct(id);
  }

  dispose() {
    _productsController?.close();
    _loadController?.close();
  }
}
