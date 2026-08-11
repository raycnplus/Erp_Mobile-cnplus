import 'package:dio/dio.dart';
import '../../../../../core/network/dio_client.dart';
import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts();
  Future<ProductModel> getProductDetail(int id);
  Future<ProductModel> createProduct(ProductModel product);
  Future<ProductModel> updateProduct(int id, ProductModel product);
  Future<void> deleteProduct(int id);
  Future<Map<String, List<dynamic>>> getDropdownData();
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final DioClient dioClient;

  ProductRemoteDataSourceImpl(this.dioClient);

  @override
  Future<List<ProductModel>> getProducts() async {
    try {
      final response = await dioClient.dio.get('/inventory/products');
      
      if (response.statusCode == 200) {
        final data = response.data['data'] as List;
        return data.map((e) => ProductModel.fromJson(e)).toList();
      }
      throw Exception('Failed to load products');
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  @override
  Future<ProductModel> getProductDetail(int id) async {
    try {
      final response = await dioClient.dio.get('/inventory/products/show/$id');
      
      if (response.statusCode == 200) {
        final data = response.data['data'];
        return ProductModel.fromJson(data);
      }
      throw Exception('Failed to load product detail');
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  @override
  Future<ProductModel> createProduct(ProductModel product) async {
    try {
      final response = await dioClient.dio.post(
        '/inventory/products/store',
        data: product.toJson(),
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data['data'];
        return ProductModel.fromJson(data);
      }
      throw Exception('Failed to create product');
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  @override
  Future<ProductModel> updateProduct(int id, ProductModel product) async {
    try {
      final response = await dioClient.dio.put(
        '/inventory/products/$id',
        data: product.toJson(),
      );
      
      if (response.statusCode == 200) {
        final data = response.data['data'];
        return ProductModel.fromJson(data);
      }
      throw Exception('Failed to update product');
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  @override
  Future<void> deleteProduct(int id) async {
    try {
      final response = await dioClient.dio.delete('/inventory/products/$id');
      
      if (response.statusCode != 200) {
        throw Exception('Failed to delete product');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  @override
  Future<Map<String, List<dynamic>>> getDropdownData() async {
    try {
      final response = await dioClient.dio.get('/inventory/products/create');
      
      if (response.statusCode == 200) {
        final data = response.data['data'];
        return {
          'product_types': data['product_types'] ?? [],
          'categories': data['categories'] ?? [],
          'brands': data['brands'] ?? [],
          'uoms': data['uoms'] ?? [],
        };
      }
      throw Exception('Failed to load dropdown data');
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }
}