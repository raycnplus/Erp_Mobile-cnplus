import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; 
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

// [BARU] Menambahkan import untuk AppRoutes
import '../../../../core/routes/app_routes.dart'; 

import '../../master_data/product_type/index/screen/product_type_index_screen.dart';
import '../../master_data/product_category/index/screen/product_category_index_screen.dart';
import '../../master_data/brand/index/screen/brand_index_screen.dart';
import '../../master_data/warehouse/warehouse_master/index/screen/warehouse_index_screen.dart';
import '../../master_data/warehouse/locations_master/index/screen/index_location_screen.dart';
import '../../master_data/product/product/index/screen/index_product_screen.dart';
import '../../master_data/product/lot_serial_numbers/screen/index_screen_lsn.dart';
import '../../master_data/vendor/index/screen/index_screen_vendor.dart';

class DashboardDrawer extends StatefulWidget {
  const DashboardDrawer({super.key});

  @override
  State<DashboardDrawer> createState() => _DashboardDrawerState();
}

class _DashboardDrawerState extends State<DashboardDrawer> {
  
  static const Color accentColor = Color(0xFF2D6A4F); 
  static final Color accentBgColor = accentColor.withOpacity(0.1);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: AnimationLimiter(
          child: ListView(
            padding: EdgeInsets.zero,
            children: AnimationConfiguration.toStaggeredList(
              duration: const Duration(milliseconds: 300),
              childAnimationBuilder: (widget) => SlideAnimation(
                verticalOffset: 40.0,
                child: FadeInAnimation(
                  child: widget,
                ),
              ),
              children: [
                // === 1. DRAWER HEADER (PROFILE) ===
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade200, width: 1.5)
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset('assets/logo.png', height: 28),
                      const SizedBox(height: 4),
                      Text(
                        "Mobile ERP", 
                        style: GoogleFonts.poppins(color: Colors.grey.shade500, fontSize: 13)
                      ),
                    ],
                  ),
                ),

                // === 2. NAVIGASI GLOBAL ===
                // [BARU] Menambahkan bagian yang ketinggalan
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
                  child: _buildDrawerItem(
                    title: 'Pilih Modul',
                    icon: Icons.apps_outlined,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, AppRoutes.modul);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
                  child: _buildDrawerItem(
                    title: 'Pemberitahuan',
                    icon: Icons.notifications_outlined,
                    onTap: () {
                      Navigator.pop(context);
                      // TODO: Navigasi
                    },
                  ),
                ),

                const Divider(height: 1, indent: 16, endIndent: 16, thickness: 1),
                
                // === 3. MASTER DATA TITLE ===
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
                
                // === 4. MENU NAVIGASI (MASTER DATA INVENTORY) ===
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: _buildCustomExpansionTile(
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
                      _buildDrawerItem(
                        title: 'Serial Number',
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const LotSerialIndexScreen()));
                        },
                        isSubItem: true,
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: _buildCustomExpansionTile(
                    title: 'Warehouse',
                    icon: Icons.warehouse_outlined,
                    children: [
                      _buildDrawerItem(
                        title: 'Warehouse',
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const WarehouseIndexScreen()));
                        },
                        isSubItem: true,
                      ),
                      _buildDrawerItem(
                        title: 'Location',
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const LocationIndexScreen()));
                        },
                        isSubItem: true,
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: _buildDrawerItem(
                    title: 'Products Type',
                    icon: Icons.category_outlined,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const ProductTypeIndexScreen()));
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: _buildDrawerItem(
                    title: 'Products Category',
                    icon: Icons.list_alt,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const ProductCategoryScreen()));
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: _buildDrawerItem(
                    title: 'Brand',
                    icon: Icons.sell_outlined,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => BrandIndexScreen()));
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: _buildDrawerItem(
                    title: 'Vendor',
                    icon: Icons.business_outlined,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const VendorIndexScreen()));
                    },
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  // Custom Widget untuk Item Menu (ListTile)
  Widget _buildDrawerItem({
    required String title,
    IconData? icon,
    required VoidCallback onTap,
    bool isSubItem = false,
  }) {
    
    Widget leadingWidget;
    if (isSubItem) {
      leadingWidget = Padding(
        padding: const EdgeInsets.only(left: 10.0), // Indentasi
        child: Icon(Icons.circle_outlined, size: 12, color: Colors.grey.shade500),
      );
    } else if (icon != null) {
      leadingWidget = Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: accentBgColor, // Latar belakang hijau muda
        ),
        child: Icon(icon, color: accentColor, size: 18), // Ikon hijau tua
      );
    } else {
      leadingWidget = const SizedBox(width: 36); // Fallback
    }

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
      leading: leadingWidget,
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontWeight: isSubItem ? FontWeight.normal : FontWeight.w500,
          fontSize: 14,
          color: isSubItem ? Colors.black.withOpacity(0.7) : Colors.black87,
        ),
      ),
      onTap: onTap,
      splashColor: accentBgColor,
      hoverColor: accentBgColor.withOpacity(0.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  // Custom Widget untuk Expansion Tile
  Widget _buildCustomExpansionTile({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: accentBgColor,
          ),
          child: Icon(icon, color: accentColor, size: 18),
        ),
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