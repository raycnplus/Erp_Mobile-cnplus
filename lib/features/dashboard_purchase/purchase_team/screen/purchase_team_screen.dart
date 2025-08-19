import 'package:flutter/material.dart';
import '../models/purchase_team_index_models.dart';
import '../widget/purchase_team_list_card.dart';

class PurchaseTeamScreen extends StatelessWidget {
  const PurchaseTeamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Purchase Team'),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Purchase Team",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12),
            PurchaseTeamCardList(),
          ],
        ),
      ),
    );
  }
}