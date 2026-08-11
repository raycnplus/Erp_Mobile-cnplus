import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'core/injector/injector.dart';
import 'services/connectivity_service.dart';
import 'core/widgets/connectivity_banner.dart';
import 'package:erp_mobile_cnplus/features/auth/presentation/controllers/auth_controller.dart';
import 'package:erp_mobile_cnplus/features/profile/presentation/controllers/profile_controller.dart';
import 'package:erp_mobile_cnplus/features/master/product/presentation/controllers/product_controller.dart';
import 'package:erp_mobile_cnplus/features/master/brand/presentation/controllers/brand_controller.dart';
import 'package:erp_mobile_cnplus/features/master/product_category/presentation/controllers/product_category_controller.dart';
import 'package:erp_mobile_cnplus/features/master/vendor/presentation/controllers/vendor_controller.dart';
import 'package:erp_mobile_cnplus/features/master/product_type/presentation/controllers/product_type_controller.dart';
import 'package:erp_mobile_cnplus/features/master/location/presentation/controllers/location_controller.dart';
import 'package:erp_mobile_cnplus/features/master/warehouse/presentation/controllers/warehouse_controller.dart';
import 'package:erp_mobile_cnplus/features/master/customer/presentation/controllers/customer_controller.dart';
import 'package:erp_mobile_cnplus/features/master/customer_category/presentation/controllers/customer_category_controller.dart';
import 'package:erp_mobile_cnplus/features/master/sales_team/presentation/controllers/sales_team_controller.dart';
import 'package:erp_mobile_cnplus/features/master/purchase_team/presentation/controllers/purchase_team_controller.dart';
import 'package:erp_mobile_cnplus/features/master/employee/presentation/controllers/employee_controller.dart';
import 'package:erp_mobile_cnplus/features/master/project/presentation/controllers/project_controller.dart';
import 'package:erp_mobile_cnplus/features/hr/department/presentation/controllers/department_controller.dart';
import 'package:erp_mobile_cnplus/features/hr/national_holiday/presentation/controllers/national_holiday_controller.dart';
import 'package:erp_mobile_cnplus/features/hr/employee_status/presentation/controllers/employee_status_controller.dart';
import 'package:erp_mobile_cnplus/features/hr/position/presentation/controllers/position_controller.dart';
import 'package:erp_mobile_cnplus/features/hr/leave_type/presentation/controllers/leave_type_controller.dart';
import 'package:erp_mobile_cnplus/features/hr/collective_leave/presentation/controllers/collective_leave_controller.dart';
import 'package:erp_mobile_cnplus/features/hr/attendance/presentation/controllers/attendance_controller.dart';
import 'package:erp_mobile_cnplus/features/hr/leave_allocation/presentation/controllers/leave_allocation_controller.dart';
import 'package:erp_mobile_cnplus/features/accounting/coa/presentation/controllers/coa_controller.dart';
import 'package:erp_mobile_cnplus/features/accounting/bank_account/presentation/controllers/bank_account_controller.dart';
import 'package:erp_mobile_cnplus/features/sales/price_list/presentation/controllers/price_list_controller.dart';
import 'package:erp_mobile_cnplus/features/manufacturing/workstation/presentation/controllers/workstation_controller.dart';
import 'package:erp_mobile_cnplus/features/manufacturing/bom/presentation/controllers/bom_controller.dart';
import 'package:erp_mobile_cnplus/features/master/uom/presentation/controllers/uom_controller.dart';
import 'package:erp_mobile_cnplus/features/master/user/presentation/controllers/user_controller.dart';
import 'package:erp_mobile_cnplus/features/pos/store/presentation/controllers/store_controller.dart';
import 'package:erp_mobile_cnplus/features/hr/overtime_type/presentation/controllers/overtime_type_controller.dart';
import 'package:erp_mobile_cnplus/features/hr/leave_quota/presentation/controllers/leave_quota_controller.dart';
import 'package:erp_mobile_cnplus/features/hr/leave_request/presentation/controllers/leave_request_controller.dart';
import 'package:erp_mobile_cnplus/features/hr/overtime_request/presentation/controllers/overtime_request_controller.dart';
import 'package:erp_mobile_cnplus/features/sales/quotation/presentation/controllers/quotation_controller.dart';
import 'package:erp_mobile_cnplus/features/sales/sales_order/presentation/controllers/sales_order_controller.dart';
import 'package:erp_mobile_cnplus/features/sales/direct_sales/presentation/controllers/direct_sales_controller.dart';
import 'package:erp_mobile_cnplus/features/sales/invoice/presentation/controllers/invoice_controller.dart';
import 'package:erp_mobile_cnplus/features/sales/service_sales/service_quotation/presentation/controllers/service_quotation_controller.dart';
import 'package:erp_mobile_cnplus/features/sales/service_sales/service_sales_order/presentation/controllers/service_sales_order_controller.dart';
import 'package:erp_mobile_cnplus/features/sales/service_sales/service_direct_sales/presentation/controllers/service_direct_sales_controller.dart';
import 'package:erp_mobile_cnplus/features/sales/service_sales/service_invoice/presentation/controllers/service_invoice_controller.dart';
import 'package:erp_mobile_cnplus/features/purchase/purchase_request/presentation/controllers/purchase_request_controller.dart';
import 'package:erp_mobile_cnplus/features/purchase/request_quotation/presentation/controllers/rfq_controller.dart';
import 'package:erp_mobile_cnplus/features/purchase/direct_purchase/presentation/controllers/direct_purchase_controller.dart';
import 'package:erp_mobile_cnplus/features/purchase/purchase_order/presentation/controllers/purchase_order_controller.dart';
import 'package:erp_mobile_cnplus/features/purchase/bill/presentation/controllers/bill_controller.dart';
import 'package:erp_mobile_cnplus/features/inventory/receipt_note/presentation/controllers/receipt_note_controller.dart';
import 'package:erp_mobile_cnplus/features/inventory/delivery_note/presentation/controllers/delivery_note_controller.dart';
import 'package:erp_mobile_cnplus/features/inventory/internal_transfer/presentation/controllers/internal_transfer_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  AppInjector.init();

  final connectivityService = ConnectivityService();

  runApp(
    MultiProvider(
      providers: [
        StreamProvider<bool>(
          create: (_) => connectivityService.connectionStream,
          initialData: true,
        ),
        ChangeNotifierProvider<AuthController>(
          create: (_) => getIt<AuthController>(),
        ),
        ChangeNotifierProvider<ProfileController>(
          create: (_) => getIt<ProfileController>(),
        ),
        ChangeNotifierProvider<ProductController>(
          create: (_) => getIt<ProductController>(),
        ),
        ChangeNotifierProvider<BrandController>(
          create: (_) => getIt<BrandController>(),
        ),
        ChangeNotifierProvider<ProductCategoryController>(
          create: (_) => getIt<ProductCategoryController>(),
        ),
        ChangeNotifierProvider<VendorController>(
          create: (_) => getIt<VendorController>(),
        ),
        ChangeNotifierProvider<ProductTypeController>(
          create: (_) => getIt<ProductTypeController>(),
        ),
        ChangeNotifierProvider<LocationController>(
          create: (_) => getIt<LocationController>(),
        ),
        ChangeNotifierProvider<WarehouseController>(
          create: (_) => getIt<WarehouseController>(),
        ),
        ChangeNotifierProvider<CustomerCategoryController>(
          create: (_) => getIt<CustomerCategoryController>(),
        ),
        ChangeNotifierProvider<CustomerController>(
          create: (_) => getIt<CustomerController>(),
        ),
        ChangeNotifierProvider<SalesTeamController>(
          create: (_) => getIt<SalesTeamController>(),
        ),
        ChangeNotifierProvider<PurchaseTeamController>(
          create: (_) => getIt<PurchaseTeamController>(),
        ),
        ChangeNotifierProvider<AttendanceController>(
          create: (_) => getIt<AttendanceController>(),
        ),
        ChangeNotifierProvider<DepartmentController>(
          create: (_) => getIt<DepartmentController>(),
        ),
        ChangeNotifierProvider<EmployeeStatusController>(
          create: (_) => getIt<EmployeeStatusController>(),
        ),
        ChangeNotifierProvider<NationalHolidayController>(
          create: (_) => getIt<NationalHolidayController>(),
        ),
        ChangeNotifierProvider<PositionController>(
          create: (_) => getIt<PositionController>(),
        ),
        ChangeNotifierProvider<LeaveTypeController>(
          create: (_) => getIt<LeaveTypeController>(),
        ),
        ChangeNotifierProvider<CollectiveLeaveController>(
          create: (_) => getIt<CollectiveLeaveController>(),
        ),
        ChangeNotifierProvider<EmployeeController>(
          create: (_) => getIt<EmployeeController>(),
        ),
        ChangeNotifierProvider<LeaveAllocationController>(
          create: (_) => getIt<LeaveAllocationController>(),
        ),
        ChangeNotifierProvider<CoaController>(
          create: (_) => getIt<CoaController>(),
        ),
        ChangeNotifierProvider<BankAccountController>(
          create: (_) => getIt<BankAccountController>(),
        ),
        ChangeNotifierProvider<ProjectController>(
          create: (_) => getIt<ProjectController>(),
        ),
        ChangeNotifierProvider<PriceListController>(
          create: (_) => getIt<PriceListController>(),
        ),
        ChangeNotifierProvider<WorkstationController>(
          create: (_) => getIt<WorkstationController>(),
        ),
        ChangeNotifierProvider<BomController>(
          create: (_) => getIt<BomController>(),
        ),
        ChangeNotifierProvider<UomController>(
          create: (_) => getIt<UomController>(),
        ),
        ChangeNotifierProvider<UserController>(
          create: (_) => getIt<UserController>(),
        ),
        ChangeNotifierProvider<StoreController>(
          create: (_) => getIt<StoreController>(),
        ),
        ChangeNotifierProvider<OvertimeTypeController>(
          create: (_) => getIt<OvertimeTypeController>(),
        ),
        ChangeNotifierProvider<LeaveQuotaController>(
          create: (_) => getIt<LeaveQuotaController>(),
        ),
        ChangeNotifierProvider<LeaveRequestController>(
          create: (_) => getIt<LeaveRequestController>(),
        ),
        ChangeNotifierProvider<OvertimeRequestController>(
          create: (_) => getIt<OvertimeRequestController>(),
        ),
        ChangeNotifierProvider<QuotationController>(
          create: (_) => getIt<QuotationController>(),
        ),
        ChangeNotifierProvider<SalesOrderController>(
          create: (_) => getIt<SalesOrderController>(),
        ),
        ChangeNotifierProvider<DirectSalesController>(
           create: (_) => getIt<DirectSalesController>(),
        ),
        ChangeNotifierProvider<InvoiceController>(
          create: (_) => getIt<InvoiceController>(),
        ),
        ChangeNotifierProvider<ServiceQuotationController>(
          create: (_) => getIt<ServiceQuotationController>(),
        ),
        ChangeNotifierProvider<ServiceSalesOrderController>(
          create: (_) => getIt<ServiceSalesOrderController>(),
        ),
        ChangeNotifierProvider<ServiceDirectSalesController>(
          create: (_) => getIt<ServiceDirectSalesController>(),
        ),
        ChangeNotifierProvider<ServiceInvoiceController>(
          create: (_) => getIt<ServiceInvoiceController>(),
        ),
        ChangeNotifierProvider<PurchaseRequestController>(
          create: (_) => getIt<PurchaseRequestController>(),
        ),
        ChangeNotifierProvider<RfqController>(
          create: (_) => getIt<RfqController>(),
        ),
        ChangeNotifierProvider<DirectPurchaseController>(
          create: (_) => getIt<DirectPurchaseController>(),
        ),
        ChangeNotifierProvider<PurchaseOrderController>(
          create: (_) => getIt<PurchaseOrderController>(),
        ),
        ChangeNotifierProvider<BillController>(
          create: (_) => getIt<BillController>(),
        ),
        ChangeNotifierProvider<ReceiptNoteController>(
          create: (_) => getIt<ReceiptNoteController>(),
        ),
        ChangeNotifierProvider<DeliveryNoteController>(
          create: (_) => getIt<DeliveryNoteController>(),
        ),
        ChangeNotifierProvider<InternalTransferController>(
          create: (_) =>getIt<InternalTransferController>(),
        )
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final baseTheme = AppTheme.lightTheme;
    final ensuredTheme = baseTheme.copyWith(
      textSelectionTheme: baseTheme.textSelectionTheme.copyWith(
        selectionColor: const Color.fromRGBO(58, 121, 183, 0.25),
        selectionHandleColor: const Color.fromARGB(255, 58, 121, 183),
        cursorColor: const Color.fromARGB(255, 58, 121, 183),
      ),
    );

    return MaterialApp(
      title: 'CNERSIA Mobile',
      debugShowCheckedModeBanner: false,
      theme: ensuredTheme,
      initialRoute: AppRoutes.splash, 
      routes: AppRoutes.routes,
      builder: (context, child) {
        return ConnectivityBanner(
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}