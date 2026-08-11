import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:erp_mobile_cnplus/features/hr/leave_quota/presentation/controllers/leave_quota_controller.dart';
import 'package:erp_mobile_cnplus/features/hr/leave_quota/data/models/leave_quota_models.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';

class LeaveQuotaDetailScreen extends StatefulWidget {
  final String employeeEncryption;
  final String employeeName;
  final String leaveTypeName;
  final String period;
  final int leaveTypeId;

  const LeaveQuotaDetailScreen({
    super.key,
    required this.employeeEncryption,
    required this.employeeName,
    required this.leaveTypeName,
    required this.leaveTypeId,
    required this.period,
  });

  @override
  State<LeaveQuotaDetailScreen> createState() =>
      _LeaveQuotaDetailScreenState();
}

class _LeaveQuotaDetailScreenState extends State<LeaveQuotaDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;
  Map<String, dynamic>? _detail;
  bool _loadingDetail = false;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDetail();
      context.read<LeaveQuotaController>().fetchHistory(
            widget.employeeEncryption,
            widget.leaveTypeId,
            period: widget.period,
          );
    });
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  Future<void> _loadDetail() async {
    setState(() => _loadingDetail = true);
    try {
      final result = await context.read<LeaveQuotaController>().ds.getDetail(
            widget.employeeEncryption,
            widget.leaveTypeId,
            period: widget.period,
          );
      if (mounted) {
        setState(() {
          _detail = result;
          _loadingDetail = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loadingDetail = false);
    }
  }

  String _fmt(String? d) {
    if (d == null) return '-';
    try {
      return DateFormat('d MMM yyyy').format(DateTime.parse(d));
    } catch (_) {
      return d;
    }
  }

  Color _statusColor(String? s) {
    switch (s) {
      case 'Approved':
        return Colors.green;
      case 'Waiting Approval':
        return Colors.orange;
      case 'Rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final summary = _detail?['data']?['summary'];

    return Scaffold(
      backgroundColor: colorBackground,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.employeeName,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: colorTextPrimary,
                fontSize: 16,
              ),
            ),
            Text(
              widget.leaveTypeName,
              style: GoogleFonts.poppins(color: colorPrimary, fontSize: 12),
            ),
          ],
        ),
        backgroundColor: colorCard,
        foregroundColor: colorTextPrimary,
        elevation: 1,
      ),
      body: Column(
        children: [
          if (_loadingDetail)
            const LinearProgressIndicator(
              color: colorPrimary,
              backgroundColor: colorGreyLight,
            )
          else if (summary != null) ...[
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorCard,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _summaryItem(
                        'Quota',
                        summary['quota_formatted'] ??
                            '${summary['total_quota']} days',
                        colorPrimary,
                      ),
                      _divider(),
                      _summaryItem(
                        'Used',
                        summary['used_formatted'] ??
                            '${summary['total_used']} days',
                        Colors.orange,
                      ),
                      _divider(),
                      _summaryItem(
                        'Remaining',
                        summary['remaining_formatted'] ??
                            '${summary['total_remaining']} days',
                        Colors.green.shade700,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: summary['total_quota'] > 0
                          ? (summary['total_used'] / summary['total_quota'])
                              .clamp(0.0, 1.0)
                          : 0.0,
                      minHeight: 8,
                      backgroundColor: colorGreyLight,
                      color: colorPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Period: ${widget.period}',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: colorTextSubtle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          TabBar(
            controller: _tab,
            labelColor: colorPrimary,
            unselectedLabelColor: colorTextSubtle,
            indicatorColor: colorPrimary,
            labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            tabs: const [
              Tab(text: 'Leave History'),
              Tab(text: 'Info'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tab,
              children: [
                Consumer<LeaveQuotaController>(
                  builder: (_, ctrl, __) {
                    if (ctrl.isLoadingHistory) {
                      return const Center(
                        child: CircularProgressIndicator(color: colorPrimary),
                      );
                    }
                    if (ctrl.historyError != null) {
                      return Center(
                        child: Text(
                          ctrl.historyError!,
                          style: GoogleFonts.poppins(color: colorError),
                        ),
                      );
                    }
                    if (ctrl.history.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.event_busy,
                                size: 64, color: colorGrey),
                            const SizedBox(height: 12),
                            Text(
                              'No leave history',
                              style: GoogleFonts.poppins(
                                color: colorTextSubtle,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: ctrl.history.length,
                      itemBuilder: (_, i) => _historyItem(ctrl.history[i]),
                    );
                  },
                ),
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Card(
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
                                  const Icon(Icons.person_outline,
                                      color: colorPrimary, size: 20),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Employee',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: colorTextPrimary,
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(height: 24),
                              _row('Name', widget.employeeName),
                              _row('Leave Type', widget.leaveTypeName),
                              _row('Period', widget.period),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: color,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 11, color: colorTextSubtle),
        ),
      ],
    );
  }

  Widget _divider() {
    return Container(height: 40, width: 1, color: colorGreyLight);
  }

  Widget _historyItem(LeaveHistoryModel h) {
    final c = _statusColor(h.status);
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: colorGreyLight),
      ),
      color: colorCard,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_fmt(h.startDatetime)} → ${_fmt(h.endDatetime)}',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: colorTextPrimary,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: c.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: c.withOpacity(0.3)),
                  ),
                  child: Text(
                    h.status,
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      color: c,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              '${h.totalDays.toStringAsFixed(0)} day(s)',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: colorPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (h.description?.isNotEmpty == true) ...[
              const SizedBox(height: 2),
              Text(
                h.description!,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: colorTextSubtle,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            if (h.approverName?.isNotEmpty == true) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.person_outline,
                      size: 12, color: colorTextSubtle),
                  const SizedBox(width: 4),
                  Text(
                    'Approved by: ${h.approverName}',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: colorTextSubtle,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(color: colorTextSubtle, fontSize: 14),
          ),
          const SizedBox(width: 16),
          Flexible(
            child: Text(
              value,
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
    );
  }
}