// Ganti seluruh isi file: lib/.../product/create/widget/create_product_widget.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../../../../services/api_base.dart';
import '../models/create_product_models.dart'; // Pastikan path ini benar

class ProductCreateWidget extends StatefulWidget {
  const ProductCreateWidget({super.key});

  @override
  State<ProductCreateWidget> createState() => _ProductCreateWidgetState();
}

class _ProductCreateWidgetState extends State<ProductCreateWidget> {
  final _formKey = GlobalKey<FormState>();
  final storage = const FlutterSecureStorage();

  final nameCtrl = TextEditingController();
  final codeCtrl = TextEditingController();
  final salesPriceCtrl = TextEditingController();
  final costPriceCtrl = TextEditingController();
  final purchasePriceCtrl = TextEditingController();
  final barcodeCtrl = TextEditingController();
  final noteDetailCtrl = TextEditingController();
  final weightCtrl = TextEditingController();
  final lengthCtrl = TextEditingController();
  final widthCtrl = TextEditingController();
  final heightCtrl = TextEditingController();
  final volumeCtrl = TextEditingController();
  final noteInventoryCtrl = TextEditingController();

  bool isSales = false;
  bool isPurchase = false;
  bool isPOS = false;
  bool isDirect = false;
  bool isExpense = false;
  bool tracking = false;

  DropdownProductType? selectedType;
  DropdownProductCategory? selectedCategory;
  DropdownProductBrand? selectedBrand;
  DropdownUnitOfMeasure? selectedUom;
  String? selectedTrackingMethod;

  List<DropdownProductType> productTypes = [];
  List<DropdownProductCategory> categories = [];
  List<DropdownProductBrand> brands = [];
  List<DropdownUnitOfMeasure> uoms = [];

  final trackingMethods = [
    {'value': 'lots', 'display': 'By Lots'},
    {'value': 'serial_number', 'display': 'By Serial Number'},
  ];

  bool isLoading = true;
  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _fetchDropdownData();
  }

  Future<void> _fetchDropdownData() async {
    setState(() => isLoading = true);
    final token = await storage.read(key: "token");
    final endpoint = "${ApiBase.baseUrl}/inventory/products/create";

    try {
      final res = await http.get(Uri.parse(endpoint), headers: {"Authorization": "Bearer $token"});
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body)['data'];
        if (mounted) {
          setState(() {
            productTypes = (data['product_types'] as List).map((e) => DropdownProductType.fromJson(e)).toList();
            categories = (data['categories'] as List).map((e) => DropdownProductCategory.fromJson(e)).toList();
            uoms = (data['uoms'] as List).map((e) => DropdownUnitOfMeasure.fromJson(e)).toList();
            brands = (data['brands'] as List).map((e) => DropdownProductBrand.fromJson(e)).toList();
          });
        }
      } else {
        throw Exception('Gagal memuat data dropdown');
      }
    } catch (e) {
      if(mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}"), backgroundColor: Colors.red));
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> _submitProduct() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => isSubmitting = true);

    final token = await storage.read(key: "token");

    final requestBody = {
      "product_name": nameCtrl.text.trim(),
      "product_code": codeCtrl.text.trim(),
      "sales": isSales,
      "purchase": isPurchase,
      "point_of_sale": isPOS,
      "direct_purchase": isDirect,
      "expense": isExpense,
      "product_detail": {
        "product_type": selectedType?.id,
        "product_category": selectedCategory?.id,
        "product_brand": selectedBrand?.id,
        "unit_of_measure": selectedUom?.id,
        "sales_price": double.tryParse(salesPriceCtrl.text) ?? 0,
        "purchase_price": double.tryParse(purchasePriceCtrl.text) ?? 0,
        "cost_price": double.tryParse(costPriceCtrl.text) ?? 0,
        "barcode": barcodeCtrl.text.trim(),
        "note_detail": noteDetailCtrl.text.trim(),
      },
      "inventory": {
        "weight": double.tryParse(weightCtrl.text) ?? 0,
        "length": double.tryParse(lengthCtrl.text) ?? 0,
        "width": double.tryParse(widthCtrl.text) ?? 0,
        "height": double.tryParse(heightCtrl.text) ?? 0,
        "volume": double.tryParse(volumeCtrl.text) ?? 0,
        "note_inventory": noteInventoryCtrl.text.trim(),
        "tracking": tracking,
        "tracking_method": tracking ? selectedTrackingMethod : null,
      },
    };

    try {
      final res = await http.post(
        Uri.parse("${ApiBase.baseUrl}/inventory/products/"),
        headers: {"Authorization": "Bearer $token", "Content-Type": "application/json", "Accept": "application/json"},
        body: jsonEncode(requestBody),
      );

      final body = jsonDecode(res.body);
      if (!mounted) return;

      if (res.statusCode == 201 || res.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(body['message'] ?? "Produk berhasil dibuat"), backgroundColor: Colors.green));
        Navigator.pop(context, true);
      } else {
        throw Exception(body['message'] ?? 'Gagal membuat produk');
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Terjadi error: $e"), backgroundColor: Colors.red));
    } finally {
      if(mounted) setState(() => isSubmitting = false);
    }
  }

  Widget _buildSwitch(String title, bool value, ValueChanged<bool> onChanged) {
    return Column(children: [Text(title, style: const TextStyle(fontSize: 12)), Switch(value: value, onChanged: onChanged)]);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    // ✅ UI LENGKAP DITAMBAHKAN DI SINI
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(controller: nameCtrl, decoration: const InputDecoration(labelText: "Product Name"), validator: (v) => v!.isEmpty ? "Wajib diisi" : null),
            const SizedBox(height: 12),
            TextFormField(controller: codeCtrl, decoration: const InputDecoration(labelText: "Product Code")),
            const SizedBox(height: 12),
            Wrap(alignment: WrapAlignment.spaceAround, children: [
              _buildSwitch("Sales", isSales, (v) => setState(() => isSales = v)),
              _buildSwitch("Purchase", isPurchase, (v) => setState(() => isPurchase = v)),
              _buildSwitch("POS", isPOS, (v) => setState(() => isPOS = v)),
              _buildSwitch("Direct", isDirect, (v) => setState(() => isDirect = v)),
              _buildSwitch("Expense", isExpense, (v) => setState(() => isExpense = v)),
            ]),
            const Divider(),
            DropdownButtonFormField<DropdownProductType>(value: selectedType, items: productTypes.map((t) => DropdownMenuItem(value: t, child: Text(t.name))).toList(), onChanged: (val) => setState(() => selectedType = val), decoration: const InputDecoration(labelText: "Product Type")),
            DropdownButtonFormField<DropdownProductCategory>(value: selectedCategory, items: categories.map((c) => DropdownMenuItem(value: c, child: Text(c.name))).toList(), onChanged: (val) => setState(() => selectedCategory = val), decoration: const InputDecoration(labelText: "Category")),
            DropdownButtonFormField<DropdownProductBrand>(value: selectedBrand, items: brands.map((b) => DropdownMenuItem(value: b, child: Text(b.name))).toList(), onChanged: (val) => setState(() => selectedBrand = val), decoration: const InputDecoration(labelText: "Brand")),
            DropdownButtonFormField<DropdownUnitOfMeasure>(value: selectedUom, items: uoms.map((u) => DropdownMenuItem(value: u, child: Text(u.name))).toList(), onChanged: (val) => setState(() => selectedUom = val), decoration: const InputDecoration(labelText: "UOM")),
            TextFormField(controller: salesPriceCtrl, decoration: const InputDecoration(labelText: "Sales Price"), keyboardType: TextInputType.number),
            TextFormField(controller: purchasePriceCtrl, decoration: const InputDecoration(labelText: "Purchase Price"), keyboardType: TextInputType.number),
            TextFormField(controller: costPriceCtrl, decoration: const InputDecoration(labelText: "Cost Price"), keyboardType: TextInputType.number),
            TextFormField(controller: barcodeCtrl, decoration: const InputDecoration(labelText: "Barcode")),
            TextFormField(controller: noteDetailCtrl, decoration: const InputDecoration(labelText: "General Notes"), maxLines: 2),
            const Divider(),
            SwitchListTile(title: const Text("Tracking"), value: tracking, onChanged: (v) => setState(() { tracking = v; if (!v) selectedTrackingMethod = null; })),
            if (tracking)
              DropdownButtonFormField<String>(value: selectedTrackingMethod, items: trackingMethods.map((m) => DropdownMenuItem(value: m['value'], child: Text(m['display']!))).toList(), onChanged: (v) => setState(() => selectedTrackingMethod = v), decoration: const InputDecoration(labelText: "Tracking Method")),
            TextFormField(controller: weightCtrl, decoration: const InputDecoration(labelText: "Weight (kg)"), keyboardType: TextInputType.number),
            TextFormField(controller: lengthCtrl, decoration: const InputDecoration(labelText: "Length (cm)"), keyboardType: TextInputType.number),
            TextFormField(controller: widthCtrl, decoration: const InputDecoration(labelText: "Width (cm)"), keyboardType: TextInputType.number),
            TextFormField(controller: heightCtrl, decoration: const InputDecoration(labelText: "Height (cm)"), keyboardType: TextInputType.number),
            TextFormField(controller: volumeCtrl, decoration: const InputDecoration(labelText: "Volume (cm³)"), keyboardType: TextInputType.number),
            TextFormField(controller: noteInventoryCtrl, decoration: const InputDecoration(labelText: "Inventory Notes")),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: isSubmitting ? null : _submitProduct,
              child: isSubmitting
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 3))
                  : const Text("Create Product"),
            ),
          ],
        ),
      ),
    );
  }
}