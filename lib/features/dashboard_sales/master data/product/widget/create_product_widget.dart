import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../../../services/api_base.dart';
import '../models/create_product_models.dart';

class ProductCreateWidget extends StatefulWidget {
  const ProductCreateWidget({super.key});

  @override
  State<ProductCreateWidget> createState() => _ProductCreateWidgetState();
}

class _ProductCreateWidgetState extends State<ProductCreateWidget> {
  final _formKey = GlobalKey<FormState>();
  final storage = const FlutterSecureStorage();

  // Controllers
  final _nameController = TextEditingController();
  final _codeController = TextEditingController();
  final _salesPriceController = TextEditingController();
  final _costPriceController = TextEditingController();
  final _barcodeController = TextEditingController();
  final _noteController = TextEditingController();

  // Dropdown data
  List<DropdownProductType> productTypes = [];
  List<DropdownProductCategory> categories = [];
  List<DropdownProductBrand> brands = [];
  List<DropdownUnitOfMeasure> uoms = [];

  DropdownProductType? selectedType;
  DropdownProductCategory? selectedCategory;
  DropdownProductBrand? selectedBrand;
  DropdownUnitOfMeasure? selectedUom;

  bool tracking = false;

  @override
  void initState() {
    super.initState();
    fetchDropdowns();
  }

  Future<void> fetchDropdowns() async {
    final token = await storage.read(key: 'token');

    try {
      // ⚠️ Ganti endpoint sesuai API kamu
      final typeRes = await http.get(
        Uri.parse("${ApiBase.baseUrl}/sales/product-types"),
        headers: {"Authorization": "Bearer $token"},
      );
      final catRes = await http.get(
        Uri.parse("${ApiBase.baseUrl}/sales/product-categories"),
        headers: {"Authorization": "Bearer $token"},
      );
      final brandRes = await http.get(
        Uri.parse("${ApiBase.baseUrl}/inventory/brand"),
        headers: {"Authorization": "Bearer $token"},
      );
      final uomRes = await http.get(
        Uri.parse("${ApiBase.baseUrl}/master/unit-of-measure"),
        headers: {"Authorization": "Bearer $token"},
      );

      if (typeRes.statusCode == 200 &&
          catRes.statusCode == 200 &&
          brandRes.statusCode == 200 &&
          uomRes.statusCode == 200) {
        setState(() {
          productTypes = (jsonDecode(typeRes.body)["data"] as List)
              .map((e) => DropdownProductType.fromJson(e))
              .toList();

          categories = (jsonDecode(catRes.body)["data"] as List)
              .map((e) => DropdownProductCategory.fromJson(e))
              .toList();

          brands = (jsonDecode(brandRes.body)["data"] as List)
              .map((e) => DropdownProductBrand.fromJson(e))
              .toList();

          uoms = (jsonDecode(uomRes.body)["data"] as List)
              .map((e) => DropdownUnitOfMeasure.fromJson(e))
              .toList();
        });
      }
    } catch (e) {
      debugPrint("Error fetch dropdowns: $e");
    }
  }

  /// 🔹 Submit data create product
  Future<void> submit() async {
    if (!_formKey.currentState!.validate()) return;

    final model = ProductCreateModel(
      productName: _nameController.text,
      productCode: _codeController.text,
      productTypeId: selectedType?.id ?? 0,
      productCategoryId: selectedCategory?.id ?? 0,
      productBrandId: selectedBrand?.id ?? 0,
      unitOfMeasureId: selectedUom?.id ?? 0,
      salesPrice: double.tryParse(_salesPriceController.text) ?? 0,
      costPrice: double.tryParse(_costPriceController.text) ?? 0,
      barcode: _barcodeController.text,
      tracking: tracking ? "Yes" : "No",
      note: _noteController.text,
    );

    final token = await storage.read(key: 'token');
    final url = Uri.parse("${ApiBase.baseUrl}/sales/products/");

    final response = await http.post(url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode(model.toJson()));

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Product created successfully")),
      );
      Navigator.pop(context, true); // balik ke list dengan refresh
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Error: ${response.body}")),
      );
    }
  }

  Widget _buildDropdown<T>(
      String label, List<T> items, T? selected, Function(T?) onChanged) {
    return DropdownButtonFormField<T>(
      decoration: InputDecoration(labelText: label),
      value: selected,
      items: items.map((item) {
        String name = "";
        if (item is DropdownProductType) name = item.name;
        if (item is DropdownProductCategory) name = item.name;
        if (item is DropdownProductBrand) name = item.name;
        if (item is DropdownUnitOfMeasure) name = item.name;

        return DropdownMenuItem<T>(value: item, child: Text(name));
      }).toList(),
      onChanged: onChanged,
      validator: (val) => val == null ? "Required" : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: "Product Name"),
            validator: (val) =>
                val == null || val.isEmpty ? "Required" : null,
          ),
          TextFormField(
            controller: _codeController,
            decoration: const InputDecoration(labelText: "Product Code"),
          ),
          const SizedBox(height: 10),
          _buildDropdown("Product Type", productTypes, selectedType,
              (val) => setState(() => selectedType = val)),
          _buildDropdown("Product Category", categories, selectedCategory,
              (val) => setState(() => selectedCategory = val)),
          _buildDropdown("Product Brand", brands, selectedBrand,
              (val) => setState(() => selectedBrand = val)),
          _buildDropdown("Unit of Measure", uoms, selectedUom,
              (val) => setState(() => selectedUom = val)),
          TextFormField(
            controller: _salesPriceController,
            decoration: const InputDecoration(labelText: "Sales Price"),
            keyboardType: TextInputType.number,
          ),
          TextFormField(
            controller: _costPriceController,
            decoration: const InputDecoration(labelText: "Cost Price"),
            keyboardType: TextInputType.number,
          ),
          TextFormField(
            controller: _barcodeController,
            decoration: const InputDecoration(labelText: "Barcode"),
          ),
          SwitchListTile(
            title: const Text("Tracking"),
            value: tracking,
            onChanged: (val) => setState(() => tracking = val),
          ),
          TextFormField(
            controller: _noteController,
            decoration: const InputDecoration(labelText: "General Notes"),
            maxLines: 3,
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: submit,
            icon: const Icon(Icons.save),
            label: const Text("Save Product"),
          )
        ],
      ),
    );
  }
}
