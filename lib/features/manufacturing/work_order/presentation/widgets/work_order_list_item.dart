import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/features/manufacturing/work_order/data/models/work_order_models.dart';

class WorkOrderListItem extends StatefulWidget {
  final WorkOrderModel wo;
  final VoidCallback onTapCard;
  final VoidCallback onStart;
  final VoidCallback onPause;
  final VoidCallback onResume;
  final VoidCallback onComplete;

  const WorkOrderListItem({
    super.key,
    required this.wo,
    required this.onTapCard,
    required this.onStart,
    required this.onPause,
    required this.onResume,
    required this.onComplete,
  });

  @override
  State<WorkOrderListItem> createState() => _State();
}

class _State extends State<WorkOrderListItem> {
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    if (widget.wo.isInProgress) {
      _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
        if (mounted) setState(() {});
      });
    }
  }

  @override
  void didUpdateWidget(covariant WorkOrderListItem old) {
    super.didUpdateWidget(old);
    if (widget.wo.isInProgress && _ticker == null) {
      _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
        if (mounted) setState(() {});
      });
    } else if (!widget.wo.isInProgress && _ticker != null) {
      _ticker?.cancel();
      _ticker = null;
    }
  }

  @override
  void dispose() {
    _ticker?.cancel();
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

  int _liveActualSeconds() {
    final wo = widget.wo;
    if (wo.isInProgress && wo.startTime != null) {
      try {
        final start = DateTime.parse(wo.startTime!);
        final elapsed = DateTime.now().difference(start).inSeconds;
        return wo.actualDuration + elapsed;
      } catch (_) {
        return wo.actualDuration;
      }
    }
    return wo.actualDuration;
  }

  String _fmtDuration(int totalSeconds) {
    if (totalSeconds < 0) totalSeconds = 0;
    final h = totalSeconds ~/ 3600;
    final m = (totalSeconds % 3600) ~/ 60;
    final s = totalSeconds % 60;
    return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final wo = widget.wo;
    final color = Color(wo.statusColor);

    return Card(
      color: colorCard,
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: colorGreyLight),
      ),
      child: InkWell(
        onTap: widget.onTapCard,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      wo.operationName ?? '-',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 14, color: colorTextPrimary),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: color.withOpacity(0.3)),
                    ),
                    child: Text(
                      wo.statusLabel,
                      style: GoogleFonts.poppins(fontSize: 10, color: color, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '${wo.moReference ?? '-'} • ${wo.productName ?? '-'}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(fontSize: 12, color: colorTextSubtle),
              ),
              if (wo.bomName?.isNotEmpty == true)
                Text(
                  'BoM: ${wo.bomName}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(fontSize: 11, color: colorGrey),
                ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Workstation: ${wo.workstationName ?? '-'}',
                      style: GoogleFonts.poppins(fontSize: 11, color: colorTextSubtle),
                    ),
                  ),
                  Text(
                    _fmt(wo.scheduledDate),
                    style: GoogleFonts.poppins(fontSize: 11, color: colorGrey),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Planned: ${wo.durationFormatted ?? '00:00:00'}',
                      style: GoogleFonts.poppins(fontSize: 11, color: colorTextSubtle),
                    ),
                  ),
                  Text(
                    'Actual: ${_fmtDuration(_liveActualSeconds())}',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: wo.isInProgress ? colorPrimary : colorTextPrimary,
                    ),
                  ),
                ],
              ),
              if (!wo.isCompleted) ...[
                const SizedBox(height: 10),
                Row(
                  children: [
                    if (wo.isPending)
                      _actionBtn('Start', Icons.play_arrow, colorPrimary, widget.onStart),
                    if (wo.isInProgress) ...[
                      _actionBtn('Pause', Icons.pause, Colors.orange, widget.onPause),
                      const SizedBox(width: 8),
                      _actionBtn('Complete', Icons.check_circle, Colors.green, widget.onComplete),
                    ],
                    if (wo.isPaused) ...[
                      _actionBtn('Resume', Icons.play_arrow, colorPrimary, widget.onResume),
                      const SizedBox(width: 8),
                      _actionBtn('Complete', Icons.check_circle, Colors.green, widget.onComplete),
                    ],
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _actionBtn(String label, IconData icon, Color color, VoidCallback onTap) => OutlinedButton.icon(
    onPressed: onTap,
    icon: Icon(icon, size: 14),
    label: Text(label, style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600)),
    style: OutlinedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      foregroundColor: color,
      side: BorderSide(color: color),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
    ),
  );
}