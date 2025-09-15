// purchase_team_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../widget/purchase_team_list_card.dart';
import '../../Team_create/screen/purchase_team_screen_create.dart';
import '../../Team_Show/screen/purchase_team_show_screen.dart';

class PurchaseTeamScreen extends StatefulWidget {
  const PurchaseTeamScreen({super.key});

  @override
  State<PurchaseTeamScreen> createState() => _PurchaseTeamScreenState();
}

class _PurchaseTeamScreenState extends State<PurchaseTeamScreen> {
  String searchQuery = '';
  Key _purchaseTeamListKey = UniqueKey();

  void _refreshPurchaseTeamList() {
    setState(() {
      _purchaseTeamListKey = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Purchase Team'),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Purchase Team",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
            Expanded(
              child: PurchaseTeamCardList(
                key: _purchaseTeamListKey,
                searchQuery: searchQuery,
                onTap: (teamId) async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PurchaseTeamShowScreen(teamId: teamId),
                    ),
                  );

                  if (result == true && mounted) {
                    _refreshPurchaseTeamList();
                  }
                },
              ),
            ),
          ],
        ),
      ),
      // ...existing code...
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          print(
            '[DEBUG] FAB PurchaseTeamScreen ditekan, membuka PurchaseTeamScreenCreate',
          );
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const PurchaseTeamScreenCreate()),
          );
          if (result == true && mounted) {
            print('[DEBUG] Selesai create team, refresh list');
            _refreshPurchaseTeamList();
          }
        },
        backgroundColor: const Color(0xFF009688),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      // ...existing code...
    );
  }
}
