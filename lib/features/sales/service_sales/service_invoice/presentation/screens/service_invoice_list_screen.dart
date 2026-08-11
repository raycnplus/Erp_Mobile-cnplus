import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/features/sales/service_sales/service_invoice/presentation/controllers/service_invoice_controller.dart';
import 'package:erp_mobile_cnplus/features/sales/service_sales/service_invoice/presentation/widgets/service_invoice_list_item.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/shared/widgets/pagination_bottom_bar.dart';
import 'service_invoice_detail_screen.dart';
import 'service_invoice_form_screen.dart';

class ServiceInvoiceListScreen extends StatefulWidget {
  const ServiceInvoiceListScreen({
    super.key,
  });

  @override
  State<ServiceInvoiceListScreen> createState() {
    return _State();
  }
}

class _State extends State<ServiceInvoiceListScreen> {
  final _searchCtrl = TextEditingController();
  String? _selectedStatus;
  static const _statuses = [
    'Draft',
    'Waiting Approval',
    'Confirmed',
    'Posted',
    'Cancelled',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ServiceInvoiceController>().fetchList();
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _goToForm() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ServiceInvoiceFormScreen()),
    ).then((_) {
      context.read<ServiceInvoiceController>().fetchList(status: _selectedStatus);
    });
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
              'Service Invoices',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: colorTextPrimary,
                fontSize: 20,
              ),
            ),
            Text(
              'Service invoice management',
              style: GoogleFonts.poppins(
                color: colorTextSubtle,
                fontSize: 12,
              ),
            ),
          ],
        ),
        elevation: 0.5,
        backgroundColor: colorWhite,
        foregroundColor: colorTextPrimary,
        actions: [
          Consumer<ServiceInvoiceController>(
            builder: (_, ctrl, __) {
              return PopupMenuButton<String>(
                icon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.filter_list,
                      size: 20,
                    ),
                    if (_selectedStatus != null && _selectedStatus!.isNotEmpty) ...[
                      const SizedBox(width: 2),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: colorPrimary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ],
                ),
                onSelected: (s) {
                  final status = s.isEmpty ? null : s;
                  setState(() {
                    _selectedStatus = status;
                  });
                  ctrl.fetchList(status: status);
                },
                itemBuilder: (_) {
                  return [
                    const PopupMenuItem(
                      value: '',
                      child: Text('All Status'),
                    ),
                    ..._statuses.map((s) {
                      return PopupMenuItem(
                        value: s,
                        child: Text(s),
                      );
                    }),
                  ];
                },
              );
            },
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
              onChanged: (v) {
                context.read<ServiceInvoiceController>().search(v);
              },
              decoration: InputDecoration(
                hintText: 'Look for references or customers...',
                hintStyle: GoogleFonts.poppins(
                  fontSize: 13,
                  color: colorGrey,
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: colorGrey,
                  size: 20,
                ),
                suffixIcon: _searchCtrl.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: colorGrey,
                          size: 18,
                        ),
                        onPressed: () {
                          _searchCtrl.clear();
                          context.read<ServiceInvoiceController>().clearSearch();
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
                  borderSide: const BorderSide(color: colorGreyLight),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: colorPrimary,
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Consumer<ServiceInvoiceController>(
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
                  return const Center(
                    child: CircularProgressIndicator(color: colorPrimary),
                  );
                }

                if (ctrl.listError != null && ctrl.pageItems.isEmpty) {
                  return _buildErrorState(ctrl);
                }

                if (ctrl.pageItems.isEmpty) {
                  return Column(
                    children: [
                      Expanded(child: _buildEmptyState(_searchCtrl.text.isNotEmpty)),
                      bar,
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
                            '${ctrl.total} service invoices',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: colorTextSubtle,
                            ),
                          ),
                          Text(
                            'Pages ${ctrl.currentPage} of ${ctrl.lastPage}',
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
                        onRefresh: () {
                          return ctrl.fetchList(status: _selectedStatus);
                        },
                        color: colorPrimary,
                        child: ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                          itemCount: ctrl.pageItems.length,
                          itemBuilder: (_, i) {
                            return ServiceInvoiceListItem(
                              invoice: ctrl.pageItems[i],
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) {
                                      return ServiceInvoiceDetailScreen(
                                        encryption: ctrl.pageItems[i].encryption,
                                      );
                                    },
                                  ),
                                ).then((_) {
                                  ctrl.fetchList(status: _selectedStatus);
                                });
                              },
                            );
                          },
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

  Widget _buildErrorState(ServiceInvoiceController ctrl) {
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
              onPressed: () => ctrl.fetchList(status: _selectedStatus),
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

  Widget _buildEmptyState(bool isSearching) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isSearching ? Icons.search_off : Icons.receipt_long_outlined,
            size: 80,
            color: colorGrey,
          ),
          const SizedBox(height: 16),
          Text(
            isSearching ? 'Service invoice not found' : 'No service invoices yet',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: colorTextSubtle,
            ),
          ),
          if (isSearching) ...[
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: () {
                _searchCtrl.clear();
                context.read<ServiceInvoiceController>().clearSearch();
              },
              icon: const Icon(Icons.close, size: 16, color: colorPrimary),
              label: Text('Clear search',
                  style: GoogleFonts.poppins(color: colorPrimary, fontSize: 14)),
            ),
          ],
        ],
      ),
    );
  }
}