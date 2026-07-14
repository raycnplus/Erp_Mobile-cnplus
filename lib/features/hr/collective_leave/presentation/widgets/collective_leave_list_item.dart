import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/features/hr/collective_leave/data/models/collective_leave_models.dart';

class CollectiveLeaveListItem extends StatelessWidget {
  final CollectiveLeaveModel collectiveLeave;
  final VoidCallback onTap;

  const CollectiveLeaveListItem({
    super.key,
    required this.collectiveLeave,
    required this.onTap,
  });

  String _formatDate(dynamic date) {
    if (date == null) return '-';

    if (date is DateTime) {
      return '${date.day.toString().padLeft(2, '0')}/'
          '${date.month.toString().padLeft(2, '0')}/'
          '${date.year}';
    }

    if (date is String && date.isNotEmpty) {
      try {
        final parsed = DateTime.parse(date);
        return '${parsed.day.toString().padLeft(2, '0')}/'
            '${parsed.month.toString().padLeft(2, '0')}/'
            '${parsed.year}';
      } catch (_) {
        return date;
      }
    }

    return '-';
  }

  @override
  Widget build(BuildContext context) {
    final duration = collectiveLeave.duration;
    return Card(
      color: colorCard,
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: colorGreyLight, width: 1),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: colorPrimary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.calendar_month_outlined,
                  color: colorPrimary,
                  size: 26,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      collectiveLeave.collectiveLeaveName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: colorTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.date_range_outlined,
                          size: 13,
                          color: colorTextSubtle,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${_formatDate(collectiveLeave.fromDate)} – ${_formatDate(collectiveLeave.toDate)}',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: colorTextSubtle,
                          ),
                        ),
                      ],
                    ),
                    if (duration != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        '$duration day${duration > 1 ? 's' : ''}',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: colorPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 15, color: colorGrey),
            ],
          ),
        ),
      ),
    );
  }
}