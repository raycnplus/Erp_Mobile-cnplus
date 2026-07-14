import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/features/hr/leave_request/data/models/leave_request_models.dart';
import 'package:erp_mobile_cnplus/shared/widgets/audit_trail_list.dart';

class LeaveRequestDetailTabs extends StatefulWidget {
  final LeaveRequestDetailModel detail;
  final VoidCallback? onApprove;
  final VoidCallback? onReject;
  final bool canApprove;

  const LeaveRequestDetailTabs({
    super.key,
    required this.detail,
    this.onApprove,
    this.onReject,
    this.canApprove = false,
  });

  @override
  State<LeaveRequestDetailTabs> createState() =>
      _LeaveRequestDetailTabsState();
}

class _LeaveRequestDetailTabsState extends State<LeaveRequestDetailTabs>
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

  String _fmt(String? d) {
    if (d == null) return '-';
    try {
      return DateFormat('d MMM yyyy').format(DateTime.parse(d));
    } catch (_) {
      return d;
    }
  }

  String _fmtDt(String? d) {
    if (d == null) return '-';
    try {
      return DateFormat('d MMM yyyy, hh:mm a').format(DateTime.parse(d));
    } catch (_) {
      return d;
    }
  }

  String _safe(dynamic v) =>
      (v == null || v.toString().isEmpty) ? '-' : v.toString();

  String _durationLabel(String? t) {
    switch (t) {
      case 'FULL':
        return 'Full Day';
      case 'HALF':
        return 'Half Day';
      default:
        return _safe(t);
    }
  }

  String _sessionLabel(String? s) {
    switch (s) {
      case 'MORNING':
        return 'Morning (First Half)';
      case 'AFTERNOON':
        return 'Afternoon (Second Half)';
      default:
        return _safe(s);
    }
  }

  Widget _buildPipeline() {
    final status = widget.detail.status;
    final isRejected = status == 'Rejected';
    final steps = isRejected
        ? ['Draft', 'Waiting Approval', 'Rejected']
        : ['Draft', 'Waiting Approval', 'Approved'];
    final activeIdx = steps.indexOf(status).clamp(0, steps.length - 1);

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Row(
        children: List.generate(steps.length * 2 - 1, (i) {
          if (i.isOdd) {
            final passed = (i ~/ 2) < activeIdx;
            return Expanded(
              child: Container(
                height: 2,
                color: passed ? colorPrimary : colorGreyLight,
              ),
            );
          }
          final idx = i ~/ 2;
          final isDone = idx < activeIdx;
          final isCurrent = idx == activeIdx;
          final label = steps[idx];
          Color dotColor = colorGreyLight;
          if (isCurrent) {
            dotColor = label == 'Rejected'
                ? const Color(0xFFC62828)
                : label == 'Approved'
                    ? const Color(0xFF2E7D32)
                    : colorPrimary;
          } else if (isDone) {
            dotColor = colorPrimary;
          }
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (isDone || isCurrent) ? dotColor : Colors.white,
                  border: Border.all(
                    color: (isDone || isCurrent) ? dotColor : colorGreyLight,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: isDone
                      ? const Icon(Icons.check, size: 15, color: Colors.white)
                      : isCurrent
                          ? Icon(
                              _dotIcon(label),
                              size: 14,
                              color: Colors.white,
                            )
                          : null,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label == 'Waiting Approval' ? 'Waiting' : label,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 9,
                  fontWeight:
                      isCurrent ? FontWeight.w700 : FontWeight.normal,
                  color: isCurrent
                      ? dotColor
                      : isDone
                          ? colorPrimary
                          : colorGrey,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  IconData _dotIcon(String s) {
    switch (s) {
      case 'Approved':
        return Icons.check;
      case 'Rejected':
        return Icons.close;
      case 'Waiting Approval':
        return Icons.access_time;
      default:
        return Icons.edit_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.detail;
    return Column(
      children: [
        _buildPipeline(),
        const Divider(height: 1, thickness: 1, color: colorGreyLight),
        if (d.isWaitingApproval && widget.canApprove)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
            child: Row(
              children: [
                if (widget.onApprove != null)
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: widget.onApprove,
                      icon: const Icon(Icons.check, size: 18),
                      label: Text(
                        'Approve',
                        style:
                            GoogleFonts.poppins(fontWeight: FontWeight.w600),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E7D32),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                if (widget.onApprove != null && widget.onReject != null)
                  const SizedBox(width: 12),
                if (widget.onReject != null)
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: widget.onReject,
                      icon: const Icon(Icons.close, size: 18),
                      label: Text(
                        'Reject',
                        style:
                            GoogleFonts.poppins(fontWeight: FontWeight.w600),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorError,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        TabBar(
          controller: _tab,
          labelColor: colorPrimary,
          unselectedLabelColor: colorTextSubtle,
          indicatorColor: colorPrimary,
          labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          tabs: const [Tab(text: 'Info'), Tab(text: 'Audit Trail')],
        ),
        Expanded(
          child: TabBarView(
            controller: _tab,
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _infoCard('Leave Info', Icons.event_available_outlined, [
                      _row('Employee', _safe(d.employeeName)),
                      _row('Leave Type', _safe(d.leaveTypeName)),
                      _row('Start Date', _fmt(d.startDatetime)),
                      _row('End Date', _fmt(d.endDatetime)),
                      _row('Duration',
                          '${d.totalDays.toStringAsFixed(2)} day(s)'),
                      _row('Type', _durationLabel(d.durationType)),
                      if (d.halfSession != null)
                        _row('Session', _sessionLabel(d.halfSession)),
                      if (d.description?.isNotEmpty == true)
                        _row('Description', d.description!),
                      _row(
                        'Attachment',
                        d.attachmentUrl?.isNotEmpty == true
                            ? d.attachmentUrl!
                            : 'No attachment',
                      ),
                    ]),
                    const SizedBox(height: 12),
                    _infoCard('Submitted By', Icons.person_outline, [
                      _row('Created By', _safe(d.createdByName)),
                      _row('Created On', _fmtDt(d.createdDate)),
                    ]),
                  ],
                ),
              ),
              AuditTrailList(
                items: d.auditTrails
                    .map((a) => AuditTrailItem(
                          actionByName: a.actionByName,
                          actionById: a.actionById,
                          date: a.date,
                          description: a.description,
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(color: colorTextSubtle, fontSize: 13),
          ),
          const SizedBox(width: 16),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                color: colorTextPrimary,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoCard(String title, IconData icon, List<Widget> rows) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: colorCard,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: colorPrimary, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: colorTextPrimary,
                  ),
                ),
              ],
            ),
            const Divider(height: 20),
            ...rows,
          ],
        ),
      ),
    );
  }
}