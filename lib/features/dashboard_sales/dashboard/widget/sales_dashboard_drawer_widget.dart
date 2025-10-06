import 'package:erp_mobile_cnplus/features/dashboard_inventory/master_data/brand/index/screen/brand_index_screen.dart';
import 'package:erp_mobile_cnplus/features/dashboard_inventory/master_data/product/product/index/screen/index_product_screen.dart';
import 'package:erp_mobile_cnplus/features/dashboard_sales/master%20data/costumer_category/screen/costumer_category_index_screen.dart';
import 'package:erp_mobile_cnplus/features/dashboard_sales/master%20data/sales_team/index/screen/sales_team_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart'; // <<< DITAMBAHKAN
import '../../master data/product_category/screen/product_category_index_screen.dart';
import '../../master data/product_type/screen/product_type_index_screen.dart';
import '../../master data/costumer/screen/costumer_index_screen.dart';

class SalesDashboardDrawer extends StatefulWidget {
  const SalesDashboardDrawer({super.key});

  @override
  State<SalesDashboardDrawer> createState() => _SalesDashboardDrawerState();
}

class _SalesDashboardDrawerState extends State<SalesDashboardDrawer> {
  String username = '';
  String email = '';
  // Mendefinisikan warna aksen utama
  static const Color accentColor = Color(0xFF2D6A4F); // Warna hijau tua

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
            // === 1. DRAWER HEADER (PROFILE) - Mengikuti Desain Inventory ===
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
                  // Logo Placeholder (Ganti dengan logo asli jika ada)
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
            
            // === 2. MASTER DATA TITLE ===
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
            
            // === 3. MENU NAVIGASI (DENGAN IKON & EXPANSION YANG LEBIH BAIK) ===
            
            // Single Menu Items
            _buildDrawerItem(
              title: 'Customer',
              icon: Icons.people_outline,
              onTap: () {
                Navigator.pop(context);
                // Navigator.pop(context); // Baris ini sepertinya tidak diperlukan lagi
                Navigator.push(context, MaterialPageRoute(builder: (context) => const CustomerIndexScreen()));
              },
            ),
            _buildDrawerItem(
              title: 'Customer Category',
              icon: Icons.group_work_outlined,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const CustomerCategoryScreen()));
              },
            ),

            // Product Expansion (Mengikuti struktur Inventory)
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
            
            _buildDrawerItem(
              title: 'Sales Team',
              icon: Icons.group_add_outlined,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const SalesTeamScreen()));
              },
            ),

            _buildDrawerItem(
              title: 'Products Type',
              icon: Icons.category_outlined,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ProductTypeIndexScreen()));
              },
            ),
            _buildDrawerItem(
              title: 'Products Category',
              icon: Icons.list_alt,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ProductCategoryScreen()));
              },
            ),
            _buildDrawerItem(
              title: 'Brands',
              icon: Icons.sell_outlined,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const BrandIndexScreen()));
              },
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
  
  // Custom Widget untuk Item Menu (ListTile) - Dari Inventory
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

  // Custom Widget untuk Expansion Tile yang lebih rapi - Dari Inventory
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