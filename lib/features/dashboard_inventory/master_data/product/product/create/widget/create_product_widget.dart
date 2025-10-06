import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../../../../services/api_base.dart';
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
  final nameCtrl = TextEditingController();
  final codeCtrl = TextEditingController();
  final salesPriceCtrl = TextEditingController();
  final costPriceCtrl = TextEditingController();
  final barcodeCtrl = TextEditingController();
  final noteDetailCtrl = TextEditingController(); // Deskripsi produk
  final weightCtrl = TextEditingController();
  final lengthCtrl = TextEditingController();
  final widthCtrl = TextEditingController();
  final heightCtrl = TextEditingController();
  final volumeCtrl = TextEditingController();
  final noteInventoryCtrl = TextEditingController();

  // Dropdowns
  DropdownProductType? selectedType;
  DropdownProductCategory? selectedCategory;
  DropdownUnitOfMeasure? selectedUom;

  List<DropdownProductType> productTypes = [];
  List<DropdownProductCategory> categories = [];
  List<DropdownUnitOfMeasure> uoms = [];

  bool isLoadingType = true;
  bool isLoadingCategory = true;
  bool isLoadingUom = true;

  bool tracking = false;

  @override
  void initState() {
    super.initState();
    _fetchProductTypes();
    _fetchCategories();
    _fetchUoms();
  }

  Future<void> _fetchProductTypes() async {
    final token = await storage.read(key: "token");
    try {
      final res = await http.get(
        Uri.parse("${ApiBase.baseUrl}/inventory/product-type/"),
        headers: {"Authorization": "Bearer $token"},
      );

      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        dynamic data;

        if (body is Map && body.containsKey("data")) {
          data = body["data"];
        } else if (body is Map && body.containsKey("result")) {
          data = body["result"];
        } else if (body is List) {
          data = body;
        }

        if (data != null) {
          setState(() {
            productTypes = (data as List)
                .map((e) => DropdownProductType.fromJson(e))
                .toList();
          });
        }
      }
    } catch (e) {
      debugPrint("Error fetch product types: $e");
    } finally {
      setState(() => isLoadingType = false);
    }
  }

  Future<void> _fetchCategories() async {
    final token = await storage.read(key: "token");
    try {
      final res = await http.get(
        Uri.parse("${ApiBase.baseUrl}/inventory/product-category/"),
        headers: {"Authorization": "Bearer $token"},
      );

      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        dynamic data;

        if (body is Map && body.containsKey("data")) {
          data = body["data"];
        } else if (body is Map && body.containsKey("result")) {
          data = body["result"];
        } else if (body is List) {
          data = body;
        }

        if (data != null) {
          setState(() {
            categories = (data as List)
                .map((e) => DropdownProductCategory.fromJson(e))
                .toList();
          });
        }
      }
    } catch (e) {
      debugPrint("Error fetch categories: $e");
    } finally {
      setState(() => isLoadingCategory = false);
    }
  }

  Future<void> _fetchUoms() async {
    final token = await storage.read(key: "token");
    try {
      final res = await http.get(
        Uri.parse("${ApiBase.baseUrl}/master/unit-of-measure"),
        headers: {"Authorization": "Bearer $token"},
      );

      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        final data = body is Map && body.containsKey("data")
            ? body["data"]
            : body;

        if (data != null) {
          setState(() {
            uoms = (data as List)
                .map((e) => DropdownUnitOfMeasure.fromJson(e))
                .toList();
          });
        }
      }
    } catch (e) {
      debugPrint("Error fetch uoms: $e");
    } finally {
      setState(() => isLoadingUom = false);
    }
  }

  Future<void> _submitProduct() async {
    if (!_formKey.currentState!.validate()) return;

    // simpan semua field
    _formKey.currentState!.save();

    if (selectedType == null ||
        selectedCategory == null ||
        selectedUom == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Semua dropdown harus `1 diisi")),
      );
      return;
    }

    final token = await storage.read(key: "token");
    debugPrint("Product Name: ${nameCtrl.text}");
    debugPrint("Product Code: ${codeCtrl.text}");


    final requestBody = {
      "product": {
        "product_name": nameCtrl.text.trim(),
        "product_code": codeCtrl.text.trim(),
        "sales": true,
        "purchase": true,
        "direct": true,
        "expense": true,
      },
      "product_detail": {
        "product_type": selectedType?.id,
        "product_category": selectedCategory?.id,
        "unit_of_measure": selectedUom?.id,
        "sales_price": salesPriceCtrl.text.isEmpty
            ? 0
            : double.parse(salesPriceCtrl.text),
        "purchase_price": costPriceCtrl.text.isEmpty
            ? 0
            : double.parse(costPriceCtrl.text),
        "barcode": barcodeCtrl.text.trim(),
        "note_detail": noteDetailCtrl.text.trim(),
      },
      "inventory": {
        "weight": weightCtrl.text.isEmpty ? 0 : double.parse(weightCtrl.text),
        "length": lengthCtrl.text.isEmpty ? 0 : double.parse(lengthCtrl.text),
        "width": widthCtrl.text.isEmpty ? 0 : double.parse(widthCtrl.text),
        "height": heightCtrl.text.isEmpty ? 0 : double.parse(heightCtrl.text),
        "volume": volumeCtrl.text.isEmpty ? 0 : double.parse(volumeCtrl.text),
        "note_inventory": noteInventoryCtrl.text.trim(),
        "tracking": tracking,
        "tracking_method": null,
      },
    };

    debugPrint(
      "Request Body: ${const JsonEncoder.withIndent('  ').convert(requestBody)}",
    );

    try {
      final response = await http.post(
        Uri.parse("${ApiBase.baseUrl}/inventory/products/store"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(requestBody),
      );

      debugPrint("Response Status: ${response.statusCode}");
      debugPrint("Response Body: ${response.body}");

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (responseData['status'] == 'success') {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                responseData['message'] ?? 'Product created successfully',
              ),
            ),
          );
          Navigator.pop(context, true);
        } else {
          throw Exception(responseData['message'] ?? 'Unknown error occurred');
        }
      } else {
        throw Exception(responseData['message'] ?? 'Failed to create product');
      }
    } catch (e) {
      debugPrint("Error creating product: $e");
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: "Product Name"),
              validator: (v) => v!.isEmpty ? "required" : null,
              onSaved: (v) => nameCtrl.text = v ?? "",
            ),
            TextFormField(
              controller: codeCtrl,
              decoration: const InputDecoration(labelText: "Product Code"),
              validator: (v) => v!.isEmpty ? "required" : null,
              onSaved: (v) => codeCtrl.text = v ?? "",
            ),

            isLoadingType
                ? const CircularProgressIndicator()
                : DropdownButtonFormField<DropdownProductType>(
                    value: selectedType,
                    items: productTypes
                        .map(
                          (t) =>
                              DropdownMenuItem(value: t, child: Text(t.name)),
                        )
                        .toList(),
                    onChanged: (val) => setState(() => selectedType = val),
                    decoration: const InputDecoration(
                      labelText: "Product Type",
                    ),
                    validator: (v) => v == null ? "required" : null,
                  ),
            isLoadingCategory
                ? const CircularProgressIndicator()
                : DropdownButtonFormField<DropdownProductCategory>(
                    value: selectedCategory,
                    items: categories
                        .map(
                          (c) =>
                              DropdownMenuItem(value: c, child: Text(c.name)),
                        )
                        .toList(),
                    onChanged: (val) => setState(() => selectedCategory = val),
                    decoration: const InputDecoration(labelText: "Category"),
                    validator: (v) => v == null ? "required" : null,
                  ),
            isLoadingUom
                ? const CircularProgressIndicator()
                : DropdownButtonFormField<DropdownUnitOfMeasure>(
                    value: selectedUom,
                    items: uoms
                        .map(
                          (u) =>
                              DropdownMenuItem(value: u, child: Text(u.name)),
                        )
                        .toList(),
                    onChanged: (val) => setState(() => selectedUom = val),
                    decoration: const InputDecoration(
                      labelText: "Unit of Measure",
                    ),
                    validator: (v) => v == null ? "required" : null,
                  ),
            TextFormField(
              controller: salesPriceCtrl,
              decoration: const InputDecoration(labelText: "Sales Price"),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: costPriceCtrl,
              decoration: const InputDecoration(labelText: "Cost Price"),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: barcodeCtrl,
              decoration: const InputDecoration(labelText: "Barcode"),
            ),
            TextFormField(
              controller: noteDetailCtrl,
              decoration: const InputDecoration(labelText: "Note Detail"),
              maxLines: 2,
            ),
            SwitchListTile(
              title: const Text("Tracking"),
              value: tracking,
              onChanged: (val) => setState(() => tracking = val),
            ),
            TextFormField(
              controller: weightCtrl,
              decoration: const InputDecoration(labelText: "Weight"),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: lengthCtrl,
              decoration: const InputDecoration(labelText: "Length"),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: widthCtrl,
              decoration: const InputDecoration(labelText: "Width"),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: heightCtrl,
              decoration: const InputDecoration(labelText: "Height"),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: volumeCtrl,
              decoration: const InputDecoration(labelText: "Volume"),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: noteInventoryCtrl,
              decoration: const InputDecoration(labelText: "Note Inventory"),
              maxLines: 2,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitProduct,
              child: const Text("Create Product"),
            ),
          ],
        ),
      ),
    );
  }
}
