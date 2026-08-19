import 'package:get_it/get_it.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../network/dio_client.dart';

// Auth
import 'package:erp_mobile_cnplus/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:erp_mobile_cnplus/features/auth/data/repositories/auth_repository.dart';
import 'package:erp_mobile_cnplus/features/auth/domain/usecases/login_usecase.dart';
import 'package:erp_mobile_cnplus/features/auth/presentation/controllers/auth_controller.dart';

// Profile
import 'package:erp_mobile_cnplus/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/profile/data/repositories/profile_repository.dart';
import 'package:erp_mobile_cnplus/features/profile/domain/usecases/get_profile.dart';
import 'package:erp_mobile_cnplus/features/profile/domain/usecases/logout.dart';
import 'package:erp_mobile_cnplus/features/profile/presentation/controllers/profile_controller.dart';

// Modul
import 'package:erp_mobile_cnplus/features/modul/presentation/controllers/modul_controller.dart';

// Dashboard Inventory
import 'package:erp_mobile_cnplus/features/inventory/dashboard/data/datasources/inventory_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/inventory/dashboard/data/repositories/inventory_dashboard_repository.dart';
import 'package:erp_mobile_cnplus/features/inventory/dashboard/domain/usecases/inventory_dashboard_usecase.dart';
import 'package:erp_mobile_cnplus/features/inventory/dashboard/presentation/controllers/inventory_dashboard_controller.dart';

// Dashboard Purchase
import 'package:erp_mobile_cnplus/features/purchase/dashboard/data/datasources/purchase_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/purchase/dashboard/data/repositories/purchase_remote_repositories.dart';
import 'package:erp_mobile_cnplus/features/purchase/dashboard/domain/usecases/get_purchase_dashboard_data.dart';
import 'package:erp_mobile_cnplus/features/purchase/dashboard/presentation/controllers/purchase_dashboard_controller.dart';

// Dashboard Sales
import 'package:erp_mobile_cnplus/features/sales/dashboard/data/datasources/sales_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/sales/dashboard/data/repositories/sales_dashboard_repository.dart';
import 'package:erp_mobile_cnplus/features/sales/dashboard/domain/usecases/get_sales_dashboard_data.dart';
import 'package:erp_mobile_cnplus/features/sales/dashboard/presentation/controllers/sales_dashboard_controller.dart';

// Dashboard HR
import 'package:erp_mobile_cnplus/features/hr/dashboard/data/datasources/hr_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/hr/dashboard/data/repositories/hr_dashboard_repository.dart';
import 'package:erp_mobile_cnplus/features/hr/dashboard/domain/usecases/hr_dashboard_usecases.dart.dart';
import 'package:erp_mobile_cnplus/features/hr/dashboard/presentation/controllers/hr_dashboard_controller.dart';

// Dashboard Accounting
import 'package:erp_mobile_cnplus/features/accounting/dashboard/data/datasources/accounting_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/accounting/dashboard/data/repositories/accounting_remote_repositories.dart';
import 'package:erp_mobile_cnplus/features/accounting/dashboard/domain/usecases/get_accounting_dashboard.dart';
import 'package:erp_mobile_cnplus/features/accounting/dashboard/presentation/controllers/accounting_dashboard_controller.dart';

// Dashboard Manufacturing
import 'package:erp_mobile_cnplus/features/manufacturing/dashboard/data/datasources/manufacturing_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/manufacturing/dashboard/data/repositories/manufacturing_dashboard_repository.dart';
import 'package:erp_mobile_cnplus/features/manufacturing/dashboard/domain/usecases/manufacturing_dashboard_usecases.dart';
import 'package:erp_mobile_cnplus/features/manufacturing/dashboard/presentation/controllers/manufacturing_dashboard_controller.dart';

// Dashboard CRM
import 'package:erp_mobile_cnplus/features/crm/dashboard/data/datasources/crm_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/crm/dashboard/data/repositories/crm_dashboard_repository.dart';
import 'package:erp_mobile_cnplus/features/crm/dashboard/domain/usecases/crm_dashboard_usecases.dart';
import 'package:erp_mobile_cnplus/features/crm/dashboard/presentation/controllers/crm_dashboard_controller.dart';

// Dashboard PoS
import 'package:erp_mobile_cnplus/features/pos/dashboard/data/datasources/pos_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/pos/dashboard/data/repositories/pos_dashboard_repository.dart';
import 'package:erp_mobile_cnplus/features/pos/dashboard/domain/usecases/pos_dashboard_usecases.dart';
import 'package:erp_mobile_cnplus/features/pos/dashboard/presentation/controllers/pos_dashboard_controller.dart';

// General Dashboard
import 'package:erp_mobile_cnplus/features/general_dashboard/data/datasources/general_dashboard_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/general_dashboard/data/repositories/general_dashboard_repository.dart';
import 'package:erp_mobile_cnplus/features/general_dashboard/domain/usecases/general_dashboard_usecases.dart';
import 'package:erp_mobile_cnplus/features/general_dashboard/presentation/controllers/general_dashboard_controller.dart';

// Master Product
import 'package:erp_mobile_cnplus/features/master/product/data/datasources/product_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/master/product/data/repositories/product_repository.dart';
import 'package:erp_mobile_cnplus/features/master/product/domain/usecases/product_usecases.dart';
import 'package:erp_mobile_cnplus/features/master/product/presentation/controllers/product_controller.dart';

// Master Brand
import 'package:erp_mobile_cnplus/features/master/brand/data/datasources/brand_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/master/brand/data/repositories/brand_repository.dart';
import 'package:erp_mobile_cnplus/features/master/brand/domain/usecases/brand_usecases.dart';
import 'package:erp_mobile_cnplus/features/master/brand/presentation/controllers/brand_controller.dart';

// Master Product Category
import 'package:erp_mobile_cnplus/features/master/product_category/data/datasources/product_category_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/master/product_category/data/repositories/product_category_repository.dart';
import 'package:erp_mobile_cnplus/features/master/product_category/domain/usecases/product_category_usecases.dart';
import 'package:erp_mobile_cnplus/features/master/product_category/presentation/controllers/product_category_controller.dart';

// Master Product Type
import 'package:erp_mobile_cnplus/features/master/product_type/data/datasources/product_type_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/master/product_type/data/repositories/product_type_repository.dart';
import 'package:erp_mobile_cnplus/features/master/product_type/domain/usecases/product_type_usecases.dart';
import 'package:erp_mobile_cnplus/features/master/product_type/presentation/controllers/product_type_controller.dart';

// Master Vendor
import 'package:erp_mobile_cnplus/features/master/vendor/data/datasources/vendor_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/master/vendor/data/repositories/vendor_repository.dart';
import 'package:erp_mobile_cnplus/features/master/vendor/domain/usecases/vendor_usecases.dart';
import 'package:erp_mobile_cnplus/features/master/vendor/presentation/controllers/vendor_controller.dart';

// Master Location
import 'package:erp_mobile_cnplus/features/master/location/data/datasources/location_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/master/location/data/repositories/location_repository.dart';
import 'package:erp_mobile_cnplus/features/master/location/domain/usecases/location_usecases.dart';
import 'package:erp_mobile_cnplus/features/master/location/presentation/controllers/location_controller.dart';

// Master Warehouse
import 'package:erp_mobile_cnplus/features/master/warehouse/data/datasources/warehouse_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/master/warehouse/data/repositories/warehouse_repository.dart';
import 'package:erp_mobile_cnplus/features/master/warehouse/domain/usecases/warehouse_usecases.dart';
import 'package:erp_mobile_cnplus/features/master/warehouse/presentation/controllers/warehouse_controller.dart';

// Master Customer Category
import 'package:erp_mobile_cnplus/features/master/customer_category/data/datasources/customer_category_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/master/customer_category/data/repositories/customer_category_repository.dart';
import 'package:erp_mobile_cnplus/features/master/customer_category/domain/usecases/customer_category_usecases.dart';
import 'package:erp_mobile_cnplus/features/master/customer_category/presentation/controllers/customer_category_controller.dart';

// Master Customer
import 'package:erp_mobile_cnplus/features/master/customer/data/datasources/customer_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/master/customer/data/repositories/customer_repository.dart';
import 'package:erp_mobile_cnplus/features/master/customer/domain/usecases/customer_usecases.dart';
import 'package:erp_mobile_cnplus/features/master/customer/presentation/controllers/customer_controller.dart';

// Master Sales Team
import 'package:erp_mobile_cnplus/features/master/sales_team/data/datasources/sales_team_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/master/sales_team/data/repositories/sales_team_repository.dart';
import 'package:erp_mobile_cnplus/features/master/sales_team/domain/usecases/sales_team_usecases.dart';
import 'package:erp_mobile_cnplus/features/master/sales_team/presentation/controllers/sales_team_controller.dart';

// Master Purchase Team
import 'package:erp_mobile_cnplus/features/master/purchase_team/data/datasources/purchase_team_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/master/purchase_team/data/repositories/purchase_team_repository.dart';
import 'package:erp_mobile_cnplus/features/master/purchase_team/domain/usecases/purchase_team_usecases.dart';
import 'package:erp_mobile_cnplus/features/master/purchase_team/presentation/controllers/purchase_team_controller.dart';

// HR Attendance
import 'package:erp_mobile_cnplus/features/hr/attendance/data/datasources/attendance_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/hr/attendance/data/repositories/attendance_repository.dart';
import 'package:erp_mobile_cnplus/features/hr/attendance/domain/usecases/attendance_usecases.dart';
import 'package:erp_mobile_cnplus/features/hr/attendance/presentation/controllers/attendance_controller.dart';

// HR Department
import 'package:erp_mobile_cnplus/features/hr/department/data/datasources/department_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/hr/department/data/repositories/department_repository.dart';
import 'package:erp_mobile_cnplus/features/hr/department/domain/usecases/department_usecases.dart';
import 'package:erp_mobile_cnplus/features/hr/department/presentation/controllers/department_controller.dart';

// HR Employee Status
import 'package:erp_mobile_cnplus/features/hr/employee_status/data/datasources/employee_status_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/hr/employee_status/data/repositories/employee_status_repository.dart';
import 'package:erp_mobile_cnplus/features/hr/employee_status/domain/usecases/employee_status_usecases.dart';
import 'package:erp_mobile_cnplus/features/hr/employee_status/presentation/controllers/employee_status_controller.dart';

// HR National Holiday
import 'package:erp_mobile_cnplus/features/hr/national_holiday/data/datasources/national_holiday_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/hr/national_holiday/data/repositories/national_holiday_repository.dart';
import 'package:erp_mobile_cnplus/features/hr/national_holiday/domain/usecases/national_holiday_usecases.dart';
import 'package:erp_mobile_cnplus/features/hr/national_holiday/presentation/controllers/national_holiday_controller.dart';

// HR Position
import 'package:erp_mobile_cnplus/features/hr/position/data/datasources/position_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/hr/position/data/repositories/position_repository.dart';
import 'package:erp_mobile_cnplus/features/hr/position/domain/usecases/position_usecases.dart';
import 'package:erp_mobile_cnplus/features/hr/position/presentation/controllers/position_controller.dart';

// HR Leave Type
import 'package:erp_mobile_cnplus/features/hr/leave_type/data/datasources/leave_type_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/hr/leave_type/data/repositories/leave_type_repository.dart';
import 'package:erp_mobile_cnplus/features/hr/leave_type/domain/usecases/leave_type_usecases.dart';
import 'package:erp_mobile_cnplus/features/hr/leave_type/presentation/controllers/leave_type_controller.dart';

// HR Collective Leave
import 'package:erp_mobile_cnplus/features/hr/collective_leave/data/datasources/collective_leave_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/hr/collective_leave/data/repositories/collective_leave_repository.dart';
import 'package:erp_mobile_cnplus/features/hr/collective_leave/domain/usecases/collective_leave_usecases.dart';
import 'package:erp_mobile_cnplus/features/hr/collective_leave/presentation/controllers/collective_leave_controller.dart';

// Master Employee
import 'package:erp_mobile_cnplus/features/master/employee/data/datasources/employee_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/master/employee/data/repositories/employee_repository.dart';
import 'package:erp_mobile_cnplus/features/master/employee/domain/usecases/employee_usecases.dart';
import 'package:erp_mobile_cnplus/features/master/employee/presentation/controllers/employee_controller.dart';

// HR Leave Allocation
import 'package:erp_mobile_cnplus/features/hr/leave_allocation/data/datasources/leave_allocation_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/hr/leave_allocation/data/repositories/leave_allocation_repository.dart';
import 'package:erp_mobile_cnplus/features/hr/leave_allocation/domain/usecases/leave_allocation_usecases.dart';
import 'package:erp_mobile_cnplus/features/hr/leave_allocation/presentation/controllers/leave_allocation_controller.dart';

// Accounting Coa
import 'package:erp_mobile_cnplus/features/accounting/coa/data/datasources/coa_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/accounting/coa/data/repositories/coa_repository.dart';
import 'package:erp_mobile_cnplus/features/accounting/coa/domain/usecases/coa_usecases.dart';
import 'package:erp_mobile_cnplus/features/accounting/coa/presentation/controllers/coa_controller.dart';

// Accounting Bank Account
import 'package:erp_mobile_cnplus/features/accounting/bank_account/data/datasources/bank_account_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/accounting/bank_account/data/repositories/bank_account_repository.dart';
import 'package:erp_mobile_cnplus/features/accounting/bank_account/domain/usecases/bank_account_usecases.dart';
import 'package:erp_mobile_cnplus/features/accounting/bank_account/presentation/controllers/bank_account_controller.dart';

// Master Project
import 'package:erp_mobile_cnplus/features/master/project/data/datasources/project_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/master/project/data/repositories/project_repository.dart';
import 'package:erp_mobile_cnplus/features/master/project/domain/usecases/project_usecases.dart';
import 'package:erp_mobile_cnplus/features/master/project/presentation/controllers/project_controller.dart';

// Sales Price List
import 'package:erp_mobile_cnplus/features/sales/price_list/data/datasources/price_list_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/sales/price_list/data/repositories/price_list_repository.dart';
import 'package:erp_mobile_cnplus/features/sales/price_list/domain/usecases/price_list_usecases.dart';
import 'package:erp_mobile_cnplus/features/sales/price_list/presentation/controllers/price_list_controller.dart';

// Manufacturing Workstation
import 'package:erp_mobile_cnplus/features/manufacturing/workstation/data/datasources/workstation_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/manufacturing/workstation/data/repositories/workstation_repository.dart';
import 'package:erp_mobile_cnplus/features/manufacturing/workstation/domain/usecases/workstation_usecases.dart';
import 'package:erp_mobile_cnplus/features/manufacturing/workstation/presentation/controllers/workstation_controller.dart';

// Manufacturing Bill of Material
import 'package:erp_mobile_cnplus/features/manufacturing/bom/data/datasources/bom_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/manufacturing/bom/data/repositories/bom_repository.dart';
import 'package:erp_mobile_cnplus/features/manufacturing/bom/domain/usecases/bom_usecases.dart';
import 'package:erp_mobile_cnplus/features/manufacturing/bom/presentation/controllers/bom_controller.dart';

// Master UOM
import 'package:erp_mobile_cnplus/features/master/uom/data/datasources/uom_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/master/uom/data/repositories/uom_repository.dart';
import 'package:erp_mobile_cnplus/features/master/uom/domain/usecases/uom_usecases.dart';
import 'package:erp_mobile_cnplus/features/master/uom/presentation/controllers/uom_controller.dart';

// Master User
import 'package:erp_mobile_cnplus/features/master/user/data/datasources/user_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/master/user/data/repositories/user_repository.dart';
import 'package:erp_mobile_cnplus/features/master/user/domain/usecases/user_usecases.dart';
import 'package:erp_mobile_cnplus/features/master/user/presentation/controllers/user_controller.dart';

// PoS Store
import 'package:erp_mobile_cnplus/features/pos/store/data/datasources/store_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/pos/store/data/repositories/store_repository.dart';
import 'package:erp_mobile_cnplus/features/pos/store/domain/usecases/store_usecases.dart';
import 'package:erp_mobile_cnplus/features/pos/store/presentation/controllers/store_controller.dart';

// HR Overtime Type
import 'package:erp_mobile_cnplus/features/hr/overtime_type/data/datasources/overtime_type_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/hr/overtime_type/data/repositories/overtime_type_repository.dart';
import 'package:erp_mobile_cnplus/features/hr/overtime_type/domain/usecases/overtime_type_usecases.dart';
import 'package:erp_mobile_cnplus/features/hr/overtime_type/presentation/controllers/overtime_type_controller.dart';

// HR Leave Quota
import 'package:erp_mobile_cnplus/features/hr/leave_quota/data/datasources/leave_quota_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/hr/leave_quota/presentation/controllers/leave_quota_controller.dart';

// HR Leave Request
import 'package:erp_mobile_cnplus/features/hr/leave_request/data/datasources/leave_request_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/hr/leave_request/data/repositories/leave_request_repository.dart';
import 'package:erp_mobile_cnplus/features/hr/leave_request/domain/usecases/leave_request_usecases.dart';
import 'package:erp_mobile_cnplus/features/hr/leave_request/presentation/controllers/leave_request_controller.dart';

// HR Overtime Request
import 'package:erp_mobile_cnplus/features/hr/overtime_request/data/datasources/overtime_request_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/hr/overtime_request/data/repositories/overtime_request_repository.dart';
import 'package:erp_mobile_cnplus/features/hr/overtime_request/domain/usecases/overtime_request_usecases.dart';
import 'package:erp_mobile_cnplus/features/hr/overtime_request/presentation/controllers/overtime_request_controller.dart';

// Sales Quotation
import 'package:erp_mobile_cnplus/features/sales/quotation/data/datasources/quotation_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/sales/quotation/data/repositories/quotation_repository.dart';
import 'package:erp_mobile_cnplus/features/sales/quotation/domain/usecases/quotation_usecases.dart';
import 'package:erp_mobile_cnplus/features/sales/quotation/presentation/controllers/quotation_controller.dart';

// Sales Sales Order
import 'package:erp_mobile_cnplus/features/sales/sales_order/data/datasources/sales_order_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/sales/sales_order/data/repositories/sales_order_repository.dart';
import 'package:erp_mobile_cnplus/features/sales/sales_order/domain/usecases/sales_order_usecases.dart';
import 'package:erp_mobile_cnplus/features/sales/sales_order/presentation/controllers/sales_order_controller.dart';

// Sales Direct Sales
import 'package:erp_mobile_cnplus/features/sales/direct_sales/data/datasources/direct_sales_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/sales/direct_sales/data/repositories/direct_sales_repository.dart';
import 'package:erp_mobile_cnplus/features/sales/direct_sales/domain/usecases/direct_sales_usecases.dart';
import 'package:erp_mobile_cnplus/features/sales/direct_sales/presentation/controllers/direct_sales_controller.dart';

// Sales Invoice
import 'package:erp_mobile_cnplus/features/sales/invoice/data/datasources/invoice_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/sales/invoice/data/repositories/invoice_repository.dart';
import 'package:erp_mobile_cnplus/features/sales/invoice/domain/usecases/invoice_usecases.dart';
import 'package:erp_mobile_cnplus/features/sales/invoice/presentation/controllers/invoice_controller.dart';

// Sales Service Quotation
import 'package:erp_mobile_cnplus/features/sales/service_sales/service_quotation/data/datasources/service_quotation_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/sales/service_sales/service_quotation/data/repositories/service_quotation_repository.dart';
import 'package:erp_mobile_cnplus/features/sales/service_sales/service_quotation/domain/usecases/service_quotation_usecases.dart';
import 'package:erp_mobile_cnplus/features/sales/service_sales/service_quotation/presentation/controllers/service_quotation_controller.dart';

// Sales Service Sales Order
import 'package:erp_mobile_cnplus/features/sales/service_sales/service_sales_order/data/datasources/service_sales_order_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/sales/service_sales/service_sales_order/data/repositories/service_sales_order_repository.dart';
import 'package:erp_mobile_cnplus/features/sales/service_sales/service_sales_order/domain/usecases/service_sales_order_usecases.dart';
import 'package:erp_mobile_cnplus/features/sales/service_sales/service_sales_order/presentation/controllers/service_sales_order_controller.dart';

// Sales Service Direct Sales
import 'package:erp_mobile_cnplus/features/sales/service_sales/service_direct_sales/data/datasources/service_direct_sales_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/sales/service_sales/service_direct_sales/data/repositories/service_direct_sales_repository.dart';
import 'package:erp_mobile_cnplus/features/sales/service_sales/service_direct_sales/domain/usecases/service_direct_sales_usecases.dart';
import 'package:erp_mobile_cnplus/features/sales/service_sales/service_direct_sales/presentation/controllers/service_direct_sales_controller.dart';

// Sales Service Invoice
import 'package:erp_mobile_cnplus/features/sales/service_sales/service_invoice/data/datasources/service_invoice_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/sales/service_sales/service_invoice/data/repositories/service_invoice_repository.dart';
import 'package:erp_mobile_cnplus/features/sales/service_sales/service_invoice/domain/usecases/service_invoice_usecases.dart';
import 'package:erp_mobile_cnplus/features/sales/service_sales/service_invoice/presentation/controllers/service_invoice_controller.dart';

// Purchase Purchase Request
import 'package:erp_mobile_cnplus/features/purchase/purchase_request/data/datasources/purchase_request_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/purchase/purchase_request/data/repositories/purchase_request_repository.dart';
import 'package:erp_mobile_cnplus/features/purchase/purchase_request/domain/usecases/purchase_request_usecases.dart';
import 'package:erp_mobile_cnplus/features/purchase/purchase_request/presentation/controllers/purchase_request_controller.dart';

// Purchase Purchase Request
import 'package:erp_mobile_cnplus/features/purchase/request_quotation/data/datasources/rfq_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/purchase/request_quotation/data/repositories/rfq_repository.dart';
import 'package:erp_mobile_cnplus/features/purchase/request_quotation/domain/usecases/rfq_usecases.dart';
import 'package:erp_mobile_cnplus/features/purchase/request_quotation/presentation/controllers/rfq_controller.dart';

// Purchase Direct Purchase
import 'package:erp_mobile_cnplus/features/purchase/direct_purchase/data/datasources/direct_purchase_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/purchase/direct_purchase/data/repositories/direct_purchase_repository.dart';
import 'package:erp_mobile_cnplus/features/purchase/direct_purchase/domain/usecases/direct_purchase_usecases.dart';
import 'package:erp_mobile_cnplus/features/purchase/direct_purchase/presentation/controllers/direct_purchase_controller.dart';

// Purchase Purchase Order
import 'package:erp_mobile_cnplus/features/purchase/purchase_order/data/datasources/purchase_order_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/purchase/purchase_order/data/repositories/purchase_order_repository.dart';
import 'package:erp_mobile_cnplus/features/purchase/purchase_order/domain/usecases/purchase_order_usecases.dart';
import 'package:erp_mobile_cnplus/features/purchase/purchase_order/presentation/controllers/purchase_order_controller.dart';

// Purchase Bill
import 'package:erp_mobile_cnplus/features/purchase/bill/data/datasources/bill_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/purchase/bill/data/repositories/bill_repository.dart';
import 'package:erp_mobile_cnplus/features/purchase/bill/domain/usecases/bill_usecases.dart';
import 'package:erp_mobile_cnplus/features/purchase/bill/presentation/controllers/bill_controller.dart';

// Inventory Receipt Note
import 'package:erp_mobile_cnplus/features/inventory/receipt_note/data/datasources/receipt_note_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/inventory/receipt_note/data/repositories/receipt_note_repository.dart';
import 'package:erp_mobile_cnplus/features/inventory/receipt_note/domain/usecases/receipt_note_usecases.dart';
import 'package:erp_mobile_cnplus/features/inventory/receipt_note/presentation/controllers/receipt_note_controller.dart';

// Inventory Delivery Note
import 'package:erp_mobile_cnplus/features/inventory/delivery_note/data/datasources/delivery_note_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/inventory/delivery_note/data/repositories/delivery_note_repository.dart';
import 'package:erp_mobile_cnplus/features/inventory/delivery_note/domain/usecases/delivery_note_usecases.dart';
import 'package:erp_mobile_cnplus/features/inventory/delivery_note/presentation/controllers/delivery_note_controller.dart';

// Inventory Internal Transfer
import 'package:erp_mobile_cnplus/features/inventory/internal_transfer/data/datasources/internal_transfer_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/inventory/internal_transfer/data/repositories/internal_transfer_repository.dart';
import 'package:erp_mobile_cnplus/features/inventory/internal_transfer/domain/usecases/internal_transfer_usecases.dart';
import 'package:erp_mobile_cnplus/features/inventory/internal_transfer/presentation/controllers/internal_transfer_controller.dart';

// Inventory Transfer In
import 'package:erp_mobile_cnplus/features/inventory/transfer_in/data/datasources/transfer_in_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/inventory/transfer_in/data/repositories/transfer_in_repository.dart';
import 'package:erp_mobile_cnplus/features/inventory/transfer_in/domain/usecases/transfer_in_usecases.dart';
import 'package:erp_mobile_cnplus/features/inventory/transfer_in/presentation/controllers/transfer_in_controller.dart';

// Inventory Transfer Out
import 'package:erp_mobile_cnplus/features/inventory/transfer_out/data/datasources/transfer_out_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/inventory/transfer_out/data/repositories/transfer_out_repository.dart';
import 'package:erp_mobile_cnplus/features/inventory/transfer_out/domain/usecases/transfer_out_usecases.dart';
import 'package:erp_mobile_cnplus/features/inventory/transfer_out/presentation/controllers/transfer_out_controller.dart';

// Inventory Scrap Order
import 'package:erp_mobile_cnplus/features/inventory/scrap_order/data/datasources/scrap_order_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/inventory/scrap_order/data/repositories/scrap_order_repository.dart';
import 'package:erp_mobile_cnplus/features/inventory/scrap_order/domain/usecases/scrap_order_usecases.dart';
import 'package:erp_mobile_cnplus/features/inventory/scrap_order/presentation/controllers/scrap_order_controller.dart';

// Inventory Stock Count
import 'package:erp_mobile_cnplus/features/inventory/stock_count/data/datasources/stock_count_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/inventory/stock_count/data/repositories/stock_count_repository.dart';
import 'package:erp_mobile_cnplus/features/inventory/stock_count/domain/usecases/stock_count_usecases.dart';
import 'package:erp_mobile_cnplus/features/inventory/stock_count/presentation/controllers/stock_count_controller.dart';

// Inventory Return RN
import 'package:erp_mobile_cnplus/features/inventory/return_rn/data/datasources/return_rn_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/inventory/return_rn/data/repositories/return_rn_repository.dart';
import 'package:erp_mobile_cnplus/features/inventory/return_rn/domain/usecases/return_rn_usecases.dart';
import 'package:erp_mobile_cnplus/features/inventory/return_rn/presentation/controllers/return_rn_controller.dart';

// Inventory Return DN
import 'package:erp_mobile_cnplus/features/inventory/return_dn/data/datasources/return_dn_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/inventory/return_dn/data/repositories/return_dn_repository.dart';
import 'package:erp_mobile_cnplus/features/inventory/return_dn/domain/usecases/return_dn_usecases.dart';
import 'package:erp_mobile_cnplus/features/inventory/return_dn/presentation/controllers/return_dn_controller.dart';


final getIt = GetIt.instance;

class AppInjector {
  static void init() {
    // ==================== CORE ====================
    getIt.registerLazySingleton<FlutterSecureStorage>(() => const FlutterSecureStorage());
    getIt.registerLazySingleton<DioClient>(() => DioClient());

    // ==================== AUTH ====================
    getIt.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(getIt<DioClient>()));
    getIt.registerLazySingleton<AuthLocalDataSource>(() => AuthLocalDataSourceImpl(getIt<FlutterSecureStorage>()));
    getIt.registerLazySingleton<AuthRepository>(() => AuthRepository(
      remoteDataSource: getIt<AuthRemoteDataSource>(),
      localDataSource: getIt<AuthLocalDataSource>(),
    ));
    getIt.registerLazySingleton<LoginUseCase>(() => LoginUseCase(getIt<AuthRepository>()));
    getIt.registerFactory<AuthController>(() => AuthController(
      loginUseCase: getIt<LoginUseCase>(),
      authRepository: getIt<AuthRepository>(),
    ));

    // ==================== PROFILE ====================
    getIt.registerLazySingleton<ProfileRemoteDataSource>(() => ProfileRemoteDataSourceImpl(getIt<DioClient>().dio));
    getIt.registerLazySingleton<ProfileRepository>(() => ProfileRepository(remoteDataSource: getIt<ProfileRemoteDataSource>()));
    getIt.registerLazySingleton(() => GetProfile(getIt<ProfileRepository>()));
    getIt.registerLazySingleton(() => Logout(getIt<ProfileRepository>(), getIt<FlutterSecureStorage>()));
    getIt.registerFactory<ProfileController>(() => ProfileController(
      getProfile: getIt<GetProfile>(),
      logout: getIt<Logout>(),
    ));

    // ==================== MODUL ====================
    getIt.registerFactory<ModulController>(() => ModulController(
      authRepository: getIt<AuthRepository>(),
      dioClient: getIt<DioClient>(),
    ));

    // ==================== DASHBOARD INVENTORY ====================
    getIt.registerLazySingleton<InventoryRemoteDataSource>(() => InventoryRemoteDataSourceImpl(getIt<DioClient>()));
    getIt.registerLazySingleton<InventoryDashboardRepository>(() => InventoryDashboardRepository(remoteDataSource: getIt<InventoryRemoteDataSource>()));
    getIt.registerLazySingleton<GetInventoryDashboard>(() => GetInventoryDashboard(getIt<InventoryDashboardRepository>()));
    getIt.registerFactory<InventoryDashboardController>(() => InventoryDashboardController(getIt<GetInventoryDashboard>()));

    // ==================== DASHBOARD PURCHASE ====================
    getIt.registerLazySingleton<PurchaseRemoteDataSource>(() => PurchaseRemoteDataSourceImpl(getIt<DioClient>()));
    getIt.registerLazySingleton<PurchaseDashboardRepository>(() => PurchaseDashboardRepository(remoteDataSource: getIt<PurchaseRemoteDataSource>()));
    getIt.registerLazySingleton<GetPurchaseDashboardData>(() => GetPurchaseDashboardData(getIt<PurchaseDashboardRepository>()));
    getIt.registerFactory<PurchaseDashboardController>(() => PurchaseDashboardController(getDashboardData: getIt<GetPurchaseDashboardData>()));

    // ==================== DASHBOARD SALES ====================
    getIt.registerLazySingleton<SalesRemoteDataSource>(() => SalesRemoteDataSourceImpl(getIt<DioClient>()));
    getIt.registerLazySingleton<SalesDashboardRepository>(() => SalesDashboardRepository(remoteDataSource: getIt<SalesRemoteDataSource>()));
    getIt.registerLazySingleton<GetSalesDashboardData>(() => GetSalesDashboardData(getIt<SalesDashboardRepository>()));
    getIt.registerFactory<SalesDashboardController>(() => SalesDashboardController(getDashboardData: getIt<GetSalesDashboardData>()));

    // ==================== DASHBOARD HR ====================
    getIt.registerLazySingleton(() => HrRemoteDataSource(getIt<DioClient>().dio));
    getIt.registerLazySingleton(() => HrDashboardRepository(remoteDataSource: getIt()));
    getIt.registerLazySingleton(() => GetHrDashboardData(getIt()));
    getIt.registerLazySingleton(() => HrDashboardController(getHrDashboardData: getIt()));

    // ==================== DASHBOARD ACCOUNTING ====================
    getIt.registerLazySingleton<AccountingRemoteDataSource>(() => AccountingRemoteDataSourceImpl(getIt<DioClient>()));
    getIt.registerLazySingleton<AccountingDashboardRepository>(() => AccountingDashboardRepository(remoteDataSource: getIt<AccountingRemoteDataSource>()));
    getIt.registerLazySingleton<GetAccountingDashboardData>(() => GetAccountingDashboardData(getIt<AccountingDashboardRepository>()));
    getIt.registerFactory<AccountingDashboardController>(() => AccountingDashboardController(getDashboardData: getIt<GetAccountingDashboardData>()));

    // ==================== DASHBOARD MANUFACTURING ====================
    getIt.registerLazySingleton<ManufacturingRemoteDataSource>(() => ManufacturingRemoteDataSourceImpl(getIt<DioClient>()));
    getIt.registerLazySingleton<ManufacturingDashboardRepository>(() => ManufacturingDashboardRepository(remoteDataSource: getIt<ManufacturingRemoteDataSource>()));
    getIt.registerLazySingleton<GetManufacturingDashboardData>(() => GetManufacturingDashboardData(getIt<ManufacturingDashboardRepository>()));
    getIt.registerFactory<ManufacturingDashboardController>(() => ManufacturingDashboardController(getManufacturingDashboardData: getIt<GetManufacturingDashboardData>()));

    // ==================== CRM DASHBOARD ====================
    getIt.registerLazySingleton<CrmRemoteDataSource>(() => CrmRemoteDataSource(getIt<DioClient>().dio));
    getIt.registerLazySingleton<CrmDashboardRepository>(() => CrmDashboardRepository(dataSource: getIt()));
    getIt.registerLazySingleton(() => GetCrmDashboard(getIt()));
    getIt.registerLazySingleton(() => GetCrmConversationChart(getIt()));
    getIt.registerLazySingleton(() => GetCrmMessageChart(getIt()));
    getIt.registerLazySingleton<CrmDashboardController>(() => CrmDashboardController(
      getDashboard: getIt(), getConversationChart: getIt(), getMessageChart: getIt(),
    ));

    // ==================== POS DASHBOARD ====================
    getIt.registerLazySingleton<PosRemoteDataSource>(() => PosRemoteDataSource(getIt<DioClient>().dio));
    getIt.registerLazySingleton<PosDashboardRepository>(() => PosDashboardRepository(dataSource: getIt()));
    getIt.registerLazySingleton(() => GetPosDashboard(getIt()));
    getIt.registerLazySingleton<PosDashboardController>(() => PosDashboardController(getPosDashboard: getIt()));

    // ==================== GENERAL DASHBOARD ====================
    getIt.registerLazySingleton<GeneralDashboardRemoteDataSource>(() => GeneralDashboardRemoteDataSource(getIt<DioClient>().dio));
    getIt.registerLazySingleton<GeneralDashboardRepository>(() => GeneralDashboardRepository(remoteDataSource: getIt()));
    getIt.registerLazySingleton(() => GetGeneralDashboard(getIt()));
    getIt.registerLazySingleton<GeneralDashboardController>(() => GeneralDashboardController(getGeneralDashboard: getIt()));

    // ==================== HR ATTENDANCE ====================
    getIt.registerLazySingleton<AttendanceRemoteDataSource>(() => AttendanceRemoteDataSourceImpl(getIt<DioClient>().dio));
    getIt.registerLazySingleton<AttendanceRepository>(() => AttendanceRepository(remoteDataSource: getIt<AttendanceRemoteDataSource>()));
    getIt.registerLazySingleton(() => GetAttendanceData(getIt<AttendanceRepository>()));
    getIt.registerLazySingleton(() => CheckIn(getIt<AttendanceRepository>()));
    getIt.registerLazySingleton(() => CheckOut(getIt<AttendanceRepository>()));
    getIt.registerLazySingleton(() => GetAttendanceHistory(getIt<AttendanceRepository>()));
    getIt.registerFactory<AttendanceController>(() => AttendanceController(
      getAttendanceData: getIt<GetAttendanceData>(),
      checkInUseCase: getIt<CheckIn>(),
      checkOutUseCase: getIt<CheckOut>(),
      getAttendanceHistory: getIt<GetAttendanceHistory>(),
    ));

    // ==================== HR DEPARTMENT ====================
    getIt.registerLazySingleton<DepartmentRemoteDataSource>(() => DepartmentRemoteDataSource(getIt<DioClient>().dio));
    getIt.registerLazySingleton<DepartmentRepository>(() => DepartmentRepository(remoteDataSource: getIt<DepartmentRemoteDataSource>()));
    getIt.registerLazySingleton(() => GetDepartmentList(getIt<DepartmentRepository>()));
    getIt.registerLazySingleton(() => GetDepartmentDetail(getIt<DepartmentRepository>()));
    getIt.registerLazySingleton(() => CreateDepartment(getIt<DepartmentRepository>()));
    getIt.registerLazySingleton(() => UpdateDepartment(getIt<DepartmentRepository>()));
    getIt.registerLazySingleton(() => DeleteDepartment(getIt<DepartmentRepository>()));
    getIt.registerLazySingleton<DepartmentController>(() => DepartmentController(
      getDepartmentList: getIt<GetDepartmentList>(),
      getDepartmentDetail: getIt<GetDepartmentDetail>(),
      createDepartment: getIt<CreateDepartment>(),
      updateDepartment: getIt<UpdateDepartment>(),
      deleteDepartment: getIt<DeleteDepartment>(),
    ));

    // ==================== HR EMPLOYEE STATUS ====================
    getIt.registerLazySingleton<EmployeeStatusRemoteDataSource>(() => EmployeeStatusRemoteDataSource(getIt<DioClient>().dio));
    getIt.registerLazySingleton<EmployeeStatusRepository>(() => EmployeeStatusRepository(remoteDataSource: getIt<EmployeeStatusRemoteDataSource>()));
    getIt.registerLazySingleton(() => GetEmployeeStatusList(getIt<EmployeeStatusRepository>()));
    getIt.registerLazySingleton(() => GetEmployeeStatusDetail(getIt<EmployeeStatusRepository>()));
    getIt.registerLazySingleton(() => CreateEmployeeStatus(getIt<EmployeeStatusRepository>()));
    getIt.registerLazySingleton(() => UpdateEmployeeStatus(getIt<EmployeeStatusRepository>()));
    getIt.registerLazySingleton(() => DeleteEmployeeStatus(getIt<EmployeeStatusRepository>()));
    getIt.registerLazySingleton<EmployeeStatusController>(() => EmployeeStatusController(
      getStatusList: getIt<GetEmployeeStatusList>(),
      getStatusDetail: getIt<GetEmployeeStatusDetail>(),
      createStatus: getIt<CreateEmployeeStatus>(),
      updateStatus: getIt<UpdateEmployeeStatus>(),
      deleteStatus: getIt<DeleteEmployeeStatus>(),
    ));

    // ==================== HR NATIONAL HOLIDAY ====================
    getIt.registerLazySingleton<NationalHolidayRemoteDataSource>(() => NationalHolidayRemoteDataSource(getIt<DioClient>().dio));
    getIt.registerLazySingleton<NationalHolidayRepository>(() => NationalHolidayRepository(remoteDataSource: getIt<NationalHolidayRemoteDataSource>()));
    getIt.registerLazySingleton(() => GetNationalHolidayList(getIt<NationalHolidayRepository>()));
    getIt.registerLazySingleton(() => GetNationalHolidayDetail(getIt<NationalHolidayRepository>()));
    getIt.registerLazySingleton(() => CreateNationalHoliday(getIt<NationalHolidayRepository>()));
    getIt.registerLazySingleton(() => UpdateNationalHoliday(getIt<NationalHolidayRepository>()));
    getIt.registerLazySingleton(() => DeleteNationalHoliday(getIt<NationalHolidayRepository>()));
    getIt.registerLazySingleton<NationalHolidayController>(() => NationalHolidayController(
      getHolidayList: getIt<GetNationalHolidayList>(),
      getHolidayDetail: getIt<GetNationalHolidayDetail>(),
      createHoliday: getIt<CreateNationalHoliday>(),
      updateHoliday: getIt<UpdateNationalHoliday>(),
      deleteHoliday: getIt<DeleteNationalHoliday>(),
    ));

    // ==================== MASTER PRODUCT ====================
    getIt.registerLazySingleton<ProductRemoteDataSource>(() => ProductRemoteDataSource(getIt<DioClient>().dio));
    getIt.registerLazySingleton<ProductRepository>(() => ProductRepository(remoteDataSource: getIt<ProductRemoteDataSource>()));
    getIt.registerLazySingleton(() => GetProductList(getIt<ProductRepository>()));
    getIt.registerLazySingleton(() => GetProductDetail(getIt<ProductRepository>()));
    getIt.registerLazySingleton(() => GetProductFormDropdownData(getIt<ProductRepository>()));
    getIt.registerLazySingleton(() => CreateProduct(getIt<ProductRepository>()));
    getIt.registerLazySingleton(() => UpdateProduct(getIt<ProductRepository>()));
    getIt.registerLazySingleton(() => DeleteProduct(getIt<ProductRepository>()));
    getIt.registerLazySingleton<ProductController>(() => ProductController(
      getProductList: getIt<GetProductList>(),
      getProductDetail: getIt<GetProductDetail>(),
      getFormDropdownData: getIt<GetProductFormDropdownData>(),
      createProduct: getIt<CreateProduct>(),
      updateProduct: getIt<UpdateProduct>(),
      deleteProduct: getIt<DeleteProduct>(),
    ));

    // ==================== MASTER BRAND ====================
    getIt.registerLazySingleton<BrandRemoteDataSource>(() => BrandRemoteDataSource(getIt<DioClient>().dio));
    getIt.registerLazySingleton<BrandRepository>(() => BrandRepository(remoteDataSource: getIt<BrandRemoteDataSource>()));
    getIt.registerLazySingleton(() => GetBrandList(getIt<BrandRepository>()));
    getIt.registerLazySingleton(() => GetBrandDetail(getIt<BrandRepository>()));
    getIt.registerLazySingleton(() => CreateBrand(getIt<BrandRepository>()));
    getIt.registerLazySingleton(() => UpdateBrand(getIt<BrandRepository>()));
    getIt.registerLazySingleton(() => DeleteBrand(getIt<BrandRepository>()));
    getIt.registerFactory<BrandController>(() => BrandController(
      getBrandList: getIt<GetBrandList>(),
      getBrandDetail: getIt<GetBrandDetail>(),
      createBrand: getIt<CreateBrand>(),
      updateBrand: getIt<UpdateBrand>(),
      deleteBrand: getIt<DeleteBrand>(),
    ));

    // ==================== MASTER PRODUCT CATEGORY ====================
    getIt.registerLazySingleton<ProductCategoryRemoteDataSource>(() => ProductCategoryRemoteDataSource(getIt<DioClient>().dio));
    getIt.registerLazySingleton<ProductCategoryRepository>(() => ProductCategoryRepository(remoteDataSource: getIt<ProductCategoryRemoteDataSource>()));
    getIt.registerLazySingleton(() => GetProductCategoryList(getIt<ProductCategoryRepository>()));
    getIt.registerLazySingleton(() => GetProductCategoryDetail(getIt<ProductCategoryRepository>()));
    getIt.registerLazySingleton(() => CreateProductCategory(getIt<ProductCategoryRepository>()));
    getIt.registerLazySingleton(() => UpdateProductCategory(getIt<ProductCategoryRepository>()));
    getIt.registerLazySingleton(() => DeleteProductCategory(getIt<ProductCategoryRepository>()));
    getIt.registerFactory<ProductCategoryController>(() => ProductCategoryController(
      getProductCategoryList: getIt<GetProductCategoryList>(),
      getProductCategoryDetail: getIt<GetProductCategoryDetail>(),
      createProductCategory: getIt<CreateProductCategory>(),
      updateProductCategory: getIt<UpdateProductCategory>(),
      deleteProductCategory: getIt<DeleteProductCategory>(),
    ));

    // ==================== MASTER PRODUCT TYPE ====================
    getIt.registerLazySingleton<ProductTypeRemoteDataSource>(() => ProductTypeRemoteDataSource(getIt<DioClient>().dio));
    getIt.registerLazySingleton<ProductTypeRepository>(() => ProductTypeRepository(remoteDataSource: getIt<ProductTypeRemoteDataSource>()));
    getIt.registerLazySingleton(() => GetProductTypeList(getIt<ProductTypeRepository>()));
    getIt.registerLazySingleton(() => GetProductTypeDetail(getIt<ProductTypeRepository>()));
    getIt.registerLazySingleton(() => CreateProductType(getIt<ProductTypeRepository>()));
    getIt.registerLazySingleton(() => UpdateProductType(getIt<ProductTypeRepository>()));
    getIt.registerLazySingleton(() => DeleteProductType(getIt<ProductTypeRepository>()));
    getIt.registerFactory<ProductTypeController>(() => ProductTypeController(
      getProductTypeList: getIt<GetProductTypeList>(),
      getProductTypeDetail: getIt<GetProductTypeDetail>(),
      createProductType: getIt<CreateProductType>(),
      updateProductType: getIt<UpdateProductType>(),
      deleteProductType: getIt<DeleteProductType>(),
    ));

    // ==================== MASTER VENDOR ====================
    getIt.registerLazySingleton<VendorRemoteDataSource>(() => VendorRemoteDataSource(getIt<DioClient>().dio));
    getIt.registerLazySingleton<VendorRepository>(() => VendorRepository(remoteDataSource: getIt<VendorRemoteDataSource>()));
    getIt.registerLazySingleton(() => GetVendorList(getIt<VendorRepository>()));
    getIt.registerLazySingleton(() => GetVendorDetail(getIt<VendorRepository>()));
    getIt.registerLazySingleton(() => GetVendorFormDropdownData(getIt<VendorRepository>()));
    getIt.registerLazySingleton(() => CreateVendor(getIt<VendorRepository>()));
    getIt.registerLazySingleton(() => UpdateVendor(getIt<VendorRepository>()));
    getIt.registerLazySingleton(() => DeleteVendor(getIt<VendorRepository>()));
    getIt.registerLazySingleton<VendorController>(() => VendorController(
      getVendorList: getIt<GetVendorList>(),
      getVendorDetail: getIt<GetVendorDetail>(),
      getFormDropdownData: getIt<GetVendorFormDropdownData>(),
      createVendor: getIt<CreateVendor>(),
      updateVendor: getIt<UpdateVendor>(),
      deleteVendor: getIt<DeleteVendor>(),
    ));

    // ==================== MASTER LOCATION ====================
    getIt.registerLazySingleton<LocationRemoteDataSource>(() => LocationRemoteDataSource(getIt<DioClient>().dio));
    getIt.registerLazySingleton<LocationRepository>(() => LocationRepository(remoteDataSource: getIt<LocationRemoteDataSource>()));
    getIt.registerLazySingleton(() => GetLocationList(getIt<LocationRepository>()));
    getIt.registerLazySingleton(() => GetLocationDetail(getIt<LocationRepository>()));
    getIt.registerLazySingleton(() => GetLocationFormDropdownData(getIt<LocationRepository>()));
    getIt.registerLazySingleton(() => CreateLocation(getIt<LocationRepository>()));
    getIt.registerLazySingleton(() => UpdateLocation(getIt<LocationRepository>()));
    getIt.registerLazySingleton(() => DeleteLocation(getIt<LocationRepository>()));
    getIt.registerFactory<LocationController>(() => LocationController(
      getLocationList: getIt<GetLocationList>(),
      getLocationDetail: getIt<GetLocationDetail>(),
      getFormDropdownData: getIt<GetLocationFormDropdownData>(),
      createLocation: getIt<CreateLocation>(),
      updateLocation: getIt<UpdateLocation>(),
      deleteLocation: getIt<DeleteLocation>(),
    ));

    // ==================== MASTER WAREHOUSE ====================
    getIt.registerLazySingleton<WarehouseRemoteDataSource>(() => WarehouseRemoteDataSource(getIt<DioClient>().dio));
    getIt.registerLazySingleton<WarehouseRepository>(() => WarehouseRepository(remoteDataSource: getIt<WarehouseRemoteDataSource>()));
    getIt.registerLazySingleton(() => GetWarehouseList(getIt<WarehouseRepository>()));
    getIt.registerLazySingleton(() => GetWarehouseDetail(getIt<WarehouseRepository>()));
    getIt.registerLazySingleton(() => CreateWarehouse(getIt<WarehouseRepository>()));
    getIt.registerLazySingleton(() => UpdateWarehouse(getIt<WarehouseRepository>()));
    getIt.registerLazySingleton(() => DeleteWarehouse(getIt<WarehouseRepository>()));
    getIt.registerFactory<WarehouseController>(() => WarehouseController(
      getWarehouseList: getIt<GetWarehouseList>(),
      getWarehouseDetail: getIt<GetWarehouseDetail>(),
      createWarehouse: getIt<CreateWarehouse>(),
      updateWarehouse: getIt<UpdateWarehouse>(),
      deleteWarehouse: getIt<DeleteWarehouse>(),
    ));

    // ==================== MASTER CUSTOMER CATEGORY ====================
    getIt.registerLazySingleton<CustomerCategoryRemoteDataSource>(() => CustomerCategoryRemoteDataSource(getIt<DioClient>().dio));
    getIt.registerLazySingleton<CustomerCategoryRepository>(() => CustomerCategoryRepository(remoteDataSource: getIt<CustomerCategoryRemoteDataSource>()));
    getIt.registerLazySingleton(() => GetCustomerCategoryList(getIt<CustomerCategoryRepository>()));
    getIt.registerLazySingleton(() => GetCustomerCategoryDetail(getIt<CustomerCategoryRepository>()));
    getIt.registerLazySingleton(() => CreateCustomerCategory(getIt<CustomerCategoryRepository>()));
    getIt.registerLazySingleton(() => UpdateCustomerCategory(getIt<CustomerCategoryRepository>()));
    getIt.registerLazySingleton(() => DeleteCustomerCategory(getIt<CustomerCategoryRepository>()));
    getIt.registerFactory<CustomerCategoryController>(() => CustomerCategoryController(
      getCustomerCategoryList: getIt<GetCustomerCategoryList>(),
      getCustomerCategoryDetail: getIt<GetCustomerCategoryDetail>(),
      createCustomerCategory: getIt<CreateCustomerCategory>(),
      updateCustomerCategory: getIt<UpdateCustomerCategory>(),
      deleteCustomerCategory: getIt<DeleteCustomerCategory>(),
    ));

    // ==================== MASTER CUSTOMER ====================
    getIt.registerLazySingleton<CustomerRemoteDataSource>(() => CustomerRemoteDataSource(getIt<DioClient>().dio));
    getIt.registerLazySingleton<CustomerRepository>(() => CustomerRepository(remoteDataSource: getIt<CustomerRemoteDataSource>()));
    getIt.registerLazySingleton(() => GetCustomerList(getIt<CustomerRepository>()));
    getIt.registerLazySingleton(() => GetCustomerDetail(getIt<CustomerRepository>()));
    getIt.registerLazySingleton(() => GetCustomerFormDropdownData(getIt<CustomerRepository>()));
    getIt.registerLazySingleton(() => CreateCustomer(getIt<CustomerRepository>()));
    getIt.registerLazySingleton(() => UpdateCustomer(getIt<CustomerRepository>()));
    getIt.registerLazySingleton(() => DeleteCustomer(getIt<CustomerRepository>()));
    getIt.registerFactory<CustomerController>(() => CustomerController(
      getCustomerList: getIt<GetCustomerList>(),
      getCustomerDetail: getIt<GetCustomerDetail>(),
      getFormDropdownData: getIt<GetCustomerFormDropdownData>(),
      createCustomer: getIt<CreateCustomer>(),
      updateCustomer: getIt<UpdateCustomer>(),
      deleteCustomer: getIt<DeleteCustomer>(),
    ));

    // ==================== MASTER SALES TEAM ====================
    getIt.registerLazySingleton<SalesTeamRemoteDataSource>(() => SalesTeamRemoteDataSource(getIt<DioClient>().dio));
    getIt.registerLazySingleton<SalesTeamRepository>(() => SalesTeamRepository(remoteDataSource: getIt<SalesTeamRemoteDataSource>()));
    getIt.registerLazySingleton(() => GetSalesTeamList(getIt<SalesTeamRepository>()));
    getIt.registerLazySingleton(() => GetSalesTeamDetail(getIt<SalesTeamRepository>()));
    getIt.registerLazySingleton(() => GetSalesTeamFormOptions(getIt<SalesTeamRepository>()));
    getIt.registerLazySingleton(() => CreateSalesTeam(getIt<SalesTeamRepository>()));
    getIt.registerLazySingleton(() => UpdateSalesTeam(getIt<SalesTeamRepository>()));
    getIt.registerLazySingleton(() => DeleteSalesTeam(getIt<SalesTeamRepository>()));
    getIt.registerLazySingleton<SalesTeamController>(() => SalesTeamController(
      getSalesTeamList: getIt<GetSalesTeamList>(),
      getSalesTeamDetail: getIt<GetSalesTeamDetail>(),
      getFormOptions: getIt<GetSalesTeamFormOptions>(),
      createSalesTeam: getIt<CreateSalesTeam>(),
      updateSalesTeam: getIt<UpdateSalesTeam>(),
      deleteSalesTeam: getIt<DeleteSalesTeam>(),
    ));

    // ==================== MASTER PURCHASE TEAM ====================
    getIt.registerLazySingleton<PurchaseTeamRemoteDataSource>(() => PurchaseTeamRemoteDataSource(getIt<DioClient>().dio));
    getIt.registerLazySingleton<PurchaseTeamRepository>(() => PurchaseTeamRepository(remoteDataSource: getIt<PurchaseTeamRemoteDataSource>()));
    getIt.registerLazySingleton(() => GetPurchaseTeamList(getIt<PurchaseTeamRepository>()));
    getIt.registerLazySingleton(() => GetPurchaseTeamDetail(getIt<PurchaseTeamRepository>()));
    getIt.registerLazySingleton(() => GetPurchaseTeamFormOptions(getIt<PurchaseTeamRepository>()));
    getIt.registerLazySingleton(() => CreatePurchaseTeam(getIt<PurchaseTeamRepository>()));
    getIt.registerLazySingleton(() => UpdatePurchaseTeam(getIt<PurchaseTeamRepository>()));
    getIt.registerLazySingleton(() => DeletePurchaseTeam(getIt<PurchaseTeamRepository>()));
    getIt.registerLazySingleton<PurchaseTeamController>(() => PurchaseTeamController(
      getPurchaseTeamList: getIt<GetPurchaseTeamList>(),
      getPurchaseTeamDetail: getIt<GetPurchaseTeamDetail>(),
      getFormOptions: getIt<GetPurchaseTeamFormOptions>(),
      createPurchaseTeam: getIt<CreatePurchaseTeam>(),
      updatePurchaseTeam: getIt<UpdatePurchaseTeam>(),
      deletePurchaseTeam: getIt<DeletePurchaseTeam>(),
    ));

     // ==================== HR LEAVE TYPE ====================
    getIt.registerLazySingleton<LeaveTypeRemoteDataSource>(() => LeaveTypeRemoteDataSource(getIt<DioClient>().dio));
    getIt.registerLazySingleton<LeaveTypeRepository>(() => LeaveTypeRepository(remoteDataSource: getIt<LeaveTypeRemoteDataSource>()));
    getIt.registerLazySingleton(() => GetLeaveTypeList(getIt<LeaveTypeRepository>()));
    getIt.registerLazySingleton(() => GetLeaveTypeDetail(getIt<LeaveTypeRepository>()));
    getIt.registerLazySingleton(() => GetLeaveTypeFormOptions(getIt<LeaveTypeRepository>()));
    getIt.registerLazySingleton(() => CreateLeaveType(getIt<LeaveTypeRepository>()));
    getIt.registerLazySingleton(() => UpdateLeaveType(getIt<LeaveTypeRepository>()));
    getIt.registerLazySingleton(() => DeleteLeaveType(getIt<LeaveTypeRepository>()));
    getIt.registerLazySingleton<LeaveTypeController>(() => LeaveTypeController(
      getLeaveTypeList: getIt<GetLeaveTypeList>(),
      getLeaveTypeDetail: getIt<GetLeaveTypeDetail>(),
      getFormOptions: getIt<GetLeaveTypeFormOptions>(),
      createLeaveType: getIt<CreateLeaveType>(),
      updateLeaveType: getIt<UpdateLeaveType>(),
      deleteLeaveType: getIt<DeleteLeaveType>(),
    ));
 
    // ==================== HR POSITION ====================
    getIt.registerLazySingleton<PositionRemoteDataSource>(() => PositionRemoteDataSource(getIt<DioClient>().dio));
    getIt.registerLazySingleton<PositionRepository>(() => PositionRepository(remoteDataSource: getIt<PositionRemoteDataSource>()));
    getIt.registerLazySingleton(() => GetPositionList(getIt<PositionRepository>()));
    getIt.registerLazySingleton(() => GetPositionDetail(getIt<PositionRepository>()));
    getIt.registerLazySingleton(() => CreatePosition(getIt<PositionRepository>()));
    getIt.registerLazySingleton(() => UpdatePosition(getIt<PositionRepository>()));
    getIt.registerLazySingleton(() => DeletePosition(getIt<PositionRepository>()));
    getIt.registerLazySingleton<PositionController>(() => PositionController(
      getPositionList: getIt<GetPositionList>(),
      getPositionDetail: getIt<GetPositionDetail>(),
      createPosition: getIt<CreatePosition>(),
      updatePosition: getIt<UpdatePosition>(),
      deletePosition: getIt<DeletePosition>(),
    ));
 
    // ==================== HR COLLECTIVE LEAVE ====================
    getIt.registerLazySingleton<CollectiveLeaveRemoteDataSource>(() => CollectiveLeaveRemoteDataSource(getIt<DioClient>().dio));
    getIt.registerLazySingleton<CollectiveLeaveRepository>(() => CollectiveLeaveRepository(remoteDataSource: getIt<CollectiveLeaveRemoteDataSource>()));
    getIt.registerLazySingleton(() => GetCollectiveLeaveList(getIt<CollectiveLeaveRepository>()));
    getIt.registerLazySingleton(() => GetCollectiveLeaveDetail(getIt<CollectiveLeaveRepository>()));
    getIt.registerLazySingleton(() => CreateCollectiveLeave(getIt<CollectiveLeaveRepository>()));
    getIt.registerLazySingleton(() => UpdateCollectiveLeave(getIt<CollectiveLeaveRepository>()));
    getIt.registerLazySingleton(() => DeleteCollectiveLeave(getIt<CollectiveLeaveRepository>()));
    getIt.registerLazySingleton<CollectiveLeaveController>(() => CollectiveLeaveController(
      getCollectiveLeaveList: getIt<GetCollectiveLeaveList>(),
      getCollectiveLeaveDetail: getIt<GetCollectiveLeaveDetail>(),
      createCollectiveLeave: getIt<CreateCollectiveLeave>(),
      updateCollectiveLeave: getIt<UpdateCollectiveLeave>(),
      deleteCollectiveLeave: getIt<DeleteCollectiveLeave>(),
    ));

    // ==================== MASTER EMPLOYEE ====================
    getIt.registerLazySingleton<EmployeeRemoteDataSource>(() => EmployeeRemoteDataSource(getIt<DioClient>().dio));
    getIt.registerLazySingleton<EmployeeRepository>(() => EmployeeRepository(remoteDataSource: getIt()));
    getIt.registerLazySingleton(() => GetEmployeeList(getIt())); getIt.registerLazySingleton(() => GetEmployeeDetail(getIt()));
    getIt.registerLazySingleton(() => GetEmployeeFormOptions(getIt())); getIt.registerLazySingleton(() => CreateEmployee(getIt()));
    getIt.registerLazySingleton(() => UpdateEmployee(getIt())); getIt.registerLazySingleton(() => DeleteEmployee(getIt()));
    getIt.registerLazySingleton(() => CreateEmployeeUserAccount(getIt()));
    getIt.registerLazySingleton<EmployeeController>(() => EmployeeController(
      getEmployeeList: getIt(), getEmployeeDetail: getIt(), getFormOptions: getIt(),
      createEmployee: getIt(), updateEmployee: getIt(), deleteEmployee: getIt(),
      createUserAccount: getIt(),
    ));

    // ==================== HR LEAVE ALLOCATION ====================
    getIt.registerLazySingleton<LeaveAllocationRemoteDataSource>(() => LeaveAllocationRemoteDataSource(getIt<DioClient>().dio));
    getIt.registerLazySingleton<LeaveAllocationRepository>(() => LeaveAllocationRepository(remoteDataSource: getIt()));
    getIt.registerLazySingleton(() => GetLeaveAllocationList(getIt())); getIt.registerLazySingleton(() => GetLeaveAllocationDetail(getIt()));
    getIt.registerLazySingleton(() => GetLeaveAllocationFormOptions(getIt())); getIt.registerLazySingleton(() => CreateLeaveAllocation(getIt()));
    getIt.registerLazySingleton(() => UpdateLeaveAllocation(getIt())); getIt.registerLazySingleton(() => DeleteLeaveAllocation(getIt()));
    getIt.registerLazySingleton<LeaveAllocationController>(() => LeaveAllocationController(
      getList: getIt(), getDetail: getIt(), getFormOptions: getIt(),
      createAllocation: getIt(), updateAllocation: getIt(), deleteAllocation: getIt(),
    ));

    // ==================== ACCOUNTING COA ====================
    getIt.registerLazySingleton<CoaRemoteDataSource>(() => CoaRemoteDataSource(getIt<DioClient>().dio));
    getIt.registerLazySingleton<CoaRepository>(() => CoaRepository(remoteDataSource: getIt()));
    getIt.registerLazySingleton(() => GetCoaList(getIt())); getIt.registerLazySingleton(() => GetCoaDetail(getIt()));
    getIt.registerLazySingleton(() => GetCoaFormOptions(getIt())); getIt.registerLazySingleton(() => GetCoaAutonumber(getIt()));
    getIt.registerLazySingleton(() => CheckCoaChildren(getIt())); getIt.registerLazySingleton(() => CreateCoa(getIt()));
    getIt.registerLazySingleton(() => UpdateCoa(getIt())); getIt.registerLazySingleton(() => DeleteCoa(getIt()));
    getIt.registerLazySingleton<CoaController>(() => CoaController(
      getCoaList: getIt(), getCoaDetail: getIt(), getFormOptions: getIt(), getAutonumber: getIt(),
      checkChildren: getIt(), createCoa: getIt(), updateCoa: getIt(), deleteCoa: getIt(),
    ));

    // ==================== ACCOUNTING BANK ACCOUNT ====================
    getIt.registerLazySingleton<BankAccountRemoteDataSource>(() => BankAccountRemoteDataSource(getIt<DioClient>().dio));
    getIt.registerLazySingleton<BankAccountRepository>(() => BankAccountRepository(remoteDataSource: getIt()));
    getIt.registerLazySingleton(() => GetBankAccountList(getIt())); getIt.registerLazySingleton(() => GetBankAccountDetail(getIt()));
    getIt.registerLazySingleton(() => GetBankAccountFormOptions(getIt())); getIt.registerLazySingleton(() => CreateBankAccount(getIt()));
    getIt.registerLazySingleton(() => UpdateBankAccount(getIt())); getIt.registerLazySingleton(() => DeleteBankAccount(getIt()));
    getIt.registerLazySingleton<BankAccountController>(() => BankAccountController(
      getList: getIt(), getDetail: getIt(), getFormOptions: getIt(),
      createBankAccount: getIt(), updateBankAccount: getIt(), deleteBankAccount: getIt(),
    ));

    // ==================== MASTER PROJECT ====================
    getIt.registerLazySingleton<ProjectRemoteDataSource>(() => ProjectRemoteDataSource(getIt<DioClient>().dio));
    getIt.registerLazySingleton<ProjectRepository>(() => ProjectRepository(remoteDataSource: getIt()));
    getIt.registerLazySingleton(() => GetProjectList(getIt())); getIt.registerLazySingleton(() => GetProjectDetail(getIt()));
    getIt.registerLazySingleton(() => GetProjectFormOptions(getIt())); getIt.registerLazySingleton(() => CreateProject(getIt()));
    getIt.registerLazySingleton(() => UpdateProject(getIt())); getIt.registerLazySingleton(() => DeleteProject(getIt()));
    getIt.registerLazySingleton<ProjectController>(() => ProjectController(
      getProjectList: getIt(), getProjectDetail: getIt(), getFormOptions: getIt(),
      createProject: getIt(), updateProject: getIt(), deleteProject: getIt(),
    ));

    // ==================== SALES PRICE LIST ====================
    getIt.registerLazySingleton<PriceListRemoteDataSource>(() => PriceListRemoteDataSource(getIt<DioClient>().dio));
    getIt.registerLazySingleton<PriceListRepository>(() => PriceListRepository(remoteDataSource: getIt()));
    getIt.registerLazySingleton(() => GetPriceListList(getIt())); getIt.registerLazySingleton(() => GetPriceListDetail(getIt()));
    getIt.registerLazySingleton(() => GetPriceListProducts(getIt())); getIt.registerLazySingleton(() => CreatePriceList(getIt()));
    getIt.registerLazySingleton(() => UpdatePriceList(getIt())); getIt.registerLazySingleton(() => DeletePriceList(getIt()));
    getIt.registerLazySingleton<PriceListController>(() => PriceListController(
      getList: getIt(), getDetail: getIt(), getProducts: getIt(),
      createPriceList: getIt(), updatePriceList: getIt(), deletePriceList: getIt(),
    ));

    // ==================== MANUFACTURING WORKSTATION ====================
    getIt.registerLazySingleton<WorkstationRemoteDataSource>(() => WorkstationRemoteDataSource(getIt<DioClient>().dio));
    getIt.registerLazySingleton<WorkstationRepository>(() => WorkstationRepository(remoteDataSource: getIt()));
    getIt.registerLazySingleton(() => GetWorkstationList(getIt())); getIt.registerLazySingleton(() => GetWorkstationDetail(getIt()));
    getIt.registerLazySingleton(() => CreateWorkstation(getIt())); getIt.registerLazySingleton(() => UpdateWorkstation(getIt())); getIt.registerLazySingleton(() => DeleteWorkstation(getIt()));
    getIt.registerLazySingleton<WorkstationController>(() => WorkstationController(getList: getIt(), getDetail: getIt(), createWorkstation: getIt(), updateWorkstation: getIt(), deleteWorkstation: getIt()));

    // ==================== MANUFACTURING BOM ====================
    getIt.registerLazySingleton<BomRemoteDataSource>(() => BomRemoteDataSource(getIt<DioClient>().dio));
    getIt.registerLazySingleton<BomRepository>(() => BomRepository(remoteDataSource: getIt()));
    getIt.registerLazySingleton(() => GetBomList(getIt())); getIt.registerLazySingleton(() => GetBomDetail(getIt()));
    getIt.registerLazySingleton(() => GetBomFormOptions(getIt())); getIt.registerLazySingleton(() => CreateBom(getIt()));
    getIt.registerLazySingleton(() => UpdateBom(getIt())); getIt.registerLazySingleton(() => DeleteBom(getIt()));
    getIt.registerLazySingleton<BomController>(() => BomController(getBomList: getIt(), getBomDetail: getIt(), getFormOptions: getIt(), createBom: getIt(), updateBom: getIt(), deleteBom: getIt()));

    // ==================== MASTER UOM ====================
    getIt.registerLazySingleton<UomRemoteDataSource>(() => UomRemoteDataSource(getIt<DioClient>().dio));
    getIt.registerLazySingleton<UomRepository>(() => UomRepository(remoteDataSource: getIt()));
    getIt.registerLazySingleton(() => GetUomList(getIt())); getIt.registerLazySingleton(() => GetUomDetail(getIt()));
    getIt.registerLazySingleton(() => CreateUom(getIt())); getIt.registerLazySingleton(() => UpdateUom(getIt())); getIt.registerLazySingleton(() => DeleteUom(getIt()));
    getIt.registerLazySingleton(() => GetUomFormOptions(getIt()));
    getIt.registerLazySingleton<UomController>(() => UomController(getList: getIt(), getDetail: getIt(), getFormOptions: getIt(), createUom: getIt(), updateUom: getIt(), deleteUom: getIt()));

    // ==================== MASTER USER ====================
    getIt.registerLazySingleton<UserRemoteDataSource>(() => UserRemoteDataSource(getIt<DioClient>().dio));
    getIt.registerLazySingleton<UserRepository>(() => UserRepository(remoteDataSource: getIt()));
    getIt.registerLazySingleton(() => GetUserList(getIt())); getIt.registerLazySingleton(() => GetUserDetail(getIt()));
    getIt.registerLazySingleton(() => ToggleUserStatus(getIt())); getIt.registerLazySingleton(() => DeleteUser(getIt()));
    getIt.registerLazySingleton<UserController>(() => UserController(getUserList: getIt(), getUserDetail: getIt(), toggleUserStatus: getIt(), deleteUser: getIt()));

    // ==================== POS: STORE ====================
    getIt.registerLazySingleton<StoreRemoteDataSource>(() => StoreRemoteDataSource(getIt<DioClient>().dio));
    getIt.registerLazySingleton<StoreRepository>(() => StoreRepository(remoteDataSource: getIt()));
    getIt.registerLazySingleton(() => GetStoreList(getIt()));
    getIt.registerLazySingleton(() => GetStoreDetail(getIt()));
    getIt.registerLazySingleton(() => GetStoreOptions(getIt()));
    getIt.registerLazySingleton(() => CreateStore(getIt()));
    getIt.registerLazySingleton(() => UpdateStore(getIt()));
    getIt.registerLazySingleton(() => DeleteStore(getIt()));
    getIt.registerLazySingleton(() => SelectStore(getIt()));
    getIt.registerLazySingleton(() => VerifyStorePin(getIt()));
    getIt.registerLazySingleton<StoreController>(() => StoreController(
      getStoreList: getIt(), getStoreDetail: getIt(), getStoreOptions: getIt(),
      createStore: getIt(), updateStore: getIt(), deleteStore: getIt(),
      selectStore: getIt(), verifyStorePin: getIt(),
    ));

    // ==================== HR: OVERTIME TYPE ====================
    getIt.registerLazySingleton<OvertimeTypeRemoteDataSource>(() => OvertimeTypeRemoteDataSource(getIt<DioClient>().dio));
    getIt.registerLazySingleton<OvertimeTypeRepository>(() => OvertimeTypeRepository(ds: getIt()));
    getIt.registerLazySingleton(() => GetOvertimeTypeList(getIt())); getIt.registerLazySingleton(() => GetOvertimeTypeDetail(getIt()));
    getIt.registerLazySingleton(() => GetOvertimeTypeFormOptions(getIt())); getIt.registerLazySingleton(() => CreateOvertimeType(getIt()));
    getIt.registerLazySingleton(() => UpdateOvertimeType(getIt())); getIt.registerLazySingleton(() => DeleteOvertimeType(getIt()));
    getIt.registerLazySingleton<OvertimeTypeController>(() => OvertimeTypeController(getList: getIt(), getDetail: getIt(), getFormOptions: getIt(), createOT: getIt(), updateOT: getIt(), deleteOT: getIt()));

    // ==================== HR: LEAVE QUOTA ====================
    getIt.registerLazySingleton<LeaveQuotaRemoteDataSource>(() => LeaveQuotaRemoteDataSource(getIt<DioClient>().dio));
    getIt.registerLazySingleton<LeaveQuotaController>(() => LeaveQuotaController(ds: getIt()));

    // ==================== HR: LEAVE REQUEST ====================
    getIt.registerLazySingleton<LeaveRequestRemoteDataSource>(() => LeaveRequestRemoteDataSource(getIt<DioClient>().dio));
    getIt.registerLazySingleton<LeaveRequestRepository>(() => LeaveRequestRepository(remoteDataSource: getIt()));
    getIt.registerLazySingleton(() => GetLeaveRequestList(getIt()));
    getIt.registerLazySingleton(() => GetLeaveRequestDetail(getIt()));
    getIt.registerLazySingleton(() => GetLeaveRequestFormOptions(getIt()));
    getIt.registerLazySingleton(() => CreateLeaveRequest(getIt()));
    getIt.registerLazySingleton(() => UpdateLeaveRequest(getIt()));
    getIt.registerLazySingleton(() => DeleteLeaveRequest(getIt()));
    getIt.registerLazySingleton(() => ApproveLeaveRequest(getIt()));
    getIt.registerLazySingleton(() => RejectLeaveRequest(getIt()));
    getIt.registerLazySingleton<LeaveRequestController>(() => LeaveRequestController(
      getLeaveRequestList:        getIt(),
      getLeaveRequestDetail:      getIt(),
      getLeaveRequestFormOptions: getIt(),
      createLeaveRequest:         getIt(),
      updateLeaveRequest:         getIt(),
      deleteLeaveRequest:         getIt(),
      approveLeaveRequest:        getIt(),
      rejectLeaveRequest:         getIt(),
    ));

    // ==================== OVERTIME REQUEST ====================
    getIt.registerLazySingleton<OvertimeRequestRemoteDataSource>(() => OvertimeRequestRemoteDataSource(getIt<DioClient>().dio));
    getIt.registerLazySingleton<OvertimeRequestRepository>(() => OvertimeRequestRepository(ds: getIt()));
    getIt.registerLazySingleton(() => GetOvertimeRequestList(getIt()));
    getIt.registerLazySingleton(() => GetOvertimeRequestDetail(getIt()));
    getIt.registerLazySingleton(() => GetOvertimeRequestFormOptions(getIt()));
    getIt.registerLazySingleton(() => CreateOvertimeRequest(getIt()));
    getIt.registerLazySingleton(() => UpdateOvertimeRequest(getIt()));
    getIt.registerLazySingleton(() => DeleteOvertimeRequest(getIt()));
    getIt.registerLazySingleton(() => ApproveOvertimeRequest(getIt()));
    getIt.registerLazySingleton(() => RejectOvertimeRequest(getIt()));
    getIt.registerLazySingleton<OvertimeRequestController>(() => OvertimeRequestController(
      getList: getIt(), 
      getDetail: getIt(),
      getFormOptions: getIt(),
      createOT: getIt(), 
      updateOT: getIt(),
      deleteOT: getIt(),
      approveOT: getIt(), 
      rejectOT: getIt(),
    ));

    // ==================== QUOTATION ====================
    getIt.registerLazySingleton<QuotationRemoteDataSource>(() => QuotationRemoteDataSource(getIt<DioClient>().dio));
    getIt.registerLazySingleton<QuotationRepository>(() => QuotationRepository(ds: getIt()));
    getIt.registerLazySingleton(() => GetQuotationList(getIt()));
    getIt.registerLazySingleton(() => GetQuotationDetail(getIt()));
    getIt.registerLazySingleton(() => GetQuotationFormOptions(getIt()));
    getIt.registerLazySingleton(() => SaveQuotation(getIt()));
    getIt.registerLazySingleton(() => CancelQuotation(getIt()));
    getIt.registerLazySingleton(() => DeleteQuotation(getIt()));
    getIt.registerLazySingleton(() => CreateSalesOrderFromQuotation(getIt()));
    getIt.registerLazySingleton(() => GetProductsByLocation(getIt()));
    getIt.registerLazySingleton(() => GetPriceFromList(getIt()));
    getIt.registerLazySingleton(() => ApproveQuotation(getIt()));
    getIt.registerLazySingleton(() => RejectQuotation(getIt()));
    getIt.registerLazySingleton(() => GetQuotationSteps(getIt()));
    getIt.registerLazySingleton<QuotationController>(() => QuotationController(
      getList: getIt(), getDetail: getIt(), getFormOptions: getIt(),
      saveQ: getIt(), cancelQ: getIt(), deleteQ: getIt(),
      createSOUC: getIt(), getProductsByLocation: getIt(), getPriceFromList: getIt(),
      approveQ: getIt(), rejectQ: getIt(), getSteps: getIt(),
    ));

    // ==================== SALES ORDER ====================
    getIt.registerLazySingleton<SalesOrderRemoteDataSource>(() => SalesOrderRemoteDataSource(getIt<DioClient>().dio),);
    getIt.registerLazySingleton<SalesOrderRepository>(() => SalesOrderRepository(getIt()),);
    getIt.registerLazySingleton(() => GetSOList(getIt()));
    getIt.registerLazySingleton(() => GetSODetail(getIt()));
    getIt.registerLazySingleton(() => GetSOFormOptions(getIt()));
    getIt.registerLazySingleton(() => SaveSalesOrder(getIt()));
    getIt.registerLazySingleton(() => CancelSalesOrder(getIt()));
    getIt.registerLazySingleton(() => CloseSalesOrder(getIt()));
    getIt.registerLazySingleton(() => DeleteSalesOrder(getIt()));
    getIt.registerLazySingleton(() => CreateInvoiceFromSO(getIt()));
    getIt.registerLazySingleton(() => CreateInvoiceFromTerm(getIt()));
    getIt.registerLazySingleton(() => GetSOProductsByLocation(getIt()));
    getIt.registerLazySingleton(() => GetSOPriceFromList(getIt()));
    getIt.registerLazySingleton(() => ApproveSalesOrder(getIt()));
    getIt.registerLazySingleton(() => RejectSalesOrder(getIt()));
    getIt.registerLazySingleton(() => GetSOSteps(getIt()));
    getIt.registerLazySingleton<SalesOrderController>(
      () => SalesOrderController(
        getList:                getIt(),
        getDetail:              getIt(),
        getFormOptions:         getIt(),
        saveSO:                 getIt(),
        cancelSO:               getIt(),
        closeSO:                getIt(),
        deleteSO:               getIt(),
        createInvoiceUC:        getIt(),
        createInvoiceFromTermUC: getIt(),
        getProductsByLocation:  getIt(),
        getPriceFromList:       getIt(),
        approveSO:              getIt(),
        rejectSO:               getIt(),
        getSteps:               getIt(),
      ),
    );

    // ==================== DIRECT SALES ====================
    getIt.registerLazySingleton<DirectSalesRemoteDataSource>(() => DirectSalesRemoteDataSource(getIt<DioClient>().dio),);
    getIt.registerLazySingleton<DirectSalesRepository>(() => DirectSalesRepository(getIt()),);
    getIt.registerLazySingleton(() => GetDSList(getIt()));
    getIt.registerLazySingleton(() => GetDSDetail(getIt()));
    getIt.registerLazySingleton(() => GetDSFormOptions(getIt()));
    getIt.registerLazySingleton(() => SaveDirectSales(getIt()));
    getIt.registerLazySingleton(() => CancelDirectSales(getIt()));
    getIt.registerLazySingleton(() => DeleteDirectSales(getIt()));
    getIt.registerLazySingleton(() => CreateInvoiceFromDS(getIt()));
    getIt.registerLazySingleton(() => CreateInvoiceFromDSTerm(getIt()));
    getIt.registerLazySingleton(() => GetDSProductsByLocation(getIt()));
    getIt.registerLazySingleton(() => GetDSPriceFromList(getIt()));
    getIt.registerLazySingleton(() => ApproveDirectSales(getIt()));
    getIt.registerLazySingleton(() => RejectDirectSales(getIt()));
    getIt.registerLazySingleton(() => GetDSSteps(getIt()));
    getIt.registerLazySingleton<DirectSalesController>(
      () => DirectSalesController(
        getList:                 getIt(),
        getDetail:               getIt(),
        getFormOptions:          getIt(),
        saveDS:                  getIt(),
        cancelDS:                getIt(),
        deleteDS:                getIt(),
        createInvoiceUC:         getIt(),
        createInvoiceFromTermUC: getIt(),
        getProductsByLocation:   getIt(),
        getPriceFromList:        getIt(),
        approveDS:               getIt(),
        rejectDS:                getIt(),
        getSteps:                getIt(),
      ),
    );

    // ==================== INVOICE ====================
    getIt.registerLazySingleton<InvoiceRemoteDataSource>(() => InvoiceRemoteDataSource(getIt<DioClient>().dio),);
    getIt.registerLazySingleton<InvoiceRepository>(() => InvoiceRepository(getIt()),);
    getIt.registerLazySingleton(() => GetInvoiceList(getIt()));
    getIt.registerLazySingleton(() => GetInvoiceDetail(getIt()));
    getIt.registerLazySingleton(() => GetInvoiceFormOptions(getIt()));
    getIt.registerLazySingleton(() => SaveInvoice(getIt()));
    getIt.registerLazySingleton(() => CancelInvoice(getIt()));
    getIt.registerLazySingleton(() => DeleteInvoice(getIt()));
    getIt.registerLazySingleton(() => CreatePaymentFromInvoice(getIt()));
    getIt.registerLazySingleton(() => GetInvPriceFromList(getIt()));
    getIt.registerLazySingleton(() => ApproveInvoice(getIt()));
    getIt.registerLazySingleton(() => RejectInvoice(getIt()));
    getIt.registerLazySingleton(() => GetInvoiceSteps(getIt()));
    getIt.registerLazySingleton<InvoiceController>(
      () => InvoiceController(
        getList:                 getIt(),
        getDetail:               getIt(),
        getFormOptions:          getIt(),
        saveInv:                  getIt(),
        cancelInv:                getIt(),
        deleteInv:                getIt(),
        createPaymentUC:         getIt(),
        getPriceFromList:        getIt(),
        approveInv:               getIt(),
        rejectInv:                getIt(),
        getSteps:                getIt(),
      ),
    );

    // ==================== SERVICE QUOTATION ====================
    getIt.registerLazySingleton<ServiceQuotationRemoteDataSource>(() => ServiceQuotationRemoteDataSource(getIt<DioClient>().dio));
    getIt.registerLazySingleton<ServiceQuotationRepository>(() => ServiceQuotationRepository(getIt()),);
    getIt.registerLazySingleton(() => GetSQList(getIt()));
    getIt.registerLazySingleton(() => GetSQDetail(getIt()));
    getIt.registerLazySingleton(() => GetSQFormOptions(getIt()));
    getIt.registerLazySingleton(() => SaveServiceQuotation(getIt()));
    getIt.registerLazySingleton(() => CancelServiceQuotation(getIt()));
    getIt.registerLazySingleton(() => DeleteServiceQuotation(getIt()));
    getIt.registerLazySingleton(() => CreateSSOFromSQ(getIt()));
    getIt.registerLazySingleton(() => GetSQPriceFromList(getIt()));
    getIt.registerLazySingleton(() => ApproveSQ(getIt()));
    getIt.registerLazySingleton(() => RejectSQ(getIt()));
    getIt.registerLazySingleton(() => GetSQSteps(getIt()));
    getIt.registerLazySingleton<ServiceQuotationController>(() => ServiceQuotationController(
      getList: getIt(), getDetail: getIt(), getFormOptions: getIt(),
      saveQ: getIt(), cancelQ: getIt(), deleteQ: getIt(),
      createSSOUC: getIt(), getPriceFromList: getIt(),
      approveQ: getIt(), rejectQ: getIt(), getSteps: getIt(),
    ));

    // ==================== SERVICE SALES ORDER ====================
    getIt.registerLazySingleton<ServiceSalesOrderRemoteDataSource>(() => ServiceSalesOrderRemoteDataSource(getIt<DioClient>().dio),);
    getIt.registerLazySingleton<ServiceSalesOrderRepository>(() => ServiceSalesOrderRepository(getIt()),);
    getIt.registerLazySingleton(() => GetSSOList(getIt()));
    getIt.registerLazySingleton(() => GetSSODetail(getIt()));
    getIt.registerLazySingleton(() => GetSSOFormOptions(getIt()));
    getIt.registerLazySingleton(() => SaveServiceSalesOrder(getIt()));
    getIt.registerLazySingleton(() => CancelServiceSalesOrder(getIt()));
    getIt.registerLazySingleton(() => CloseServiceSalesOrder(getIt()));
    getIt.registerLazySingleton(() => DeleteServiceSalesOrder(getIt()));
    getIt.registerLazySingleton(() => CreateInvoiceFromSSO(getIt()));
    getIt.registerLazySingleton(() => CreateInvoiceFromSSOTerm(getIt()));
    getIt.registerLazySingleton(() => GetSSOPriceFromList(getIt()));
    getIt.registerLazySingleton(() => ApproveSSO(getIt()));
    getIt.registerLazySingleton(() => RejectSSO(getIt()));
    getIt.registerLazySingleton(() => GetSSOSteps(getIt()));
    getIt.registerLazySingleton<ServiceSalesOrderController>(
      () => ServiceSalesOrderController(
        getList:                getIt(),
        getDetail:              getIt(),
        getFormOptions:         getIt(),
        saveSSO:                 getIt(),
        cancelSSO:               getIt(),
        closeSSO:                getIt(),
        deleteSSO:               getIt(),
        createInvoiceUC:        getIt(),
        createInvoiceFromTermUC: getIt(),
        getPriceFromList:       getIt(),
        approveSSO:              getIt(),
        rejectSSO:               getIt(),
        getSteps:               getIt(),
      ),
    );

    // ==================== SERVICE DIRECT SALES ====================
    getIt.registerLazySingleton<ServiceDirectSalesRemoteDataSource>(() => ServiceDirectSalesRemoteDataSource(getIt<DioClient>().dio));
    getIt.registerLazySingleton<ServiceDirectSalesRepository>(() => ServiceDirectSalesRepository(getIt()),);
    getIt.registerLazySingleton(() => GetSDSList(getIt()));
    getIt.registerLazySingleton(() => GetSDSDetail(getIt()));
    getIt.registerLazySingleton(() => GetSDSFormOptions(getIt()));
    getIt.registerLazySingleton(() => SaveServiceDirectSales(getIt()));
    getIt.registerLazySingleton(() => CancelServiceDirectSales(getIt()));
    getIt.registerLazySingleton(() => DeleteServiceDirectSales(getIt()));
    getIt.registerLazySingleton(() => CreateInvoiceFromSDSTerm(getIt()));
    getIt.registerLazySingleton(() => GetSDSPriceFromList(getIt()));
    getIt.registerLazySingleton<ServiceDirectSalesController>(
      () => ServiceDirectSalesController(
        getList: getIt(),
        getDetail: getIt(),
        getFormOptions: getIt(),
        saveSDS: getIt(),
        cancelSDS: getIt(),
        deleteSDS: getIt(),
        createInvoiceFromTermUC: getIt(),
        getPriceFromList: getIt(),
      ),
    );

    // ==================== SERVICE INVOICE ====================
    getIt.registerLazySingleton<ServiceInvoiceRemoteDataSource>(() => ServiceInvoiceRemoteDataSource(getIt<DioClient>().dio),);
    getIt.registerLazySingleton<ServiceInvoiceRepository>(() => ServiceInvoiceRepository(getIt()),);
    getIt.registerLazySingleton(() => GetServiceInvoiceList(getIt()));
    getIt.registerLazySingleton(() => GetServiceInvoiceDetail(getIt()));
    getIt.registerLazySingleton(() => GetServiceInvoiceFormOptions(getIt()));
    getIt.registerLazySingleton(() => SaveServiceInvoice(getIt()));
    getIt.registerLazySingleton(() => CancelServiceInvoice(getIt()));
    getIt.registerLazySingleton(() => DeleteServiceInvoice(getIt()));
    getIt.registerLazySingleton(() => CreateServiceInvoicePayment(getIt()));
    getIt.registerLazySingleton(() => GetServiceInvoicePriceFromList(getIt()));
    getIt.registerLazySingleton(() => ApproveServiceInvoice(getIt()));
    getIt.registerLazySingleton(() => RejectServiceInvoice(getIt()));
    getIt.registerLazySingleton(() => GetServiceInvoiceSteps(getIt()));
    getIt.registerLazySingleton<ServiceInvoiceController>(
      () => ServiceInvoiceController(
        getList:                 getIt(),
        getDetail:               getIt(),
        getFormOptions:          getIt(),
        saveInv:                  getIt(),
        cancelInv:                getIt(),
        deleteInv:                getIt(),
        createPaymentUC:         getIt(),
        getPriceFromList:        getIt(),
        approveInv:               getIt(),
        rejectInv:                getIt(),
        getSteps:                getIt(),
      ),
    );

    // ==================== PURCHASE REQUEST ====================
    getIt.registerLazySingleton<PurchaseRequestRemoteDataSource>(() => PurchaseRequestRemoteDataSource(getIt<DioClient>().dio),);
    getIt.registerLazySingleton<PurchaseRequestRepository>(() => PurchaseRequestRepository(getIt()),);
    getIt.registerLazySingleton(() => GetPRList(getIt()));
    getIt.registerLazySingleton(() => GetPRDetail(getIt()));
    getIt.registerLazySingleton(() => GetPRFormOptions(getIt()));
    getIt.registerLazySingleton(() => SavePurchaseRequest(getIt()));
    getIt.registerLazySingleton(() => CancelPurchaseRequest(getIt()));
    getIt.registerLazySingleton(() => DeletePurchaseRequest(getIt()));
    getIt.registerLazySingleton(() => CreateRfqFromPR(getIt()));
    getIt.registerLazySingleton(() => CreateDpFromPR(getIt()));
    getIt.registerLazySingleton(() => ApprovePurchaseRequest(getIt()));
    getIt.registerLazySingleton(() => RejectPurchaseRequest(getIt()));
    getIt.registerLazySingleton(() => GetPRSteps(getIt()));
    getIt.registerLazySingleton<PurchaseRequestController>(
      () => PurchaseRequestController(
        getList:                 getIt(),
        getDetail:               getIt(),
        getFormOptions:          getIt(),
        savePR:                  getIt(),
        cancelPR:                getIt(),
        deletePR:                getIt(),
        createRfqUC:             getIt(),
        createDpUC:              getIt(),
        approvePR:               getIt(),
        rejectPR:                getIt(),
        getSteps:                getIt(),
      ),
    );

    // ==================== RFQ ====================
    getIt.registerLazySingleton<RfqRemoteDataSource>(() => RfqRemoteDataSource(getIt<DioClient>().dio),);
    getIt.registerLazySingleton<RfqRepository>(() => RfqRepository(getIt()),);
    getIt.registerLazySingleton(() => GetRfqList(getIt()));
    getIt.registerLazySingleton(() => GetRfqDetail(getIt()));
    getIt.registerLazySingleton(() => GetRfqFormOptions(getIt()));
    getIt.registerLazySingleton(() => GetRfqPriceFromList(getIt()));
    getIt.registerLazySingleton(() => GetRfqLocationsByWarehouse(getIt()));
    getIt.registerLazySingleton(() => SaveRfq(getIt()));
    getIt.registerLazySingleton(() => CancelRfq(getIt()));
    getIt.registerLazySingleton(() => DeleteRfq(getIt()));
    getIt.registerLazySingleton(() => CreatePOFromRfq(getIt()));
    getIt.registerLazySingleton(() => ApproveRfq(getIt()));
    getIt.registerLazySingleton(() => RejectRfq(getIt()));
    getIt.registerLazySingleton(() => GetRfqSteps(getIt()));
    getIt.registerLazySingleton<RfqController>(
      () => RfqController(
        getList:                 getIt(),
        getDetail:               getIt(),
        getFormOptions:          getIt(),
        getPriceFromList:        getIt(),
        getLocationsByWarehouse: getIt(),
        saveRfq:                 getIt(),
        cancelRfq:               getIt(),
        deleteRfq:               getIt(),
        createPOUC:              getIt(),
        approveRfq:              getIt(),
        rejectRfq:               getIt(),
        getSteps:                getIt(),
      ),
    );

    // ==================== DIRECT PURCHASE ====================
    getIt.registerLazySingleton<DirectPurchaseRemoteDataSource>(() => DirectPurchaseRemoteDataSource(getIt<DioClient>().dio),);
    getIt.registerLazySingleton<DirectPurchaseRepository>(() => DirectPurchaseRepository(getIt()),);
    getIt.registerLazySingleton(() => GetDirectPurchaseList(getIt()));
    getIt.registerLazySingleton(() => GetDirectPurchaseDetail(getIt()));
    getIt.registerLazySingleton(() => GetDirectPurchaseFormOptions(getIt()));
    getIt.registerLazySingleton(() => GetDirectPurchasePriceFromList(getIt()));
    getIt.registerLazySingleton(() => SaveDirectPurchase(getIt()));
    getIt.registerLazySingleton(() => CancelDirectPurchase(getIt()));
    getIt.registerLazySingleton(() => DeleteDirectPurchase(getIt()));
    getIt.registerLazySingleton(() => ApproveDirectPurchase(getIt()));
    getIt.registerLazySingleton(() => RejectDirectPurchase(getIt()));
    getIt.registerLazySingleton(() => CloseDirectPurchase(getIt()));
    getIt.registerLazySingleton(() => GetDirectPurchaseSteps(getIt()));
    getIt.registerLazySingleton<DirectPurchaseController>(
      () => DirectPurchaseController(
        getList:                 getIt(),
        getDetail:               getIt(),
        getFormOptions:          getIt(),
        getPriceFromList:        getIt(),
        saveDirectPurchase:      getIt(),
        cancelDirectPurchase:    getIt(),
        deleteDirectPurchase:    getIt(),
        approveDirectPurchase:   getIt(),
        rejectDirectPurchase:    getIt(),
        closeDirectPurchase:     getIt(),
        getSteps:                getIt(),
      ),
    );

    // ==================== PURCHASE ORDER ====================
    getIt.registerLazySingleton<PurchaseOrderRemoteDataSource>(() => PurchaseOrderRemoteDataSource(getIt<DioClient>().dio),);
    getIt.registerLazySingleton<PurchaseOrderRepository>(() => PurchaseOrderRepository(getIt()),);
    getIt.registerLazySingleton(() => GetPOList(getIt()));
    getIt.registerLazySingleton(() => GetPODetail(getIt()));
    getIt.registerLazySingleton(() => GetPOFormOptions(getIt()));
    getIt.registerLazySingleton(() => GetPOPriceFromList(getIt()));
    getIt.registerLazySingleton(() => GetPOLastPrices(getIt()));
    getIt.registerLazySingleton(() => SavePurchaseOrder(getIt()));
    getIt.registerLazySingleton(() => CancelPurchaseOrder(getIt()));
    getIt.registerLazySingleton(() => DeletePurchaseOrder(getIt()));
    getIt.registerLazySingleton(() => CreateBillFromPO(getIt()));
    getIt.registerLazySingleton(() => CreateBillFromTerm(getIt()));
    getIt.registerLazySingleton(() => ApprovePurchaseOrder(getIt()));
    getIt.registerLazySingleton(() => RejectPurchaseOrder(getIt()));
    getIt.registerLazySingleton(() => ClosePurchaseOrder(getIt()));
    getIt.registerLazySingleton(() => GetPOSteps(getIt()));
    getIt.registerLazySingleton<PurchaseOrderController>(
      () => PurchaseOrderController(
        getList:                 getIt(),
        getDetail:               getIt(),
        getFormOptions:          getIt(),
        getPriceFromList:        getIt(),
        getLastPricesUC:         getIt(),
        savePO:                  getIt(),
        cancelPO:                getIt(),
        deletePO:                getIt(),
        createBillUC:            getIt(),
        createBillFromTermUC:    getIt(),
        approvePO:               getIt(),
        rejectPO:                getIt(),
        closePO:                 getIt(),
        getSteps:                getIt(),
      ),
    );

    // ==================== BILL ====================
    getIt.registerLazySingleton<BillRemoteDataSource>(() => BillRemoteDataSource(getIt<DioClient>().dio),);
    getIt.registerLazySingleton<BillRepository>(() => BillRepository(getIt()),);
    getIt.registerLazySingleton(() => GetBillList(getIt()));
    getIt.registerLazySingleton(() => GetBillDetail(getIt()));
    getIt.registerLazySingleton(() => GetBillFormOptions(getIt()));
    getIt.registerLazySingleton(() => SaveBill(getIt()));
    getIt.registerLazySingleton(() => CancelBill(getIt()));
    getIt.registerLazySingleton(() => DeleteBill(getIt()));
    getIt.registerLazySingleton(() => CreateBillPayment(getIt()));
    getIt.registerLazySingleton(() => GetBillPriceFromList(getIt()));
    getIt.registerLazySingleton(() => ApproveBill(getIt()));
    getIt.registerLazySingleton(() => RejectBill(getIt()));
    getIt.registerLazySingleton(() => GetBillSteps(getIt()));
    getIt.registerLazySingleton<BillController>(
      () => BillController(
        getList:                 getIt(),
        getDetail:               getIt(),
        getFormOptions:          getIt(),
        saveBill:                  getIt(),
        cancelBill:                getIt(),
        deleteBill:                getIt(),
        createPaymentUC:         getIt(),
        getPriceFromList:        getIt(),
        approveBill:               getIt(),
        rejectBill:                getIt(),
        getSteps:                getIt(),
      ),
    );

    // ==================== RECEIPT NOTE ====================
    getIt.registerLazySingleton<ReceiptNoteRemoteDataSource>(() => ReceiptNoteRemoteDataSource(getIt<DioClient>().dio),);
    getIt.registerLazySingleton<ReceiptNoteRepository>(() => ReceiptNoteRepository(getIt()),);
    getIt.registerLazySingleton(() => GetRNList(getIt()));
    getIt.registerLazySingleton(() => GetRNDetail(getIt()));
    getIt.registerLazySingleton(() => GetRNFormOptions(getIt()));
    getIt.registerLazySingleton(() => GetRNInventorySettings(getIt()));
    getIt.registerLazySingleton(() => SaveReceiptNote(getIt()));
    getIt.registerLazySingleton(() => ConfirmReceiptNote(getIt()));
    getIt.registerLazySingleton(() => ValidateReceiptNote(getIt()));
    getIt.registerLazySingleton(() => CreateReturnFromReceiptNote(getIt()));
    getIt.registerLazySingleton(() => SaveReceiptNoteTracking(getIt()));
    getIt.registerLazySingleton(() => CancelReceiptNote(getIt()));
    getIt.registerLazySingleton(() => DeleteReceiptNote(getIt()));
    getIt.registerLazySingleton(() => ApproveReceiptNote(getIt()));
    getIt.registerLazySingleton(() => RejectReceiptNote(getIt()));
    getIt.registerLazySingleton(() => GetRNSteps(getIt()));
    getIt.registerLazySingleton<ReceiptNoteController>(
      () => ReceiptNoteController(
        getList:                 getIt(),
        getDetail:               getIt(),
        getFormOptions:          getIt(),
        getInventorySettings:    getIt(),
        saveRN:                  getIt(),
        confirmRN:               getIt(),
        validateRN:              getIt(),
        createReturnUC:          getIt(),
        saveTrackingUC:          getIt(),
        cancelRN:                getIt(),
        deleteRN:                getIt(),
        approveRN:               getIt(),
        rejectRN:                getIt(),
        getSteps:                getIt(),
      ),
    );

    // ==================== DELIVERY NOTE ====================
    getIt.registerLazySingleton<DeliveryNoteRemoteDataSource>(() => DeliveryNoteRemoteDataSource(getIt<DioClient>().dio),);
    getIt.registerLazySingleton<DeliveryNoteRepository>(() => DeliveryNoteRepository(getIt()),);
    getIt.registerLazySingleton(() => GetDNList(getIt()));
    getIt.registerLazySingleton(() => GetDNDetail(getIt()));
    getIt.registerLazySingleton(() => GetDNFormOptions(getIt()));
    getIt.registerLazySingleton(() => GetDNProductsByLocation(getIt()));
    getIt.registerLazySingleton(() => CheckDNStock(getIt()));
    getIt.registerLazySingleton(() => GetDNLotSerialsSorted(getIt()));
    getIt.registerLazySingleton(() => SaveDeliveryNote(getIt()));
    getIt.registerLazySingleton(() => ConfirmDeliveryNote(getIt()));
    getIt.registerLazySingleton(() => ValidateDeliveryNote(getIt()));
    getIt.registerLazySingleton(() => CreateReturnFromDeliveryNote(getIt()));
    getIt.registerLazySingleton(() => SaveDNTracking(getIt()));
    getIt.registerLazySingleton(() => CancelDeliveryNote(getIt()));
    getIt.registerLazySingleton(() => DeleteDeliveryNote(getIt()));
    getIt.registerLazySingleton(() => ApproveDeliveryNote(getIt()));
    getIt.registerLazySingleton(() => RejectDeliveryNote(getIt()));
    getIt.registerLazySingleton(() => GetDNSteps(getIt()));
    getIt.registerLazySingleton<DeliveryNoteController>(
      () => DeliveryNoteController(
        getList:                 getIt(),
        getDetail:               getIt(),
        getFormOptions:          getIt(),
        getProductsByLocation:   getIt(),
        getLotSerialsSortedUC:   getIt(),
        checkStockUC:            getIt(),
        saveDN:                  getIt(),
        confirmDN:               getIt(),
        validateDN:              getIt(),
        createReturnUC:          getIt(),
        saveTrackingUC:          getIt(),
        cancelDN:                getIt(),
        deleteDN:                getIt(),
        approveDN:               getIt(),
        rejectDN:                getIt(),
        getSteps:                getIt(),
      ),
    );

    // ==================== INTERNAL TRANSFER ====================
    getIt.registerLazySingleton<InternalTransferRemoteDataSource>(() => InternalTransferRemoteDataSource(getIt<DioClient>().dio),);
    getIt.registerLazySingleton<InternalTransferRepository>(() => InternalTransferRepository(getIt()),);
    getIt.registerLazySingleton(() => GetITList(getIt()));
    getIt.registerLazySingleton(() => GetITDetail(getIt()));
    getIt.registerLazySingleton(() => GetITFormOptions(getIt()));
    getIt.registerLazySingleton(() => GetITProductsByLocation(getIt()));
    getIt.registerLazySingleton(() => CheckITStock(getIt()));
    getIt.registerLazySingleton(() => GetITLotSerialsSorted(getIt()));
    getIt.registerLazySingleton(() => SaveInternalTransfer(getIt()));
    getIt.registerLazySingleton(() => ConfirmInternalTransfer(getIt()));
    getIt.registerLazySingleton(() => ValidateInternalTransfer(getIt()));
    getIt.registerLazySingleton(() => SaveITTracking(getIt()));
    getIt.registerLazySingleton(() => CancelInternalTransfer(getIt()));
    getIt.registerLazySingleton(() => DeleteInternalTransfer(getIt()));
    getIt.registerLazySingleton(() => ApproveInternalTransfer(getIt()));
    getIt.registerLazySingleton(() => RejectInternalTransfer(getIt()));
    getIt.registerLazySingleton(() => GetITSteps(getIt()));
    getIt.registerLazySingleton<InternalTransferController>(
      () => InternalTransferController(
        getList:                 getIt(),
        getDetail:               getIt(),
        getFormOptions:          getIt(),
        getProductsByLocation:   getIt(),
        getLotSerialsSortedUC:   getIt(),
        checkStockUC:            getIt(),
        saveIT:                  getIt(),
        confirmIT:               getIt(),
        validateIT:              getIt(),
        saveTrackingUC:          getIt(),
        cancelIT:                getIt(),
        deleteIT:                getIt(),
        approveIT:               getIt(),
        rejectIT:                getIt(),
        getSteps:                getIt(),
      ),
    );
    
    // ==================== TRANSFER OUT ====================
    getIt.registerLazySingleton<TransferOutRemoteDataSource>(() => TransferOutRemoteDataSource(getIt<DioClient>().dio));
    getIt.registerLazySingleton<TransferOutRepository>(() => TransferOutRepository(getIt()));
    getIt.registerLazySingleton(() => GetTOList(getIt()));
    getIt.registerLazySingleton(() => GetTODetail(getIt()));
    getIt.registerLazySingleton(() => SaveTransferOut(getIt()));
    getIt.registerLazySingleton(() => ValidateTransferOut(getIt()));
    getIt.registerLazySingleton<TransferOutController>(
      () => TransferOutController(
        getList:    getIt(),
        getDetail:  getIt(),
        saveTO:     getIt(),
        validateTO: getIt(),
      ),
    );

    // ==================== TRANSFER IN ====================
    getIt.registerLazySingleton<TransferInRemoteDataSource>(() => TransferInRemoteDataSource(getIt<DioClient>().dio));
    getIt.registerLazySingleton<TransferInRepository>(() => TransferInRepository(getIt()));
    getIt.registerLazySingleton(() => GetTIList(getIt()));
    getIt.registerLazySingleton(() => GetTIDetail(getIt()));
    getIt.registerLazySingleton(() => SaveTransferIn(getIt()));
    getIt.registerLazySingleton(() => ValidateTransferIn(getIt()));
    getIt.registerLazySingleton<TransferInController>(
      () => TransferInController(
        getList:    getIt(),
        getDetail:  getIt(),
        saveTI:     getIt(),
        validateTI: getIt(),
      ),
    );

    // ==================== SCRAP ORDER ====================
    getIt.registerLazySingleton<ScrapOrderRemoteDataSource>(() => ScrapOrderRemoteDataSource(getIt<DioClient>().dio));
    getIt.registerLazySingleton<ScrapOrderRepository>(() => ScrapOrderRepository(getIt()));
    getIt.registerLazySingleton(() => GetScrapOrderList(getIt()));
    getIt.registerLazySingleton(() => GetScrapOrderDetail(getIt()));
    getIt.registerLazySingleton(() => GetScrapOrderFormOptions(getIt()));
    getIt.registerLazySingleton(() => GetScrapOrderProductsByLocation(getIt()));
    getIt.registerLazySingleton(() => CheckScrapOrderStock(getIt()));
    getIt.registerLazySingleton(() => SaveScrapOrder(getIt()));
    getIt.registerLazySingleton(() => ConfirmScrapOrder(getIt()));
    getIt.registerLazySingleton(() => ValidateScrapOrder(getIt()));
    getIt.registerLazySingleton(() => CancelScrapOrder(getIt()));
    getIt.registerLazySingleton(() => DeleteScrapOrder(getIt()));
    getIt.registerLazySingleton(() => ApproveScrapOrder(getIt()));
    getIt.registerLazySingleton(() => RejectScrapOrder(getIt()));
    getIt.registerLazySingleton(() => GetScrapOrderSteps(getIt()));
    getIt.registerLazySingleton<ScrapOrderController>(
      () => ScrapOrderController(
        getList:               getIt(),
        getDetail:             getIt(),
        getFormOptions:        getIt(),
        getProductsByLocation: getIt(),
        checkStockUC:          getIt(),
        saveSO:                getIt(),
        confirmSO:             getIt(),
        validateSO:            getIt(),
        cancelSO:              getIt(),
        deleteSO:              getIt(),
        approveSO:             getIt(),
        rejectSO:              getIt(),
        getSteps:              getIt(),
      ),
    );

    // ==================== STOCK COUNT ====================
    getIt.registerLazySingleton<StockCountRemoteDataSource>(() => StockCountRemoteDataSource(getIt<DioClient>().dio));
    getIt.registerLazySingleton<StockCountRepository>(() => StockCountRepository(getIt()));
    getIt.registerLazySingleton(() => GetSCList(getIt()));
    getIt.registerLazySingleton(() => GetSCDetail(getIt()));
    getIt.registerLazySingleton(() => GetSCFormOptions(getIt()));
    getIt.registerLazySingleton(() => CreateStockCount(getIt()));
    getIt.registerLazySingleton(() => UpdateStockCountHeader(getIt()));
    getIt.registerLazySingleton(() => ConfirmStockCount(getIt()));
    getIt.registerLazySingleton(() => ValidateStockCount(getIt()));
    getIt.registerLazySingleton(() => CancelStockCount(getIt()));
    getIt.registerLazySingleton(() => DeleteStockCount(getIt()));
    getIt.registerLazySingleton(() => StoreLocationCount(getIt()));
    getIt.registerLazySingleton(() => LoadSCProducts(getIt()));
    getIt.registerLazySingleton(() => GetSCLocationsByWarehouse(getIt()));
    getIt.registerLazySingleton(() => GetSCIndexLocation(getIt()));
    getIt.registerLazySingleton(() => GetSCSteps(getIt()));
    getIt.registerLazySingleton(() => ApproveStockCount(getIt()));
    getIt.registerLazySingleton(() => RejectStockCount(getIt()));
    getIt.registerLazySingleton<StockCountController>(
      () => StockCountController(
        getList:                 getIt(),
        getDetail:               getIt(),
        getFormOptions:          getIt(),
        createSC:                getIt(),
        updateHeader:            getIt(),
        confirmSC:               getIt(),
        validateSC:              getIt(),
        cancelSC:                getIt(),
        deleteSC:                getIt(),
        storeLocationCount:      getIt(),
        loadProducts:            getIt(),
        getLocationsByWarehouse: getIt(),
        getIndexLocation:        getIt(),
        getSteps:                getIt(),
        approveSC:               getIt(),
        rejectSC:                getIt(),
      ),
    );
  }
}