import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/features/master/project/data/models/project_models.dart';

class ProjectListItem extends StatelessWidget {
  final ProjectModel project;
  final VoidCallback onTap;

  const ProjectListItem({super.key, required this.project, required this.onTap});

  String _fmtDate(String? d) {
    if (d == null || d.isEmpty) return '-';
    try {
      return DateFormat('d MMM yyyy').format(DateTime.parse(d));
    } catch (_) {
      return d;
    }
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
          child: Row(children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: colorPrimary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.folder_outlined, color: colorPrimary, size: 26),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  project.projectName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 15, color: colorTextPrimary),
                ),
                const SizedBox(height: 2),
                Text(
                  project.projectCode,
                  style: GoogleFonts.poppins(fontSize: 12, color: colorPrimary, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 3),
                Row(children: [
                  if (project.customer != '-') ...[
                    const Icon(Icons.person_outline, size: 12, color: colorTextSubtle),
                    const SizedBox(width: 3),
                    Flexible(
                      child: Text(
                        project.customer,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(fontSize: 11, color: colorTextSubtle),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  const Icon(Icons.calendar_today_outlined, size: 12, color: colorTextSubtle),
                  const SizedBox(width: 3),
                  Text(
                    '${_fmtDate(project.startDate)}${project.endDate != null ? ' – ${_fmtDate(project.endDate)}' : ''}',
                    style: GoogleFonts.poppins(fontSize: 11, color: colorTextSubtle),
                  ),
                ]),
              ]),
            ),
            const Icon(Icons.arrow_forward_ios, size: 15, color: colorGrey),
          ]),
        ),
      ),
    );
  }
}