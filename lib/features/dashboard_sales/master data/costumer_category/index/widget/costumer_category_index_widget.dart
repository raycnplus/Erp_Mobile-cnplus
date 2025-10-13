// lib/features/dashboard_sales/master data/costumer_category/widget/costumer_category_index_widget.dart

import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';

import '../../../../../../shared/widgets/custom_refresh_indicator.dart';
import '../../../../../../services/api_base.dart';
import '../models/costumer_category_index_models.dart';
import 'customer_category_list_shimmer.dart';
import '../../update/widget/costumer_category_update_dialog.dart';
import '../../update/models/costumer_category_update_models.dart';

class CustomerCategoryIndexWidget extends StatefulWidget {
  final void Function(CustomerCategoryModel category)? onTap;
  final VoidCallback? onUpdateSuccess;
  final Function(String name)? onDeleteSuccess;

  const CustomerCategoryIndexWidget({
    super.key,
    this.onTap,
    this.onUpdateSuccess,
    this.onDeleteSuccess,
  });

  @override
  State<CustomerCategoryIndexWidget> createState() =>
      CustomerCategoryIndexWidgetState();
}

class CustomerCategoryIndexWidgetState
    extends State<CustomerCategoryIndexWidget> {
  bool _isLoading = true;
  List<CustomerCategoryModel> _categories = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    if (!_isLoading) {
      setState(() => _isLoading = true);
    }
    try {
      final data = await fetchCustomerCategories();
      if (mounted) {
        setState(() {
          _categories = data;
          _error = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _error = e.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void reloadData() {
    _loadData();
  }

  Future<List<CustomerCategoryModel>> fetchCustomerCategories() async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');
    if (token == null) throw Exception("Token not found.");
    final url = Uri.parse("${ApiBase.baseUrl}/sales/customer-category/");
    final response = await http.get(
      url,
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
    );
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final List<dynamic> dataList = decoded is Map<String, dynamic> &&
              decoded.containsKey('data')
          ? decoded['data']
          : (decoded is List ? decoded : []);
      return dataList.map((item) => CustomerCategoryModel.fromJson(item)).toList();
    } else {
      throw Exception("Failed to load data: Status code ${response.statusCode}");
    }
  }

  Future<void> _showUpdateDialog(CustomerCategoryModel category) async {
    final bool? wasUpdated = await showUpdateCustomerCategoryDialog(
      context,
      id: category.id,
      initialData:
          CustomerCategoryUpdateModel(customerCategoryName: category.name),
    );
    if (wasUpdated == true) {
      reloadData();
      widget.onUpdateSuccess?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content;
    if (_isLoading && _categories.isEmpty) {
      content = const CustomerCategoryListShimmer();
    } else if (_error != null) {
      content = Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Error: $_error"),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: reloadData, child: const Text("Try Again")),
          ],
        ),
      );
    } else if (_categories.isEmpty) {
      content = const Center(child: Text("No customer categories found"));
    } else {
      content = ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          return _buildCategoryCard(category);
        },
      );
    }
    return CustomRefreshIndicator(onRefresh: _loadData, child: content);
  }

  Widget _buildCategoryCard(CustomerCategoryModel category) {
    final cardBorderRadius = BorderRadius.circular(12);
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      decoration: BoxDecoration(
        borderRadius: cardBorderRadius,
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withAlpha(26),
              spreadRadius: 0,
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: ClipRRect(
        borderRadius: cardBorderRadius,
        child: Dismissible(
          key: Key(category.id.toString()),
          background: _buildSwipeActionContainer(color: Colors.blue, icon: Icons.edit, text: 'Edit', alignment: Alignment.centerLeft),
          secondaryBackground: _buildSwipeActionContainer(color: Colors.red, icon: Icons.delete, text: 'Delete', alignment: Alignment.centerRight),
          confirmDismiss: (direction) async {
            if (direction == DismissDirection.endToStart) {
              bool? deleteConfirmed = await _showDeleteConfirmationDialog(category);
              if (deleteConfirmed == true) {
                final success = await _deleteCategory(category.id);
                if (!mounted) return false;
                if (success) {
                  reloadData();
                  widget.onDeleteSuccess?.call(category.name);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete ${category.name}'), backgroundColor: Colors.redAccent));
                }
                return success;
              }
              return false;
            } else {
              _showUpdateDialog(category);
              return false;
            }
          },
          child: Material(
            color: Colors.white,
            child: InkWell(
              onTap: () => widget.onTap?.call(category),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(category.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 4),
                          Text("Created: ${_formatDate(category.createdDate)}", style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  String _formatDate(String dateString) {
    if (dateString.isEmpty) return 'No date';
    try {
      final dateTime = DateTime.parse(dateString);
      return DateFormat('d MMM yyyy').format(dateTime);
    } catch (e) {
      return dateString;
    }
  }

  Future<bool> _deleteCategory(int id) async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');
    final url = Uri.parse("${ApiBase.baseUrl}/sales/customer-category/$id");
    final response = await http.delete(url,
        headers: {"Authorization": "Bearer $token", "Accept": "application/json"});
    return response.statusCode == 200 || response.statusCode == 204;
  }
  
  Container _buildSwipeActionContainer({required Color color, required IconData icon, required String text, required Alignment alignment}) {
    return Container(
      color: color,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      alignment: alignment,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (alignment == Alignment.centerLeft) ...[Icon(icon, color: Colors.white), const SizedBox(width: 8)],
          Text(text, style: const TextStyle(color: Colors.white)),
          if (alignment == Alignment.centerRight) ...[const SizedBox(width: 8), Icon(icon, color: Colors.white)],
        ],
      ),
    );
  }

  Future<bool?> _showDeleteConfirmationDialog(CustomerCategoryModel category) {
    return showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withAlpha(102),
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Dialog(
            backgroundColor: Colors.white.withAlpha(230),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Icon(Icons.delete_rounded, color: Color(0xFFF35D5D), size: 50.0),
                  const SizedBox(height: 28),
                  Text("Are you sure you want to delete ${category.name}?", textAlign: TextAlign.center, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF333333))),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF35D5D), foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text("Yes, Delete", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text("Keep It", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}