import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../../../../services/api_base.dart';
import '../models/update_product_models_inv.dart';

class ProductUpdateWidget extends StatefulWidget {
  final int id;

  const ProductUpdateWidget({super.key, required this.id});

  @override
  State<ProductUpdateWidget> createState() => _ProductUpdateWidgetState();
}

class _ProductUpdateWidgetState extends State<ProductUpdateWidget> {
  final _formKey = GlobalKey<FormState>();
  final storage = const FlutterSecureStorage();

  // Controllers
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController barcodeController = TextEditingController();
  final TextEditingController salesPriceController = TextEditingController();
  final TextEditingController purchasePriceController = TextEditingController();
  final TextEditingController costPriceController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final TextEditingController weightController = TextEditingController();

  // Dropdown data
  List<DropdownProductType> productTypes = [];
  List<DropdownProductCategory> categories = [];
  List<DropdownProductBrand> brands = [];
  List<DropdownUnitOfMeasure> uoms = [];

  // Selected dropdowns
  DropdownProductType? selectedProductType;
  DropdownProductCategory? selectedCategory;
  DropdownProductBrand? selectedBrand;
  DropdownUnitOfMeasure? selectedUom;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    await _fetchDropdownData();
    await _fetchExistingData();
  }

  Future<void> _fetchDropdownData() async {
    final token = await storage.read(key: "token");
    final endpoint = "${ApiBase.baseUrl}/inventory/products/create";

    try {
      final res = await http.get(Uri.parse(endpoint), headers: {
        "Authorization": "Bearer $token",
      });

      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);

        setState(() {
          productTypes = (body['product_type'] as List)
              .map((e) => DropdownProductType.fromJson(e))
              .toList();

          categories = (body['product_category'] as List)
              .map((e) => DropdownProductCategory.fromJson(e))
              .toList();

          brands = (body['product_brand'] as List)
              .map((e) => DropdownProductBrand.fromJson(e))
              .toList();

          uoms = (body['uom'] as List)
              .map((e) => DropdownUnitOfMeasure.fromJson(e))
              .toList();
        });
      }
    } catch (e) {
      debugPrint("Error dropdown: $e");
    }
  }

  Future<void> _fetchExistingData() async {
    final token = await storage.read(key: "token");
    final endpoint =
        "${ApiBase.baseUrl}/inventory/products/show/${widget.id}";

    try {
      final res = await http.get(Uri.parse(endpoint), headers: {
        "Authorization": "Bearer $token",
      });

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body)['data'];
        final product = data['product'];
        final detail = data['product_detail'];

        setState(() {
          productNameController.text = product['product_name'] ?? '';
          barcodeController.text = product['barcode'] ?? '';
          salesPriceController.text = (detail['sales_price'] ?? '').toString();
          purchasePriceController.text =
              (detail['purchase_price'] ?? '').toString();
          costPriceController.text = (detail['cost_price'] ?? 0).toString();
          noteController.text = detail['note_detail'] ?? '';
          weightController.text = product['weight']?.toString() ?? '';

          // Match dropdowns by id
          selectedProductType = productTypes.isNotEmpty
              ? productTypes.firstWhere(
                  (e) => e.id == detail['product_type'],
                  orElse: () => productTypes.first,
                )
              : null;

          selectedCategory = categories.isNotEmpty
              ? categories.firstWhere(
                  (e) => e.id == detail['product_category'],
                  orElse: () => categories.first,
                )
              : null;

          selectedBrand = detail['product_brand'] == null
              ? null
              : (brands.isNotEmpty
                  ? brands.firstWhere(
                      (e) => e.id == detail['product_brand'],
                      orElse: () => brands.first,
                    )
                  : null);

          selectedUom = uoms.isNotEmpty
              ? uoms.firstWhere(
                  (e) => e.id == detail['unit_of_measure'],
                  orElse: () => uoms.first,
                )
              : null;
        });
      }
    } catch (e) {
      debugPrint("Error fetch existing: $e");
    }
  }

  Future<void> _updateProduct() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);
    try {
      final token = await storage.read(key: 'token');
      final endpoint =
          "${ApiBase.baseUrl}/inventory/products/${widget.id}";

      final body = {
        'product_name': productNameController.text,
        'barcode': barcodeController.text,
        'sales_price': salesPriceController.text,
        'purchase_price': purchasePriceController.text,
        'cost_price': costPriceController.text,
        'note_detail': noteController.text,
        'weight': weightController.text,
        'product_type': selectedProductType?.id.toString(),
        'product_category': selectedCategory?.id.toString(),
        'product_brand': selectedBrand?.id.toString(),
        'unit_of_measure': selectedUom?.id.toString(),
      };

      final res = await http.put(
        Uri.parse(endpoint),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (res.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Product updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        debugPrint(res.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed: ${res.statusCode}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      debugPrint('Error update: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: productNameController,
                    decoration:
                        const InputDecoration(labelText: "Product Name"),
                    validator: (v) =>
                        v!.isEmpty ? "Please enter product name" : null,
                  ),
                  const SizedBox(height: 10),

                  DropdownButtonFormField<DropdownProductType>(
                    value: selectedProductType,
                    items: productTypes
                        .map((e) =>
                            DropdownMenuItem(value: e, child: Text(e.name)))
                        .toList(),
                    onChanged: (v) => setState(() => selectedProductType = v),
                    decoration:
                        const InputDecoration(labelText: "Product Type"),
                  ),
                  const SizedBox(height: 10),

                  DropdownButtonFormField<DropdownProductCategory>(
                    value: selectedCategory,
                    items: categories
                        .map((e) =>
                            DropdownMenuItem(value: e, child: Text(e.name)))
                        .toList(),
                    onChanged: (v) => setState(() => selectedCategory = v),
                    decoration: const InputDecoration(labelText: "Category"),
                  ),
                  const SizedBox(height: 10),

                  DropdownButtonFormField<DropdownProductBrand>(
                    value: selectedBrand,
                    items: brands
                        .map((e) =>
                            DropdownMenuItem(value: e, child: Text(e.name)))
                        .toList(),
                    onChanged: (v) => setState(() => selectedBrand = v),
                    decoration: const InputDecoration(labelText: "Brand"),
                  ),
                  const SizedBox(height: 10),

                  DropdownButtonFormField<DropdownUnitOfMeasure>(
                    value: selectedUom,
                    items: uoms
                        .map((e) =>
                            DropdownMenuItem(value: e, child: Text(e.name)))
                        .toList(),
                    onChanged: (v) => setState(() => selectedUom = v),
                    decoration: const InputDecoration(labelText: "UOM"),
                  ),
                  const SizedBox(height: 10),

                  TextFormField(
                    controller: barcodeController,
                    decoration:
                        const InputDecoration(labelText: "Barcode"),
                  ),
                  const SizedBox(height: 10),

                  TextFormField(
                    controller: salesPriceController,
                    decoration:
                        const InputDecoration(labelText: "Sales Price"),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 10),

                  TextFormField(
                    controller: purchasePriceController,
                    decoration:
                        const InputDecoration(labelText: "Purchase Price"),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 10),

                  TextFormField(
                    controller: costPriceController,
                    decoration:
                        const InputDecoration(labelText: "Cost Price"),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 10),

                  TextFormField(
                    controller: noteController,
                    decoration:
                        const InputDecoration(labelText: "Note Detail"),
                  ),
                  const SizedBox(height: 10),

                  TextFormField(
                    controller: weightController,
                    decoration:
                        const InputDecoration(labelText: "Weight"),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: _updateProduct,
                    child: const Text("Update Product"),
                  ),
                ],
              ),
            ),
          );
  }
}