import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';

class AuditTrailItem {
  final String? actionByName;
  final String? actionById;
  final String? date;
  final String? description;

  const AuditTrailItem({
    this.actionByName,
    this.actionById,
    this.date,
    this.description,
  });
}

class AuditTrailList extends StatelessWidget {
  final List<AuditTrailItem> items;
  final EdgeInsetsGeometry padding;

  const AuditTrailList({
    super.key,
    required this.items,
    this.padding = const EdgeInsets.all(16),
  });

  static const _palette = [
    Color(0xFF6F42C1),
    Color(0xFFD63384),
    Color(0xFFFD7E14),
    Color(0xFF20C997),
    Color(0xFF198754),
    Color(0xFF0DCAF0),
    Color(0xFFFFC107),
    Color(0xFFDC3545),
  ];

  Color _avatarColor(String? id) {
    final key = int.tryParse(id ?? '0') ?? 0;
    return _palette[key % _palette.length];
  }

  String _initials(String? name) {
    final n = (name ?? '').trim();

    if (n.isEmpty) {
      return 'NA';
    }

    final parts = n.split(RegExp(r'\s+'));

    final first =
        parts[0].isNotEmpty ? parts[0][0].toUpperCase() : '';

    final second = parts.length > 1 && parts[1].isNotEmpty
        ? parts[1][0].toUpperCase()
        : '';

    return '$first$second';
  }

  String _displayName(AuditTrailItem item) {
    final id = item.actionById ?? '';

    if (id == '0' || id.isEmpty) {
      return 'SYSTEM';
    }

    return item.actionByName?.isNotEmpty == true
        ? item.actionByName!
        : 'Unknown';
  }

  String _fmtDate(String? date) {
    if (date == null) {
      return '-';
    }

    try {
      return DateFormat('MMM d, yyyy').format(DateTime.parse(date));
    } catch (_) {
      return date;
    }
  }

  String _fmtTime(String? date) {
    if (date == null) {
      return '';
    }

    try {
      return DateFormat('hh:mm:ss a').format(DateTime.parse(date));
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.history,
              size: 64,
              color: colorGrey,
            ),
            const SizedBox(height: 12),
            Text(
              'No audit trail',
              style: GoogleFonts.poppins(
                color: colorTextSubtle,
              ),
            ),
          ],
        ),
      );
    }

    final children = <Widget>[];
    String? lastDate;

    for (final item in items) {
      final dateLabel = _fmtDate(item.date);
      final timeLabel = _fmtTime(item.date);
      final name = _displayName(item);
      final initials = _initials(name);
      final color = _avatarColor(item.actionById);

      if (dateLabel != lastDate) {
        children.add(
          _DateSeparator(label: dateLabel),
        );

        lastDate = dateLabel;
      }

      children.add(
        Padding(
          padding: const EdgeInsets.only(
            bottom: 12,
            left: 8,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: color,
                child: Text(
                  initials,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Card(
                  elevation: 1,
                  margin: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: colorCard,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                name,
                                style: GoogleFonts.poppins(
                                  fontWeight:
                                      FontWeight.w600,
                                  fontSize: 13,
                                  color:
                                      colorTextPrimary,
                                ),
                              ),
                            ),
                            if (timeLabel.isNotEmpty)
                              Text(
                                timeLabel,
                                style:
                                    GoogleFonts.poppins(
                                  fontSize: 10,
                                  color: colorGrey,
                                ),
                              ),
                          ],
                        ),
                        if (item.description?.isNotEmpty ==
                            true) ...[
                          const SizedBox(height: 4),
                          _DescriptionText(
                            text: item.description!,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView(
      padding: padding,
      children: children,
    );
  }
}

class _DateSeparator extends StatelessWidget {
  final String label;

  const _DateSeparator({
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 12,
      ),
      child: Row(
        children: [
          const Expanded(
            child: Divider(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
            ),
            child: Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: colorGrey,
              ),
            ),
          ),
          const Expanded(
            child: Divider(),
          ),
        ],
      ),
    );
  }
}

class _DescriptionText extends StatelessWidget {
  final String text;

  const _DescriptionText({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final spans = <TextSpan>[];
    final parts = text.split('[Blank]');

    for (var i = 0; i < parts.length; i++) {
      if (parts[i].isNotEmpty) {
        spans.add(
          TextSpan(text: parts[i]),
        );
      }

      if (i < parts.length - 1) {
        spans.add(
          TextSpan(
            text: '[Blank]',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              color: colorTextPrimary,
            ),
          ),
        );
      }
    }

    return RichText(
      text: TextSpan(
        style: GoogleFonts.poppins(
          fontSize: 12,
          color: colorTextSubtle,
        ),
        children: spans,
      ),
    );
  }
}