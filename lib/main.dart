import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'core/injector/injector.dart';
import 'services/connectivity_service.dart';
import 'core/widgets/connectivity_banner.dart';
import 'core/services/download_service.dart';

// AUTH
import 'package:erp_mobile_cnplus/features/auth/presentation/controllers/auth_controller.dart';

// PROFILE
import 'package:erp_mobile_cnplus/features/profile/presentation/controllers/profile_controller.dart';

// MASTER DATA
// -- Product
import 'package:erp_mobile_cnplus/features/master/product/presentation/controllers/product_controller.dart';

// -- Brand
import 'package:erp_mobile_cnplus/features/master/brand/presentation/controllers/brand_controller.dart';

// -- Product Category
import 'package:erp_mobile_cnplus/features/master/product_category/presentation/controllers/product_category_controller.dart';

// -- Product Type
import 'package:erp_mobile_cnplus/features/master/product_type/presentation/controllers/product_type_controller.dart';

// -- Uom
import 'package:erp_mobile_cnplus/features/master/uom/presentation/controllers/uom_controller.dart';

// -- Vendor
import 'package:erp_mobile_cnplus/features/master/vendor/presentation/controllers/vendor_controller.dart';

// -- Customer
import 'package:erp_mobile_cnplus/features/master/customer/presentation/controllers/customer_controller.dart';

// -- Customer Category
import 'package:erp_mobile_cnplus/features/master/customer_category/presentation/controllers/customer_category_controller.dart';

// -- Location
import 'package:erp_mobile_cnplus/features/master/location/presentation/controllers/location_controller.dart';

// -- Warehouse
import 'package:erp_mobile_cnplus/features/master/warehouse/presentation/controllers/warehouse_controller.dart';

// -- Sales Team
import 'package:erp_mobile_cnplus/features/master/sales_team/presentation/controllers/sales_team_controller.dart';

// -- Purchase Team
import 'package:erp_mobile_cnplus/features/master/purchase_team/presentation/controllers/purchase_team_controller.dart';

// -- Employee
import 'package:erp_mobile_cnplus/features/master/employee/presentation/controllers/employee_controller.dart';

// -- Project
import 'package:erp_mobile_cnplus/features/master/project/presentation/controllers/project_controller.dart';

// -- User
import 'package:erp_mobile_cnplus/features/master/user/presentation/controllers/user_controller.dart';

// INVENTORY
// -- Receipt Note
import 'package:erp_mobile_cnplus/features/inventory/receipt_note/presentation/controllers/receipt_note_controller.dart';

// -- Delivery Note
import 'package:erp_mobile_cnplus/features/inventory/delivery_note/presentation/controllers/delivery_note_controller.dart';

// -- Internal Transfer
import 'package:erp_mobile_cnplus/features/inventory/internal_transfer/presentation/controllers/internal_transfer_controller.dart';

// -- Transfer In
import 'package:erp_mobile_cnplus/features/inventory/transfer_in/presentation/controllers/transfer_in_controller.dart';

// -- Transfer Out
import 'package:erp_mobile_cnplus/features/inventory/transfer_out/presentation/controllers/transfer_out_controller.dart';

// -- Scrap Order
import 'package:erp_mobile_cnplus/features/inventory/scrap_order/presentation/controllers/scrap_order_controller.dart';

// -- Stock Count
import 'package:erp_mobile_cnplus/features/inventory/stock_count/presentation/controllers/stock_count_controller.dart';

// -- Return RN
import 'package:erp_mobile_cnplus/features/inventory/return_rn/presentation/controllers/return_rn_controller.dart';

// -- Return DN
import 'package:erp_mobile_cnplus/features/inventory/return_dn/presentation/controllers/return_dn_controller.dart';

// -- Reports
import 'package:erp_mobile_cnplus/features/inventory/warehouse_report/presentation/controllers/warehouse_report_controller.dart';
import 'package:erp_mobile_cnplus/features/inventory/location_report/presentation/controllers/location_report_controller.dart';
import 'package:erp_mobile_cnplus/features/inventory/stock_report/presentation/controllers/stock_report_controller.dart';
import 'package:erp_mobile_cnplus/features/inventory/stock_movement/presentation/controllers/stock_movement_controller.dart';
import 'package:erp_mobile_cnplus/features/inventory/stock_valuation/presentation/controllers/stock_valuation_controller.dart';
import 'package:erp_mobile_cnplus/features/inventory/history_stock/presentation/controllers/history_stock_controller.dart';
import 'package:erp_mobile_cnplus/features/inventory/expired_report/presentation/controllers/expired_report_controller.dart';

// SALES
// -- Price List
import 'package:erp_mobile_cnplus/features/sales/price_list/presentation/controllers/price_list_controller.dart';

// -- Quotation
import 'package:erp_mobile_cnplus/features/sales/quotation/presentation/controllers/quotation_controller.dart';

// -- Sales Order
import 'package:erp_mobile_cnplus/features/sales/sales_order/presentation/controllers/sales_order_controller.dart';

// -- Direct Sales
import 'package:erp_mobile_cnplus/features/sales/direct_sales/presentation/controllers/direct_sales_controller.dart';

// -- Invoice
import 'package:erp_mobile_cnplus/features/sales/invoice/presentation/controllers/invoice_controller.dart';

// -- Service Quotation
import 'package:erp_mobile_cnplus/features/sales/service_sales/service_quotation/presentation/controllers/service_quotation_controller.dart';

// -- Service Sales Order
import 'package:erp_mobile_cnplus/features/sales/service_sales/service_sales_order/presentation/controllers/service_sales_order_controller.dart';

// -- Service Direct Sales
import 'package:erp_mobile_cnplus/features/sales/service_sales/service_direct_sales/presentation/controllers/service_direct_sales_controller.dart';

// -- Service Invoice
import 'package:erp_mobile_cnplus/features/sales/service_sales/service_invoice/presentation/controllers/service_invoice_controller.dart';

// -- Reports
import 'package:erp_mobile_cnplus/features/sales/quotation_report/presentation/controllers/quotation_report_controller.dart';
import 'package:erp_mobile_cnplus/features/sales/sales_order_report/presentation/controllers/sales_order_report_controller.dart';
import 'package:erp_mobile_cnplus/features/sales/direct_sales_report/presentation/controllers/direct_sales_report_controller.dart';
import 'package:erp_mobile_cnplus/features/sales/invoice_report/presentation/controllers/invoice_report_controller.dart';
import 'package:erp_mobile_cnplus/features/sales/service_quotation_report/presentation/controllers/service_quotation_report_controller.dart';
import 'package:erp_mobile_cnplus/features/sales/service_sales_order_report/presentation/controllers/service_sales_order_report_controller.dart';
import 'package:erp_mobile_cnplus/features/sales/service_direct_sales_report/presentation/controllers/service_direct_sales_report_controller.dart';
import 'package:erp_mobile_cnplus/features/sales/service_invoice_report/presentation/controllers/service_invoice_report_controller.dart';
import 'package:erp_mobile_cnplus/features/sales/sales_product_report/presentation/controllers/sales_product_report_controller.dart';
import 'package:erp_mobile_cnplus/features/sales/salespersons_report/presentation/controllers/salespersons_report_controller.dart';
import 'package:erp_mobile_cnplus/features/sales/top_customer_report/presentation/controllers/top_customer_report_controller.dart';
import 'package:erp_mobile_cnplus/features/sales/ppn_report/presentation/controllers/ppn_report_controller.dart';
import 'package:erp_mobile_cnplus/features/sales/pph_report/presentation/controllers/pph_report_controller.dart';

// PURCHASE
// -- Purchase Request
import 'package:erp_mobile_cnplus/features/purchase/purchase_request/presentation/controllers/purchase_request_controller.dart';

// -- Rfq
import 'package:erp_mobile_cnplus/features/purchase/request_quotation/presentation/controllers/rfq_controller.dart';

// -- Direct Purchase
import 'package:erp_mobile_cnplus/features/purchase/direct_purchase/presentation/controllers/direct_purchase_controller.dart';

// -- Purchase Order
import 'package:erp_mobile_cnplus/features/purchase/purchase_order/presentation/controllers/purchase_order_controller.dart';

// -- Bill
import 'package:erp_mobile_cnplus/features/purchase/bill/presentation/controllers/bill_controller.dart';

// -- Reports
import 'package:erp_mobile_cnplus/features/purchase/purchase_request_report/presentation/controllers/purchase_request_report_controller.dart';
import 'package:erp_mobile_cnplus/features/purchase/request_quotation_report/presentation/controllers/request_quotation_report_controller.dart';
import 'package:erp_mobile_cnplus/features/purchase/purchase_order_report/presentation/controllers/purchase_order_report_controller.dart';
import 'package:erp_mobile_cnplus/features/purchase/direct_purchase_report/presentation/controllers/direct_purchase_report_controller.dart';
import 'package:erp_mobile_cnplus/features/purchase/top_purchase_order_report/presentation/controllers/top_purchase_order_report_controller.dart';
import 'package:erp_mobile_cnplus/features/purchase/top_purchasing_product_report/presentation/controllers/top_purchasing_product_report_controller.dart';

// HR
// -- Attendance
import 'package:erp_mobile_cnplus/features/hr/attendance/presentation/controllers/attendance_controller.dart';

// -- Department
import 'package:erp_mobile_cnplus/features/hr/department/presentation/controllers/department_controller.dart';

// -- Employee Status
import 'package:erp_mobile_cnplus/features/hr/employee_status/presentation/controllers/employee_status_controller.dart';

// -- National Holiday
import 'package:erp_mobile_cnplus/features/hr/national_holiday/presentation/controllers/national_holiday_controller.dart';

// -- Position
import 'package:erp_mobile_cnplus/features/hr/position/presentation/controllers/position_controller.dart';

// -- Leave Type
import 'package:erp_mobile_cnplus/features/hr/leave_type/presentation/controllers/leave_type_controller.dart';

// -- Collective Leave
import 'package:erp_mobile_cnplus/features/hr/collective_leave/presentation/controllers/collective_leave_controller.dart';

// -- Leave Allocation
import 'package:erp_mobile_cnplus/features/hr/leave_allocation/presentation/controllers/leave_allocation_controller.dart';

// -- Overtime Type
import 'package:erp_mobile_cnplus/features/hr/overtime_type/presentation/controllers/overtime_type_controller.dart';

// -- Leave Quota
import 'package:erp_mobile_cnplus/features/hr/leave_quota/presentation/controllers/leave_quota_controller.dart';

// -- Leave Request
import 'package:erp_mobile_cnplus/features/hr/leave_request/presentation/controllers/leave_request_controller.dart';

// -- Overtime Request
import 'package:erp_mobile_cnplus/features/hr/overtime_request/presentation/controllers/overtime_request_controller.dart';

// -- My Pay Slip
import 'package:erp_mobile_cnplus/features/hr/my_payslip/presentation/controllers/my_payslip_controller.dart';

// -- My Pay Slip Detail
import 'package:erp_mobile_cnplus/features/hr/my_payslip/presentation/controllers/my_payslip_detail_controller.dart';

// -- Reports
import 'package:erp_mobile_cnplus/features/hr/attendance_report/presentation/controllers/attendance_report_controller.dart';
import 'package:erp_mobile_cnplus/features/hr/attendance_late_report/presentation/controllers/attendance_late_report_controller.dart';
import 'package:erp_mobile_cnplus/features/hr/attendance_overtime_report/presentation/controllers/attendance_overtime_report_controller.dart';
import 'package:erp_mobile_cnplus/features/hr/leave_report/presentation/controllers/leave_report_controller.dart';
import 'package:erp_mobile_cnplus/features/hr/payroll_summary_report/presentation/controllers/payroll_summary_report_controller.dart';

// ACCOUNTING
// -- Coa
import 'package:erp_mobile_cnplus/features/accounting/coa/presentation/controllers/coa_controller.dart';

// -- Bank Account
import 'package:erp_mobile_cnplus/features/accounting/bank_account/presentation/controllers/bank_account_controller.dart';

// -- Asset Category
import 'package:erp_mobile_cnplus/features/accounting/asset_category/presentation/controllers/asset_category_controller.dart';

// -- Fixed Asset
import 'package:erp_mobile_cnplus/features/accounting/fixed_asset/presentation/controllers/fixed_asset_controller.dart';

// -- Cash Bank
import 'package:erp_mobile_cnplus/features/accounting/cash_bank/presentation/controllers/cash_bank_controller.dart';

// -- Journal Entry
import 'package:erp_mobile_cnplus/features/accounting/journal_entry/presentation/controllers/journal_entry_controller.dart';

// -- Bill Payment
import 'package:erp_mobile_cnplus/features/accounting/bill_payment/presentation/controllers/bill_payment_controller.dart';

// -- Invoice Payment
import 'package:erp_mobile_cnplus/features/accounting/invoice_payment/presentation/controllers/invoice_payment_controller.dart';

// -- Period Closing
import 'package:erp_mobile_cnplus/features/accounting/period_closing/presentation/controllers/period_closing_controller.dart';

// -- Asset Depreciation
import 'package:erp_mobile_cnplus/features/accounting/asset_depreciation/presentation/controllers/asset_depreciation_controller.dart';

// -- Asset Movement
import 'package:erp_mobile_cnplus/features/accounting/asset_movement/presentation/controllers/asset_movement_controller.dart';

// -- Asset Disposal
import 'package:erp_mobile_cnplus/features/accounting/asset_disposal/presentation/controllers/asset_disposal_controller.dart';

// -- Tax Payment
import 'package:erp_mobile_cnplus/features/accounting/tax_payment/presentation/controllers/tax_payment_controller.dart';

// -- Bpe Management
import 'package:erp_mobile_cnplus/features/accounting/bpe_management/presentation/controllers/bpe_management_controller.dart';

// -- Reports
import 'package:erp_mobile_cnplus/features/accounting/general_ledger/presentation/controllers/general_ledger_controller.dart';
import 'package:erp_mobile_cnplus/features/accounting/cash_bank_report/presentation/controllers/cash_bank_report_controller.dart';
import 'package:erp_mobile_cnplus/features/accounting/trial_balance/presentation/controllers/trial_balance_controller.dart';
import 'package:erp_mobile_cnplus/features/accounting/cash_flow/presentation/controllers/cash_flow_controller.dart';
import 'package:erp_mobile_cnplus/features/accounting/balance_sheet/presentation/controllers/balance_sheet_controller.dart';
import 'package:erp_mobile_cnplus/features/accounting/profit_loss/presentation/controllers/profit_loss_controller.dart';
import 'package:erp_mobile_cnplus/features/accounting/ar_aging_report/presentation/controllers/ar_aging_report_controller.dart';
import 'package:erp_mobile_cnplus/features/accounting/billing_tax_report/presentation/controllers/billing_tax_report_controller.dart';
import 'package:erp_mobile_cnplus/features/accounting/check_balance_journal/presentation/controllers/check_balance_journal_controller.dart';
import 'package:erp_mobile_cnplus/features/accounting/depreciation_report/presentation/controllers/depreciation_report_controller.dart';

// MANUFACTURING
// -- Workstation
import 'package:erp_mobile_cnplus/features/manufacturing/workstation/presentation/controllers/workstation_controller.dart';

// -- Bom
import 'package:erp_mobile_cnplus/features/manufacturing/bom/presentation/controllers/bom_controller.dart';

// -- Manufacturing Order
import 'package:erp_mobile_cnplus/features/manufacturing/manufacturing_order/presentation/controllers/manufacturing_order_controller.dart';

// -- Unbuild Order
import 'package:erp_mobile_cnplus/features/manufacturing/unbuild_order/presentation/controllers/unbuild_order_controller.dart';

// -- Work Order
import 'package:erp_mobile_cnplus/features/manufacturing/work_order/presentation/controllers/work_order_controller.dart';

// POS
// -- Store
import 'package:erp_mobile_cnplus/features/pos/store/presentation/controllers/store_controller.dart';

// -- Printer Config
import 'package:erp_mobile_cnplus/features/pos/printer_config/presentation/controllers/printer_config_controller.dart';

// -- Top Customer Report
import 'package:erp_mobile_cnplus/features/pos/top_customer_report/presentation/controllers/top_customer_report_controller.dart' as pos_top_customer_report;

// -- Sold Product Report
import 'package:erp_mobile_cnplus/features/pos/sold_product_report/presentation/controllers/sold_product_report_controller.dart' as pos_sold_product_report;

// -- Store Session Report
import 'package:erp_mobile_cnplus/features/pos/store_session_report/presentation/controllers/store_session_report_controller.dart';

// -- Transaction History
import 'package:erp_mobile_cnplus/features/pos/transaction_history/presentation/controllers/transaction_history_controller.dart';

// -- Transaction
import 'package:erp_mobile_cnplus/features/pos/transaction/presentation/controllers/pos_session_controller.dart';
import 'package:erp_mobile_cnplus/features/pos/transaction/presentation/controllers/pos_sale_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FlutterDownloader.initialize(debug: false);
  FlutterDownloader.registerCallback(DownloadService.callbackDispatcher);
  DownloadService.instance.init();

  AppInjector.init();

  final connectivityService = ConnectivityService();

  runApp(
    MultiProvider(
      providers: [
        // ==================== CORE ====================
        StreamProvider<bool>(
          create: (_) => connectivityService.connectionStream,
          initialData: true,
        ),

        // ==================== AUTH ====================
        ChangeNotifierProvider<AuthController>(
          create: (_) => getIt<AuthController>(),
        ),
        // ==================== PROFILE ====================
        ChangeNotifierProvider<ProfileController>(
          create: (_) => getIt<ProfileController>(),
        ),
        // ==================== MASTER DATA ====================
        ChangeNotifierProvider<ProductController>(
          create: (_) => getIt<ProductController>(),
        ),
        ChangeNotifierProvider<BrandController>(
          create: (_) => getIt<BrandController>(),
        ),
        ChangeNotifierProvider<ProductCategoryController>(
          create: (_) => getIt<ProductCategoryController>(),
        ),
        ChangeNotifierProvider<ProductTypeController>(
          create: (_) => getIt<ProductTypeController>(),
        ),
        ChangeNotifierProvider<UomController>(
          create: (_) => getIt<UomController>(),
        ),
        ChangeNotifierProvider<VendorController>(
          create: (_) => getIt<VendorController>(),
        ),
        ChangeNotifierProvider<CustomerController>(
          create: (_) => getIt<CustomerController>(),
        ),
        ChangeNotifierProvider<CustomerCategoryController>(
          create: (_) => getIt<CustomerCategoryController>(),
        ),
        ChangeNotifierProvider<LocationController>(
          create: (_) => getIt<LocationController>(),
        ),
        ChangeNotifierProvider<WarehouseController>(
          create: (_) => getIt<WarehouseController>(),
        ),
        ChangeNotifierProvider<SalesTeamController>(
          create: (_) => getIt<SalesTeamController>(),
        ),
        ChangeNotifierProvider<PurchaseTeamController>(
          create: (_) => getIt<PurchaseTeamController>(),
        ),
        ChangeNotifierProvider<EmployeeController>(
          create: (_) => getIt<EmployeeController>(),
        ),
        ChangeNotifierProvider<ProjectController>(
          create: (_) => getIt<ProjectController>(),
        ),
        ChangeNotifierProvider<UserController>(
          create: (_) => getIt<UserController>(),
        ),
        // ==================== INVENTORY ====================
        ChangeNotifierProvider<ReceiptNoteController>(
          create: (_) => getIt<ReceiptNoteController>(),
        ),
        ChangeNotifierProvider<DeliveryNoteController>(
          create: (_) => getIt<DeliveryNoteController>(),
        ),
        ChangeNotifierProvider<InternalTransferController>(
          create: (_) => getIt<InternalTransferController>(),
        ),
        ChangeNotifierProvider<TransferInController>(
          create: (_) => getIt<TransferInController>(),
        ),
        ChangeNotifierProvider<TransferOutController>(
          create: (_) => getIt<TransferOutController>(),
        ),
        ChangeNotifierProvider<ScrapOrderController>(
          create: (_) => getIt<ScrapOrderController>(),
        ),
        ChangeNotifierProvider<StockCountController>(
          create: (_) => getIt<StockCountController>(),
        ),
        ChangeNotifierProvider<ReturnRNController>(
          create: (_) => getIt<ReturnRNController>(),
        ),
        ChangeNotifierProvider<ReturnDNController>(
          create: (_) => getIt<ReturnDNController>(),
        ),
        // -- Reports
        ChangeNotifierProvider<WarehouseReportController>(
          create: (_) => getIt<WarehouseReportController>(),
        ),
        ChangeNotifierProvider<LocationReportController>(
          create: (_) => getIt<LocationReportController>(),
        ),
        ChangeNotifierProvider<StockReportController>(
          create: (_) => getIt<StockReportController>(),
        ),
        ChangeNotifierProvider<StockMovementController>(
          create: (_) => getIt<StockMovementController>(),
        ),
        ChangeNotifierProvider<StockValuationController>(
          create: (_) => getIt<StockValuationController>(),
        ),
        ChangeNotifierProvider<HistoryStockController>(
          create: (_) => getIt<HistoryStockController>(),
        ),
        ChangeNotifierProvider<ExpiredReportController>(
          create: (_) => getIt<ExpiredReportController>(),
        ),
        // ==================== SALES ====================
        ChangeNotifierProvider<PriceListController>(
          create: (_) => getIt<PriceListController>(),
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
        // -- Reports
        ChangeNotifierProvider<QuotationReportController>(
          create: (_) => getIt<QuotationReportController>(),
        ),
        ChangeNotifierProvider<SalesOrderReportController>(
          create: (_) => getIt<SalesOrderReportController>(),
        ),
        ChangeNotifierProvider<DirectSalesReportController>(
          create: (_) => getIt<DirectSalesReportController>(),
        ),
        ChangeNotifierProvider<InvoiceReportController>(
          create: (_) => getIt<InvoiceReportController>(),
        ),
        ChangeNotifierProvider<ServiceQuotationReportController>(
          create: (_) => getIt<ServiceQuotationReportController>(),
        ),
        ChangeNotifierProvider<ServiceSalesOrderReportController>(
          create: (_) => getIt<ServiceSalesOrderReportController>(),
        ),
        ChangeNotifierProvider<ServiceDirectSalesReportController>(
          create: (_) => getIt<ServiceDirectSalesReportController>(),
        ),
        ChangeNotifierProvider<ServiceInvoiceReportController>(
          create: (_) => getIt<ServiceInvoiceReportController>(),
        ),
        ChangeNotifierProvider<SalesProductReportController>(
          create: (_) => getIt<SalesProductReportController>(),
        ),
        ChangeNotifierProvider<SalespersonsReportController>(
          create: (_) => getIt<SalespersonsReportController>(),
        ),
        ChangeNotifierProvider<TopCustomerReportController>(
          create: (_) => getIt<TopCustomerReportController>(),
        ),
        ChangeNotifierProvider<PPNReportController>(
          create: (_) => getIt<PPNReportController>(),
        ),
        ChangeNotifierProvider<PPHReportController>(
          create: (_) => getIt<PPHReportController>(),
        ),
        // ==================== PURCHASE ====================
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
        // -- Reports
        ChangeNotifierProvider<PurchaseRequestReportController>(
          create: (_) => getIt<PurchaseRequestReportController>(),
        ),
        ChangeNotifierProvider<RequestQuotationReportController>(
          create: (_) => getIt<RequestQuotationReportController>(),
        ),
        ChangeNotifierProvider<PurchaseOrderReportController>(
          create: (_) => getIt<PurchaseOrderReportController>(),
        ),
        ChangeNotifierProvider<DirectPurchaseReportController>(
          create: (_) => getIt<DirectPurchaseReportController>(),
        ),
        ChangeNotifierProvider<TopPurchaseOrderReportController>(
          create: (_) => getIt<TopPurchaseOrderReportController>(),
        ),
        ChangeNotifierProvider<TopPurchasingProductReportController>(
          create: (_) => getIt<TopPurchasingProductReportController>(),
        ),
        // ==================== HR ====================
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
        ChangeNotifierProvider<LeaveAllocationController>(
          create: (_) => getIt<LeaveAllocationController>(),
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
        ChangeNotifierProvider<MyPaySlipController>(
          create: (_) => getIt<MyPaySlipController>(),
        ),
        ChangeNotifierProvider<MyPaySlipDetailController>(
          create: (_) => getIt<MyPaySlipDetailController>(),
        ),
        // -- Reports
        ChangeNotifierProvider<AttendanceReportController>(
          create: (_) => getIt<AttendanceReportController>(),
        ),
        ChangeNotifierProvider<AttendanceLateReportController>(
          create: (_) => getIt<AttendanceLateReportController>(),
        ),
        ChangeNotifierProvider<AttendanceOvertimeReportController>(
          create: (_) => getIt<AttendanceOvertimeReportController>(),
        ),
        ChangeNotifierProvider<LeaveReportController>(
          create: (_) => getIt<LeaveReportController>(),
        ),
        ChangeNotifierProvider<PayrollSummaryReportController>(
          create: (_) => getIt<PayrollSummaryReportController>(),
        ),
        // ==================== ACCOUNTING ====================
        ChangeNotifierProvider<CoaController>(
          create: (_) => getIt<CoaController>(),
        ),
        ChangeNotifierProvider<BankAccountController>(
          create: (_) => getIt<BankAccountController>(),
        ),
        ChangeNotifierProvider<AssetCategoryController>(
          create: (_) => getIt<AssetCategoryController>(),
        ),
        ChangeNotifierProvider<FixedAssetController>(
          create: (_) => getIt<FixedAssetController>(),
        ),
        ChangeNotifierProvider<CashBankController>(
          create: (_) => getIt<CashBankController>(),
        ),
        ChangeNotifierProvider<JournalEntryController>(
          create: (_) => getIt<JournalEntryController>(),
        ),
        ChangeNotifierProvider<BillPaymentController>(
          create: (_) => getIt<BillPaymentController>(),
        ),
        ChangeNotifierProvider<InvoicePaymentController>(
          create: (_) => getIt<InvoicePaymentController>(),
        ),
        ChangeNotifierProvider<PeriodClosingController>(
          create: (_) => getIt<PeriodClosingController>(),
        ),
        ChangeNotifierProvider<AssetDepreciationController>(
          create: (_) => getIt<AssetDepreciationController>(),
        ),
        ChangeNotifierProvider<AssetMovementController>(
          create: (_) => getIt<AssetMovementController>(),
        ),
        ChangeNotifierProvider<AssetDisposalController>(
          create: (_) => getIt<AssetDisposalController>(),
        ),
        ChangeNotifierProvider<TaxPaymentController>(
          create: (_) => getIt<TaxPaymentController>(),
        ),
        ChangeNotifierProvider<BpeManagementController>(
          create: (_) => getIt<BpeManagementController>(),
        ),
        // -- Reports
        ChangeNotifierProvider<GeneralLedgerController>(
          create: (_) => getIt<GeneralLedgerController>(),
        ),
        ChangeNotifierProvider<CashBankReportController>(
          create: (_) => getIt<CashBankReportController>(),
        ),
        ChangeNotifierProvider<TrialBalanceController>(
          create: (_) => getIt<TrialBalanceController>(),
        ),
        ChangeNotifierProvider<CashFlowController>(
          create: (_) => getIt<CashFlowController>(),
        ),
        ChangeNotifierProvider<BalanceSheetController>(
          create: (_) => getIt<BalanceSheetController>(),
        ),
        ChangeNotifierProvider<ProfitLossController>(
          create: (_) => getIt<ProfitLossController>(),
        ),
        ChangeNotifierProvider<ARAgingReportController>(
          create: (_) => getIt<ARAgingReportController>(),
        ),
        ChangeNotifierProvider<BillingTaxReportController>(
          create: (_) => getIt<BillingTaxReportController>(),
        ),
        ChangeNotifierProvider<CheckBalanceJournalController>(
          create: (_) => getIt<CheckBalanceJournalController>(),
        ),
        ChangeNotifierProvider<DepreciationReportController>(
          create: (_) => getIt<DepreciationReportController>(),
        ),
        // ==================== MANUFACTURING ====================
        ChangeNotifierProvider<WorkstationController>(
          create: (_) => getIt<WorkstationController>(),
        ),
        ChangeNotifierProvider<BomController>(
          create: (_) => getIt<BomController>(),
        ),
        ChangeNotifierProvider<ManufacturingOrderController>(
          create: (_) => getIt<ManufacturingOrderController>(),
        ),
        ChangeNotifierProvider<UnbuildOrderController>(
          create: (_) => getIt<UnbuildOrderController>(),
        ),
        ChangeNotifierProvider<WorkOrderController>(
          create: (_) => getIt<WorkOrderController>(),
        ),
        // ==================== POS ====================
        ChangeNotifierProvider<StoreController>(
          create: (_) => getIt<StoreController>(),
        ),
        ChangeNotifierProvider<PrinterConfigController>(
          create: (_) => getIt<PrinterConfigController>(),
        ),
        ChangeNotifierProvider<pos_top_customer_report.TopCustomerReportController>(
          create: (_) => getIt<pos_top_customer_report.TopCustomerReportController>(),
        ),
        ChangeNotifierProvider<pos_sold_product_report.SoldProductReportController>(
          create: (_) => getIt<pos_sold_product_report.SoldProductReportController>(),
        ),
        ChangeNotifierProvider<StoreSessionReportController>(
          create: (_) => getIt<StoreSessionReportController>(),
        ),
        ChangeNotifierProvider<TransactionHistoryController>(
          create: (_) => getIt<TransactionHistoryController>(),
        ),
        ChangeNotifierProvider<PosSessionController>(
          create: (_) => getIt<PosSessionController>(),
        ),
        ChangeNotifierProvider<PosSaleController>(
          create: (_) => getIt<PosSaleController>(),
        ),
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
        return ConnectivityBanner(child: child ?? const SizedBox.shrink());
      },
    );
  }
}