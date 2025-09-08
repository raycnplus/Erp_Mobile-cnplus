import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../product_type/screen/product_type_index_screen.dart'; // <-- Perubahan di sini

class DashboardDrawer extends StatefulWidget {
  const DashboardDrawer({super.key});

  @override
  State<DashboardDrawer> createState() => _DashboardDrawerState();
}

class _DashboardDrawerState extends State<DashboardDrawer> {
  String username = '';
  String email = '';

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('nama_lengkap') ?? '';
      email = prefs.getString('email') ?? '';
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
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
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

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Row(
              children: [
                const Icon(Icons.storage, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  'Master Data',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),

          ExpansionTile(
            leading: const Text('•', style: TextStyle(fontSize: 20)),
            title: const Text('Product'),
            trailing: const Icon(Icons.keyboard_arrow_down),
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

          ExpansionTile(
            leading: const Text('•', style: TextStyle(fontSize: 20)),
            title: const Text('Warehouse'),
            trailing: const Icon(Icons.keyboard_arrow_down),
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
            leading: const Text('•', style: TextStyle(fontSize: 20)),
            title: const Text('Products Type'),
            onTap: () {
              // <-- Perubahan di sini
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProductTypeIndexScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Text('•', style: TextStyle(fontSize: 20)),
            title: const Text('Products Category'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Text('•', style: TextStyle(fontSize: 20)),
            title: const Text('Brand'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Text('•', style: TextStyle(fontSize: 20)),
            title: const Text('Vendor'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}