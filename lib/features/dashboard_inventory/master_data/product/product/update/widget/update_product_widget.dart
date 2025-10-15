import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../../../../services/api_base.dart';

class ProductUpdateWidget extends StatefulWidget {
  final int id;
  const ProductUpdateWidget({super.key, required this.id});

  @override
  State<ProductUpdateWidget> createState() => _ProductUpdateWidgetState();
}

class _ProductUpdateWidgetState extends State<ProductUpdateWidget> {
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

  // Switches / Checkboxes
  bool isSales = false;
  bool isPurchase = false;
  bool isDirectPurchase = false;
  bool isExpense = false;
  bool tracking = false;

  // Tracking method
  String selectedTrackingMethod = '';

  bool loading = false;

  @override
  void initState() {
    super.initState();
    fetchProductDetail();
  }

  Future<void> fetchProductDetail() async {
    final token = await storage.read(key: 'token');
    final url = Uri.parse('${ApiBase.baseUrl}/inventory/products/${widget.id}');
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];

      setState(() {
        nameCtrl.text = data['product_name'] ?? '';
        codeCtrl.text = data['product_code'] ?? '';
        isSales = data['sales'] ?? false;
        isPurchase = data['purchase'] ?? false;
        isDirectPurchase = data['direct_purchase'] ?? false;
        isExpense = data['expense'] ?? false;

        final detail = data['product_detail'] ?? {};
        salesPriceCtrl.text = detail['sales_price']?.toString() ?? '';
        costPriceCtrl.text = detail['purchase_price']?.toString() ?? '';
        barcodeCtrl.text = detail['barcode'] ?? '';
        noteDetailCtrl.text = detail['note_detail'] ?? '';

        final inv = data['inventory'] ?? {};
        weightCtrl.text = inv['weight']?.toString() ?? '';
        lengthCtrl.text = inv['length']?.toString() ?? '';
        widthCtrl.text = inv['width']?.toString() ?? '';
        heightCtrl.text = inv['height']?.toString() ?? '';
        volumeCtrl.text = inv['volume']?.toString() ?? '';
        noteInventoryCtrl.text = inv['note_inventory'] ?? '';
        tracking = inv['tracking'] ?? false;
        selectedTrackingMethod = inv['tracking_method'] ?? '';
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat produk (${response.statusCode})')),
      );
    }
  }

  Future<void> updateProduct() async {
    setState(() => loading = true);
    final token = await storage.read(key: 'token');
    final url = Uri.parse('${ApiBase.baseUrl}/inventory/products/${widget.id}');

    final body = {
      "product_name": nameCtrl.text.trim(),
      "product_code": codeCtrl.text.trim(),
      "sales": isSales,
      "purchase": isPurchase,
      "direct_purchase": isDirectPurchase,
      "expense": isExpense,
      "product_detail": {
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

    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    setState(() => loading = false);

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Produk berhasil diupdate')));
      Navigator.pop(context, true);
    } else {
      final err = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal update: ${err['message']}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ----------- General Section -----------
                const Text(
                  "General Information",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: 'Product Name'),
                ),
                TextField(
                  controller: codeCtrl,
                  decoration: const InputDecoration(labelText: 'Product Code'),
                ),
                TextField(
                  controller: salesPriceCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Sales Price'),
                ),
                TextField(
                  controller: costPriceCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Purchase Price'),
                ),
                TextField(
                  controller: barcodeCtrl,
                  decoration: const InputDecoration(labelText: 'Barcode'),
                ),
                TextField(
                  controller: noteDetailCtrl,
                  decoration: const InputDecoration(labelText: 'Note Detail'),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                const Text("Flags", style: TextStyle(fontWeight: FontWeight.bold)),
                CheckboxListTile(
                  title: const Text('Sales'),
                  value: isSales,
                  onChanged: (v) => setState(() => isSales = v!),
                ),
                CheckboxListTile(
                  title: const Text('Purchase'),
                  value: isPurchase,
                  onChanged: (v) => setState(() => isPurchase = v!),
                ),
                CheckboxListTile(
                  title: const Text('Direct Purchase'),
                  value: isDirectPurchase,
                  onChanged: (v) => setState(() => isDirectPurchase = v!),
                ),
                CheckboxListTile(
                  title: const Text('Expense'),
                  value: isExpense,
                  onChanged: (v) => setState(() => isExpense = v!),
                ),

                const Divider(height: 32, thickness: 1),

                // ----------- Inventory Section -----------
                const Text(
                  "Inventory Details",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: weightCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Weight'),
                ),
                TextField(
                  controller: lengthCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Length'),
                ),
                TextField(
                  controller: widthCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Width'),
                ),
                TextField(
                  controller: heightCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Height'),
                ),
                TextField(
                  controller: volumeCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Volume'),
                ),
                TextField(
                  controller: noteInventoryCtrl,
                  decoration: const InputDecoration(labelText: 'Note Inventory'),
                  maxLines: 2,
                ),
                SwitchListTile(
                  title: const Text('Tracking'),
                  value: tracking,
                  onChanged: (v) => setState(() => tracking = v),
                ),
                if (tracking)
                  TextField(
                    decoration: const InputDecoration(labelText: 'Tracking Method'),
                    onChanged: (val) => selectedTrackingMethod = val,
                    controller:
                        TextEditingController(text: selectedTrackingMethod),
                  ),

                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: loading ? null : updateProduct,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Update Product'),
                ),
              ],
            ),
          );
  }
}
