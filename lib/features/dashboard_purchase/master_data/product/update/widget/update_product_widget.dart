import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:erp_mobile_cnplus/features/dashboard_purchase/master_data/product/create/models/create_product_models.dart';
import 'package:erp_mobile_cnplus/features/dashboard_purchase/master_data/product/show/models/show_product_models.dart';

class UpdateProductWidget extends StatefulWidget {
  final ShowProductModel product;
  final List<Category> categories;
  final List<Brand> brands;
  final List<ProductType> productTypes;
  final List<Uom> uoms;

  const UpdateProductWidget({
    super.key,
    required this.product,
    required this.categories,
    required this.brands,
    required this.productTypes,
    required this.uoms,
  });

  @override
  State<UpdateProductWidget> createState() => _UpdateProductWidgetState();
}

class _UpdateProductWidgetState extends State<UpdateProductWidget> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _productNameController;
  late TextEditingController _salesPriceController;
  late TextEditingController _costPriceController;
  late TextEditingController _barcodeController;
  late TextEditingController _internalNotesController;

  // Variabel untuk menampung nilai dropdown yang dipilih
  int? _selectedProductType;
  int? _selectedProductCategory;
  int? _selectedBrand;
  int? _selectedUom;

  bool _canBeSold = false;
  bool _canBePurchased = false;

  @override
  void initState() {
    super.initState();
    final productData = widget.product.data;

    // Inisialisasi semua controller dengan data yang sudah ada
    _productNameController =
        TextEditingController(text: productData.product.productName);
    _salesPriceController = TextEditingController(
        text: productData.productDetail?.salesPrice.toString() ?? '0');
    _costPriceController = TextEditingController(
        text: productData.productDetail?.purchasePrice.toString() ?? '0');
    _barcodeController =
        TextEditingController(text: productData.productDetail?.barcode ?? '');
    _internalNotesController =
        TextEditingController(text: productData.productDetail?.noteDetail ?? '');

    // Inisialisasi nilai awal untuk checkbox
    _canBeSold = productData.product.sales == 1;
    _canBePurchased = productData.product.purchase == 1;

    // =======================================================================
    // == BAGIAN PERBAIKAN ==
    // Inisialisasi nilai awal untuk dropdown dari data produk yang ada
    // =======================================================================
    _selectedProductType = productData.productDetail?.productType;
    _selectedProductCategory = productData.productDetail?.productCategory;
    _selectedBrand = productData.productDetail?.productBrand;
    _selectedUom = productData.productDetail?.unitOfMeasure;
  }

  @override
  void dispose() {
    // Pastikan untuk melepaskan controller saat widget tidak lagi digunakan
    _productNameController.dispose();
    _salesPriceController.dispose();
    _costPriceController.dispose();
    _barcodeController.dispose();
    _internalNotesController.dispose();
    super.dispose();
  }

  Future<void> _updateProduct() async {
    if (_formKey.currentState!.validate()) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      final url = Uri.parse(
          'https://erp-api.gitavagroup.id/api/v1/purchase/products/${widget.product.data.product.idProduct}');
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
      final body = json.encode({
        'product_name': _productNameController.text,
        'sales_price': _salesPriceController.text,
        'cost_price': _costPriceController.text,
        'product_type': _selectedProductType,
        'product_category': _selectedProductCategory,
        'product_brand': _selectedBrand,
        'unit_of_measure': _selectedUom,
        'barcode': _barcodeController.text,
        'internal_notes': _internalNotesController.text,
        'can_be_sold': _canBeSold,
        'can_be_purchased': _canBePurchased,
      });

      try {
        final response = await http.put(url, headers: headers, body: body);

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Product updated successfully')),
          );
          // Kembali ke halaman sebelumnya dan kirim sinyal sukses
          Navigator.of(context).pop(true);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Failed to update product: ${response.body}')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Product Name
          TextFormField(
            controller: _productNameController,
            decoration: const InputDecoration(
              labelText: 'Product Name',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a product name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Checkboxes
          Row(
            children: [
              Checkbox(
                value: _canBeSold,
                onChanged: (value) {
                  setState(() {
                    _canBeSold = value!;
                  });
                },
              ),
              const Text('Can Be Sold'),
              const SizedBox(width: 16),
              Checkbox(
                value: _canBePurchased,
                onChanged: (value) {
                  setState(() {
                    _canBePurchased = value!;
                  });
                },
              ),
              const Text('Can Be Purchased'),
            ],
          ),
          const SizedBox(height: 16),

          // Sales Price
          TextFormField(
            controller: _salesPriceController,
            decoration: const InputDecoration(
              labelText: 'Sales Price',
              border: OutlineInputBorder(),
              prefixText: 'Rp ',
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a sales price';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Cost Price
          TextFormField(
            controller: _costPriceController,
            decoration: const InputDecoration(
              labelText: 'Cost Price',
              border: OutlineInputBorder(),
              prefixText: 'Rp ',
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a cost price';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Product Type Dropdown
          DropdownButtonFormField<int>(
            value: _selectedProductType,
            items: widget.productTypes.map((ProductType productType) {
              return DropdownMenuItem<int>(
                value: productType.idProductType,
                child: Text(productType.productTypeName),
              );
            }).toList(),
            decoration: const InputDecoration(
              labelText: 'Product Type',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              setState(() {
                _selectedProductType = value;
              });
            },
            validator: (value) =>
                value == null ? 'Please select a product type' : null,
          ),
          const SizedBox(height: 16),

          // Product Category Dropdown
          DropdownButtonFormField<int>(
            value: _selectedProductCategory,
            items: widget.categories.map((Category category) {
              return DropdownMenuItem<int>(
                value: category.idProductCategory,
                child: Text(category.productCategoryName),
              );
            }).toList(),
            decoration: const InputDecoration(
              labelText: 'Product Category',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              setState(() {
                _selectedProductCategory = value;
              });
            },
            validator: (value) =>
                value == null ? 'Please select a category' : null,
          ),
          const SizedBox(height: 16),

          // Brand Dropdown
          DropdownButtonFormField<int>(
            value: _selectedBrand,
            items: widget.brands.map((Brand brand) {
              return DropdownMenuItem<int>(
                value: brand.idBrand,
                child: Text(brand.brandName),
              );
            }).toList(),
            decoration: const InputDecoration(
              labelText: 'Brand',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              setState(() {
                _selectedBrand = value;
              });
            },
            // Brand tidak wajib, jadi tidak ada validator
          ),
          const SizedBox(height: 16),

          // Unit of Measure (UoM) Dropdown
          DropdownButtonFormField<int>(
            value: _selectedUom,
            items: widget.uoms.map((Uom uom) {
              return DropdownMenuItem<int>(
                value: uom.idUnitOfMeasure,
                child: Text(uom.unitOfMeasureName),
              );
            }).toList(),
            decoration: const InputDecoration(
              labelText: 'Unit of Measure',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              setState(() {
                _selectedUom = value;
              });
            },
            validator: (value) =>
                value == null ? 'Please select a unit of measure' : null,
          ),
          const SizedBox(height: 16),

          // Barcode
          TextFormField(
            controller: _barcodeController,
            decoration: const InputDecoration(
              labelText: 'Barcode',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),

          // Internal Notes
          TextFormField(
            controller: _internalNotesController,
            decoration: const InputDecoration(
              labelText: 'Internal Notes',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 24),

          // Update Button
          ElevatedButton(
            onPressed: _updateProduct,
            child: const Text('Update Product'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ],
      ),
    );
  }
}