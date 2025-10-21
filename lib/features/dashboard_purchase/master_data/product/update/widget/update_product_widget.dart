// Lokasi: lib/.../product/update/widget/update_product_widget.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:equatable/equatable.dart';
import '../../../../../../../services/api_base.dart';
import '../models/update_product_models.dart';

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

  // State
  bool isSales = false;
  bool isPurchase = false;
  bool isPOS = false;
  bool isDirect = false;
  bool isExpense = false;
  bool tracking = false;
  
  // Dropdown Selections
  DropdownProductType? selectedType;
  DropdownProductCategory? selectedCategory;
  DropdownUnitOfMeasure? selectedUom;
  DropdownProductBrand? selectedBrand;
  String? selectedTrackingMethod;
  
  // Dropdown Data Lists
  List<DropdownProductType> productTypes = [];
  List<DropdownProductCategory> categories = [];
  List<DropdownUnitOfMeasure> uoms = [];
  List<DropdownProductBrand> brands = [];
  
  // <-- PERBAIKAN: Sesuaikan nilai 'value' agar cocok dengan JSON baru
  final trackingMethods = [
    {'value': 'lots', 'display': 'By Lots'},
    {'value': 'serial_number', 'display': 'By Serial Number'}, 
  ];

  bool isLoading = true;
  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _fetchAllData();
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    codeCtrl.dispose();
    salesPriceCtrl.dispose();
    costPriceCtrl.dispose();
    purchasePriceCtrl.dispose();
    barcodeCtrl.dispose();
    noteDetailCtrl.dispose();
    weightCtrl.dispose();
    lengthCtrl.dispose();
    widthCtrl.dispose();
    heightCtrl.dispose();
    volumeCtrl.dispose();
    noteInventoryCtrl.dispose();
    super.dispose();
  }

  T? _findDropdownItemById<T extends Equatable>(
    List<T> items, 
    int? id, 
    int Function(T) getId
  ) {
    if (id == null) {
      debugPrint("⚠️  ID is null, returning null");
      return null;
    }
    
    if (items.isEmpty) {
      debugPrint("⚠️  List is empty, returning null");
      return null;
    }
    
    try {
      final found = items.firstWhere((item) => getId(item) == id);
      debugPrint("✅ Found item: $found");
      return found;
    } catch (e) {
      debugPrint("❌ Item with id=$id NOT FOUND in list");
      return null;
    }
  }

  Future<void> _fetchAllData() async {
    setState(() => isLoading = true);
    
    try {
      debugPrint("📥 Step 1: Fetching dropdown data...");
      await _fetchDropdownData();
      
      debugPrint("📥 Step 2: Fetching product detail...");
      if (mounted) {
        await _fetchProductDetail();
      }
      
      debugPrint("✅ All data fetched successfully");
    } catch (e) {
      debugPrint("❌ Error during initial data fetch: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error fetching data: ${e.toString()}"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> _fetchDropdownData() async {
    try {
      final token = await storage.read(key: "token");
      if (token == null) throw Exception("Token not found");
      
      final endpoint = "${ApiBase.baseUrl}/inventory/products/create";
      debugPrint("🌐 Fetching from: $endpoint");
      
      final res = await http.get(
        Uri.parse(endpoint),
        headers: {"Authorization": "Bearer $token"}
      ).timeout(const Duration(seconds: 10));

      debugPrint("📡 Response status: ${res.statusCode}");

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body)['data'];
        
        final types = (data['product_types'] as List)
            .map((e) => DropdownProductType.fromJson(e))
            .toList();
        final cats = (data['categories'] as List)
            .map((e) => DropdownProductCategory.fromJson(e))
            .toList();
        final uomsList = (data['uoms'] as List)
            .map((e) => DropdownUnitOfMeasure.fromJson(e))
            .toList();
        final brandsList = (data['brands'] as List)
            .map((e) => DropdownProductBrand.fromJson(e))
            .toList();
        
        setState(() {
          productTypes = types;
          categories = cats;
          uoms = uomsList;
          brands = brandsList;
        });
        
        debugPrint("✅ Dropdown loaded: ${types.length} types, ${cats.length} categories, ${uomsList.length} uoms, ${brandsList.length} brands");
      } else {
        throw Exception('Failed to load dropdown data: ${res.statusCode}');
      }
    } catch (e) {
      debugPrint("❌ Error fetching dropdown: $e");
      rethrow;
    }
  }
  
  Future<void> _fetchProductDetail() async {
    try {
      final token = await storage.read(key: "token");
      if (token == null) throw Exception("Token not found");
      
      final endpoint = "${ApiBase.baseUrl}/inventory/products/${widget.id}";
      debugPrint("🌐 Fetching product from: $endpoint");

      final res = await http.get(
        Uri.parse(endpoint),
        headers: {"Authorization": "Bearer $token"}
      ).timeout(const Duration(seconds: 10));

      debugPrint("📡 Response status: ${res.statusCode}");

      if (res.statusCode == 200) {
        final responseBody = jsonDecode(res.body);
        final data = responseBody['data'];
        
        final product = ProductData.fromJson(data['product']);
        final detail = ProductDetailData.fromJson(data['product_detail']);
        final inv = InventoryData.fromJson(data['inventory']);

        final foundType = _findDropdownItemById(productTypes, detail.productType, (e) => e.id);
        final foundCategory = _findDropdownItemById(categories, detail.productCategory, (e) => e.id);
        final foundBrand = _findDropdownItemById(brands, detail.productBrand, (e) => e.id);
        final foundUom = _findDropdownItemById(uoms, detail.unitOfMeasure, (e) => e.id);
        
        if (mounted) {
          setState(() {
            nameCtrl.text = product.productName;
            codeCtrl.text = product.productCode;
            salesPriceCtrl.text = (detail.salesPrice ?? 0).toString();
            purchasePriceCtrl.text = (detail.purchasePrice ?? 0).toString();
            costPriceCtrl.text = (detail.costPrice ?? 0).toString();
            barcodeCtrl.text = detail.barcode ?? '';
            noteDetailCtrl.text = detail.noteDetail ?? '';
            weightCtrl.text = (inv.weight ?? 0).toString();
            lengthCtrl.text = (inv.length ?? 0).toString();
            widthCtrl.text = (inv.width ?? 0).toString();
            heightCtrl.text = (inv.height ?? 0).toString();
            volumeCtrl.text = (inv.volume ?? 0).toString();
            noteInventoryCtrl.text = inv.noteInventory ?? '';

            // Mengisi state untuk Switch
            isSales = product.sales;
            isPurchase = product.purchase;
            isDirect = product.directPurchase;
            isExpense = product.expense;
            isPOS = product.pos; 
            tracking = inv.tracking ?? false;
            
            // Mengisi state untuk Dropdown
            selectedType = foundType;
            selectedCategory = foundCategory;
            selectedBrand = foundBrand;
            selectedUom = foundUom;
            
            // Tracking method
            if (tracking && inv.trackingMethod != null) {
              final methodExists = trackingMethods.any(
                (m) => m['value'] == inv.trackingMethod
              );
              selectedTrackingMethod = methodExists ? inv.trackingMethod : null;
            } else {
              selectedTrackingMethod = null;
            }
          });
          
          debugPrint("✅ State updated successfully");
        }
      } else {
        final errorBody = jsonDecode(res.body);
        throw Exception('Failed to load product: ${errorBody['message'] ?? res.statusCode}');
      }
    } catch (e) {
      debugPrint("❌ Error fetching product detail: $e");
      rethrow;
    }
  }

  Future<void> _updateProduct() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => isSubmitting = true);
    
    try {
      final token = await storage.read(key: "token");
      if (token == null) throw Exception("Token not found");

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

      debugPrint("📤 Sending update request...");
      debugPrint("Body: ${jsonEncode(body)}");

      final res = await http.put(
        Uri.parse("${ApiBase.baseUrl}/inventory/products/${widget.id}"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json"
        },
        body: jsonEncode(body),
      ).timeout(const Duration(seconds: 15));

      final json = jsonDecode(res.body);
      
      if (!mounted) return;

      if (res.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(json['message'] ?? "Produk berhasil diperbarui"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      } else {
        throw Exception(json['message'] ?? 'Gagal memperbarui produk');
      }
    } catch (e) {
      debugPrint("❌ Update error: $e");
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Update Product")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: nameCtrl,
                      decoration: const InputDecoration(labelText: "Product Name"),
                      validator: (v) => v!.isEmpty ? "Wajib diisi" : null
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: codeCtrl,
                      decoration: const InputDecoration(labelText: "Product Code")
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
                      ]
                    ),
                    const Divider(),
                    DropdownButtonFormField<DropdownProductType>(
                      value: selectedType,
                      items: productTypes.map((t) => DropdownMenuItem(
                        value: t,
                        child: Text(t.name)
                      )).toList(),
                      onChanged: (val) => setState(() => selectedType = val),
                      decoration: const InputDecoration(labelText: "Product Type")
                    ),
                    DropdownButtonFormField<DropdownProductCategory>(
                      value: selectedCategory,
                      items: categories.map((c) => DropdownMenuItem(
                        value: c,
                        child: Text(c.name)
                      )).toList(),
                      onChanged: (val) => setState(() => selectedCategory = val),
                      decoration: const InputDecoration(labelText: "Category")
                    ),
                    DropdownButtonFormField<DropdownProductBrand>(
                      value: selectedBrand,
                      items: brands.map((b) => DropdownMenuItem(
                        value: b,
                        child: Text(b.name)
                      )).toList(),
                      onChanged: (val) => setState(() => selectedBrand = val),
                      decoration: const InputDecoration(labelText: "Brand")
                    ),
                    DropdownButtonFormField<DropdownUnitOfMeasure>(
                      value: selectedUom,
                      items: uoms.map((u) => DropdownMenuItem(
                        value: u,
                        child: Text(u.name)
                      )).toList(),
                      onChanged: (val) => setState(() => selectedUom = val),
                      decoration: const InputDecoration(labelText: "UOM")
                    ),
                    TextFormField(
                      controller: salesPriceCtrl,
                      decoration: const InputDecoration(labelText: "Sales Price"),
                      keyboardType: TextInputType.number
                    ),
                    TextFormField(
                      controller: purchasePriceCtrl,
                      decoration: const InputDecoration(labelText: "Purchase Price"),
                      keyboardType: TextInputType.number
                    ),
                    TextFormField(
                      controller: costPriceCtrl,
                      decoration: const InputDecoration(labelText: "Cost Price"),
                      keyboardType: TextInputType.number
                    ),
                    TextFormField(
                      controller: barcodeCtrl,
                      decoration: const InputDecoration(labelText: "Barcode")
                    ),
                    TextFormField(
                      controller: noteDetailCtrl,
                      decoration: const InputDecoration(labelText: "General Notes"),
                      maxLines: 2
                    ),
                    const Divider(),
                    SwitchListTile(
                      title: const Text("Tracking"),
                      value: tracking,
                      onChanged: (v) => setState(() {
                        tracking = v;
                        if (!v) selectedTrackingMethod = null;
                      })
                    ),
                    if (tracking)
                      DropdownButtonFormField<String>(
                        value: selectedTrackingMethod,
                        items: trackingMethods.map((m) => DropdownMenuItem(
                          value: m['value'],
                          child: Text(m['display']!)
                        )).toList(),
                        onChanged: (v) => setState(() => selectedTrackingMethod = v),
                        decoration: const InputDecoration(labelText: "Tracking Method")
                      ),
                    TextFormField(
                      controller: weightCtrl,
                      decoration: const InputDecoration(labelText: "Weight (kg)"),
                      keyboardType: TextInputType.number
                    ),
                    TextFormField(
                      controller: lengthCtrl,
                      decoration: const InputDecoration(labelText: "Length (cm)"),
                      keyboardType: TextInputType.number
                    ),
                    TextFormField(
                      controller: widthCtrl,
                      decoration: const InputDecoration(labelText: "Width (cm)"),
                      keyboardType: TextInputType.number
                    ),
                    TextFormField(
                      controller: heightCtrl,
                      decoration: const InputDecoration(labelText: "Height (cm)"),
                      keyboardType: TextInputType.number
                    ),
                    TextFormField(
                      controller: volumeCtrl,
                      decoration: const InputDecoration(labelText: "Volume (cm³)")
                    ),
                    TextFormField(
                      controller: noteInventoryCtrl,
                      decoration: const InputDecoration(labelText: "Inventory Notes")
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: isSubmitting ? null : _updateProduct,
                      child: isSubmitting
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                color: Colors.white,
                              )
                            )
                          : const Text("Update Product"),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSwitch(String title, bool value, ValueChanged<bool> onChanged) {
    return Column(
      children: [
        Text(title, style: const TextStyle(fontSize: 12)),
        Switch(value: value, onChanged: onChanged)
      ]
    );
  }
}