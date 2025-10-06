// purchase_team_screen.dart

import 'package:flutter/material.dart';
import '../widget/sales_team_list_card.dart';
import '../../creeate/screen/sales_team_screen_create.dart';
import '../../show/screen/sales_team_show_screen.dart';

class SalesTeamScreen extends StatefulWidget {
  const SalesTeamScreen({super.key});

  @override
  State<SalesTeamScreen> createState() => _SalesTeamScreenState();
}

class _SalesTeamScreenState extends State<SalesTeamScreen> {
  String searchQuery = '';
  Key _salesTeamListKey = UniqueKey();

  void _refreshSalesTeamList() {
    setState(() {
      _salesTeamListKey = UniqueKey(); // Fixed variable name
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Sales Team'), // Changed from Purchase to Sales
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
              "Sales Team", // Changed from Purchase to Sales
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
              child: SalesTeamCardList(
                // Changed class name
                key: _salesTeamListKey,
                searchQuery: searchQuery,
                onTap: (teamId) async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SalesTeamShowScreen(
                        teamId: teamId,
                      ), // Changed class name
                    ),
                  );

                  if (result == true && mounted) {
                    _refreshSalesTeamList(); // Fixed method name
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          print(
            '[DEBUG] FAB SalesTeamScreen ditekan, membuka SalesTeamScreenCreate', // Updated debug message
          );
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const SalesTeamScreenCreate(),
            ), // Changed class name
          );
          if (result == true && mounted) {
            print('[DEBUG] Selesai create team, refresh list');
            _refreshSalesTeamList(); // Fixed method name
          }
        },
        backgroundColor: const Color(0xFF009688),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
