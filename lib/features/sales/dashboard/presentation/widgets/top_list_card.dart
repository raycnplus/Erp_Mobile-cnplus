import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TopListData {
  final String title;
  final String? subtitle;
  final String value;

  const TopListData({
    required this.title,
    this.subtitle,
    required this.value,
  });
}

class TopListCard extends StatelessWidget {
  final String title;
  final List<TopListData> items;
  final Color mainColor;

  const TopListCard({
    super.key,
    required this.title,
    required this.items,
    this.mainColor = const Color(0xFF409c9c),
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shadowColor: mainColor.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          if (items.isEmpty)
            Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Text(
                  'No data available',
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final isLastItem = index == items.length - 1;
                final rank = index + 1;

                final Color circleColor = mainColor.withOpacity(0.1);
                final Color textColor = mainColor;

                return Column(
                  children: [
                    ListTile(
                      leading: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: circleColor,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '$rank',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              color: textColor,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
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
                      subtitle: item.subtitle == null
                          ? null
                          : Text(
                              item.subtitle!,
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                      trailing: Text(
                        item.value,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          color: mainColor,
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
        ],
      ),
    );
  }
}