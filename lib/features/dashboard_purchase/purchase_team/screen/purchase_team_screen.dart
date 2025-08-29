  import 'package:flutter/material.dart';
  import '../widget/purchase_team_list_card.dart';
  import '../../purchase_team/screen/purchase_team_show_screen.dart';

  class PurchaseTeamScreen extends StatefulWidget {
    const PurchaseTeamScreen({super.key});

    @override
    State<PurchaseTeamScreen> createState() => _PurchaseTeamScreenState();
  }

  class _PurchaseTeamScreenState extends State<PurchaseTeamScreen> {
    String searchQuery = '';

    // ...existing code...
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: const Color(0xFFF1FFF2), // ganti ke warna F1FFF2
        appBar: AppBar(
          title: const Text('Purchase Team'),
          backgroundColor: const Color(0xFFF1FFF2), // samakan dengan background
          elevation: 0,
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
                  fillColor: const Color(0xFFD6F3DE),
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
    searchQuery: searchQuery,
    onTap: (teamId) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PurchaseTeamShowScreen(teamId: teamId), // ✅ screen detail
        ),
      );
    },
  ),
),



            ],
          ),
        ),
      floatingActionButton: FloatingActionButton(
       onPressed: () {
        Navigator.push(
        context,
        MaterialPageRoute(
        builder: (_) => const PurchaseTeamScreen(),
      ),
    );
  },
  backgroundColor: const Color(0xFF009688),
  child: const Icon(Icons.add, color: Colors.white),
),

      );
    }
  }
