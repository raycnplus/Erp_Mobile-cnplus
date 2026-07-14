import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/shared/widgets/pagination_bottom_bar.dart';
import 'package:erp_mobile_cnplus/features/hr/employee_status/presentation/controllers/employee_status_controller.dart';
import 'package:erp_mobile_cnplus/features/hr/employee_status/presentation/widgets/employee_status_list_item.dart';
import 'employee_status_detail_screen.dart';
import 'employee_status_form_screen.dart';

class EmployeeStatusListScreen extends StatefulWidget {
  const EmployeeStatusListScreen({
    super.key,
  });

  @override
  State<EmployeeStatusListScreen> createState() =>
      _EmployeeStatusListScreenState();
}

class _EmployeeStatusListScreenState
    extends State<EmployeeStatusListScreen> {
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EmployeeStatusController>().fetchList();
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _goToForm() => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const EmployeeStatusFormScreen()),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: colorWhite,
        foregroundColor: colorTextPrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Employee Status',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: colorTextPrimary,
                fontSize: 20,
              ),
            ),
            Text(
              'Manage employee statuses',
              style: GoogleFonts.poppins(
                color: colorTextSubtle,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            color: colorCard,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: TextField(
              controller: _searchCtrl,
              onChanged: (value) {
                context.read<EmployeeStatusController>().search(value);
                setState(() {});
              },
              decoration: InputDecoration(
                hintText: 'Search status...',
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
                          context.read<EmployeeStatusController>().clearSearch();
                          setState(() {});
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
                  borderSide: const BorderSide(
                    color: colorGreyLight,
                    width: 1,
                  ),
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
            child: Consumer<EmployeeStatusController>(
              builder: (_, controller, __) {
                final bar = PaginationBottomBar(
                  currentPage: controller.currentPage,
                  lastPage: controller.lastPage,
                  hasPrev: controller.hasPrevPage,
                  hasNext: controller.hasNextPage,
                  onGoToPage: controller.goToPage,
                  onPrev: controller.prevPage,
                  onNext: controller.nextPage,
                  onCreateTap: _goToForm,
                );

                if (controller.isLoadingList) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: colorPrimary,
                    ),
                  );
                }

                if (controller.listError != null &&
                    controller.itemList.isEmpty) {
                  return _buildErrorState(controller);
                }

                if (controller.itemList.isEmpty) {
                  return Column(
                    children: [
                      Expanded(
                        child: _buildEmptyState(_searchCtrl.text.isNotEmpty),
                      ),
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
                            '${controller.total} statuses',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: colorTextSubtle,
                            ),
                          ),
                          Text(
                            'Pages ${controller.currentPage} of ${controller.lastPage}',
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
                        color: colorPrimary,
                        onRefresh: () {
                          return controller.fetchList();
                        },
                        child: ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                          itemCount: controller.itemList.length,
                          itemBuilder: (_, index) {
                            final item = controller.itemList[index];
                            return EmployeeStatusListItem(
                              status: item,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) {
                                      return EmployeeStatusDetailScreen(
                                        encryption: item.encryption,
                                      );
                                    },
                                  ),
                                );
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

  Widget _buildErrorState(EmployeeStatusController controller) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: colorError,
            ),
            const SizedBox(height: 16),
            Text(
              controller.listError!,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: colorError,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: controller.fetchList,
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

  Widget _buildEmptyState(bool isSearching) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isSearching ? Icons.search_off : Icons.badge_outlined,
            size: 80,
            color: colorGrey,
          ),
          const SizedBox(height: 16),
          Text(
            isSearching ? 'Status not found' : 'No employee statuses yet',
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
                context.read<EmployeeStatusController>().clearSearch();
                setState(() {});
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