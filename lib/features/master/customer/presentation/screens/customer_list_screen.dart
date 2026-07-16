import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/features/master/customer/presentation/controllers/customer_controller.dart';
import 'package:erp_mobile_cnplus/features/master/customer/presentation/widgets/customer_list_item.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/shared/widgets/pagination_bottom_bar.dart';
import 'customer_form_screen.dart';
import 'customer_detail_screen.dart';

class CustomerListScreen extends StatefulWidget {
  const CustomerListScreen({super.key});

  @override
  State<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctrl = context.read<CustomerController>();
      ctrl.fetchCustomerList();
      ctrl.fetchFormDropdownData();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String v) =>
      context.read<CustomerController>().searchCustomers(v);

  void _clearSearch() {
    _searchController.clear();
    context.read<CustomerController>().clearSearch();
  }

  Future<void> _handleRefresh() =>
      context.read<CustomerController>().fetchCustomerList();

  void _navigateToCreate() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CustomerFormScreen()),
    );
  }

  void _navigateToDetail(String encryption) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => CustomerDetailScreen(encryption: encryption)),
    );
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
            Text("Customers",
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    color: colorTextPrimary,
                    fontSize: 20)),
            Text('Manage your customers',
                style: GoogleFonts.poppins(
                    color: colorTextSubtle, fontSize: 12)),
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
              controller: _searchController,
              onChanged: _onSearchChanged,
              style: GoogleFonts.poppins(fontSize: 14, color: colorTextPrimary),
              decoration: InputDecoration(
                hintText: 'Search name, code, email...',
                hintStyle: GoogleFonts.poppins(fontSize: 13, color: colorGrey),
                prefixIcon:
                    const Icon(Icons.search, color: colorGrey, size: 20),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon:
                            const Icon(Icons.close, color: colorGrey, size: 18),
                        onPressed: _clearSearch)
                    : null,
                filled: true,
                fillColor: colorBackground,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: colorGreyLight, width: 1)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: colorPrimary, width: 1.5)),
              ),
            ),
          ),
          Expanded(
            child: Consumer<CustomerController>(
              builder: (context, ctrl, child) {
                final bar = PaginationBottomBar(
                  currentPage: ctrl.currentPage,
                  lastPage: ctrl.lastPage,
                  hasPrev: ctrl.hasPrevPage,
                  hasNext: ctrl.hasNextPage,
                  onGoToPage: ctrl.goToPage,
                  onPrev: ctrl.prevPage,
                  onNext: ctrl.nextPage,
                  onCreateTap: _navigateToCreate,
                );

                if (ctrl.isLoadingList) {
                  return const Center(
                      child: CircularProgressIndicator(color: colorPrimary));
                }

                if (ctrl.listError != null && ctrl.customerList.isEmpty) {
                  return _buildErrorState(ctrl.listError!, _handleRefresh);
                }

                if (ctrl.customerList.isEmpty) {
                  return Column(
                    children: [
                      Expanded(child: _buildEmptyState(
                        isSearching: _searchController.text.isNotEmpty,
                        onClearSearch: _clearSearch,
                      )),
                      bar,
                    ],
                  );
                }

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${ctrl.total} customers',
                              style: GoogleFonts.poppins(
                                  fontSize: 12, color: colorTextSubtle)),
                          Text('Pages ${ctrl.currentPage} of ${ctrl.lastPage}',
                              style: GoogleFonts.poppins(
                                  fontSize: 12, color: colorTextSubtle)),
                        ],
                      ),
                    ),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: _handleRefresh,
                        color: colorPrimary,
                        child: ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                          itemCount: ctrl.customerList.length,
                          itemBuilder: (context, index) {
                            final customer = ctrl.customerList[index];
                            return CustomerListItem(
                              customer: customer,
                              onTap: () => _navigateToDetail(customer.encryption),
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

  Widget _buildErrorState(String error, VoidCallback onRetry) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: colorError),
            const SizedBox(height: 16),
            Text(error,
                style: GoogleFonts.poppins(color: colorError),
                textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                  backgroundColor: colorPrimary, foregroundColor: colorWhite),
              child: const Text("Try Again"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState({bool isSearching = false, VoidCallback? onClearSearch}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(isSearching ? Icons.search_off : Icons.people_outline,
                size: 80, color: colorGrey),
            const SizedBox(height: 16),
            Text(
              isSearching ? 'Customer not found' : 'No customers yet',
              style: GoogleFonts.poppins(
                  fontSize: 18, fontWeight: FontWeight.w500, color: colorTextSubtle),
              textAlign: TextAlign.center,
            ),
            if (isSearching) ...[
              const SizedBox(height: 16),
              TextButton.icon(
                onPressed: onClearSearch,
                icon: const Icon(Icons.close, size: 16, color: colorPrimary),
                label: Text('Clear search',
                    style: GoogleFonts.poppins(color: colorPrimary, fontSize: 14)),
              ),
            ] else ...[
              const SizedBox(height: 8),
              Text('Tap + button to add your first customer',
                  style:
                      GoogleFonts.poppins(fontSize: 14, color: colorGreyDark)),
            ],
          ],
        ),
      ),
    );
  }
}