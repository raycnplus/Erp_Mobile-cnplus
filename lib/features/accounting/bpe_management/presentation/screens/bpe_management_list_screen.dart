import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/features/accounting/bpe_management/presentation/controllers/bpe_management_controller.dart';
import 'package:erp_mobile_cnplus/features/accounting/bpe_management/presentation/widgets/bpe_management_list_item.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/shared/widgets/pagination_bottom_bar.dart';
import 'bpe_management_detail_screen.dart';
import 'bpe_management_form_screen.dart';

class BpeManagementListScreen extends StatefulWidget {
  const BpeManagementListScreen({super.key});

  @override
  State<BpeManagementListScreen> createState() => _BpeManagementListScreenState();
}

class _BpeManagementListScreenState extends State<BpeManagementListScreen> {
  final _searchCtrl = TextEditingController();
  String? _selectedStatus;

  static const _statuses = ['Draft', 'Confirmed', 'Validated'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => context.read<BpeManagementController>().fetchList(),
    );
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _applyFilter() {
    return context.read<BpeManagementController>().fetchList(
          status: _selectedStatus,
          search: _searchCtrl.text.trim().isEmpty ? null : _searchCtrl.text.trim(),
        );
  }

  void _goToForm() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const BpeManagementFormScreen()),
    ).then((_) => _applyFilter());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'BPE Management',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: colorTextPrimary,
                fontSize: 20,
              ),
            ),
            Text(
              'Bukti Potong Elektronik',
              style: GoogleFonts.poppins(color: colorTextSubtle, fontSize: 12),
            ),
          ],
        ),
        elevation: 0.5,
        backgroundColor: colorWhite,
        foregroundColor: colorTextPrimary,
        actions: [
          PopupMenuButton<String>(
            icon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.filter_list, size: 20),
                if (_selectedStatus != null) ...[
                  const SizedBox(width: 2),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(color: colorPrimary, shape: BoxShape.circle),
                  ),
                ],
              ],
            ),
            onSelected: (s) {
              setState(() => _selectedStatus = s.isEmpty ? null : s);
              _applyFilter();
            },
            itemBuilder: (_) => [
              const PopupMenuItem(value: '', child: Text('All Status')),
              ..._statuses.map((s) => PopupMenuItem(value: s, child: Text(s))),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: colorCard,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: TextField(
              controller: _searchCtrl,
              onSubmitted: (_) => _applyFilter(),
              decoration: InputDecoration(
                hintText: 'Search BPE number...',
                hintStyle: GoogleFonts.poppins(fontSize: 13, color: colorGrey),
                prefixIcon: const Icon(Icons.search, color: colorGrey, size: 20),
                suffixIcon: _searchCtrl.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close, color: colorGrey, size: 18),
                        onPressed: () {
                          _searchCtrl.clear();
                          _applyFilter();
                        },
                      )
                    : null,
                filled: true,
                fillColor: colorBackground,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: colorGreyLight),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: colorPrimary, width: 1.5),
                ),
              ),
            ),
          ),
          Expanded(
            child: Consumer<BpeManagementController>(
              builder: (_, ctrl, __) {
                final bar = PaginationBottomBar(
                  currentPage: ctrl.currentPage,
                  lastPage: ctrl.lastPage,
                  hasPrev: ctrl.hasPrev,
                  hasNext: ctrl.hasNext,
                  onGoToPage: ctrl.goToPage,
                  onPrev: ctrl.prevPage,
                  onNext: ctrl.nextPage,
                  onCreateTap: _goToForm,
                );

                if (ctrl.isLoadingList) {
                  return const Center(child: CircularProgressIndicator(color: colorPrimary));
                }

                if (ctrl.listError != null && ctrl.items.isEmpty) {
                  return _buildErrorState(ctrl);
                }

                final isFiltering = _searchCtrl.text.isNotEmpty || _selectedStatus != null;

                if (ctrl.items.isEmpty) {
                  return Column(
                    children: [
                      Expanded(child: _buildEmptyState(isFiltering)),
                      bar,
                    ],
                  );
                }

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${ctrl.total} BPE',
                            style: GoogleFonts.poppins(fontSize: 12, color: colorTextSubtle),
                          ),
                          Text(
                            'Pages ${ctrl.currentPage} of ${ctrl.lastPage}',
                            style: GoogleFonts.poppins(fontSize: 12, color: colorTextSubtle),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: _applyFilter,
                        color: colorPrimary,
                        child: ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                          itemCount: ctrl.items.length,
                          itemBuilder: (_, i) => BpeManagementListItem(
                            item: ctrl.items[i],
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BpeManagementDetailScreen(
                                  encryption: ctrl.items[i].encryption,
                                ),
                              ),
                            ).then((_) => _applyFilter()),
                          ),
                        ),
                      ),
                    ),
                    bar,
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BpeManagementController ctrl) {
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
              onPressed: _applyFilter,
              style: ElevatedButton.styleFrom(
                backgroundColor: colorPrimary,
                foregroundColor: colorWhite,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isFiltering) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isFiltering ? Icons.search_off : Icons.description_outlined,
            size: 80,
            color: colorGrey,
          ),
          const SizedBox(height: 16),
          Text(
            isFiltering ? 'BPE not found' : 'No BPE yet',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: colorTextSubtle,
            ),
          ),
          if (isFiltering) ...[
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: () {
                setState(() {
                  _searchCtrl.clear();
                  _selectedStatus = null;
                });
                _applyFilter();
              },
              icon: const Icon(Icons.close, size: 16, color: colorPrimary),
              label: Text('Clear filter',
                  style: GoogleFonts.poppins(color: colorPrimary, fontSize: 14)),
            ),
          ],
        ],
      ),
    );
  }
}