import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class KpiRow {
  final String label;
  final String value;     
  final String achievement; 

  const KpiRow({required this.label, this.value = '', this.achievement = ''});
}

class AccountingKpiCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Color color;
  final List<KpiRow> rows;

  const AccountingKpiCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.color,
    required this.rows,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (subtitle != null)
              Text(
                subtitle!,
                style: GoogleFonts.poppins(color: Colors.white70, fontSize: 11),
              ),
            const SizedBox(height: 8),
            for (var i = 0; i < rows.length; i++) ...[
              if (i > 0) const Divider(height: 1, color: Colors.white24),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            rows[i].label,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        if (rows[i].achievement.isNotEmpty)
                          Text(
                            rows[i].achievement,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                      ],
                    ),
                    if (rows[i].value.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          rows[i].value,
                          style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}