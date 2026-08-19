import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/features/inventory/stock_count/presentation/controllers/stock_count_controller.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'stock_count_location_count_screen.dart';

class StockCountLocationListScreen extends StatefulWidget {
  final String encryption;
  const StockCountLocationListScreen({super.key, required this.encryption});

  @override
  State<StockCountLocationListScreen> createState() => _State();
}

class _State extends State<StockCountLocationListScreen> {
  List<dynamic> _locations = [];
  bool _isLoading = true;
  String? _error;
  String? _warehouseId;
  String? _stockOpnameId;
  String? _stockOpnameStatus;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    setState(() { _isLoading = true; _error = null; });
    final ctrl = context.read<StockCountController>();
    final d = ctrl.detail;
    if (d == null || d.idWarehouse == null) {
      setState(() { _isLoading = false; _error = 'Missing stock count context'; });
      return;
    }
    try {
      final locs = await ctrl.getLocationsByWarehouse(d.idWarehouse!);
      final itemsByLoc = d.itemsByLocation;
      setState(() {
        _stockOpnameId = d.idStockOpname.toString();
        _stockOpnameStatus = d.status;
        _warehouseId = d.idWarehouse.toString();
        _locations = locs.map((l) {
          final items = itemsByLoc[l.id] ?? [];
          String status = 'not_started';
          if (items.isNotEmpty) {
            status = items.any((i) => i.status != 'Confirmed') ? 'draft' : 'confirmed';
          }
          return {'id_location': l.id, 'location_name': l.name, 'status': status};
        }).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() { _isLoading = false; _error = e.toString(); });
    }
  }

  Color _statusColor(String s) {
    switch (s) {
      case 'confirmed': return colorSuccess;
      case 'draft': return Colors.orange;
      default: return colorGrey;
    }
  }

  String _statusLabel(String s) {
    switch (s) {
      case 'confirmed': return 'Confirmed';
      case 'draft': return 'Draft';
      default: return 'Not Started';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      appBar: AppBar(
        title: Text('Location List', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: colorTextPrimary)),
        backgroundColor: colorCard,
        foregroundColor: colorTextPrimary,
        elevation: 1,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: colorPrimary))
          : _error != null
              ? Center(child: Text(_error!, style: GoogleFonts.poppins(color: colorError)))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _locations.length,
                  itemBuilder: (_, i) {
                    final loc = _locations[i];
                    final status = loc['status'] as String;
                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      color: colorCard,
                      child: ListTile(
                        title: Text(loc['location_name'], style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14)),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(color: _statusColor(status).withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                          child: Text(_statusLabel(status), style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w600, color: _statusColor(status))),
                        ),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => StockCountLocationCountScreen(
                              encryption: widget.encryption,
                              idStockOpname: int.parse(_stockOpnameId!),
                              idWarehouse: int.parse(_warehouseId!),
                              idLocation: loc['id_location'],
                              locationName: loc['location_name'],
                            ),
                          ),
                        ).then((_) => _load()),
                      ),
                    );
                  },
                ),
    );
  }
}