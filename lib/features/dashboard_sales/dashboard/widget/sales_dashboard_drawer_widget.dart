import 'package:erp_mobile_cnplus/features/dashboard_inventory/master_data/brand/index/screen/brand_index_screen.dart';
import 'package:erp_mobile_cnplus/features/dashboard_sales/master%20data/costumer_category/screen/costumer_category_index_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset('assets/logo.png', height: 24),
                const SizedBox(height: 8),
                const Text("Mobile Erp", style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 30),
                const Center(
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/avatar.png'),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    username.isNotEmpty ? username : "User",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                const SizedBox(height: 4),
                Center(
                  child: Text(
                    email.isNotEmpty ? email : "-",
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          const Divider(thickness: 1),

          // Master Data Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                const Icon(Icons.storage, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  'Master Data',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          ListTile(
            leading: const Text('•', style: TextStyle(fontSize: 20, color: Colors.grey)),
            title: const Text('Customer'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pop(context);
               Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CustomerIndexScreen(),
                      )
              );
            },
          ),
          ListTile(
            leading: const Text('•', style: TextStyle(fontSize: 20, color: Colors.grey)),
            title: const Text('Customer Category'),
            onTap: () {
              Navigator.pop(context);
               Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CustomerCategoryScreen(),
                      )
              );
            },
          ),
          ExpansionTile(
            leading: const Text('•', style: TextStyle(fontSize: 20, color: Colors.grey)),
            title: const Text('Product'),
            trailing: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 40.0),
                child: ListTile(
                  title: const Text('Product'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40.0),
                child: ListTile(
                  title: const Text('Serial Number'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
          ListTile(
            leading: const Text('•', style: TextStyle(fontSize: 20, color: Colors.grey)),
            title: const Text('Sales Team'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Text('•', style: TextStyle(fontSize: 20, color: Colors.grey)),
            title: const Text('Products Type'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProductTypeIndexScreen(),
                      )
              );
            },
          ),
          ListTile(
            leading: const Text('•', style: TextStyle(fontSize: 20, color: Colors.grey)),
            title: const Text('Products Category'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProductCategoryScreen(),
                      )
              );
            },
          ),
          ListTile(
            leading: const Text('•', style: TextStyle(fontSize: 20, color: Colors.grey)),
            title: const Text('Brands'),
            onTap: () {
              Navigator.pop(context);
               Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BrandIndexScreen(),
                      )
              );
            },
          ),
        ],
      ),
    );
  }
}