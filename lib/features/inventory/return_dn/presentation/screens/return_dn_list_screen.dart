import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/features/inventory/return_dn/presentation/controllers/return_dn_controller.dart';
import 'package:erp_mobile_cnplus/features/inventory/return_dn/presentation/widgets/return_dn_list_item.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/shared/widgets/pagination_bottom_bar.dart';
import 'return_dn_detail_screen.dart';
import 'return_dn_form_screen.dart';

class ReturnDNListScreen extends StatefulWidget {
  const ReturnDNListScreen({super.key});
  @override
  State<ReturnDNListScreen> createState() => _State();
}

class _State extends State<ReturnDNListScreen> {
  final _searchCtrl = TextEditingController();
  String? _selectedStatus;
  static const _statuses = ['Draft', 'Waiting Approval', 'Confirmed', 'Done', 'Cancelled'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => context.read<ReturnDNController>().fetchList());
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _goToForm() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const ReturnDNFormScreen()))
        .then((_) => context.read<ReturnDNController>().fetchList(status: _selectedStatus));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new), onPressed: () => Navigator.pop(context)),
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Return Delivery Note', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 20, color: colorTextPrimary)),
          Text('Delivery note return management', style: GoogleFonts.poppins(color: colorTextSubtle, fontSize: 12)),
        ]),
        elevation: 0.5,
        backgroundColor: colorWhite,
        foregroundColor: colorTextPrimary,
        actions: [
          Consumer<ReturnDNController>(
            builder: (_, ctrl, __) => PopupMenuButton<String>(
              icon: Row(mainAxisSize: MainAxisSize.min, children: [
                const Icon(Icons.filter_list, size: 20),
                if (_selectedStatus != null && _selectedStatus!.isNotEmpty)
                  Container(margin: const EdgeInsets.only(left: 2), width: 8, height: 8,
                      decoration: const BoxDecoration(color: colorPrimary, shape: BoxShape.circle)),
              ]),
              onSelected: (s) {
                final status = s.isEmpty ? null : s;
                setState(() => _selectedStatus = status);
                ctrl.fetchList(status: status);
              },
              itemBuilder: (_) => [
                const PopupMenuItem(value: '', child: Text('All Status')),
                ..._statuses.map((s) => PopupMenuItem(value: s, child: Text(s))),
              ],
            ),
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
              onChanged: (v) => context.read<ReturnDNController>().search(v),
              decoration: InputDecoration(
                hintText: 'Look for reference or DN...',
                hintStyle: GoogleFonts.poppins(fontSize: 13, color: colorGrey),
                prefixIcon: const Icon(Icons.search, color: colorGrey, size: 20),
                suffixIcon: _searchCtrl.text.isNotEmpty
                    ? IconButton(icon: const Icon(Icons.close, color: colorGrey, size: 18), onPressed: () {
                        _searchCtrl.clear();
                        context.read<ReturnDNController>().clearSearch();
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
            child: Consumer<ReturnDNController>(
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
                      _searchCtrl.text.isNotEmpty ? 'Return Delivery Note not found' : 'No return delivery note yet',
                      style: GoogleFonts.poppins(fontSize: 16, color: colorTextSubtle),
                    ))),
                    bar,
                  ]);
                }

                return Column(children: [
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () => ctrl.fetchList(status: _selectedStatus),
                      color: colorPrimary,
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                        itemCount: ctrl.pageItems.length,
                        itemBuilder: (_, i) => ReturnDNListItem(
                          rdn: ctrl.pageItems[i],
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => ReturnDNDetailScreen(encryption: ctrl.pageItems[i].encryption)),
                          ).then((_) => ctrl.fetchList(status: _selectedStatus)),
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