import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../../shared/widgets/success_bottom_sheet.dart';
import '../../create/widget/product_type_create_form_widget.dart';
import '../widget/product_type_index_widget.dart';
import '../../../../../../shared/widgets/custom_refresh_indicator.dart';
import '../../show/widget/product_type_show_widget.dart';

class ProductTypeIndexScreen extends StatefulWidget {
  const ProductTypeIndexScreen({super.key});

  @override
  State<ProductTypeIndexScreen> createState() => _ProductTypeIndexScreenState();
}

class _ProductTypeIndexScreenState extends State<ProductTypeIndexScreen> {
  final GlobalKey<ProductTypeScreenState> _productTypeScreenKey =
      GlobalKey<ProductTypeScreenState>();

  Future<void> _refreshData() async {
    _productTypeScreenKey.currentState?.reloadData();
  }

  void _showCreateSuccessMessage() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return const SuccessBottomSheet(
          title: "Successfully Created!",
          message: "New product type has been added to the list.",
        );
      },
    );
  }

  void _showUpdateSuccessMessage() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return const SuccessBottomSheet(
          title: "Successfully Updated!",
          message: "The product type has been updated.",
          themeColor: Color(0xFF4A90E2),
        );
      },
    );
  }

  // FUNGSI BARU: Notifikasi untuk DELETE (Merah)
  void _showDeleteSuccessMessage(String deletedItemName) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return SuccessBottomSheet(
          title: "Successfully Deleted!",
          message: "'$deletedItemName' has been removed.",
          themeColor: const Color(0xFFF35D5D), // KIRIM WARNA MERAH DI SINI
        );
      },
    );
  }

  void _showCreateProductTypeModal() async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: const ProductTypeCreateWidget(),
          ),
        );
      },
    );

    if (result == true) {
      _productTypeScreenKey.currentState?.reloadData();
      _showCreateSuccessMessage();
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
            Text(
              "Product Types",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: Colors.black87,
                fontSize: 20,
              ),
            ),
            Text(
              'Swipe an item for actions',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.normal,
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
          ],
        ),
        elevation: 0.5,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      body: CustomRefreshIndicator(
        onRefresh: _refreshData,
        child: ProductTypeScreen(
          key: _productTypeScreenKey,
          onTap: (productType) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ProductTypeShowScreen(id: productType.id),
              ),
            );
          },
          onUpdateSuccess: () {
            _showUpdateSuccessMessage();
          },
          // SAMBUNGKAN CALLBACK DELETE KE FUNGSI BARU DI SINI
          onDeleteSuccess: (String itemName) {
            _showDeleteSuccessMessage(itemName);
          },
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF679436).withAlpha(102),
              blurRadius: 15,
              spreadRadius: 2,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: _showCreateProductTypeModal,
          tooltip: 'Add Product Type',
          backgroundColor: const Color(0xFF679436),
          elevation: 0,
          child: const Icon(
            Icons.add,
            color: Color(0xFFF0E68C),
          ),
        ),
      ),
    );
  }
}