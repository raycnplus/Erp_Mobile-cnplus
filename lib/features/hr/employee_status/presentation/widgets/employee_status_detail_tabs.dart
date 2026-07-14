import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/features/hr/employee_status/data/models/employee_status_models.dart';

class EmployeeStatusDetailTabs extends StatefulWidget {
  final EmployeeStatusDetailModel detail;

  const EmployeeStatusDetailTabs({
    super.key,
    required this.detail,
  });

  @override
  State<EmployeeStatusDetailTabs> createState() =>
      _EmployeeStatusDetailTabsState();
}

class _EmployeeStatusDetailTabsState
    extends State<EmployeeStatusDetailTabs>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      length: 2,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _formatDate(String? date) {
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

  String _safe(dynamic value) {
    if (value == null ||
        value.toString().isEmpty) {
      return '-';
    }

    return value.toString();
  }

  @override
  Widget build(BuildContext context) {
    final status = widget.detail.status;
    final isActive = status.isActive == 'Y';

    return Column(
      children: [
        TabBar(
          controller: _tabController,
          labelColor: colorPrimary,
          unselectedLabelColor:
              colorTextSubtle,
          indicatorColor: colorPrimary,
          labelStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
          tabs: const [
            Tab(text: 'General'),
            Tab(text: 'Audit Trail'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(
                  16,
                ),
                child: Column(
                  children: [
                    _buildCard(
                      'Employee Status Info',
                      Icons.badge_outlined,
                      {
                        'Name': _safe(
                          status
                              .employeeStatusName,
                        ),
                        'Status':
                            isActive
                                ? 'Active'
                                : 'Inactive',
                      },
                    ),
                  ],
                ),
              ),
              SingleChildScrollView(
                padding: const EdgeInsets.all(
                  16,
                ),
                child: Column(
                  children: [
                    _buildCard(
                      'Creation',
                      Icons.add_circle_outline,
                      {
                        'Created By': _safe(
                          widget
                              .detail
                              .createdByName,
                        ),
                        'Created On':
                            _formatDate(
                              status
                                  .createdDate,
                            ),
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildCard(
                      'Last Update',
                      Icons.update_outlined,
                      {
                        'Updated By': _safe(
                          widget
                              .detail
                              .updatedByName,
                        ),
                        'Updated On':
                            _formatDate(
                              status
                                  .updatedDate,
                            ),
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCard(
    String title,
    IconData icon,
    Map<String, String> fields,
  ) {
    final visibleFields = {
      for (final entry in fields.entries)
        if (entry.value != '-')
          entry.key: entry.value,
    };

    if (visibleFields.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      elevation: 2,
      color: colorCard,
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: colorPrimary,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style:
                      GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight:
                            FontWeight.bold,
                        color:
                            colorTextPrimary,
                      ),
                ),
              ],
            ),
            const Divider(height: 24),
            ...visibleFields.entries.map(
              (entry) {
                return Padding(
                  padding:
                      const EdgeInsets.only(
                        bottom: 12,
                      ),
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment
                            .spaceBetween,
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                    children: [
                      Text(
                        entry.key,
                        style:
                            GoogleFonts.poppins(
                              fontSize: 14,
                              color:
                                  colorTextSubtle,
                            ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Flexible(
                        child: Text(
                          entry.value,
                          textAlign:
                              TextAlign.right,
                          style:
                              GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight:
                                    FontWeight
                                        .w500,
                                color:
                                    colorTextPrimary,
                              ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}