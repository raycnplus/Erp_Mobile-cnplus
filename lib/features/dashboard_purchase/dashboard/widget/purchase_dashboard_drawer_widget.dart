import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Import halaman tujuan navigasi
import '../../master_data/purchase_team/index/screen/purchase_team_screen.dart';
import 'package:erp_mobile_cnplus/features/dashboard_inventory/master_data/product/product/index/screen/index_product_screen.dart';
import '../../master_data/product_type/index/screen/product_type_index_screen.dart';
import '../../master_data/product_category/index/screen/product_category_index_screen.dart';
import 'package:erp_mobile_cnplus/features/dashboard_inventory/master_data/brand/index/screen/brand_index_screen.dart';
import '../../master_data/vendor/screen/index_screen_vendor.dart';


class PurchaseDashboardDrawer extends StatefulWidget {
  const PurchaseDashboardDrawer({super.key});

  @override
  State<PurchaseDashboardDrawer> createState() =>
      _PurchaseDashboardDrawerState();
}

class _PurchaseDashboardDrawerState extends State<PurchaseDashboardDrawer> {
  String username = '';
  String email = '';
  // Warna aksen utama agar konsisten dengan inventory drawer
  static const Color accentColor = Color(0xFF2D6A4F); 

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    const storage = FlutterSecureStorage();

    final storedUsername = await storage.read(key: 'nama_lengkap');
    final storedEmail = await storage.read(key: 'email');

    setState(() {
      username = storedUsername ?? '';
      email = storedEmail ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // Latar belakang yang bersih
      child: Container(
        color: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // === 1. DRAWER HEADER (PROFILE) - Mengadopsi gaya dari Inventory ===
            Container(
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
              decoration: BoxDecoration(
                color: Colors.white,
                // Soft Shadow di bagian bawah header
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 1,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Logo Placeholder
                  Image.asset('assets/logo.png', height: 28),
                  const SizedBox(height: 4),
                  Text("Mobile ERP", style: GoogleFonts.poppins(color: Colors.grey.shade500, fontSize: 13)),
                  const SizedBox(height: 30),
                  
                  // Avatar dengan Soft Shadow
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: accentColor.withOpacity(0.2),
                            blurRadius: 15,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: const CircleAvatar(
                        radius: 40,
                        backgroundImage: AssetImage('assets/avatar.png'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Username
                  Center(
                    child: Text(
                      username.isNotEmpty ? username : "User",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black87
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  
                  // Email
                  Center(
                    child: Text(
                      email.isNotEmpty ? email : "-",
                      style: GoogleFonts.poppins(color: Colors.grey.shade600, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
            
            // === 2. MASTER DATA TITLE - Mengadopsi gaya dari Inventory ===
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 8.0),
              child: Text(
                'MASTER DATA',
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w700,
                  color: accentColor,
                  fontSize: 13,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            
            // === 3. MENU NAVIGASI (DENGAN IKON & STRUKTUR BARU) ===
            
            _buildDrawerItem(
              title: 'Purchase Team',
              icon: Icons.groups_outlined,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const PurchaseTeamScreen()));
              },
            ),

            // Product Expansion
            _buildCustomExpansionTile(
              title: 'Product',
              icon: Icons.inventory_2_outlined,
              children: [
                _buildDrawerItem(
                  title: 'Product',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ProductIndexScreen()));
                  },
                  isSubItem: true,
                ),
              ],
            ),

            // Single Menu Items
            _buildDrawerItem(
              title: 'Products Type',
              icon: Icons.category_outlined,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ProductTypeIndexScreen()));
              },
            ),
            _buildDrawerItem(
              title: 'Products Category', // Judul diperbaiki dari 'Products Type'
              icon: Icons.list_alt,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ProductCategoryScreen()));
              },
            ),
            _buildDrawerItem(
              title: 'Brand',
              icon: Icons.sell_outlined,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const BrandIndexScreen()));
              },
            ),
            _buildDrawerItem(
              title: 'Vendor',
              icon: Icons.business_outlined,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const VendorIndexScreen()));
              },
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
  
  // Custom Widget untuk Item Menu (ListTile) - Diambil dari Inventory Drawer
  Widget _buildDrawerItem({
    required String title,
    IconData? icon,
    required VoidCallback onTap,
    bool isSubItem = false,
  }) {
    return ListTile(
      leading: isSubItem
          ? const SizedBox(width: 24) // Indentasi untuk Sub Item
          : (icon != null ? Icon(icon, color: Colors.grey.shade600) : null),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontWeight: isSubItem ? FontWeight.normal : FontWeight.w500,
          fontSize: 14,
          color: Colors.black87,
        ),
      ),
      onTap: onTap,
    );
  }

  // Custom Widget untuk Expansion Tile yang lebih rapi - Diambil dari Inventory Drawer
  Widget _buildCustomExpansionTile({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16.0),
        leading: Icon(icon, color: Colors.grey.shade600),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
        iconColor: Colors.grey.shade600,
        collapsedIconColor: Colors.grey.shade400,
        children: children,
      ),
    );
  }
}