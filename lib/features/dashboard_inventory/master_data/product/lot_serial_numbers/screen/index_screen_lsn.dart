import 'package:flutter/material.dart';
import '../widget/index_widget_lsn.dart';

class LotSerialIndexScreen extends StatelessWidget {
  const LotSerialIndexScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Lot/Serial Number Index")),
      body: const Padding(
        padding: EdgeInsets.all(8.0),
        child: LotSerialIndexWidget(),
      ),
    );
  }
}
