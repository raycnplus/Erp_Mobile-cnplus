import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
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

  // Switches
  bool isSales = false;
  bool isPurchase = false;
  bool isPOS = false;
  bool isDirect = false;
  bool isExpense = false;
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

  final trackingMethods = [
    {'value': 'lots', 'display': 'By Lots'},
    {'value': 'serial_number', 'display': 'By Serial Number'},
  ];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAllData();
  }

  Future<void> _fetchAllData() async {
    await Future.wait([_fetchDropdownData(), _fetchProductDetail()]);
  }

  Future<void> _fetchDropdownData() async {
    final token = await storage.read(key: "token");
    final endpoint = "${ApiBase.baseUrl}/inventory/products/create";

    try {
      final res = await http.get(Uri.parse(endpoint), headers: {
        "Authorization": "Bearer $token",
      });

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body)['data'];
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
    } catch (e) {
      debugPrint("Error fetch dropdown: $e");
    }
  }

  Future<void> _fetchProductDetail() async {
    final token = await storage.read(key: "token");
    final endpoint = "${ApiBase.baseUrl}/inventory/products/${widget.id}";

    try {
      final res = await http.get(Uri.parse(endpoint), headers: {
        "Authorization": "Bearer $token",
      });

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body)['data'];
        final product = data['product'];
        final detail = data['product_detail'];
        final inv = data['inventory'];

        setState(() {
          nameCtrl.text = product['product_name'] ?? '';
          codeCtrl.text = product['product_code'] ?? '';
          barcodeCtrl.text = detail['barcode'] ?? '';
          noteDetailCtrl.text = detail['note_detail'] ?? '';
          noteInventoryCtrl.text = inv['note_inventory'] ?? '';

          salesPriceCtrl.text = (detail['sales_price'] ?? 0).toString();
          costPriceCtrl.text = (detail['cost_price'] ?? 0).toString();
          purchasePriceCtrl.text = (detail['purchase_price'] ?? 0).toString();

          weightCtrl.text = (inv['weight'] ?? '').toString();
          lengthCtrl.text = (inv['length'] ?? '').toString();
          widthCtrl.text = (inv['width'] ?? '').toString();
          heightCtrl.text = (inv['height'] ?? '').toString();
          volumeCtrl.text = (inv['volume'] ?? '').toString();

          isSales = product['sales'] ?? false;
          isPurchase = product['purchase'] ?? false;
          isPOS = product['pos'] == 1;
          isDirect = product['direct'] ?? false;
          isExpense = product['expense'] ?? false;
          tracking = inv['tracking'] ?? false;
          selectedTrackingMethod = inv['tracking_method'];

          selectedType = productTypes.firstWhere(
              (t) => t.id == detail['product_type'],
              orElse: () => productTypes.first);
          selectedCategory = categories.firstWhere(
              (c) => c.id == detail['product_category'],
              orElse: () => categories.first);
          selectedBrand = brands.firstWhere(
              (b) => b.id == detail['product_brand'],
              orElse: () => brands.isNotEmpty ? brands.first : DropdownProductBrand(id: 0, name: "-"));
          selectedUom = uoms.firstWhere(
              (u) => u.id == detail['unit_of_measure'],
              orElse: () => uoms.first);
        });
      }
    } catch (e) {
      debugPrint("Error fetch detail: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _updateProduct() async {
    if (!_formKey.currentState!.validate()) return;
    final token = await storage.read(key: "token");

    final body = {
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
        "barcode": barcodeCtrl.text,
        "note_detail": noteDetailCtrl.text,
      },
      "inventory": {
        "weight": double.tryParse(weightCtrl.text) ?? 0,
        "length": double.tryParse(lengthCtrl.text) ?? 0,
        "width": double.tryParse(widthCtrl.text) ?? 0,
        "height": double.tryParse(heightCtrl.text) ?? 0,
        "volume": double.tryParse(volumeCtrl.text) ?? 0,
        "note_inventory": noteInventoryCtrl.text,
        "tracking": tracking,
        "tracking_method": tracking ? selectedTrackingMethod : null,
      },
    };

    try {
      final res = await http.put(
        Uri.parse("${ApiBase.baseUrl}/inventory/products/${widget.id}"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode(body),
      );

      final json = jsonDecode(res.body);
      if (res.statusCode == 200 && json['status'] == 'success') {
        if (!mounted) return;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(json['message'])));
        Navigator.pop(context, true);
      } else {
        throw Exception(json['message']);
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  Widget _buildSwitch(String title, bool value, ValueChanged<bool> onChanged) {
    return Column(
      children: [
        Text(title, style: const TextStyle(fontSize: 12)),
        Switch(value: value, onChanged: onChanged),
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
              validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: codeCtrl,
              decoration: const InputDecoration(labelText: "Product Code"),
            ),
            const SizedBox(height: 12),
            Wrap(
              alignment: WrapAlignment.spaceAround,
              children: [
                _buildSwitch("Sales", isSales, (v) => setState(() => isSales = v)),
                _buildSwitch("Purchase", isPurchase, (v) => setState(() => isPurchase = v)),
                _buildSwitch("POS", isPOS, (v) => setState(() => isPOS = v)),
                _buildSwitch("Direct", isDirect, (v) => setState(() => isDirect = v)),
                _buildSwitch("Expense", isExpense, (v) => setState(() => isExpense = v)),
              ],
            ),
            const Divider(),
            DropdownButtonFormField<DropdownProductType>(
              value: selectedType,
              items: productTypes.map((t) => DropdownMenuItem(value: t, child: Text(t.name))).toList(),
              onChanged: (val) => setState(() => selectedType = val),
              decoration: const InputDecoration(labelText: "Product Type"),
            ),
            DropdownButtonFormField<DropdownProductCategory>(
              value: selectedCategory,
              items: categories.map((c) => DropdownMenuItem(value: c, child: Text(c.name))).toList(),
              onChanged: (val) => setState(() => selectedCategory = val),
              decoration: const InputDecoration(labelText: "Category"),
            ),
            DropdownButtonFormField<DropdownProductBrand>(
              value: selectedBrand,
              items: brands.map((b) => DropdownMenuItem(value: b, child: Text(b.name))).toList(),
              onChanged: (val) => setState(() => selectedBrand = val),
              decoration: const InputDecoration(labelText: "Brand"),
            ),
            DropdownButtonFormField<DropdownUnitOfMeasure>(
              value: selectedUom,
              items: uoms.map((u) => DropdownMenuItem(value: u, child: Text(u.name))).toList(),
              onChanged: (val) => setState(() => selectedUom = val),
              decoration: const InputDecoration(labelText: "UOM"),
            ),
            TextFormField(controller: salesPriceCtrl, decoration: const InputDecoration(labelText: "Sales Price")),
            TextFormField(controller: purchasePriceCtrl, decoration: const InputDecoration(labelText: "Purchase Price")),
            TextFormField(controller: barcodeCtrl, decoration: const InputDecoration(labelText: "Barcode")),
            TextFormField(controller: noteDetailCtrl, decoration: const InputDecoration(labelText: "Notes"), maxLines: 2),
            const Divider(),
            SwitchListTile(
              title: const Text("Tracking"),
              value: tracking,
              onChanged: (v) => setState(() {
                tracking = v;
                if (!v) selectedTrackingMethod = null;
              }),
            ),
            if (tracking)
              DropdownButtonFormField<String>(
                value: selectedTrackingMethod,
                items: trackingMethods.map((m) => DropdownMenuItem(value: m['value'], child: Text(m['display']!))).toList(),
                onChanged: (v) => setState(() => selectedTrackingMethod = v),
                decoration: const InputDecoration(labelText: "Tracking Method"),
              ),
            TextFormField(controller: weightCtrl, decoration: const InputDecoration(labelText: "Weight")),
            TextFormField(controller: lengthCtrl, decoration: const InputDecoration(labelText: "Length")),
            TextFormField(controller: widthCtrl, decoration: const InputDecoration(labelText: "Width")),
            TextFormField(controller: heightCtrl, decoration: const InputDecoration(labelText: "Height")),
            TextFormField(controller: volumeCtrl, decoration: const InputDecoration(labelText: "Volume")),
            TextFormField(controller: noteInventoryCtrl, decoration: const InputDecoration(labelText: "Inventory Notes")),
            const SizedBox(height: 24),
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
