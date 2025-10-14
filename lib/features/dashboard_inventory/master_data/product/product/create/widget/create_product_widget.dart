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
  final noteDetailCtrl = TextEditingController();
  final weightCtrl = TextEditingController();
  final lengthCtrl = TextEditingController();
  final widthCtrl = TextEditingController();
  final heightCtrl = TextEditingController();
  final volumeCtrl = TextEditingController();
  final noteInventoryCtrl = TextEditingController();

  // State untuk Switches
  bool isSales = true;
  bool isPurchase = true;
  bool isPointOfSale = true;
  bool isDirectPurchase = true;
  bool isExpense = true;
  bool tracking = false;

  // Dropdowns
  DropdownProductType? selectedType;
  DropdownProductCategory? selectedCategory;
  DropdownUnitOfMeasure? selectedUom;
  DropdownProductBrand? selectedBrand;
  String? selectedTrackingMethod;

  List<DropdownProductType> productTypes = [];
  List<DropdownProductCategory> categories = [];
  List<DropdownUnitOfMeasure> uoms = [];
  List<DropdownProductBrand> brands = [];

  final List<Map<String, String>> trackingMethods = [
    {'value': 'lots', 'display': 'By Lots'},
    {'value': 'serial_number', 'display': 'By Serial Number'},
  ];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDropdownData();
  }
  
  // Kode ini sudah dikoreksi untuk memanggil 1 endpoint dan menggunakan key yang benar
  Future<void> _fetchDropdownData() async {
    final token = await storage.read(key: "token");
    final endpoint = "${ApiBase.baseUrl}/inventory/products/create"; 

    try {
      final res = await http.get(
        Uri.parse(endpoint),
        headers: {"Authorization": "Bearer $token"},
      );

      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        final data = body['data']; 
        
        if (data != null) {
          setState(() {
            productTypes = (data['product_types'] as List)
                .map((e) => DropdownProductType.fromJson(e))
                .toList();
            categories = (data['categories'] as List)
                .map((e) => DropdownProductCategory.fromJson(e))
                .toList();
            uoms = (data['uoms'] as List)
                .map((e) => DropdownUnitOfMeasure.fromJson(e))
                .toList();
            brands = (data['brands'] as List)
                .map((e) => DropdownProductBrand.fromJson(e))
                .toList();
          });
        }
      }
    } catch (e) {
      debugPrint("Error fetching dropdown data: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to load initial data: $e")),
        );
      }
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _submitProduct() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    if (selectedType == null ||
        selectedCategory == null ||
        selectedUom == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Pastikan semua dropdown utama terisi")),
      );
      return;
    }

    if (tracking && selectedTrackingMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Jika tracking aktif, metode pelacakan wajib diisi")),
      );
      return;
    }

    final token = await storage.read(key: "token");

    final requestBody = {
      "product_name": nameCtrl.text.trim(),
      "product_code": codeCtrl.text.trim(),
      "sales": isSales,
      "purchase": isPurchase,
      "point_of_sale": isPointOfSale,
      "direct_purchase": isDirectPurchase,
      "expense": isExpense,
      "product_detail": {
        "product_type": selectedType?.id,
        "product_category": selectedCategory?.id,
        "product_brand": selectedBrand?.id,
        "unit_of_measure": selectedUom?.id,
        "sales_price":
            salesPriceCtrl.text.isEmpty ? 0 : double.parse(salesPriceCtrl.text),
        "purchase_price":
            costPriceCtrl.text.isEmpty ? 0 : double.parse(costPriceCtrl.text),
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
        "tracking_method": tracking ? selectedTrackingMethod : "",
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

  Widget _buildSwitch(String title, bool value, ValueChanged<bool> onChanged) {
    return Column(
      children: [
        Text(title, style: const TextStyle(fontSize: 12)),
        Switch(
          value: value,
          onChanged: onChanged,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: "Product Name"),
              validator: (v) => v!.isEmpty ? "Nama produk wajib diisi" : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: codeCtrl,
              decoration: const InputDecoration(labelText: "Product Code"),
              validator: (v) => v!.isEmpty ? "Kode produk wajib diisi" : null,
            ),
            const SizedBox(height: 16),
            Wrap(
              alignment: WrapAlignment.spaceAround,
              children: [
                _buildSwitch("Sales", isSales, (val) => setState(() => isSales = val)),
                _buildSwitch("Purchase", isPurchase, (val) => setState(() => isPurchase = val)),
                _buildSwitch("Point of Sale", isPointOfSale, (val) => setState(() => isPointOfSale = val)),
                _buildSwitch("Direct Purchase", isDirectPurchase, (val) => setState(() => isDirectPurchase = val)),
                _buildSwitch("Expense", isExpense, (val) => setState(() => isExpense = val)),
              ],
            ),
            const Divider(height: 24),

            DropdownButtonFormField<DropdownProductType>(
              value: selectedType,
              items: productTypes.map((t) => DropdownMenuItem(value: t, child: Text(t.name))).toList(),
              onChanged: (val) => setState(() => selectedType = val),
              decoration: const InputDecoration(labelText: "Product Type"),
              validator: (v) => v == null ? "Tipe produk wajib dipilih" : null,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<DropdownProductCategory>(
              value: selectedCategory,
              items: categories.map((c) => DropdownMenuItem(value: c, child: Text(c.name))).toList(),
              onChanged: (val) => setState(() => selectedCategory = val),
              decoration: const InputDecoration(labelText: "Category"),
              validator: (v) => v == null ? "Kategori wajib dipilih" : null,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<DropdownProductBrand>(
              value: selectedBrand,
              items: brands.map((b) => DropdownMenuItem(value: b, child: Text(b.name))).toList(),
              onChanged: (val) => setState(() => selectedBrand = val),
              decoration: const InputDecoration(labelText: "Product Brand"),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<DropdownUnitOfMeasure>(
              value: selectedUom,
              items: uoms.map((u) => DropdownMenuItem(value: u, child: Text(u.name))).toList(),
              onChanged: (val) => setState(() => selectedUom = val),
              decoration: const InputDecoration(labelText: "Unit of Measure"),
              validator: (v) => v == null ? "Satuan unit wajib dipilih" : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: salesPriceCtrl,
              decoration: const InputDecoration(labelText: "Sales Price"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: costPriceCtrl,
              decoration: const InputDecoration(labelText: "Cost Price"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: barcodeCtrl,
              decoration: const InputDecoration(labelText: "Barcode"),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: noteDetailCtrl,
              decoration: const InputDecoration(labelText: "General Notes"),
              maxLines: 2,
            ),
            const Divider(height: 24),
            const Text("Inventory Details", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            SwitchListTile(
              title: const Text("Tracking"),
              value: tracking,
              onChanged: (val) {
                setState(() {
                  tracking = val;
                  if (!val) {
                    selectedTrackingMethod = null;
                  }
                });
              },
            ),
            if (tracking)
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 12.0),
                child: DropdownButtonFormField<String>(
                  value: selectedTrackingMethod,
                  items: trackingMethods.map((method) => DropdownMenuItem(
                        value: method['value'],
                        child: Text(method['display']!),
                      )).toList(),
                  onChanged: (val) => setState(() => selectedTrackingMethod = val),
                  decoration: const InputDecoration(labelText: "Tracking Method"),
                  validator: (v) => v == null ? "Metode pelacakan wajib dipilih" : null,
                ),
              ),
            TextFormField(
              controller: weightCtrl,
              decoration: const InputDecoration(labelText: "Weight"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: lengthCtrl,
              decoration: const InputDecoration(labelText: "Length"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: widthCtrl,
              decoration: const InputDecoration(labelText: "Width"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: heightCtrl,
              decoration: const InputDecoration(labelText: "Height"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: volumeCtrl,
              decoration: const InputDecoration(labelText: "Volume"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: noteInventoryCtrl,
              decoration: const InputDecoration(labelText: "Inventory Notes"),
              maxLines: 2,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submitProduct,
              child: const Text("Create Product"),
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
            ),
          ],
        ),
      ),
    );
  }
}