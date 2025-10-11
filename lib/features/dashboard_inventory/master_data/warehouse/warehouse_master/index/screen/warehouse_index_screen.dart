// warehouse_index_screen.dart

import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/warehouse_index_models.dart';
import '../widget/warehouse_index_widget.dart';
import '../../show/screen/warehouse_show_screen.dart';
import '../../create/screen/warehouse_create_screen.dart';
import '../../update/widget/warehouse_update_widget.dart'; // <-- Tambahkan import ini
import '../../../../../../../shared/widgets/success_bottom_sheet.dart';
import '../../../../../../../shared/widgets/custom_refresh_indicator.dart';

class WarehouseIndexScreen extends StatefulWidget {
  const WarehouseIndexScreen({super.key});

  @override
  State<WarehouseIndexScreen> createState() => _WarehouseIndexScreenState();
}

class _WarehouseIndexScreenState extends State<WarehouseIndexScreen> {
  final GlobalKey<WarehouseListWidgetState> _warehouseListKey = GlobalKey<WarehouseListWidgetState>();

  Future<void> _refreshData() async {
    _warehouseListKey.currentState?.reloadData();
  }

  // --- Fungsi Notifikasi Sukses ---
  void _showCreateSuccessMessage() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => const SuccessBottomSheet(
        title: "Successfully Created!",
        message: "New warehouse has been added to the list.",
      ),
    );
  }

  void _showUpdateSuccessMessage() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => const SuccessBottomSheet(
        title: "Successfully Updated!",
        message: "The warehouse has been updated.",
        themeColor: Color(0xFF4A90E2),
      ),
    );
  }

  void _showDeleteSuccessMessage(String deletedItemName) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => SuccessBottomSheet(
        title: "Successfully Deleted!",
        message: "'$deletedItemName' has been removed.",
        themeColor: const Color(0xFFF35D5D),
      ),
    );
  }

  void _navigateToCreateScreen() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => const WarehouseCreateScreen(),
      ),
    );
    if (result == true) {
      _warehouseListKey.currentState?.reloadData();
      _showCreateSuccessMessage();
    }
  }

  // FUNGSI BARU UNTUK MENAMPILKAN MODAL EDIT
  Future<void> _showEditModal(WarehouseIndexModel warehouse) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        // Backdrop filter untuk efek blur di belakang
        return BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: DraggableScrollableSheet(
            initialChildSize: 0.85,
            minChildSize: 0.5,
            maxChildSize: 0.95,
            expand: false,
            builder: (_, controller) {
              return Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFF9F9F9),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28.0)),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 40,
                      height: 5,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                      child: Text("Edit Warehouse", style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold)),
                    ),
                    const Divider(height: 1),
                    Expanded(child: WarehouseEditWidget(warehouse: warehouse)),
                  ],
                ),
              );
            },
          ),
        );
      },
    );

    if (result == true) {
      _warehouseListKey.currentState?.reloadData();
      _showUpdateSuccessMessage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Warehouses", style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.black87, fontSize: 20)),
            Text('Swipe an item for actions', style: GoogleFonts.poppins(fontWeight: FontWeight.normal, color: Colors.grey.shade600, fontSize: 12)),
          ],
        ),
        elevation: 0.5,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      body: CustomRefreshIndicator(
        onRefresh: _refreshData,
        child: WarehouseListWidget(
          key: _warehouseListKey,
          onTap: (warehouse) async {
            final result = await Navigator.push<bool>(
              context,
              MaterialPageRoute(builder: (context) => WarehouseShowScreen(warehouse: warehouse)),
            );
            if (result == true) {
              _refreshData();
            }
          },
          onEdit: _showEditModal, // <-- Hubungkan fungsi edit
          onDeleteSuccess: (String itemName) {
            _showDeleteSuccessMessage(itemName);
          },
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: const Color(0xFF679436).withAlpha(102), blurRadius: 15, spreadRadius: 2, offset: const Offset(0, 5)),
          ],
        ),
        child: FloatingActionButton(
          onPressed: _navigateToCreateScreen,
          tooltip: 'Add Warehouse',
          backgroundColor: const Color(0xFF679436),
          elevation: 0,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}