import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/features/accounting/asset_movement/presentation/controllers/asset_movement_controller.dart';
import 'package:erp_mobile_cnplus/features/accounting/asset_movement/presentation/widgets/asset_movement_list_item.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/shared/widgets/pagination_bottom_bar.dart';
import 'asset_movement_detail_screen.dart';
import 'asset_movement_form_screen.dart';

class AssetMovementListScreen extends StatefulWidget {
  const AssetMovementListScreen({super.key});

  @override
  State<AssetMovementListScreen> createState() => _AssetMovementListScreenState();
}

class _AssetMovementListScreenState extends State<AssetMovementListScreen> {
  final _searchCtrl = TextEditingController();
  DateTimeRange? _range;

  String? get _start => _range == null ? null : DateFormat('yyyy-MM-dd').format(_range!.start);
  String? get _end => _range == null ? null : DateFormat('yyyy-MM-dd').format(_range!.end);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _reload());
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _reload() => context.read<AssetMovementController>().fetchList(startDate: _start, endDate: _end);

  Future<void> _pickRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(DateTime.now().year + 1, 12, 31),
      initialDateRange: _range,
      builder: (ctx, child) => Theme(data: Theme.of(ctx).copyWith(colorScheme: const ColorScheme.light(primary: colorPrimary)), child: child!),
    );
    if (picked == null || !mounted) return;
    setState(() => _range = picked);
    _reload();
  }

  void _clearRange() {
    setState(() => _range = null);
    _reload();
  }

  void _goToForm() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const AssetMovementFormScreen())).then((_) => _reload());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new), onPressed: () => Navigator.pop(context)),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Asset Movement', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 20, color: colorTextPrimary)),
            Text(
              _range == null
                  ? 'Asset PIC and location changes'
                  : '${DateFormat('d MMM yyyy').format(_range!.start)} - ${DateFormat('d MMM yyyy').format(_range!.end)}',
              style: GoogleFonts.poppins(color: colorTextSubtle, fontSize: 12),
            ),
          ],
        ),
        elevation: 0.5,
        backgroundColor: colorWhite,
        foregroundColor: colorTextPrimary,
        actions: [
          IconButton(
            icon: Row(mainAxisSize: MainAxisSize.min, children: [
              const Icon(Icons.date_range_outlined, size: 20),
              if (_range != null)
                Container(margin: const EdgeInsets.only(left: 2), width: 8, height: 8,
                    decoration: const BoxDecoration(color: colorPrimary, shape: BoxShape.circle)),
            ]),
            onPressed: _pickRange,
          ),
          if (_range != null) IconButton(icon: const Icon(Icons.close, size: 20), onPressed: _clearRange),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: colorCard,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: TextField(
              controller: _searchCtrl,
              onChanged: (v) => context.read<AssetMovementController>().search(v),
              decoration: InputDecoration(
                hintText: 'Look for reference, asset or location...',
                hintStyle: GoogleFonts.poppins(fontSize: 13, color: colorGrey),
                prefixIcon: const Icon(Icons.search, color: colorGrey, size: 20),
                suffixIcon: _searchCtrl.text.isNotEmpty
                    ? IconButton(icon: const Icon(Icons.close, color: colorGrey, size: 18), onPressed: () {
                        _searchCtrl.clear();
                        context.read<AssetMovementController>().clearSearch();
                      })
                    : null,
                filled: true, fillColor: colorBackground,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: colorGreyLight)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: colorPrimary, width: 1.5)),
              ),
            ),
          ),
          Expanded(
            child: Consumer<AssetMovementController>(
              builder: (_, ctrl, __) {
                final bar = PaginationBottomBar(
                  currentPage: ctrl.currentPage, lastPage: ctrl.lastPage,
                  hasPrev: ctrl.hasPrev, hasNext: ctrl.hasNext,
                  onGoToPage: ctrl.goToPage, onPrev: ctrl.prevPage, onNext: ctrl.nextPage,
                  onCreateTap: _goToForm,
                );

                if (ctrl.isLoadingList) return const Center(child: CircularProgressIndicator(color: colorPrimary));
                if (ctrl.listError != null && ctrl.pageItems.isEmpty) {
                  return Center(child: Text(ctrl.listError!, style: GoogleFonts.poppins(color: colorError)));
                }
                if (ctrl.pageItems.isEmpty) {
                  return Column(children: [
                    Expanded(child: Center(child: Text(
                      _searchCtrl.text.isNotEmpty ? 'Asset Movement not found' : 'No asset movements yet',
                      style: GoogleFonts.poppins(fontSize: 16, color: colorTextSubtle),
                    ))),
                    bar,
                  ]);
                }

                return Column(children: [
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: _reload,
                      color: colorPrimary,
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                        itemCount: ctrl.pageItems.length,
                        itemBuilder: (_, i) => AssetMovementListItem(
                          movement: ctrl.pageItems[i],
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => AssetMovementDetailScreen(encryption: ctrl.pageItems[i].encryption)),
                          ),
                        ),
                      ),
                    ),
                  ),
                  bar,
                ]);
              },
            ),
          ),
        ],
      ),
    );
  }
}