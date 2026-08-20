import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:erp_mobile_cnplus/core/routes/app_routes.dart';
import 'drawer_menu_config.dart';

class UniversalDrawer extends StatelessWidget {
  final String currentModule;

  const UniversalDrawer({super.key, required this.currentModule});

  static const Color _accent = Color(0xFF2D6A4F);
  static final Color _accentBg = _accent.withOpacity(0.1);

  static const _brand = _MenuItem(
    title: 'Brand',
    icon: Icons.workspace_premium_outlined,
    route: AppRoutes.brandList,
  );
  static const _productCategory = _MenuItem(
    title: 'Product Category',
    icon: Icons.category_outlined,
    route: AppRoutes.productCategoryList,
  );
  static const _productType = _MenuItem(
    title: 'Product Type',
    icon: Icons.merge_type_outlined,
    route: AppRoutes.productTypeList,
  );
  static const _vendor = _MenuItem(
    title: 'Vendor',
    icon: Icons.handshake_outlined,
    route: AppRoutes.vendorList,
  );
  static const _customer = _MenuItem(
    title: 'Customer',
    icon: Icons.person_outline,
    route: AppRoutes.customerList,
  );
  static const _customerCategory = _MenuItem(
    title: 'Customer Category',
    icon: Icons.category_outlined,
    route: AppRoutes.customerCategoryList,
  );
  static const _project = _MenuItem(
    title: 'Project',
    icon: Icons.work_outline,
    route: AppRoutes.projectList,
  );
  static const _uom = _MenuItem(
    title: 'Unit of Measure',
    icon: Icons.straighten_outlined,
    route: AppRoutes.uomList,
  );
  static const _users = _MenuItem(
    title: 'Users',
    icon: Icons.manage_accounts_outlined,
    route: AppRoutes.userList,
  );
  static const _warehouseReport = _MenuItem(
    title: 'Warehouse Report',
    icon: Icons.warehouse_outlined,
    route: AppRoutes.warehouseReport,
  );
  static const _locationReport = _MenuItem(
    title: 'Location Report',
    icon: Icons.location_on_outlined,
    route: AppRoutes.locationReport,
  );
  static const _stockReport = _MenuItem(
    title: 'Stock Report',
    icon: Icons.inventory_2_outlined,
    route: AppRoutes.stockReport,
  );
  static const _stockMovement = _MenuItem(
    title: 'Stock Movement',
    icon: Icons.swap_vert_circle_outlined,
    route: AppRoutes.stockMovement,
  );
  static const _stockValuation = _MenuItem(
    title: 'Stock Valuation',
    icon: Icons.assessment_outlined,
    route: AppRoutes.stockValuation,
  );
  static const _historyStock = _MenuItem(
    title: 'Stock History',
    icon: Icons.history,
    route: AppRoutes.historyStock,
  );
  static const _expiredReport = _MenuItem(
    title: 'Expired Report',
    icon: Icons.event_busy_outlined,
    route: AppRoutes.expiredReport,
  );
  static const _productsExpansion = _MenuItem(
    title: 'Products',
    type: _MenuType.master,
    icon: Icons.inventory_2_outlined,
    children: [_MenuItem(title: 'Product', route: AppRoutes.productList)],
  );
  static const _warehouseExpansion = _MenuItem(
    title: 'Warehouse',
    type: _MenuType.master,
    icon: Icons.warehouse_outlined,
    children: [
      _MenuItem(title: 'Warehouse', route: AppRoutes.warehouseList),
      _MenuItem(title: 'Locations', route: AppRoutes.locationList),
    ],
  );
  static const _masterDataHeader = _MenuItem(
    title: 'Master Data',
    type: _MenuType.header,
  );
  static const _operationHeader = _MenuItem(
    title: 'Operation',
    type: _MenuType.header,
  );
  static const _reportHeader = _MenuItem(
    title: 'Report',
    type: _MenuType.header,
  );
  static const _configurationHeader = _MenuItem(
    title: 'Configuration',
    type: _MenuType.header,
  );
  static const _employee = _MenuItem(
    title: 'Employee',
    icon: Icons.people_outline,
    route: AppRoutes.employeeList,
  );

  static Map<String, List<_MenuItem>> get _staticMenus => {
    AppModule.inventory: [
      _operationHeader,
      _MenuItem(
        title: 'Transfer',
        type: _MenuType.master,
        icon: Icons.local_shipping_outlined,
        children: [
          _MenuItem(title: 'Receipt Note', route: AppRoutes.receiptNoteList),
          _MenuItem(title: 'Delivery Note', route: AppRoutes.deliveryNoteList),
        ],
      ),
      _MenuItem(
        title: 'Internal Transfer',
        type: _MenuType.master,
        icon: Icons.compare_arrows_outlined,
        children: [
          _MenuItem(
            title: 'Internal Transfer',
            route: AppRoutes.internalTransferList,
          ),
          _MenuItem(title: 'Transfer In', route: AppRoutes.leaveQuotaList),
          _MenuItem(title: 'Transfer Out', route: AppRoutes.leaveQuotaList),
        ],
      ),
      _MenuItem(
        title: 'Stock Count',
        icon: Icons.fact_check_outlined,
        route: AppRoutes.stockCountList,
      ),
      _MenuItem(
        title: 'Scrap Orders',
        icon: Icons.delete_sweep_outlined,
        route: AppRoutes.scrapOrderList,
      ),
      _MenuItem(
        title: 'Return Receipt Note',
        icon: Icons.assignment_return_outlined,
        route: AppRoutes.scrapOrderList,
      ),
      _MenuItem(
        title: 'Return Delivery Note',
        icon: Icons.keyboard_return_outlined,
        route: AppRoutes.scrapOrderList,
      ),
      _masterDataHeader,
      _productsExpansion,
      _brand,
      _productCategory,
      _productType,
      _warehouseExpansion,
      _vendor,
      _reportHeader,
      _warehouseReport,
      _locationReport,
      _stockReport,
      _stockMovement,
      _stockValuation,
      _historyStock,
      _expiredReport,
      _configurationHeader,
      _users,
      _uom,
    ],

    AppModule.sales: [
      _operationHeader,
      _MenuItem(
        title: 'Goods Operation',
        type: _MenuType.master,
        icon: Icons.point_of_sale_outlined,
        children: [
          _MenuItem(title: 'Quotation', route: AppRoutes.quotationList),
          _MenuItem(title: 'Sales Order', route: AppRoutes.salesOrderList),
          _MenuItem(title: 'Direct Sales', route: AppRoutes.directSalesList),
          _MenuItem(title: 'Invoice', route: AppRoutes.invoiceList),
        ],
      ),
      _MenuItem(
        title: 'Service Operation',
        type: _MenuType.master,
        icon: Icons.design_services_outlined,
        children: [
          _MenuItem(title: 'Quotation', route: AppRoutes.serviceQuotationList),
          _MenuItem(
            title: 'Sales Order',
            route: AppRoutes.serviceSalesOrderList,
          ),
          _MenuItem(
            title: 'Direct Sales',
            route: AppRoutes.serviceDirectSalesList,
          ),
          _MenuItem(title: 'Invoice', route: AppRoutes.serviceInvoiceList),
        ],
      ),
      _masterDataHeader,
      _customer,
      _customerCategory,
      _project,
      _productsExpansion,
      _brand,
      _productCategory,
      _productType,
      _MenuItem(
        title: 'Sales Team',
        icon: Icons.groups_outlined,
        route: AppRoutes.salesTeamList,
      ),
      _MenuItem(
        title: 'Price List',
        icon: Icons.view_list_outlined,
        route: AppRoutes.priceListList,
      ),
      _configurationHeader,
      _users,
      _uom,
    ],

    AppModule.purchase: [
      _operationHeader,
      _MenuItem(
        title: 'Purchase Request',
        icon: Icons.request_quote_outlined,
        route: AppRoutes.purchaseRequestList,
      ),
      _MenuItem(
        title: 'Request for Quotation',
        icon: Icons.description_outlined,
        route: AppRoutes.rfqList,
      ),
      _MenuItem(
        title: 'Purchase Order',
        icon: Icons.shopping_bag_outlined,
        route: AppRoutes.purchaseOrderList,
      ),
      _MenuItem(
        title: 'Direct Purchase',
        icon: Icons.shopping_cart_checkout_outlined,
        route: AppRoutes.directPurchaseList,
      ),
      _MenuItem(
        title: 'Bill',
        icon: Icons.receipt_long_outlined,
        route: AppRoutes.billList,
      ),
      _masterDataHeader,
      _productsExpansion,
      _brand,
      _productCategory,
      _productType,
      _vendor,
      _MenuItem(
        title: 'Purchase Team',
        icon: Icons.groups_2_outlined,
        route: AppRoutes.purchaseTeamList,
      ),
      _configurationHeader,
      _users,
      _uom,
    ],

    AppModule.hr: [
      _operationHeader,
      _MenuItem(
        title: 'Attendance',
        icon: Icons.access_time_outlined,
        route: AppRoutes.attendance,
      ),
      _MenuItem(
        title: 'Leave',
        type: _MenuType.master,
        icon: Icons.free_cancellation_outlined,
        children: [
          _MenuItem(title: 'Leave Request', route: AppRoutes.leaveRequestList),
          _MenuItem(title: 'Leave Quota', route: AppRoutes.leaveQuotaList),
        ],
      ),
      _MenuItem(
        title: 'Overtime Request',
        icon: Icons.pending_actions_outlined,
        route: AppRoutes.overtimeRequestList,
      ),
      _MenuItem(
        title: 'Payroll Period',
        icon: Icons.event_repeat_outlined,
        route: AppRoutes.overtimeRequestList,
      ),
      _masterDataHeader,
      _employee,
      _MenuItem(
        title: 'Department',
        icon: Icons.apartment_outlined,
        route: AppRoutes.departmentList,
      ),
      _MenuItem(
        title: 'Position',
        icon: Icons.work_outline,
        route: AppRoutes.positionList,
      ),
      _MenuItem(
        title: 'Employee Status',
        icon: Icons.badge_outlined,
        route: AppRoutes.employeeStatusList,
      ),
      _MenuItem(
        title: 'Leave Type',
        icon: Icons.event_note_outlined,
        route: AppRoutes.leaveTypeList,
      ),
      _MenuItem(
        title: 'Overtime Type',
        icon: Icons.more_time_outlined,
        route: AppRoutes.overtimeTypeList,
      ),
      _MenuItem(
        title: 'Leave Allocation',
        icon: Icons.assignment_outlined,
        route: AppRoutes.leaveAllocationList,
      ),
      _MenuItem(
        title: 'Collective Leave',
        icon: Icons.calendar_month_outlined,
        route: AppRoutes.collectiveLeaveList,
      ),
      _MenuItem(
        title: 'National Holiday',
        icon: Icons.event_outlined,
        route: AppRoutes.nationalHolidayList,
      ),
      _configurationHeader,
      _users,
      _uom,
    ],

    AppModule.manufacturing: [
      _masterDataHeader,
      _MenuItem(
        title: 'Bill of Material',
        icon: Icons.list_alt,
        route: AppRoutes.bomList,
      ),
      _MenuItem(
        title: 'Workstation',
        icon: Icons.factory_outlined,
        route: AppRoutes.workstationList,
      ),
      _employee,
      _project,
      _configurationHeader,
      _users,
      _uom,
    ],

    AppModule.accounting: [
      _masterDataHeader,
      _MenuItem(
        title: 'Bank Account',
        icon: Icons.account_balance_outlined,
        route: AppRoutes.bankAccountList,
      ),
      _MenuItem(
        title: 'Chart of Account',
        icon: Icons.account_tree_outlined,
        route: AppRoutes.coaList,
      ),
      _project,
      _customer,
      _vendor,
      _configurationHeader,
      _users,
      _uom,
    ],

    AppModule.pos: [
      _masterDataHeader,
      _MenuItem(
        title: 'Stores',
        icon: Icons.storefront,
        route: AppRoutes.storeList,
      ),
      _customer,
      _customerCategory,
      _productsExpansion,
      _warehouseExpansion,
      _brand,
      _configurationHeader,
      _users,
      _uom,
    ],

    AppModule.crm: [_configurationHeader, _users, _uom],
  };

  @override
  Widget build(BuildContext context) {
    final menus = _staticMenus[currentModule] ?? [];
    return Drawer(
      backgroundColor: Colors.white,
      child: AnimationLimiter(
        child: ListView(
          padding: EdgeInsets.zero,
          children: AnimationConfiguration.toStaggeredList(
            duration: const Duration(milliseconds: 300),
            childAnimationBuilder: (w) => SlideAnimation(
              verticalOffset: 40,
              child: FadeInAnimation(child: w),
            ),
            children: [
              _buildHeader(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: _buildItem(
                  context: context,
                  title: 'Pilih Modul',
                  icon: Icons.apps_outlined,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, AppRoutes.modul);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: _buildItem(
                  context: context,
                  title: 'Dashboard',
                  icon: Icons.dashboard_outlined,
                  onTap: () => _goToDashboard(context),
                ),
              ),
              ..._buildMenuList(context, menus),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildMenuList(BuildContext context, List<_MenuItem> menus) {
    final widgets = <Widget>[];
    for (final menu in menus) {
      if (menu.type == _MenuType.header) {
        widgets.add(_buildSectionLabel(menu.title));
        widgets.add(
          const Divider(height: 1, indent: 16, endIndent: 16, thickness: 1),
        );
        continue;
      }
      if (menu.type == _MenuType.master && menu.children.isNotEmpty) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: _buildExpansion(
              context: context,
              title: menu.title,
              icon: menu.icon ?? Icons.folder_outlined,
              children: menu.children
                  .map(
                    (child) => _buildItem(
                      context: context,
                      title: child.title,
                      onTap: () => _navigate(context, child.route),
                      isChild: true,
                    ),
                  )
                  .toList(),
            ),
          ),
        );
        continue;
      }
      widgets.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: _buildItem(
            context: context,
            title: menu.title,
            icon: menu.icon,
            onTap: () => _navigate(context, menu.route),
          ),
        ),
      );
    }
    return widgets;
  }

  void _navigate(BuildContext context, String? route) {
    if (route == null) return;
    Navigator.pop(context);
    Navigator.pushNamed(context, route);
  }

  void _goToDashboard(BuildContext context) {
    Navigator.pop(context);
    final routes = {
      AppModule.inventory: AppRoutes.dashboardInventory,
      AppModule.purchase: AppRoutes.dashboardPurchase,
      AppModule.sales: AppRoutes.dashboardSales,
      AppModule.hr: AppRoutes.dashboardHr,
      AppModule.manufacturing: AppRoutes.dashboardManufacturing,
      AppModule.accounting: AppRoutes.dashboardAccounting,
      AppModule.crm: AppRoutes.dashboardCrm,
      AppModule.pos: AppRoutes.dashboardPos,
      AppModule.general: AppRoutes.generalDashboard,
    };
    final route = routes[currentModule];
    if (route != null)
      Navigator.pushNamedAndRemoveUntil(context, route, (r) => false);
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200, width: 1.5),
        ),
      ),
      child: Image.asset('assets/images/logo.png', height: 28),
    );
  }

  Widget _buildSectionLabel(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.montserrat(
          fontWeight: FontWeight.w700,
          color: _accent,
          fontSize: 13,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildItem({
    required BuildContext context,
    required String title,
    IconData? icon,
    required VoidCallback onTap,
    bool isChild = false,
  }) {
    final Widget leading;
    if (isChild) {
      leading = Padding(
        padding: const EdgeInsets.only(left: 50),
        child: Icon(
          Icons.circle_outlined,
          size: 12,
          color: Colors.grey.shade500,
        ),
      );
    } else if (icon != null) {
      leading = Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: _accentBg,
        ),
        child: Icon(icon, color: _accent, size: 18),
      );
    } else {
      leading = const SizedBox(width: 36);
    }

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
        leading: leading,
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontWeight: isChild ? FontWeight.normal : FontWeight.w500,
            fontSize: 14,
            color: isChild ? Colors.black.withOpacity(0.7) : Colors.black87,
          ),
        ),
        onTap: onTap,
        splashColor: _accentBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildExpansion({
    required BuildContext context,
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Builder(
      builder: (ctx) => Theme(
        data: Theme.of(ctx).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
          leading: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: _accentBg,
            ),
            child: Icon(icon, color: _accent, size: 18),
          ),
          title: Text(
            title,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          iconColor: Colors.grey.shade600,
          collapsedIconColor: Colors.grey.shade400,
          children: children,
        ),
      ),
    );
  }
}

enum _MenuType { normal, header, master }

class _MenuItem {
  final String title;
  final _MenuType type;
  final IconData? icon;
  final String? route;
  final List<_MenuItem> children;

  const _MenuItem({
    required this.title,
    this.type = _MenuType.normal,
    this.icon,
    this.route,
    this.children = const [],
  });
}
