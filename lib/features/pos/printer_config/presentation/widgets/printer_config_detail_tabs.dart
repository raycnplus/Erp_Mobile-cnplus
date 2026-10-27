import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/features/pos/printer_config/data/models/printer_config_models.dart';

class PrinterConfigDetailTabs extends StatefulWidget {
  final PrinterConfigModel detail;

  const PrinterConfigDetailTabs({super.key, required this.detail});

  @override
  State<PrinterConfigDetailTabs> createState() => _State();
}

class _State extends State<PrinterConfigDetailTabs> with SingleTickerProviderStateMixin {
  late TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 1, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  String _safe(dynamic v) => (v == null || v.toString().isEmpty) ? '-' : v.toString();

  @override
  Widget build(BuildContext context) {
    final p = widget.detail;
    return Column(
      children: [
        TabBar(
          controller: _tab,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          labelColor: colorPrimary,
          unselectedLabelColor: colorTextSubtle,
          indicatorColor: colorPrimary,
          labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 12),
          tabs: const [
            Tab(text: 'Info'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tab,
            children: [
              _buildInfoTab(p),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoTab(PrinterConfigModel p) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _infoCard('Printer Info', Icons.print_outlined, [
            _row('Printer Name', p.printerName),
            _row('Description', _safe(p.description)),
            _rowBadge('Default', p.isDefault),
          ]),
        ],
      ),
    );
  }

  Widget _row(String label, String value) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 130, child: Text(label, style: GoogleFonts.poppins(fontSize: 12, color: colorTextSubtle))),
        Expanded(
          child: Text(value, style: GoogleFonts.poppins(fontSize: 12, color: colorTextPrimary, fontWeight: FontWeight.w500)),
        ),
      ],
    ),
  );

  Widget _rowBadge(String label, bool isTrue) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 130, child: Text(label, style: GoogleFonts.poppins(fontSize: 12, color: colorTextSubtle))),
        if (isTrue)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: colorPrimary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: colorPrimary.withOpacity(0.3)),
            ),
            child: Text('Yes', style: GoogleFonts.poppins(fontSize: 11, color: colorPrimary, fontWeight: FontWeight.w600)),
          )
        else
          Text('No', style: GoogleFonts.poppins(fontSize: 12, color: colorTextPrimary)),
      ],
    ),
  );

  Widget _infoCard(String title, IconData icon, List<Widget> rows) => Card(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    color: colorCard,
    child: Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: colorPrimary, size: 18),
              const SizedBox(width: 8),
              Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14, color: colorTextPrimary)),
            ],
          ),
          const Divider(height: 16),
          ...rows,
        ],
      ),
    ),
  );
}