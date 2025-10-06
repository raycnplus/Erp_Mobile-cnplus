import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/index_product_models.dart';
import '../widget/index_product_widget.dart';
import '../../show/screen/show_product_screen.dart';
import '../../create/screen/create_product_screen.dart'; // Import halaman create

class ProductIndexScreen extends StatelessWidget {
  const ProductIndexScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // === UPDATED APPBAR DESIGN ===
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Product List",
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                  fontSize: 20),
            ),
            Text(
              'Tap an item for details and action',
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.normal,
                  color: Colors.grey.shade600,
                  fontSize: 12),
            ),
          ],
        ),
        elevation: 0.5,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),

      body: ProductListWidget(
        onTap: (ProductIndexModel product) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ProductShowScreen(productId: product.idProduct),
            ),
          );
        },
      ),

      // === FAB untuk navigasi ke Create ===
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF679436),
        tooltip: "Add Product",
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ProductCreateScreen(),
            ),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
