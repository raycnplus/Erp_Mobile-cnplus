// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../controllers/product_controller.dart';
// import '../widgets/product_list_view.dart';
// import '../widgets/product_detail_view.dart';
// import '../widgets/product_form_view.dart';

// class ProductScreen extends StatefulWidget {
//   const ProductScreen({super.key});

//   @override
//   State<ProductScreen> createState() => _ProductScreenState();
// }

// class _ProductScreenState extends State<ProductScreen> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<ProductController>().loadProducts();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<ProductController>(
//       builder: (context, controller, child) {
//         return Scaffold(
//           appBar: _buildAppBar(controller),
//           body: _buildBody(controller),
//           floatingActionButton: controller.viewMode == ProductViewMode.list
//               ? FloatingActionButton(
//                   backgroundColor: const Color(0xFF2D6A4F),
//                   onPressed: () => controller.showForm(),
//                   child: const Icon(Icons.add, color: Colors.white),
//                 )
//               : null,
//         );
//       },
//     );
//   }

//   PreferredSizeWidget _buildAppBar(ProductController controller) {
//     String title = 'Products';
//     if (controller.viewMode == ProductViewMode.detail) {
//       title = 'Product Detail';
//     } else if (controller.viewMode == ProductViewMode.form) {
//       title = controller.selectedProduct == null
//           ? 'Create Product'
//           : 'Edit Product';
//     }

//     return AppBar(
//       leading: controller.viewMode != ProductViewMode.list
//           ? IconButton(
//               icon: const Icon(Icons.arrow_back),
//               onPressed: () => controller.showList(),
//             )
//           : null,
//       title: Text(
//         title,
//         style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
//       ),
//       elevation: 0.5,
//       backgroundColor: Colors.white,
//       foregroundColor: Colors.black87,
//     );
//   }

//   Widget _buildBody(ProductController controller) {
//     if (controller.isLoading) {
//       return const Center(child: CircularProgressIndicator());
//     }

//     if (controller.errorMessage != null) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(controller.errorMessage!),
//             ElevatedButton(
//               onPressed: () => controller.loadProducts(),
//               child: const Text('Retry'),
//             ),
//           ],
//         ),
//       );
//     }

//     switch (controller.viewMode) {
//       case ProductViewMode.list:
//         return ProductListView(
//           products: controller.products,
//           onProductTap: (product) => controller.showDetail(product),
//         );
//       case ProductViewMode.detail:
//         return ProductDetailView(
//           product: controller.selectedProduct!,
//           onEdit: () => controller.showForm(product: controller.selectedProduct),
//           onDelete: () async {
//             final confirm = await showDialog<bool>(
//               context: context,
//               builder: (context) => AlertDialog(
//                 title: const Text('Delete Product'),
//                 content: const Text('Are you sure?'),
//                 actions: [
//                   TextButton(
//                     onPressed: () => Navigator.pop(context, false),
//                     child: const Text('Cancel'),
//                   ),
//                   TextButton(
//                     onPressed: () => Navigator.pop(context, true),
//                     child: const Text('Delete'),
//                   ),
//                 ],
//               ),
//             );
//             if (confirm == true) {
//               await controller.deleteProduct(controller.selectedProduct!.idProduct);
//             }
//           },
//         );
//       case ProductViewMode.form:
//         return ProductFormView(
//           product: controller.selectedProduct,
//           onSubmit: (product) async {
//             bool success;
//             if (controller.selectedProduct == null) {
//               success = await controller.createProduct(product);
//             } else {
//               success = await controller.updateProduct(
//                 controller.selectedProduct!.idProduct,
//                 product,
//               );
//             }
//             if (success) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(content: Text('Product saved successfully')),
//               );
//             }
//           },
//         );
//     }
//   }
// }