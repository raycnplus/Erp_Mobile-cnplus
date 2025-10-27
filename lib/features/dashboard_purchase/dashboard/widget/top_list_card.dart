import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; 
import '../models/purchase_models.dart';

class TopListCard extends StatelessWidget {
  final String title;
  final List<TopListData> items;

  const TopListCard({super.key, required this.title, required this.items});

  static const Color mainColor = Color(0xFF029379);
  static const Color goldColor = Color(0xFFFFA000); 

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4, // Efek shadow lebih halus
      shadowColor: mainColor.withOpacity(0.1), // Efek "Glow" hijau
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // [BARU] Header Judul di dalam Card
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              title,
              style: GoogleFonts.poppins( // Font konsisten
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 8), // Padding untuk list
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final isLastItem = index == items.length - 1;
              final rank = index + 1;
              
              final Color rankCircleColor = (rank == 1) ? goldColor : mainColor.withOpacity(0.1);
              final Color rankTextColor = (rank == 1) ? Colors.white : mainColor;

              return Column(
                children: [
                  ListTile(
                    leading: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: rankCircleColor,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '$rank',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            color: rankTextColor,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    // [DIUBAH] Font title dibuat lebih tebal
                    title: Text(
                      item.title,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Text(
                      item.value,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        color: mainColor, // Warna hijau
                        fontSize: 15,
                      ),
                    ),
                  ),
                  if (!isLastItem)
                    const Divider(height: 1, indent: 64, endIndent: 16),
                ],
              );
            },
          ),

          // Teks footer "ERP Data"
          Padding(
            padding: const EdgeInsets.only(right: 12, bottom: 8, top: 4),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                "ERP Data",
                style: GoogleFonts.poppins( // Font konsisten
                  fontSize: 10,
                  color: Colors.grey.shade400,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}