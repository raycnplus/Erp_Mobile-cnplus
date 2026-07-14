import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/features/hr/national_holiday/data/models/national_holiday_models.dart';

class NationalHolidayListItem extends StatelessWidget {
  final NationalHolidayModel holiday;
  final VoidCallback onTap;

  const NationalHolidayListItem({super.key, required this.holiday, required this.onTap});

  String _monthShort(String date) {
    if (date.length < 7) return '';
    const months = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final m = int.tryParse(date.substring(5, 7)) ?? 0;
    return m > 0 && m <= 12 ? months[m] : '';
  }

  @override
  Widget build(BuildContext context) {
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
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: colorPrimary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      holiday.holidayDate.length >= 10
                          ? holiday.holidayDate.substring(8, 10)
                          : '--',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                        color: colorPrimary,
                      ),
                    ),
                    Text(
                      _monthShort(holiday.holidayDate),
                      style: GoogleFonts.poppins(fontSize: 10, color: colorPrimary),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      holiday.holidayName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: colorTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      holiday.holidayDate,
                      style: GoogleFonts.poppins(fontSize: 12, color: colorTextSubtle),
                    ),
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