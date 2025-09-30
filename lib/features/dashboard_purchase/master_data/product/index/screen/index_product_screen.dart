import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Added import for GoogleFonts
import '../models/index_product_models.dart';
import '../widget/index_product_widget.dart';
import '../../show/screen/show_product_screen.dart';

class ProductIndexScreen extends StatelessWidget {
  const ProductIndexScreen({super.key});

  void _showCreateProductModal(BuildContext context) {
    // TODO: Aksi untuk menampilkan ProductCreateScreen atau modal
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("TODO: Aksi Tambah Produk Baru"))
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // === UPDATED APPBAR DESIGN ===
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87), // New back icon
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Product List", // Clearer main title
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600, 
                color: Colors.black87, 
                fontSize: 20
              )
            ),
            Text(
              'Tap an item for details and action', 
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.normal, 
                color: Colors.grey.shade600, 
                fontSize: 12
              )
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
              builder: (context) => ProductShowScreen(productId: product.idProduct),
            ),
          );
        },
      ),

      // === FLOATING ACTION BUTTON (FAB) for Create ===
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateProductModal(context),
        tooltip: 'Add New Product',
        // Menggunakan warna yang sama dengan referensi (hijau)
        backgroundColor: const Color(0xFF679436), 
        elevation: 4,
        child: const Icon(Icons.add, color: Colors.white), 
      ),
    );
  }
}