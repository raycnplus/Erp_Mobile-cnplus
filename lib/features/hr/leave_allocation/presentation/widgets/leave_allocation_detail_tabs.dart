import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/features/hr/leave_allocation/data/models/leave_allocation_models.dart';

class LeaveAllocationDetailTabs extends StatefulWidget {
  final LeaveAllocationDetailModel detail;

  const LeaveAllocationDetailTabs({
    super.key,
    required this.detail,
  });

  @override
  State<LeaveAllocationDetailTabs> createState() =>
      _LeaveAllocationDetailTabsState();
}

class _LeaveAllocationDetailTabsState
    extends State<LeaveAllocationDetailTabs>
    with SingleTickerProviderStateMixin {
  late TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  String _safe(dynamic value) {
    if (value == null || value.toString().isEmpty) {
      return '-';
    }

    return value.toString();
  }

  String _fmtDt(String? date) {
    if (date == null || date.isEmpty) {
      return '-';
    }

    try {
      return DateFormat(
        'd MMMM yyyy, hh:mm a',
      ).format(DateTime.parse(date));
    } catch (_) {
      return date;
    }
  }

  @override
  Widget build(BuildContext context) {
    final detail = widget.detail;

    return Column(
      children: [
        TabBar(
          controller: _tab,
          labelColor: colorPrimary,
          unselectedLabelColor: colorTextSubtle,
          indicatorColor: colorPrimary,
          labelStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
          tabs: const [
            Tab(text: 'Info'),
            Tab(text: 'Audit Trail'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tab,
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _card(
                      'Allocation Info',
                      Icons.assignment_outlined,
                      {
                        'Name': _safe(detail.allocationName),
                        'Year': '${detail.year}',
                        'Quota':
                            '${detail.quota.toStringAsFixed(0)} days',
                        'Leave Type': _safe(detail.leaveTypeName),
                        'Allocation By': _safe(detail.allocationBy),
                        'Total Employees':
                            '${detail.totalEmployees} employees',
                      },
                    ),
                  ],
                ),
              ),
              SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _card('Creation', Icons.add_circle_outline, {
                      'Created By': _safe(widget.detail.createdByName),
                      'Created On': _fmtDt(detail.createdDate),
                    }),
                    const SizedBox(height: 16),
                    _card('Last Update', Icons.update_outlined, {
                      'Updated By': _safe(widget.detail.updatedByName),
                      'Updated On': _fmtDt(detail.updatedDate),
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _card(
    String title,
    IconData icon,
    Map<String, String> fields,
  ) {
    final visible = {
      for (final entry in fields.entries)
        if (entry.value != '-') entry.key: entry.value,
    };

    if (visible.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: colorCard,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: colorPrimary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: colorTextPrimary,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            ...visible.entries.map(
              (entry) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.key,
                      style: GoogleFonts.poppins(
                        color: colorTextSubtle,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Flexible(
                      child: Text(
                        entry.value,
                        textAlign: TextAlign.right,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          color: colorTextPrimary,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}