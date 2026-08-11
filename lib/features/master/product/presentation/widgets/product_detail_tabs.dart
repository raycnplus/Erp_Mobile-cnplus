import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:erp_mobile_cnplus/features/master/product/data/models/product_models.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/shared/helpers/formatters.dart';

class ProductDetailTabs extends StatefulWidget {
  final ProductDetailModel productDetail;
  const ProductDetailTabs({super.key, required this.productDetail});

  @override
  State<ProductDetailTabs> createState() => _ProductDetailTabsState();
}

class _ProductDetailTabsState extends State<ProductDetailTabs>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _formatDate(String? d) {
    if (d == null || d.isEmpty) return '-';
    try {
      return DateFormat('d MMMM yyyy, hh:mm a').format(DateTime.parse(d));
    } catch (_) { return d; }
  }

  String _safe(dynamic v, [String suffix = '']) {
    if (v == null || v.toString().isEmpty) return '-';
    return '${v.toString()}$suffix';
  }

  String _safeNum(dynamic v, [String suffix = '']) {
    if (v == null) return '-';
    final n = num.tryParse(v.toString());
    if (n == null || n == 0) return '-';
    return '${v.toString()}$suffix';
  }

  String _trackingLabel(String? m) {
    switch (m) {
      case 'lots': return 'By Lots';
      case 'serial_number': return 'By Serial Number';
      default: return '-';
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.productDetail.product;
    final d = widget.productDetail.productDetail;
    final i = widget.productDetail.inventory;
    final det = widget.productDetail;

    return Column(
      children: [
        TabBar(
          controller: _tabController,
          labelColor: colorPrimary,
          unselectedLabelColor: colorTextSubtle,
          indicatorColor: colorPrimary,
          labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          tabs: const [
            Tab(text: "General"),
            Tab(text: "Inventory"),
            Tab(text: "Audit Trail"),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _card("Product Info", Icons.inventory_2_outlined, {
                      "Name": _safe(p.productName),
                      "Code": _safe(p.productCode),
                    }),
                    const SizedBox(height: 16),
                    _card("Details", Icons.category_outlined, {
                      "Type": _safe(d.productTypeName),
                      "Category": _safe(d.productCategoryName),
                      "Brand": _safe(d.brandName),
                      "Unit of Measure": _safe(d.unitOfMeasureName),
                      "Barcode": _safe(d.barcode),
                    }),
                    const SizedBox(height: 16),
                    _card("Pricing", Icons.attach_money, {
                      "Sales Price": d.salesPrice != null
                          ? formatPrice(d.salesPrice!)
                          : '-',
                      "Cost Price": d.purchasePrice != null
                          ? formatPrice(d.purchasePrice!)
                          : '-',
                    }),
                    const SizedBox(height: 16),
                    _card("Availability", Icons.toggle_on_outlined, {
                      "Sales": p.sales ? "Yes" : "No",
                      "Purchase": p.purchase ? "Yes" : "No",
                      "Point of Sale": p.pointOfSale ? "Yes" : "No",
                      "Direct Purchase": p.directPurchase ? "Yes" : "No",
                      "Expense": p.expense ? "Yes" : "No",
                    }),
                    const SizedBox(height: 16),
                    _card("Stock", Icons.warehouse_outlined, {
                      "On Hand": "${det.onHand}",
                      "Forecasted": "${det.forecasted}",
                      "Warehouses": "${det.warehouseCount}",
                      "Locations": "${det.locationCount}",
                    }),
                    if (d.noteDetail != null && d.noteDetail!.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      _noteCard("General Notes", d.noteDetail!),
                    ],
                  ],
                ),
              ),
              SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _card("Dimensions & Weight", Icons.straighten_outlined, {
                      "Weight": _safeNum(i.weight, " kg"),
                      "Length": _safeNum(i.length, " cm"),
                      "Width": _safeNum(i.width, " cm"),
                      "Height": _safeNum(i.height, " cm"),
                      "Volume": _safeNum(i.volume, " cm³"),
                    }),
                    const SizedBox(height: 16),
                    _card("Tracking", Icons.track_changes_outlined, {
                      "Tracking": i.tracking ? "Enabled" : "Disabled",
                      "Method": _trackingLabel(i.trackingMethod),
                      "Use Expiration": i.useExpiration ? "Yes" : "No",
                      if (i.useExpiration && i.expirationDays != null)
                        "Expiration Days": "${i.expirationDays} days",
                      "Auto Generate Lot": i.autoGenerateLot ? "Yes" : "No",
                    }),
                    if (i.noteInventory != null &&
                        i.noteInventory!.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      _noteCard("Inventory Notes", i.noteInventory!),
                    ],
                  ],
                ),
              ),
              SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _card("Creation", Icons.add_circle_outline, {
                      "Created By": _safe(det.createdByName),
                      "Created On": _formatDate(p.createdDate),
                    }),
                    const SizedBox(height: 16),
                    _card("Last Update", Icons.update_outlined, {
                      "Updated By": _safe(det.updatedByName),
                      "Updated On": _formatDate(p.updatedDate),
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _card(String title, IconData icon, Map<String, String> details) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: colorCard,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Icon(icon, color: colorPrimary, size: 20),
              const SizedBox(width: 8),
              Text(title,
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: colorTextPrimary)),
            ]),
            const Divider(height: 24),
            ...details.entries.map((e) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(e.key,
                          style: GoogleFonts.poppins(
                              color: colorTextSubtle, fontSize: 14)),
                      const SizedBox(width: 16),
                      Flexible(
                        child: Text(e.value,
                            textAlign: TextAlign.right,
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                color: colorTextPrimary,
                                fontSize: 14)),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _noteCard(String title, String content) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: colorCard,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: colorTextPrimary)),
            const Divider(height: 24),
            Text(content,
                style: GoogleFonts.poppins(
                    color: colorTextSubtle, fontSize: 14, height: 1.5)),
          ],
        ),
      ),
    );
  }
}