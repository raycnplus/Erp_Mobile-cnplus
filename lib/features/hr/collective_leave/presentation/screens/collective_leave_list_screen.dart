import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/features/hr/collective_leave/presentation/controllers/collective_leave_controller.dart';
import 'package:erp_mobile_cnplus/features/hr/collective_leave/presentation/widgets/collective_leave_list_item.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'collective_leave_detail_screen.dart';
import 'collective_leave_form_screen.dart';

class CollectiveLeaveListScreen extends StatefulWidget {
  const CollectiveLeaveListScreen({super.key});

  @override
  State<CollectiveLeaveListScreen> createState() =>
      _CollectiveLeaveListScreenState();
}

class _CollectiveLeaveListScreenState extends State<CollectiveLeaveListScreen> {
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => context.read<CollectiveLeaveController>().fetchList(),
    );
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Collective Leave',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: colorTextPrimary,
                fontSize: 20,
              ),
            ),
            Text(
              'Manage collective leaves',
              style: GoogleFonts.poppins(color: colorTextSubtle, fontSize: 12),
            ),
          ],
        ),
        elevation: 0.5,
        backgroundColor: colorWhite,
        foregroundColor: colorTextPrimary,
      ),
      body: Column(
        children: [
          Container(
            color: colorCard,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: TextField(
              controller: _searchCtrl,
              onChanged: (v) =>
                  context.read<CollectiveLeaveController>().search(v),
              decoration: InputDecoration(
                hintText: 'Cari cuti bersama...',
                hintStyle: GoogleFonts.poppins(fontSize: 13, color: colorGrey),
                prefixIcon: const Icon(Icons.search, color: colorGrey, size: 20),
                suffixIcon: _searchCtrl.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close,
                            color: colorGrey, size: 18),
                        onPressed: () {
                          _searchCtrl.clear();
                          context
                              .read<CollectiveLeaveController>()
                              .clearSearch();
                        },
                      )
                    : null,
                filled: true,
                fillColor: colorBackground,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: colorGreyLight, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: colorPrimary, width: 1.5),
                ),
              ),
            ),
          ),
          Expanded(
            child: Consumer<CollectiveLeaveController>(
              builder: (_, ctrl, __) {
                if (ctrl.isLoadingList) {
                  return const Center(
                    child: CircularProgressIndicator(color: colorPrimary),
                  );
                }
                if (ctrl.listError != null && ctrl.pageItems.isEmpty) {
                  return _error(ctrl);
                }
                if (ctrl.pageItems.isEmpty) {
                  return Column(
                    children: [
                      Expanded(child: _empty(_searchCtrl.text.isNotEmpty)),
                      _bottomBar(context, ctrl),
                    ],
                  );
                }
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${ctrl.total} cuti bersama',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: colorTextSubtle,
                            ),
                          ),
                          Text(
                            'Hal ${ctrl.currentPage} dari ${ctrl.lastPage}',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: colorTextSubtle,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: ctrl.fetchList,
                        color: colorPrimary,
                        child: ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                          itemCount: ctrl.pageItems.length,
                          itemBuilder: (_, i) => CollectiveLeaveListItem(
                            collectiveLeave: ctrl.pageItems[i],
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CollectiveLeaveDetailScreen(
                                  encryption: ctrl.pageItems[i].encryption,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    _bottomBar(context, ctrl),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomBar(BuildContext context, CollectiveLeaveController ctrl) {
    final current = ctrl.currentPage;
    final last = ctrl.lastPage;
    final screenWidth = MediaQuery.of(context).size.width;
    final maxBtn =
        ((screenWidth - 32 - 4 * 36 - 90) / 36).floor().clamp(1, 5);
    int start = (current - maxBtn ~/ 2).clamp(1, last);
    int end = (start + maxBtn - 1).clamp(1, last);
    if (end - start < maxBtn - 1) start = (end - maxBtn + 1).clamp(1, last);

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
      child: Row(
        children: [
          Flexible(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _PgBtn(
                    icon: Icons.first_page,
                    onTap: current > 1 ? () => ctrl.goToPage(1) : null,
                  ),
                  const SizedBox(width: 4),
                  _PgBtn(
                    icon: Icons.chevron_left,
                    onTap: ctrl.hasPrev ? ctrl.prevPage : null,
                  ),
                  const SizedBox(width: 4),
                  for (int p = start; p <= end; p++) ...[
                    _PgNumBtn(
                      page: p,
                      isActive: p == current,
                      onTap: () => ctrl.goToPage(p),
                    ),
                    const SizedBox(width: 4),
                  ],
                  _PgBtn(
                    icon: Icons.chevron_right,
                    onTap: ctrl.hasNext ? ctrl.nextPage : null,
                  ),
                  const SizedBox(width: 4),
                  _PgBtn(
                    icon: Icons.last_page,
                    onTap: current < last ? () => ctrl.goToPage(last) : null,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton.icon(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const CollectiveLeaveFormScreen(),
              ),
            ),
            icon: const Icon(Icons.add, size: 18, color: colorWhite),
            label: Text(
              'Tambah',
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: colorWhite,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: colorPrimary,
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _error(CollectiveLeaveController ctrl) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: colorError),
            const SizedBox(height: 16),
            Text(
              ctrl.listError!,
              style: GoogleFonts.poppins(color: colorError),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: ctrl.fetchList,
              style: ElevatedButton.styleFrom(
                backgroundColor: colorPrimary,
                foregroundColor: colorWhite,
              ),
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _empty(bool isSearching) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isSearching
                ? Icons.search_off
                : Icons.calendar_month_outlined,
            size: 80,
            color: colorGrey,
          ),
          const SizedBox(height: 16),
          Text(
            isSearching
                ? 'Cuti bersama tidak ditemukan'
                : 'No collective leaves yet',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: colorTextSubtle,
            ),
          ),
        ],
      ),
    );
  }
}

class _PgBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _PgBtn({required this.icon, this.onTap});

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
        child: Icon(
          icon,
          size: 17,
          color: enabled ? colorTextPrimary : colorGrey,
        ),
      ),
    );
  }
}

class _PgNumBtn extends StatelessWidget {
  final int page;
  final bool isActive;
  final VoidCallback onTap;

  const _PgNumBtn({
    required this.page,
    required this.isActive,
    required this.onTap,
  });

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
          border: Border.all(
            color: isActive ? colorPrimary : colorGreyLight,
          ),
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