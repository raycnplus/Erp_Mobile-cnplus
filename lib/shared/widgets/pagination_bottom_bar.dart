import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';

class PaginationBottomBar extends StatelessWidget {
  final int currentPage;
  final int lastPage;
  final bool hasPrev;
  final bool hasNext;
  final void Function(int page) onGoToPage;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final VoidCallback? onCreateTap;

  const PaginationBottomBar({
    super.key,
    required this.currentPage,
    required this.lastPage,
    required this.hasPrev,
    required this.hasNext,
    required this.onGoToPage,
    required this.onPrev,
    required this.onNext,
    this.onCreateTap,
  });

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    final maxBtn = ((sw - 32 - 4 * 36 - 90) / 36).floor().clamp(1, 5);
    int start = (currentPage - maxBtn ~/ 2).clamp(1, lastPage);
    int end = (start + maxBtn - 1).clamp(1, lastPage);
    if (end - start < maxBtn - 1) start = (end - maxBtn + 1).clamp(1, lastPage);

    final pageButtons = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _PgIconBtn(
          icon: Icons.first_page,
          onTap: currentPage > 1 ? () => onGoToPage(1) : null,
        ),
        const SizedBox(width: 4),
        _PgIconBtn(
          icon: Icons.chevron_left,
          onTap: hasPrev ? onPrev : null,
        ),
        const SizedBox(width: 4),
        for (int p = start; p <= end; p++) ...[
          _PgNumBtn(
            page: p,
            isActive: p == currentPage,
            onTap: () => onGoToPage(p),
          ),
          const SizedBox(width: 4),
        ],
        _PgIconBtn(
          icon: Icons.chevron_right,
          onTap: hasNext ? onNext : null,
        ),
        const SizedBox(width: 4),
        _PgIconBtn(
          icon: Icons.last_page,
          onTap: currentPage < lastPage ? () => onGoToPage(lastPage) : null,
        ),
      ],
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: colorCard,
        border: const Border(top: BorderSide(color: colorGreyLight)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: onCreateTap != null
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: pageButtons,
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: onCreateTap,
                  icon: const Icon(Icons.add, size: 18, color: colorWhite),
                  label: Text(
                    'Create',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: colorWhite,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorPrimary,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    elevation: 0,
                  ),
                ),
              ],
            )
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Center(
                widthFactor: 1,
                child: SizedBox(
                  width: sw - 24,
                  child: Center(child: pageButtons),
                ),
              ),
            ),
    );
  }
}

class _PgIconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _PgIconBtn({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: enabled ? colorBackground : colorGreyLight,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: colorGreyLight),
        ),
        child: Icon(icon, size: 17, color: enabled ? colorTextPrimary : colorGrey),
      ),
    );
  }
}

class _PgNumBtn extends StatelessWidget {
  final int page;
  final bool isActive;
  final VoidCallback onTap;

  const _PgNumBtn({required this.page, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isActive ? null : onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: isActive ? colorPrimary : colorBackground,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isActive ? colorPrimary : colorGreyLight),
        ),
        child: Center(
          child: Text(
            '$page',
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              color: isActive ? colorWhite : colorTextPrimary,
            ),
          ),
        ),
      ),
    );
  }
}