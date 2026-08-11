import 'package:dio/dio.dart';
import '../datasources/product_remote_datasource.dart';
import '../models/product_model.dart';

class ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepository({required this.remoteDataSource});

  Future<List<ProductModel>> getProducts() async {
    try {
      return await remoteDataSource.getProducts();
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }

  Future<ProductModel> getProductDetail(int id) async {
    try {
      return await remoteDataSource.getProductDetail(id);
    } catch (e) {
      throw Exception('Failed to load product detail: $e');
    }
  }

  Future<ProductModel> createProduct(ProductModel product) async {
    try {
      return await remoteDataSource.createProduct(product);
    } catch (e) {
      throw Exception('Failed to create product: $e');
    }
  }

  Future<ProductModel> updateProduct(int id, ProductModel product) async {
    try {
      return await remoteDataSource.updateProduct(id, product);
    } catch (e) {
      throw Exception('Failed to update product: $e');
    }
  }

  Future<void> deleteProduct(int id) async {
    try {
      await remoteDataSource.deleteProduct(id);
    } catch (e) {
      throw Exception('Failed to delete product: $e');
    }
  }

  Future<Map<String, List<dynamic>>> getDropdownData() async {
    try {
      return await remoteDataSource.getDropdownData();
    } catch (e) {
      throw Exception('Failed to load dropdown data: $e');
    }
  }
}