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
  final noteCtrl = TextEditingController();

  // Dropdowns
  DropdownProductType? selectedType;
  DropdownProductCategory? selectedCategory;
  DropdownProductBrand? selectedBrand;
  DropdownUnitOfMeasure? selectedUom;

  List<DropdownProductType> productTypes = [];
  List<DropdownProductCategory> categories = [];
  List<DropdownProductBrand> brands = [];
  List<DropdownUnitOfMeasure> uoms = [];

  bool isLoadingType = true;
  bool isLoadingCategory = true;
  bool isLoadingBrand = true;
  bool isLoadingUom = true;

  bool tracking = false;

  @override
  void initState() {
    super.initState();
    _fetchProductTypes();
    _fetchCategories();
    _fetchBrands();
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

      // Coba ambil sesuai struktur kemungkinan
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


Future<void> _fetchBrands() async {
  final token = await storage.read(key: "token");
  try {
    final res = await http.get(
      Uri.parse("${ApiBase.baseUrl}/inventory/brand/"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (res.statusCode == 200) {
      final body = jsonDecode(res.body);
      final data = body is Map && body.containsKey("data") ? body["data"] : body;

      if (data != null) {
        setState(() {
          brands = (data as List)
              .map((e) => DropdownProductBrand.fromJson(e))
              .toList();
        });
      }
    }
  } catch (e) {
    debugPrint("Error fetch brands: $e");
  } finally {
    setState(() => isLoadingBrand = false);
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
      final data = body is Map && body.containsKey("data") ? body["data"] : body;

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

  if (selectedType == null ||
      selectedCategory == null ||
      selectedBrand == null ||
      selectedUom == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Semua dropdown wajib dipilih")),
    );
    return;
  }

  final token = await storage.read(key: "token");

 final requestBody = {
  "product_name": nameCtrl.text,
  "product_code": codeCtrl.text,
  "id_product_type": selectedType!.id,
  "id_product_category": selectedCategory!.id,
  "id_product_brand": selectedBrand!.id,
  "id_unit_of_measure": selectedUom!.id,
  "sales_price": double.tryParse(salesPriceCtrl.text) ?? 0,
  "purchase_price": double.tryParse(costPriceCtrl.text) ?? 0,
  "barcode": barcodeCtrl.text,
  "tracking": tracking ? "Yes" : "No",
  "note": noteCtrl.text,
};


  debugPrint("Request Body: ${jsonEncode(requestBody)}");

  try {
    final res = await http.post(
      // 🔥 tanpa trailing slash
      Uri.parse("${ApiBase.baseUrl}/products/store"),
      headers: {
        "Authorization":
            token != null && token.isNotEmpty ? "Bearer $token" : "",
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode(requestBody),
    );

    debugPrint("Response Code: ${res.statusCode}");
    debugPrint("Response Body: ${res.body}");

    if (res.statusCode == 200 || res.statusCode == 201) {
      final body = jsonDecode(res.body);

      // ✅ Sesuai API kamu: "status": "success"
      if (body is Map && body["status"] == "success") {
        final msg = body["message"] ?? "Produk berhasil dibuat";

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(msg.toString())));

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) Navigator.pop(context, true);
        });
      } else {
        final errMsg = body is Map && body["message"] != null
            ? body["message"].toString()
            : "Gagal membuat produk";

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal membuat produk: $errMsg")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Request gagal. Code: ${res.statusCode}")),
      );
    }
  } catch (e) {
    debugPrint("Error: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Terjadi error: $e")),
    );
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
            ),
            TextFormField(
              controller: codeCtrl,
              decoration: const InputDecoration(labelText: "Product Code"),
            ),
            isLoadingType
                ? const CircularProgressIndicator()
                : DropdownButtonFormField<DropdownProductType>(
                    value: selectedType,
                    items: productTypes
                        .map((t) => DropdownMenuItem(
                              value: t,
                              child: Text(t.name),
                            ))
                        .toList(),
                    onChanged: (val) => setState(() => selectedType = val),
                    decoration: const InputDecoration(labelText: "Product Type"),
                    validator: (v) => v == null ? "required" : null,
                  ),
            isLoadingCategory
                ? const CircularProgressIndicator()
                : DropdownButtonFormField<DropdownProductCategory>(
                    value: selectedCategory,
                    items: categories
                        .map((c) => DropdownMenuItem(
                              value: c,
                              child: Text(c.name),
                            ))
                        .toList(),
                    onChanged: (val) => setState(() => selectedCategory = val),
                    decoration: const InputDecoration(labelText: "Category"),
                    validator: (v) => v == null ? "required" : null,
                  ),
            isLoadingBrand
                ? const CircularProgressIndicator()
                : DropdownButtonFormField<DropdownProductBrand>(
                    value: selectedBrand,
                    items: brands
                        .map((b) => DropdownMenuItem(
                              value: b,
                              child: Text(b.name),
                            ))
                        .toList(),
                    onChanged: (val) => setState(() => selectedBrand = val),
                    decoration: const InputDecoration(labelText: "Brand"),
                    validator: (v) => v == null ? "required" : null,
                  ),
            isLoadingUom
                ? const CircularProgressIndicator()
                : DropdownButtonFormField<DropdownUnitOfMeasure>(
                    value: selectedUom,
                    items: uoms
                        .map((u) => DropdownMenuItem(
                              value: u,
                              child: Text(u.name),
                            ))
                        .toList(),
                    onChanged: (val) => setState(() => selectedUom = val),
                    decoration: const InputDecoration(labelText: "Unit of Measure"),
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
            SwitchListTile(
              title: const Text("Tracking"),
              value: tracking,
              onChanged: (val) => setState(() => tracking = val),
            ),
            TextFormField(
              controller: noteCtrl,
              decoration: const InputDecoration(labelText: "Notes"),
              maxLines: 3,
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
