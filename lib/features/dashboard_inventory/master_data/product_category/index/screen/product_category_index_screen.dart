import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../../shared/widgets/success_bottom_sheet.dart';
import '../../show/widget/product_category_show_widget.dart';
import '../widget/product_category_index_widget.dart';
import '../models/product_category_index_models.dart';
import '../../create/screen/product_category_create_screen.dart';

class ProductCategoryScreen extends StatefulWidget {
  const ProductCategoryScreen({super.key});

  @override
  State<ProductCategoryScreen> createState() => _ProductCategoryScreenState();
}

class _ProductCategoryScreenState extends State<ProductCategoryScreen> {
  final GlobalKey<ProductCategoryListWidgetState> _listKey =
  GlobalKey<ProductCategoryListWidgetState>();

  Future<void> _navigateToCreate() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProductCategoryCreateScreen()),
    );

    if (result == true) {
      // DIUBAH: Panggil method yang sudah publik
      _listKey.currentState?.reloadData();
      _showCreateSuccessMessage();
    }
  }

  void _showCreateSuccessMessage() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => const SuccessBottomSheet(
        title: "Successfully Created!",
        message: "New product category has been added to the list.",
        themeColor: Color(0xFF679436),
      ),
    );
  }

  void _showDeleteSuccessMessage(String categoryName) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => SuccessBottomSheet(
        title: "Successfully Deleted!",
        message: "'$categoryName' has been removed from the list.",
        themeColor: const Color(0xFFF35D5D),
      ),
    );
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
            Text("Product Category", style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.black87, fontSize: 20)),
            Text('Swipe an item for actions', style: GoogleFonts.poppins(fontWeight: FontWeight.normal, color: Colors.grey.shade600, fontSize: 12)),
          ],
        ),
        elevation: 0.5,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      body: ProductCategoryListWidget(
        key: _listKey,
        onTap: (ProductCategory category) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductCategoryShowScreen(id: category.id),
            ),
          );
        },
        onDeleteSuccess: (String categoryName) {
          _showDeleteSuccessMessage(categoryName);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToCreate,
        child: const Icon(Icons.add),
      ),
    );
  }
}