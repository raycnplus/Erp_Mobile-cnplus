import 'package:flutter/material.dart';

class DashboardDrawer extends StatelessWidget {
  const DashboardDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // --- HEader  ---
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // setting logo di sini
                Image.asset('assets/logo.png', height: 24),
                const SizedBox(height: 8),
                const Text(
                  "Mobile Erp",
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 30),
                const Center(
                  // api avatar
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/avatar.png'),
                  ),
                ),
                const SizedBox(height: 16),
                const Center(
                  child: Text(
                    "a maulana amir",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                const Center(
                  child: Text(
                    "a.maulana.cnplus@gmail.com",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          const Divider(thickness: 1),

          // --- BAGIAN MENU ---
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
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),

          // Menu Expandable
          ExpansionTile(
            leading: const Text('•', style: TextStyle(fontSize: 20)),
            title: const Text('Product'),
            trailing: const Icon(Icons.keyboard_arrow_down),
            children: <Widget>[
              // Sub-menu x
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

          // Contoh Menu Biasa
          ListTile(
            leading: const Text('•', style: TextStyle(fontSize: 20)),
            title: const Text('Products Type'),
            onTap: () {
              Navigator.pop(context);
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