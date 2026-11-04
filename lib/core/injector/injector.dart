import 'package:get_it/get_it.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../network/dio_client.dart';

// -- Auth
import 'package:erp_mobile_cnplus/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:erp_mobile_cnplus/features/auth/data/repositories/auth_repository.dart';
import 'package:erp_mobile_cnplus/features/auth/domain/usecases/login_usecase.dart';
import 'package:erp_mobile_cnplus/features/auth/presentation/controllers/auth_controller.dart';

// -- Profile
import 'package:erp_mobile_cnplus/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/profile/data/repositories/profile_repository.dart';
import 'package:erp_mobile_cnplus/features/profile/domain/usecases/get_profile.dart';
import 'package:erp_mobile_cnplus/features/profile/domain/usecases/logout.dart';
import 'package:erp_mobile_cnplus/features/profile/presentation/controllers/profile_controller.dart';

// -- Modul
import 'package:erp_mobile_cnplus/features/modul/presentation/controllers/modul_controller.dart';

// -- General Dashboard
import 'package:erp_mobile_cnplus/features/general_dashboard/data/datasources/general_dashboard_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/general_dashboard/data/repositories/general_dashboard_repository.dart';
import 'package:erp_mobile_cnplus/features/general_dashboard/domain/usecases/general_dashboard_usecases.dart';
import 'package:erp_mobile_cnplus/features/general_dashboard/presentation/controllers/general_dashboard_controller.dart';

// DASHBOARD
// -- Inventory Dashboard
import 'package:erp_mobile_cnplus/features/inventory/dashboard/data/datasources/inventory_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/inventory/dashboard/data/repositories/inventory_dashboard_repository.dart';
import 'package:erp_mobile_cnplus/features/inventory/dashboard/domain/usecases/inventory_dashboard_usecase.dart';
import 'package:erp_mobile_cnplus/features/inventory/dashboard/presentation/controllers/inventory_dashboard_controller.dart';

// -- Purchase Dashboard
import 'package:erp_mobile_cnplus/features/purchase/dashboard/data/datasources/purchase_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/purchase/dashboard/data/repositories/purchase_remote_repositories.dart';
import 'package:erp_mobile_cnplus/features/purchase/dashboard/domain/usecases/get_purchase_dashboard_data.dart';
import 'package:erp_mobile_cnplus/features/purchase/dashboard/presentation/controllers/purchase_dashboard_controller.dart';

// -- Sales Dashboard
import 'package:erp_mobile_cnplus/features/sales/dashboard/data/datasources/sales_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/sales/dashboard/data/repositories/sales_dashboard_repository.dart';
import 'package:erp_mobile_cnplus/features/sales/dashboard/domain/usecases/get_sales_dashboard_data.dart';
import 'package:erp_mobile_cnplus/features/sales/dashboard/presentation/controllers/sales_dashboard_controller.dart';

// -- HR Dashboard
import 'package:erp_mobile_cnplus/features/hr/dashboard/data/datasources/hr_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/hr/dashboard/data/repositories/hr_dashboard_repository.dart';
import 'package:erp_mobile_cnplus/features/hr/dashboard/domain/usecases/hr_dashboard_usecases.dart';
import 'package:erp_mobile_cnplus/features/hr/dashboard/presentation/controllers/hr_dashboard_controller.dart';

// -- Accounting Dashboard
import 'package:erp_mobile_cnplus/features/accounting/dashboard/data/datasources/accounting_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/accounting/dashboard/data/repositories/accounting_remote_repositories.dart';
import 'package:erp_mobile_cnplus/features/accounting/dashboard/domain/usecases/get_accounting_dashboard.dart';
import 'package:erp_mobile_cnplus/features/accounting/dashboard/presentation/controllers/accounting_dashboard_controller.dart';

// -- Manufacturing Dashboard
import 'package:erp_mobile_cnplus/features/manufacturing/dashboard/data/datasources/manufacturing_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/manufacturing/dashboard/data/repositories/manufacturing_dashboard_repository.dart';
import 'package:erp_mobile_cnplus/features/manufacturing/dashboard/domain/usecases/manufacturing_dashboard_usecases.dart';
import 'package:erp_mobile_cnplus/features/manufacturing/dashboard/presentation/controllers/manufacturing_dashboard_controller.dart';

// -- CRM Dashboard
import 'package:erp_mobile_cnplus/features/crm/dashboard/data/datasources/crm_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/crm/dashboard/data/repositories/crm_dashboard_repository.dart';
import 'package:erp_mobile_cnplus/features/crm/dashboard/domain/usecases/crm_dashboard_usecases.dart';
import 'package:erp_mobile_cnplus/features/crm/dashboard/presentation/controllers/crm_dashboard_controller.dart';

// -- POS Dashboard
import 'package:erp_mobile_cnplus/features/pos/dashboard/data/datasources/pos_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/pos/dashboard/data/repositories/pos_dashboard_repository.dart';
import 'package:erp_mobile_cnplus/features/pos/dashboard/domain/usecases/pos_dashboard_usecases.dart';
import 'package:erp_mobile_cnplus/features/pos/dashboard/presentation/controllers/pos_dashboard_controller.dart';

// MASTER DATA
// -- Product
import 'package:erp_mobile_cnplus/features/master/product/data/datasources/product_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/master/product/data/repositories/product_repository.dart';
import 'package:erp_mobile_cnplus/features/master/product/domain/usecases/product_usecases.dart';
import 'package:erp_mobile_cnplus/features/master/product/presentation/controllers/product_controller.dart';

// -- Brand
import 'package:erp_mobile_cnplus/features/master/brand/data/datasources/brand_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/master/brand/data/repositories/brand_repository.dart';
import 'package:erp_mobile_cnplus/features/master/brand/domain/usecases/brand_usecases.dart';
import 'package:erp_mobile_cnplus/features/master/brand/presentation/controllers/brand_controller.dart';

// -- Product Category
import 'package:erp_mobile_cnplus/features/master/product_category/data/datasources/product_category_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/master/product_category/data/repositories/product_category_repository.dart';
import 'package:erp_mobile_cnplus/features/master/product_category/domain/usecases/product_category_usecases.dart';
import 'package:erp_mobile_cnplus/features/master/product_category/presentation/controllers/product_category_controller.dart';

// -- Product Type
import 'package:erp_mobile_cnplus/features/master/product_type/data/datasources/product_type_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/master/product_type/data/repositories/product_type_repository.dart';
import 'package:erp_mobile_cnplus/features/master/product_type/domain/usecases/product_type_usecases.dart';
import 'package:erp_mobile_cnplus/features/master/product_type/presentation/controllers/product_type_controller.dart';

// -- UOM
import 'package:erp_mobile_cnplus/features/master/uom/data/datasources/uom_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/master/uom/data/repositories/uom_repository.dart';
import 'package:erp_mobile_cnplus/features/master/uom/domain/usecases/uom_usecases.dart';
import 'package:erp_mobile_cnplus/features/master/uom/presentation/controllers/uom_controller.dart';

// -- Vendor
import 'package:erp_mobile_cnplus/features/master/vendor/data/datasources/vendor_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/master/vendor/data/repositories/vendor_repository.dart';
import 'package:erp_mobile_cnplus/features/master/vendor/domain/usecases/vendor_usecases.dart';
import 'package:erp_mobile_cnplus/features/master/vendor/presentation/controllers/vendor_controller.dart';

// -- Customer
import 'package:erp_mobile_cnplus/features/master/customer/data/datasources/customer_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/master/customer/data/repositories/customer_repository.dart';
import 'package:erp_mobile_cnplus/features/master/customer/domain/usecases/customer_usecases.dart';
import 'package:erp_mobile_cnplus/features/master/customer/presentation/controllers/customer_controller.dart';

// -- Customer Category
import 'package:erp_mobile_cnplus/features/master/customer_category/data/datasources/customer_category_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/master/customer_category/data/repositories/customer_category_repository.dart';
import 'package:erp_mobile_cnplus/features/master/customer_category/domain/usecases/customer_category_usecases.dart';
import 'package:erp_mobile_cnplus/features/master/customer_category/presentation/controllers/customer_category_controller.dart';

// -- Location
import 'package:erp_mobile_cnplus/features/master/location/data/datasources/location_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/master/location/data/repositories/location_repository.dart';
import 'package:erp_mobile_cnplus/features/master/location/domain/usecases/location_usecases.dart';
import 'package:erp_mobile_cnplus/features/master/location/presentation/controllers/location_controller.dart';

// -- Warehouse
import 'package:erp_mobile_cnplus/features/master/warehouse/data/datasources/warehouse_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/master/warehouse/data/repositories/warehouse_repository.dart';
import 'package:erp_mobile_cnplus/features/master/warehouse/domain/usecases/warehouse_usecases.dart';
import 'package:erp_mobile_cnplus/features/master/warehouse/presentation/controllers/warehouse_controller.dart';

// -- Sales Team
import 'package:erp_mobile_cnplus/features/master/sales_team/data/datasources/sales_team_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/master/sales_team/data/repositories/sales_team_repository.dart';
import 'package:erp_mobile_cnplus/features/master/sales_team/domain/usecases/sales_team_usecases.dart';
import 'package:erp_mobile_cnplus/features/master/sales_team/presentation/controllers/sales_team_controller.dart';

// -- Purchase Team
import 'package:erp_mobile_cnplus/features/master/purchase_team/data/datasources/purchase_team_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/master/purchase_team/data/repositories/purchase_team_repository.dart';
import 'package:erp_mobile_cnplus/features/master/purchase_team/domain/usecases/purchase_team_usecases.dart';
import 'package:erp_mobile_cnplus/features/master/purchase_team/presentation/controllers/purchase_team_controller.dart';

// -- Employee
import 'package:erp_mobile_cnplus/features/master/employee/data/datasources/employee_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/master/employee/data/repositories/employee_repository.dart';
import 'package:erp_mobile_cnplus/features/master/employee/domain/usecases/employee_usecases.dart';
import 'package:erp_mobile_cnplus/features/master/employee/presentation/controllers/employee_controller.dart';

// -- Project
import 'package:erp_mobile_cnplus/features/master/project/data/datasources/project_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/master/project/data/repositories/project_repository.dart';
import 'package:erp_mobile_cnplus/features/master/project/domain/usecases/project_usecases.dart';
import 'package:erp_mobile_cnplus/features/master/project/presentation/controllers/project_controller.dart';

// -- User
import 'package:erp_mobile_cnplus/features/master/user/data/datasources/user_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/master/user/data/repositories/user_repository.dart';
import 'package:erp_mobile_cnplus/features/master/user/domain/usecases/user_usecases.dart';
import 'package:erp_mobile_cnplus/features/master/user/presentation/controllers/user_controller.dart';

// INVENTORY
// -- Receipt Note
import 'package:erp_mobile_cnplus/features/inventory/receipt_note/data/datasources/receipt_note_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/inventory/receipt_note/data/repositories/receipt_note_repository.dart';
import 'package:erp_mobile_cnplus/features/inventory/receipt_note/domain/usecases/receipt_note_usecases.dart';
import 'package:erp_mobile_cnplus/features/inventory/receipt_note/presentation/controllers/receipt_note_controller.dart';

// -- Delivery Note
import 'package:erp_mobile_cnplus/features/inventory/delivery_note/data/datasources/delivery_note_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/inventory/delivery_note/data/repositories/delivery_note_repository.dart';
import 'package:erp_mobile_cnplus/features/inventory/delivery_note/domain/usecases/delivery_note_usecases.dart';
import 'package:erp_mobile_cnplus/features/inventory/delivery_note/presentation/controllers/delivery_note_controller.dart';

// -- Internal Transfer
import 'package:erp_mobile_cnplus/features/inventory/internal_transfer/data/datasources/internal_transfer_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/inventory/internal_transfer/data/repositories/internal_transfer_repository.dart';
import 'package:erp_mobile_cnplus/features/inventory/internal_transfer/domain/usecases/internal_transfer_usecases.dart';
import 'package:erp_mobile_cnplus/features/inventory/internal_transfer/presentation/controllers/internal_transfer_controller.dart';

// -- Transfer In
import 'package:erp_mobile_cnplus/features/inventory/transfer_in/data/datasources/transfer_in_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/inventory/transfer_in/data/repositories/transfer_in_repository.dart';
import 'package:erp_mobile_cnplus/features/inventory/transfer_in/domain/usecases/transfer_in_usecases.dart';
import 'package:erp_mobile_cnplus/features/inventory/transfer_in/presentation/controllers/transfer_in_controller.dart';

// -- Transfer Out
import 'package:erp_mobile_cnplus/features/inventory/transfer_out/data/datasources/transfer_out_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/inventory/transfer_out/data/repositories/transfer_out_repository.dart';
import 'package:erp_mobile_cnplus/features/inventory/transfer_out/domain/usecases/transfer_out_usecases.dart';
import 'package:erp_mobile_cnplus/features/inventory/transfer_out/presentation/controllers/transfer_out_controller.dart';

// -- Scrap Order
import 'package:erp_mobile_cnplus/features/inventory/scrap_order/data/datasources/scrap_order_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/inventory/scrap_order/data/repositories/scrap_order_repository.dart';
import 'package:erp_mobile_cnplus/features/inventory/scrap_order/domain/usecases/scrap_order_usecases.dart';
import 'package:erp_mobile_cnplus/features/inventory/scrap_order/presentation/controllers/scrap_order_controller.dart';

// -- Stock Count
import 'package:erp_mobile_cnplus/features/inventory/stock_count/data/datasources/stock_count_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/inventory/stock_count/data/repositories/stock_count_repository.dart';
import 'package:erp_mobile_cnplus/features/inventory/stock_count/domain/usecases/stock_count_usecases.dart';
import 'package:erp_mobile_cnplus/features/inventory/stock_count/presentation/controllers/stock_count_controller.dart';

// -- Return RN
import 'package:erp_mobile_cnplus/features/inventory/return_rn/data/datasources/return_rn_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/inventory/return_rn/data/repositories/return_rn_repository.dart';
import 'package:erp_mobile_cnplus/features/inventory/return_rn/domain/usecases/return_rn_usecases.dart';
import 'package:erp_mobile_cnplus/features/inventory/return_rn/presentation/controllers/return_rn_controller.dart';

// -- Return DN
import 'package:erp_mobile_cnplus/features/inventory/return_dn/data/datasources/return_dn_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/inventory/return_dn/data/repositories/return_dn_repository.dart';
import 'package:erp_mobile_cnplus/features/inventory/return_dn/domain/usecases/return_dn_usecases.dart';
import 'package:erp_mobile_cnplus/features/inventory/return_dn/presentation/controllers/return_dn_controller.dart';

// -- Reports
import 'package:erp_mobile_cnplus/features/inventory/warehouse_report/data/datasources/warehouse_report_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/inventory/warehouse_report/data/repositories/warehouse_report_repository.dart';
import 'package:erp_mobile_cnplus/features/inventory/warehouse_report/domain/usecases/warehouse_report_usecases.dart';
import 'package:erp_mobile_cnplus/features/inventory/warehouse_report/presentation/controllers/warehouse_report_controller.dart';

import 'package:erp_mobile_cnplus/features/inventory/location_report/data/datasources/location_report_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/inventory/location_report/data/repositories/location_report_repository.dart';
import 'package:erp_mobile_cnplus/features/inventory/location_report/domain/usecases/location_report_usecases.dart';
import 'package:erp_mobile_cnplus/features/inventory/location_report/presentation/controllers/location_report_controller.dart';

import 'package:erp_mobile_cnplus/features/inventory/stock_report/data/datasources/stock_report_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/inventory/stock_report/data/repositories/stock_report_repository.dart';
import 'package:erp_mobile_cnplus/features/inventory/stock_report/domain/usecases/stock_report_usecases.dart';
import 'package:erp_mobile_cnplus/features/inventory/stock_report/presentation/controllers/stock_report_controller.dart';

import 'package:erp_mobile_cnplus/features/inventory/stock_movement/data/datasources/stock_movement_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/inventory/stock_movement/data/repositories/stock_movement_repository.dart';
import 'package:erp_mobile_cnplus/features/inventory/stock_movement/domain/usecases/stock_movement_usecases.dart';
import 'package:erp_mobile_cnplus/features/inventory/stock_movement/presentation/controllers/stock_movement_controller.dart';

import 'package:erp_mobile_cnplus/features/inventory/stock_valuation/data/datasources/stock_valuation_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/inventory/stock_valuation/data/repositories/stock_valuation_repository.dart';
import 'package:erp_mobile_cnplus/features/inventory/stock_valuation/domain/usecases/stock_valuation_usecases.dart';
import 'package:erp_mobile_cnplus/features/inventory/stock_valuation/presentation/controllers/stock_valuation_controller.dart';

import 'package:erp_mobile_cnplus/features/inventory/history_stock/data/datasources/history_stock_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/inventory/history_stock/data/repositories/history_stock_repository.dart';
import 'package:erp_mobile_cnplus/features/inventory/history_stock/domain/usecases/history_stock_usecases.dart';
import 'package:erp_mobile_cnplus/features/inventory/history_stock/presentation/controllers/history_stock_controller.dart';

import 'package:erp_mobile_cnplus/features/inventory/expired_report/data/datasources/expired_report_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/inventory/expired_report/data/repositories/expired_report_repository.dart';
import 'package:erp_mobile_cnplus/features/inventory/expired_report/domain/usecases/expired_report_usecases.dart';
import 'package:erp_mobile_cnplus/features/inventory/expired_report/presentation/controllers/expired_report_controller.dart';

// SALES
// -- Price List
import 'package:erp_mobile_cnplus/features/sales/price_list/data/datasources/price_list_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/sales/price_list/data/repositories/price_list_repository.dart';
import 'package:erp_mobile_cnplus/features/sales/price_list/domain/usecases/price_list_usecases.dart';
import 'package:erp_mobile_cnplus/features/sales/price_list/presentation/controllers/price_list_controller.dart';

// -- Quotation
import 'package:erp_mobile_cnplus/features/sales/quotation/data/datasources/quotation_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/sales/quotation/data/repositories/quotation_repository.dart';
import 'package:erp_mobile_cnplus/features/sales/quotation/domain/usecases/quotation_usecases.dart';
import 'package:erp_mobile_cnplus/features/sales/quotation/presentation/controllers/quotation_controller.dart';

// -- Sales Order
import 'package:erp_mobile_cnplus/features/sales/sales_order/data/datasources/sales_order_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/sales/sales_order/data/repositories/sales_order_repository.dart';
import 'package:erp_mobile_cnplus/features/sales/sales_order/domain/usecases/sales_order_usecases.dart';
import 'package:erp_mobile_cnplus/features/sales/sales_order/presentation/controllers/sales_order_controller.dart';

// -- Direct Sales
import 'package:erp_mobile_cnplus/features/sales/direct_sales/data/datasources/direct_sales_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/sales/direct_sales/data/repositories/direct_sales_repository.dart';
import 'package:erp_mobile_cnplus/features/sales/direct_sales/domain/usecases/direct_sales_usecases.dart';
import 'package:erp_mobile_cnplus/features/sales/direct_sales/presentation/controllers/direct_sales_controller.dart';

// -- Invoice
import 'package:erp_mobile_cnplus/features/sales/invoice/data/datasources/invoice_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/sales/invoice/data/repositories/invoice_repository.dart';
import 'package:erp_mobile_cnplus/features/sales/invoice/domain/usecases/invoice_usecases.dart';
import 'package:erp_mobile_cnplus/features/sales/invoice/presentation/controllers/invoice_controller.dart';

// -- Service Sales: Quotation
import 'package:erp_mobile_cnplus/features/sales/service_sales/service_quotation/data/datasources/service_quotation_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/sales/service_sales/service_quotation/data/repositories/service_quotation_repository.dart';
import 'package:erp_mobile_cnplus/features/sales/service_sales/service_quotation/domain/usecases/service_quotation_usecases.dart';
import 'package:erp_mobile_cnplus/features/sales/service_sales/service_quotation/presentation/controllers/service_quotation_controller.dart';

// -- Service Sales: Sales Order
import 'package:erp_mobile_cnplus/features/sales/service_sales/service_sales_order/data/datasources/service_sales_order_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/sales/service_sales/service_sales_order/data/repositories/service_sales_order_repository.dart';
import 'package:erp_mobile_cnplus/features/sales/service_sales/service_sales_order/domain/usecases/service_sales_order_usecases.dart';
import 'package:erp_mobile_cnplus/features/sales/service_sales/service_sales_order/presentation/controllers/service_sales_order_controller.dart';

// -- Service Sales: Direct Sales
import 'package:erp_mobile_cnplus/features/sales/service_sales/service_direct_sales/data/datasources/service_direct_sales_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/sales/service_sales/service_direct_sales/data/repositories/service_direct_sales_repository.dart';
import 'package:erp_mobile_cnplus/features/sales/service_sales/service_direct_sales/domain/usecases/service_direct_sales_usecases.dart';
import 'package:erp_mobile_cnplus/features/sales/service_sales/service_direct_sales/presentation/controllers/service_direct_sales_controller.dart';

// -- Service Sales: Invoice
import 'package:erp_mobile_cnplus/features/sales/service_sales/service_invoice/data/datasources/service_invoice_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/sales/service_sales/service_invoice/data/repositories/service_invoice_repository.dart';
import 'package:erp_mobile_cnplus/features/sales/service_sales/service_invoice/domain/usecases/service_invoice_usecases.dart';
import 'package:erp_mobile_cnplus/features/sales/service_sales/service_invoice/presentation/controllers/service_invoice_controller.dart';

// -- Reports
import 'package:erp_mobile_cnplus/features/sales/quotation_report/data/datasources/quotation_report_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/sales/quotation_report/data/repositories/quotation_report_repository.dart';
import 'package:erp_mobile_cnplus/features/sales/quotation_report/domain/usecases/quotation_report_usecases.dart';
import 'package:erp_mobile_cnplus/features/sales/quotation_report/presentation/controllers/quotation_report_controller.dart';

import 'package:erp_mobile_cnplus/features/sales/sales_order_report/data/datasources/sales_order_report_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/sales/sales_order_report/data/repositories/sales_order_report_repository.dart';
import 'package:erp_mobile_cnplus/features/sales/sales_order_report/domain/usecases/sales_order_report_usecases.dart';
import 'package:erp_mobile_cnplus/features/sales/sales_order_report/presentation/controllers/sales_order_report_controller.dart';

import 'package:erp_mobile_cnplus/features/sales/direct_sales_report/data/datasources/direct_sales_report_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/sales/direct_sales_report/data/repositories/direct_sales_report_repository.dart';
import 'package:erp_mobile_cnplus/features/sales/direct_sales_report/domain/usecases/direct_sales_report_usecases.dart';
import 'package:erp_mobile_cnplus/features/sales/direct_sales_report/presentation/controllers/direct_sales_report_controller.dart';

import 'package:erp_mobile_cnplus/features/sales/invoice_report/data/datasources/invoice_report_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/sales/invoice_report/data/repositories/invoice_report_repository.dart';
import 'package:erp_mobile_cnplus/features/sales/invoice_report/domain/usecases/invoice_report_usecases.dart';
import 'package:erp_mobile_cnplus/features/sales/invoice_report/presentation/controllers/invoice_report_controller.dart';

import 'package:erp_mobile_cnplus/features/sales/service_quotation_report/data/datasources/service_quotation_report_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/sales/service_quotation_report/data/repositories/service_quotation_report_repository.dart';
import 'package:erp_mobile_cnplus/features/sales/service_quotation_report/domain/usecases/service_quotation_report_usecases.dart';
import 'package:erp_mobile_cnplus/features/sales/service_quotation_report/presentation/controllers/service_quotation_report_controller.dart';

import 'package:erp_mobile_cnplus/features/sales/service_sales_order_report/data/datasources/service_sales_order_report_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/sales/service_sales_order_report/data/repositories/service_sales_order_report_repository.dart';
import 'package:erp_mobile_cnplus/features/sales/service_sales_order_report/domain/usecases/service_sales_order_report_usecases.dart';
import 'package:erp_mobile_cnplus/features/sales/service_sales_order_report/presentation/controllers/service_sales_order_report_controller.dart';

import 'package:erp_mobile_cnplus/features/sales/service_direct_sales_report/data/datasources/service_direct_sales_report_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/sales/service_direct_sales_report/data/repositories/service_direct_sales_report_repository.dart';
import 'package:erp_mobile_cnplus/features/sales/service_direct_sales_report/domain/usecases/service_direct_sales_report_usecases.dart';
import 'package:erp_mobile_cnplus/features/sales/service_direct_sales_report/presentation/controllers/service_direct_sales_report_controller.dart';

import 'package:erp_mobile_cnplus/features/sales/service_invoice_report/data/datasources/service_invoice_report_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/sales/service_invoice_report/data/repositories/service_invoice_report_repository.dart';
import 'package:erp_mobile_cnplus/features/sales/service_invoice_report/domain/usecases/service_invoice_report_usecases.dart';
import 'package:erp_mobile_cnplus/features/sales/service_invoice_report/presentation/controllers/service_invoice_report_controller.dart';

import 'package:erp_mobile_cnplus/features/sales/sales_product_report/data/datasources/sales_product_report_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/sales/sales_product_report/data/repositories/sales_product_report_repository.dart';
import 'package:erp_mobile_cnplus/features/sales/sales_product_report/domain/usecases/sales_product_report_usecases.dart';
import 'package:erp_mobile_cnplus/features/sales/sales_product_report/presentation/controllers/sales_product_report_controller.dart';

import 'package:erp_mobile_cnplus/features/sales/salespersons_report/data/datasources/salespersons_report_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/sales/salespersons_report/data/repositories/salespersons_report_repository.dart';
import 'package:erp_mobile_cnplus/features/sales/salespersons_report/domain/usecases/salespersons_report_usecases.dart';
import 'package:erp_mobile_cnplus/features/sales/salespersons_report/presentation/controllers/salespersons_report_controller.dart';

import 'package:erp_mobile_cnplus/features/sales/top_customer_report/data/datasources/top_customer_report_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/sales/top_customer_report/data/repositories/top_customer_report_repository.dart';
import 'package:erp_mobile_cnplus/features/sales/top_customer_report/domain/usecases/top_customer_report_usecases.dart';
import 'package:erp_mobile_cnplus/features/sales/top_customer_report/presentation/controllers/top_customer_report_controller.dart';

import 'package:erp_mobile_cnplus/features/sales/ppn_report/data/datasources/ppn_report_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/sales/ppn_report/data/repositories/ppn_report_repository.dart';
import 'package:erp_mobile_cnplus/features/sales/ppn_report/domain/usecases/ppn_report_usecases.dart';
import 'package:erp_mobile_cnplus/features/sales/ppn_report/presentation/controllers/ppn_report_controller.dart';

import 'package:erp_mobile_cnplus/features/sales/pph_report/data/datasources/pph_report_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/sales/pph_report/data/repositories/pph_report_repository.dart';
import 'package:erp_mobile_cnplus/features/sales/pph_report/domain/usecases/pph_report_usecases.dart';
import 'package:erp_mobile_cnplus/features/sales/pph_report/presentation/controllers/pph_report_controller.dart';

// PURCHASE
// -- Purchase Request
import 'package:erp_mobile_cnplus/features/purchase/purchase_request/data/datasources/purchase_request_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/purchase/purchase_request/data/repositories/purchase_request_repository.dart';
import 'package:erp_mobile_cnplus/features/purchase/purchase_request/domain/usecases/purchase_request_usecases.dart';
import 'package:erp_mobile_cnplus/features/purchase/purchase_request/presentation/controllers/purchase_request_controller.dart';

// -- Request Quotation (RFQ)
import 'package:erp_mobile_cnplus/features/purchase/request_quotation/data/datasources/rfq_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/purchase/request_quotation/data/repositories/rfq_repository.dart';
import 'package:erp_mobile_cnplus/features/purchase/request_quotation/domain/usecases/rfq_usecases.dart';
import 'package:erp_mobile_cnplus/features/purchase/request_quotation/presentation/controllers/rfq_controller.dart';

// -- Direct Purchase
import 'package:erp_mobile_cnplus/features/purchase/direct_purchase/data/datasources/direct_purchase_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/purchase/direct_purchase/data/repositories/direct_purchase_repository.dart';
import 'package:erp_mobile_cnplus/features/purchase/direct_purchase/domain/usecases/direct_purchase_usecases.dart';
import 'package:erp_mobile_cnplus/features/purchase/direct_purchase/presentation/controllers/direct_purchase_controller.dart';

// -- Purchase Order
import 'package:erp_mobile_cnplus/features/purchase/purchase_order/data/datasources/purchase_order_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/purchase/purchase_order/data/repositories/purchase_order_repository.dart';
import 'package:erp_mobile_cnplus/features/purchase/purchase_order/domain/usecases/purchase_order_usecases.dart';
import 'package:erp_mobile_cnplus/features/purchase/purchase_order/presentation/controllers/purchase_order_controller.dart';

// -- Bill
import 'package:erp_mobile_cnplus/features/purchase/bill/data/datasources/bill_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/purchase/bill/data/repositories/bill_repository.dart';
import 'package:erp_mobile_cnplus/features/purchase/bill/domain/usecases/bill_usecases.dart';
import 'package:erp_mobile_cnplus/features/purchase/bill/presentation/controllers/bill_controller.dart';

// -- Reports
import 'package:erp_mobile_cnplus/features/purchase/purchase_request_report/data/datasources/purchase_request_report_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/purchase/purchase_request_report/data/repositories/purchase_request_report_repository.dart';
import 'package:erp_mobile_cnplus/features/purchase/purchase_request_report/domain/usecases/purchase_request_report_usecases.dart';
import 'package:erp_mobile_cnplus/features/purchase/purchase_request_report/presentation/controllers/purchase_request_report_controller.dart';

import 'package:erp_mobile_cnplus/features/purchase/request_quotation_report/data/datasources/request_quotation_report_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/purchase/request_quotation_report/data/repositories/request_quotation_report_repository.dart';
import 'package:erp_mobile_cnplus/features/purchase/request_quotation_report/domain/usecases/request_quotation_report_usecases.dart';
import 'package:erp_mobile_cnplus/features/purchase/request_quotation_report/presentation/controllers/request_quotation_report_controller.dart';

import 'package:erp_mobile_cnplus/features/purchase/purchase_order_report/data/datasources/purchase_order_report_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/purchase/purchase_order_report/data/repositories/purchase_order_report_repository.dart';
import 'package:erp_mobile_cnplus/features/purchase/purchase_order_report/domain/usecases/purchase_order_report_usecases.dart';
import 'package:erp_mobile_cnplus/features/purchase/purchase_order_report/presentation/controllers/purchase_order_report_controller.dart';

import 'package:erp_mobile_cnplus/features/purchase/direct_purchase_report/data/datasources/direct_purchase_report_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/purchase/direct_purchase_report/data/repositories/direct_purchase_report_repository.dart';
import 'package:erp_mobile_cnplus/features/purchase/direct_purchase_report/domain/usecases/direct_purchase_report_usecases.dart';
import 'package:erp_mobile_cnplus/features/purchase/direct_purchase_report/presentation/controllers/direct_purchase_report_controller.dart';

import 'package:erp_mobile_cnplus/features/purchase/top_purchase_order_report/data/datasources/top_purchase_order_report_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/purchase/top_purchase_order_report/data/repositories/top_purchase_order_report_repository.dart';
import 'package:erp_mobile_cnplus/features/purchase/top_purchase_order_report/domain/usecases/top_purchase_order_report_usecases.dart';
import 'package:erp_mobile_cnplus/features/purchase/top_purchase_order_report/presentation/controllers/top_purchase_order_report_controller.dart';

import 'package:erp_mobile_cnplus/features/purchase/top_purchasing_product_report/data/datasources/top_purchasing_product_report_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/purchase/top_purchasing_product_report/data/repositories/top_purchasing_product_report_repository.dart';
import 'package:erp_mobile_cnplus/features/purchase/top_purchasing_product_report/domain/usecases/top_purchasing_product_report_usecases.dart';
import 'package:erp_mobile_cnplus/features/purchase/top_purchasing_product_report/presentation/controllers/top_purchasing_product_report_controller.dart';

// HR
// -- Attendance
import 'package:erp_mobile_cnplus/features/hr/attendance/data/datasources/attendance_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/hr/attendance/data/repositories/attendance_repository.dart';
import 'package:erp_mobile_cnplus/features/hr/attendance/domain/usecases/attendance_usecases.dart';
import 'package:erp_mobile_cnplus/features/hr/attendance/presentation/controllers/attendance_controller.dart';

// -- Department
import 'package:erp_mobile_cnplus/features/hr/department/data/datasources/department_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/hr/department/data/repositories/department_repository.dart';
import 'package:erp_mobile_cnplus/features/hr/department/domain/usecases/department_usecases.dart';
import 'package:erp_mobile_cnplus/features/hr/department/presentation/controllers/department_controller.dart';

// -- Employee Status
import 'package:erp_mobile_cnplus/features/hr/employee_status/data/datasources/employee_status_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/hr/employee_status/data/repositories/employee_status_repository.dart';
import 'package:erp_mobile_cnplus/features/hr/employee_status/domain/usecases/employee_status_usecases.dart';
import 'package:erp_mobile_cnplus/features/hr/employee_status/presentation/controllers/employee_status_controller.dart';

// -- National Holiday
import 'package:erp_mobile_cnplus/features/hr/national_holiday/data/datasources/national_holiday_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/hr/national_holiday/data/repositories/national_holiday_repository.dart';
import 'package:erp_mobile_cnplus/features/hr/national_holiday/domain/usecases/national_holiday_usecases.dart';
import 'package:erp_mobile_cnplus/features/hr/national_holiday/presentation/controllers/national_holiday_controller.dart';

// -- Position
import 'package:erp_mobile_cnplus/features/hr/position/data/datasources/position_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/hr/position/data/repositories/position_repository.dart';
import 'package:erp_mobile_cnplus/features/hr/position/domain/usecases/position_usecases.dart';
import 'package:erp_mobile_cnplus/features/hr/position/presentation/controllers/position_controller.dart';

// -- Leave Type
import 'package:erp_mobile_cnplus/features/hr/leave_type/data/datasources/leave_type_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/hr/leave_type/data/repositories/leave_type_repository.dart';
import 'package:erp_mobile_cnplus/features/hr/leave_type/domain/usecases/leave_type_usecases.dart';
import 'package:erp_mobile_cnplus/features/hr/leave_type/presentation/controllers/leave_type_controller.dart';

// -- Collective Leave
import 'package:erp_mobile_cnplus/features/hr/collective_leave/data/datasources/collective_leave_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/hr/collective_leave/data/repositories/collective_leave_repository.dart';
import 'package:erp_mobile_cnplus/features/hr/collective_leave/domain/usecases/collective_leave_usecases.dart';
import 'package:erp_mobile_cnplus/features/hr/collective_leave/presentation/controllers/collective_leave_controller.dart';

// -- Leave Allocation
import 'package:erp_mobile_cnplus/features/hr/leave_allocation/data/datasources/leave_allocation_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/hr/leave_allocation/data/repositories/leave_allocation_repository.dart';
import 'package:erp_mobile_cnplus/features/hr/leave_allocation/domain/usecases/leave_allocation_usecases.dart';
import 'package:erp_mobile_cnplus/features/hr/leave_allocation/presentation/controllers/leave_allocation_controller.dart';

// -- Leave Quota
import 'package:erp_mobile_cnplus/features/hr/leave_quota/data/datasources/leave_quota_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/hr/leave_quota/presentation/controllers/leave_quota_controller.dart';

// -- Leave Request
import 'package:erp_mobile_cnplus/features/hr/leave_request/data/datasources/leave_request_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/hr/leave_request/data/repositories/leave_request_repository.dart';
import 'package:erp_mobile_cnplus/features/hr/leave_request/domain/usecases/leave_request_usecases.dart';
import 'package:erp_mobile_cnplus/features/hr/leave_request/presentation/controllers/leave_request_controller.dart';

// -- Overtime Type
import 'package:erp_mobile_cnplus/features/hr/overtime_type/data/datasources/overtime_type_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/hr/overtime_type/data/repositories/overtime_type_repository.dart';
import 'package:erp_mobile_cnplus/features/hr/overtime_type/domain/usecases/overtime_type_usecases.dart';
import 'package:erp_mobile_cnplus/features/hr/overtime_type/presentation/controllers/overtime_type_controller.dart';

// -- Overtime Request
import 'package:erp_mobile_cnplus/features/hr/overtime_request/data/datasources/overtime_request_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/hr/overtime_request/data/repositories/overtime_request_repository.dart';
import 'package:erp_mobile_cnplus/features/hr/overtime_request/domain/usecases/overtime_request_usecases.dart';
import 'package:erp_mobile_cnplus/features/hr/overtime_request/presentation/controllers/overtime_request_controller.dart';

// -- My Payslip
import 'package:erp_mobile_cnplus/features/hr/my_payslip/data/datasources/my_payslip_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/hr/my_payslip/data/repositories/my_payslip_repository.dart';
import 'package:erp_mobile_cnplus/features/hr/my_payslip/domain/usecases/my_payslip_usecases.dart';
import 'package:erp_mobile_cnplus/features/hr/my_payslip/presentation/controllers/my_payslip_controller.dart';
import 'package:erp_mobile_cnplus/features/hr/my_payslip/presentation/controllers/my_payslip_detail_controller.dart';

// -- Reports
import 'package:erp_mobile_cnplus/features/hr/attendance_report/data/datasources/attendance_report_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/hr/attendance_report/data/repositories/attendance_report_repository.dart';
import 'package:erp_mobile_cnplus/features/hr/attendance_report/domain/usecases/attendance_report_usecases.dart';
import 'package:erp_mobile_cnplus/features/hr/attendance_report/presentation/controllers/attendance_report_controller.dart';

import 'package:erp_mobile_cnplus/features/hr/attendance_late_report/data/datasources/attendance_late_report_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/hr/attendance_late_report/data/repositories/attendance_late_report_repository.dart';
import 'package:erp_mobile_cnplus/features/hr/attendance_late_report/domain/usecases/attendance_late_report_usecases.dart';
import 'package:erp_mobile_cnplus/features/hr/attendance_late_report/presentation/controllers/attendance_late_report_controller.dart';

import 'package:erp_mobile_cnplus/features/hr/attendance_overtime_report/data/datasources/attendance_overtime_report_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/hr/attendance_overtime_report/data/repositories/attendance_overtime_report_repository.dart';
import 'package:erp_mobile_cnplus/features/hr/attendance_overtime_report/domain/usecases/attendance_overtime_report_usecases.dart';
import 'package:erp_mobile_cnplus/features/hr/attendance_overtime_report/presentation/controllers/attendance_overtime_report_controller.dart';

import 'package:erp_mobile_cnplus/features/hr/leave_report/data/datasources/leave_report_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/hr/leave_report/data/repositories/leave_report_repository.dart';
import 'package:erp_mobile_cnplus/features/hr/leave_report/domain/usecases/leave_report_usecases.dart';
import 'package:erp_mobile_cnplus/features/hr/leave_report/presentation/controllers/leave_report_controller.dart';

import 'package:erp_mobile_cnplus/features/hr/payroll_summary_report/data/datasources/payroll_summary_report_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/hr/payroll_summary_report/data/repositories/payroll_summary_report_repository.dart';
import 'package:erp_mobile_cnplus/features/hr/payroll_summary_report/domain/usecases/payroll_summary_report_usecases.dart';
import 'package:erp_mobile_cnplus/features/hr/payroll_summary_report/presentation/controllers/payroll_summary_report_controller.dart';

// ACCOUNTING
// -- COA
import 'package:erp_mobile_cnplus/features/accounting/coa/data/datasources/coa_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/accounting/coa/data/repositories/coa_repository.dart';
import 'package:erp_mobile_cnplus/features/accounting/coa/domain/usecases/coa_usecases.dart';
import 'package:erp_mobile_cnplus/features/accounting/coa/presentation/controllers/coa_controller.dart';

// -- Bank Account
import 'package:erp_mobile_cnplus/features/accounting/bank_account/data/datasources/bank_account_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/accounting/bank_account/data/repositories/bank_account_repository.dart';
import 'package:erp_mobile_cnplus/features/accounting/bank_account/domain/usecases/bank_account_usecases.dart';
import 'package:erp_mobile_cnplus/features/accounting/bank_account/presentation/controllers/bank_account_controller.dart';

// -- Asset Category
import 'package:erp_mobile_cnplus/features/accounting/asset_category/data/datasources/asset_category_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/accounting/asset_category/data/repositories/asset_category_repository.dart';
import 'package:erp_mobile_cnplus/features/accounting/asset_category/domain/usecases/asset_category_usecases.dart';
import 'package:erp_mobile_cnplus/features/accounting/asset_category/presentation/controllers/asset_category_controller.dart';

// -- Fixed Asset
import 'package:erp_mobile_cnplus/features/accounting/fixed_asset/data/datasources/fixed_asset_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/accounting/fixed_asset/data/repositories/fixed_asset_repository.dart';
import 'package:erp_mobile_cnplus/features/accounting/fixed_asset/domain/usecases/fixed_asset_usecases.dart';
import 'package:erp_mobile_cnplus/features/accounting/fixed_asset/presentation/controllers/fixed_asset_controller.dart';

// -- Cash Bank
import 'package:erp_mobile_cnplus/features/accounting/cash_bank/data/datasources/cash_bank_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/accounting/cash_bank/data/repositories/cash_bank_repository.dart';
import 'package:erp_mobile_cnplus/features/accounting/cash_bank/domain/usecases/cash_bank_usecases.dart';
import 'package:erp_mobile_cnplus/features/accounting/cash_bank/presentation/controllers/cash_bank_controller.dart';

// -- Journal Entry
import 'package:erp_mobile_cnplus/features/accounting/journal_entry/data/datasources/journal_entry_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/accounting/journal_entry/data/repositories/journal_entry_repository.dart';
import 'package:erp_mobile_cnplus/features/accounting/journal_entry/domain/usecases/journal_entry_usecases.dart';
import 'package:erp_mobile_cnplus/features/accounting/journal_entry/presentation/controllers/journal_entry_controller.dart';

// -- Bill Payment
import 'package:erp_mobile_cnplus/features/accounting/bill_payment/data/datasources/bill_payment_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/accounting/bill_payment/data/repositories/bill_payment_repository.dart';
import 'package:erp_mobile_cnplus/features/accounting/bill_payment/domain/usecases/bill_payment_usecases.dart';
import 'package:erp_mobile_cnplus/features/accounting/bill_payment/presentation/controllers/bill_payment_controller.dart';

// -- Invoice Payment
import 'package:erp_mobile_cnplus/features/accounting/invoice_payment/data/datasources/invoice_payment_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/accounting/invoice_payment/data/repositories/invoice_payment_repository.dart';
import 'package:erp_mobile_cnplus/features/accounting/invoice_payment/domain/usecases/invoice_payment_usecases.dart';
import 'package:erp_mobile_cnplus/features/accounting/invoice_payment/presentation/controllers/invoice_payment_controller.dart';

// -- Period Closing
import 'package:erp_mobile_cnplus/features/accounting/period_closing/data/datasources/period_closing_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/accounting/period_closing/data/repositories/period_closing_repository.dart';
import 'package:erp_mobile_cnplus/features/accounting/period_closing/domain/usecases/period_closing_usecases.dart';
import 'package:erp_mobile_cnplus/features/accounting/period_closing/presentation/controllers/period_closing_controller.dart';

// -- Asset Depreciation
import 'package:erp_mobile_cnplus/features/accounting/asset_depreciation/data/datasources/asset_depreciation_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/accounting/asset_depreciation/data/repositories/asset_depreciation_repository.dart';
import 'package:erp_mobile_cnplus/features/accounting/asset_depreciation/domain/usecases/asset_depreciation_usecases.dart';
import 'package:erp_mobile_cnplus/features/accounting/asset_depreciation/presentation/controllers/asset_depreciation_controller.dart';

// -- Asset Movement
import 'package:erp_mobile_cnplus/features/accounting/asset_movement/data/datasources/asset_movement_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/accounting/asset_movement/data/repositories/asset_movement_repository.dart';
import 'package:erp_mobile_cnplus/features/accounting/asset_movement/domain/usecases/asset_movement_usecases.dart';
import 'package:erp_mobile_cnplus/features/accounting/asset_movement/presentation/controllers/asset_movement_controller.dart';

// -- Asset Disposal
import 'package:erp_mobile_cnplus/features/accounting/asset_disposal/data/datasources/asset_disposal_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/accounting/asset_disposal/data/repositories/asset_disposal_repository.dart';
import 'package:erp_mobile_cnplus/features/accounting/asset_disposal/domain/usecases/asset_disposal_usecases.dart';
import 'package:erp_mobile_cnplus/features/accounting/asset_disposal/presentation/controllers/asset_disposal_controller.dart';

// -- Tax Payment
import 'package:erp_mobile_cnplus/features/accounting/tax_payment/data/datasources/tax_payment_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/accounting/tax_payment/data/repositories/tax_payment_repository.dart';
import 'package:erp_mobile_cnplus/features/accounting/tax_payment/domain/usecases/tax_payment_usecases.dart';
import 'package:erp_mobile_cnplus/features/accounting/tax_payment/presentation/controllers/tax_payment_controller.dart';

// -- BPE Management
import 'package:erp_mobile_cnplus/features/accounting/bpe_management/data/datasources/bpe_management_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/accounting/bpe_management/data/repositories/bpe_management_repository.dart';
import 'package:erp_mobile_cnplus/features/accounting/bpe_management/domain/usecases/bpe_management_usecases.dart';
import 'package:erp_mobile_cnplus/features/accounting/bpe_management/presentation/controllers/bpe_management_controller.dart';

// -- Reports
import 'package:erp_mobile_cnplus/features/accounting/general_ledger/data/datasources/general_ledger_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/accounting/general_ledger/data/repositories/general_ledger_repository.dart';
import 'package:erp_mobile_cnplus/features/accounting/general_ledger/domain/usecases/general_ledger_usecases.dart';
import 'package:erp_mobile_cnplus/features/accounting/general_ledger/presentation/controllers/general_ledger_controller.dart';

import 'package:erp_mobile_cnplus/features/accounting/cash_bank_report/data/datasources/cash_bank_report_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/accounting/cash_bank_report/data/repositories/cash_bank_report_repository.dart';
import 'package:erp_mobile_cnplus/features/accounting/cash_bank_report/domain/usecases/cash_bank_report_usecases.dart';
import 'package:erp_mobile_cnplus/features/accounting/cash_bank_report/presentation/controllers/cash_bank_report_controller.dart';

import 'package:erp_mobile_cnplus/features/accounting/trial_balance/data/datasources/trial_balance_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/accounting/trial_balance/data/repositories/trial_balance_repository.dart';
import 'package:erp_mobile_cnplus/features/accounting/trial_balance/domain/usecases/trial_balance_usecases.dart';
import 'package:erp_mobile_cnplus/features/accounting/trial_balance/presentation/controllers/trial_balance_controller.dart';

import 'package:erp_mobile_cnplus/features/accounting/cash_flow/data/datasources/cash_flow_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/accounting/cash_flow/data/repositories/cash_flow_repository.dart';
import 'package:erp_mobile_cnplus/features/accounting/cash_flow/domain/usecases/cash_flow_usecases.dart';
import 'package:erp_mobile_cnplus/features/accounting/cash_flow/presentation/controllers/cash_flow_controller.dart';

import 'package:erp_mobile_cnplus/features/accounting/balance_sheet/data/datasources/balance_sheet_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/accounting/balance_sheet/data/repositories/balance_sheet_repository.dart';
import 'package:erp_mobile_cnplus/features/accounting/balance_sheet/domain/usecases/balance_sheet_usecases.dart';
import 'package:erp_mobile_cnplus/features/accounting/balance_sheet/presentation/controllers/balance_sheet_controller.dart';

import 'package:erp_mobile_cnplus/features/accounting/profit_loss/data/datasources/profit_loss_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/accounting/profit_loss/data/repositories/profit_loss_repository.dart';
import 'package:erp_mobile_cnplus/features/accounting/profit_loss/domain/usecases/profit_loss_usecases.dart';
import 'package:erp_mobile_cnplus/features/accounting/profit_loss/presentation/controllers/profit_loss_controller.dart';

import 'package:erp_mobile_cnplus/features/accounting/ar_aging_report/data/datasources/ar_aging_report_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/accounting/ar_aging_report/data/repositories/ar_aging_report_repository.dart';
import 'package:erp_mobile_cnplus/features/accounting/ar_aging_report/domain/usecases/ar_aging_report_usecases.dart';
import 'package:erp_mobile_cnplus/features/accounting/ar_aging_report/presentation/controllers/ar_aging_report_controller.dart';

import 'package:erp_mobile_cnplus/features/accounting/billing_tax_report/data/datasources/billing_tax_report_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/accounting/billing_tax_report/data/repositories/billing_tax_report_repository.dart';
import 'package:erp_mobile_cnplus/features/accounting/billing_tax_report/domain/usecases/billing_tax_report_usecases.dart';
import 'package:erp_mobile_cnplus/features/accounting/billing_tax_report/presentation/controllers/billing_tax_report_controller.dart';

import 'package:erp_mobile_cnplus/features/accounting/check_balance_journal/data/datasources/check_balance_journal_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/accounting/check_balance_journal/data/repositories/check_balance_journal_repository.dart';
import 'package:erp_mobile_cnplus/features/accounting/check_balance_journal/domain/usecases/check_balance_journal_usecases.dart';
import 'package:erp_mobile_cnplus/features/accounting/check_balance_journal/presentation/controllers/check_balance_journal_controller.dart';

import 'package:erp_mobile_cnplus/features/accounting/depreciation_report/data/datasources/depreciation_report_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/accounting/depreciation_report/data/repositories/depreciation_report_repository.dart';
import 'package:erp_mobile_cnplus/features/accounting/depreciation_report/domain/usecases/depreciation_report_usecases.dart';
import 'package:erp_mobile_cnplus/features/accounting/depreciation_report/presentation/controllers/depreciation_report_controller.dart';

// MANUFACTURING
// -- Workstation
import 'package:erp_mobile_cnplus/features/manufacturing/workstation/data/datasources/workstation_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/manufacturing/workstation/data/repositories/workstation_repository.dart';
import 'package:erp_mobile_cnplus/features/manufacturing/workstation/domain/usecases/workstation_usecases.dart';
import 'package:erp_mobile_cnplus/features/manufacturing/workstation/presentation/controllers/workstation_controller.dart';

// -- Bill of Material
import 'package:erp_mobile_cnplus/features/manufacturing/bom/data/datasources/bom_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/manufacturing/bom/data/repositories/bom_repository.dart';
import 'package:erp_mobile_cnplus/features/manufacturing/bom/domain/usecases/bom_usecases.dart';
import 'package:erp_mobile_cnplus/features/manufacturing/bom/presentation/controllers/bom_controller.dart';

// -- Manufacturing Order
import 'package:erp_mobile_cnplus/features/manufacturing/manufacturing_order/data/datasources/manufacturing_order_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/manufacturing/manufacturing_order/data/repositories/manufacturing_order_repository.dart';
import 'package:erp_mobile_cnplus/features/manufacturing/manufacturing_order/domain/usecases/manufacturing_order_usecases.dart';
import 'package:erp_mobile_cnplus/features/manufacturing/manufacturing_order/presentation/controllers/manufacturing_order_controller.dart';

// -- Unbuild Order
import 'package:erp_mobile_cnplus/features/manufacturing/unbuild_order/data/datasources/unbuild_order_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/manufacturing/unbuild_order/data/repositories/unbuild_order_repository.dart';
import 'package:erp_mobile_cnplus/features/manufacturing/unbuild_order/domain/usecases/unbuild_order_usecases.dart';
import 'package:erp_mobile_cnplus/features/manufacturing/unbuild_order/presentation/controllers/unbuild_order_controller.dart';

// -- Work Order
import 'package:erp_mobile_cnplus/features/manufacturing/work_order/data/datasources/work_order_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/manufacturing/work_order/data/repositories/work_order_repository.dart';
import 'package:erp_mobile_cnplus/features/manufacturing/work_order/domain/usecases/work_order_usecases.dart';
import 'package:erp_mobile_cnplus/features/manufacturing/work_order/presentation/controllers/work_order_controller.dart';

// POS
// -- Store
import 'package:erp_mobile_cnplus/features/pos/store/data/datasources/store_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/pos/store/data/repositories/store_repository.dart';
import 'package:erp_mobile_cnplus/features/pos/store/domain/usecases/store_usecases.dart';
import 'package:erp_mobile_cnplus/features/pos/store/presentation/controllers/store_controller.dart';

// -- Printer Config
import 'package:erp_mobile_cnplus/features/pos/printer_config/data/datasources/printer_config_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/pos/printer_config/data/repositories/printer_config_repository.dart';
import 'package:erp_mobile_cnplus/features/pos/printer_config/domain/usecases/printer_config_usecases.dart';
import 'package:erp_mobile_cnplus/features/pos/printer_config/presentation/controllers/printer_config_controller.dart';

// -- Top Customer Report
import 'package:erp_mobile_cnplus/features/pos/top_customer_report/data/datasources/top_customer_report_remote_datasource.dart' as pos_top_customer_report;
import 'package:erp_mobile_cnplus/features/pos/top_customer_report/data/repositories/top_customer_report_repository.dart' as pos_top_customer_report;
import 'package:erp_mobile_cnplus/features/pos/top_customer_report/domain/usecases/top_customer_report_usecases.dart' as pos_top_customer_report;
import 'package:erp_mobile_cnplus/features/pos/top_customer_report/presentation/controllers/top_customer_report_controller.dart' as pos_top_customer_report;

// -- Sold Product Report
import 'package:erp_mobile_cnplus/features/pos/sold_product_report/data/datasources/sold_product_report_remote_datasource.dart' as pos_sold_product_report;
import 'package:erp_mobile_cnplus/features/pos/sold_product_report/data/repositories/sold_product_report_repository.dart' as pos_sold_product_report;
import 'package:erp_mobile_cnplus/features/pos/sold_product_report/domain/usecases/sold_product_report_usecases.dart' as pos_sold_product_report;
import 'package:erp_mobile_cnplus/features/pos/sold_product_report/presentation/controllers/sold_product_report_controller.dart' as pos_sold_product_report;

// -- Store Session Report
import 'package:erp_mobile_cnplus/features/pos/store_session_report/data/datasources/store_session_report_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/pos/store_session_report/data/repositories/store_session_report_repository.dart';
import 'package:erp_mobile_cnplus/features/pos/store_session_report/domain/usecases/store_session_report_usecases.dart';
import 'package:erp_mobile_cnplus/features/pos/store_session_report/presentation/controllers/store_session_report_controller.dart';

// -- Transaction History
import 'package:erp_mobile_cnplus/features/pos/transaction_history/data/datasources/transaction_history_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/pos/transaction_history/data/repositories/transaction_history_repository.dart';
import 'package:erp_mobile_cnplus/features/pos/transaction_history/domain/usecases/transaction_history_usecases.dart';
import 'package:erp_mobile_cnplus/features/pos/transaction_history/presentation/controllers/transaction_history_controller.dart';

// -- POS Transaction
import 'package:erp_mobile_cnplus/features/pos/transaction/data/datasources/pos_transaction_remote_datasource.dart';
import 'package:erp_mobile_cnplus/features/pos/transaction/data/repositories/pos_transaction_repository.dart';
import 'package:erp_mobile_cnplus/features/pos/transaction/domain/usecases/pos_transaction_usecases.dart';
import 'package:erp_mobile_cnplus/features/pos/transaction/presentation/controllers/pos_session_controller.dart';
import 'package:erp_mobile_cnplus/features/pos/transaction/presentation/controllers/pos_sale_controller.dart';

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
    getIt.registerLazySingleton<HrRemoteDataSource>(() => HrRemoteDataSource(getIt<DioClient>().dio));
    getIt.registerLazySingleton<HrDashboardRepository>(() => HrDashboardRepository(remoteDataSource: getIt()));
    getIt.registerLazySingleton(() => GetHrDashboardData(getIt()));
    getIt.registerLazySingleton(() => GetHrStaffDashboardData(getIt()));
    getIt.registerFactory<HrDashboardController>(() => HrDashboardController(
      getHrDashboardData: getIt(),
      getHrStaffDashboardData: getIt(),
    ));

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

    // ==================== ACCOUNTING ASSET CATEGORY ====================
    getIt.registerLazySingleton<AssetCategoryRemoteDataSource>(() => AssetCategoryRemoteDataSource(getIt<DioClient>().dio));
    getIt.registerLazySingleton<AssetCategoryRepository>(() => AssetCategoryRepository(getIt()));
    getIt.registerLazySingleton(() => GetAssetCategoryList(getIt()));
    getIt.registerLazySingleton(() => GetAssetCategoryDetail(getIt()));
    getIt.registerLazySingleton(() => GetAssetCategoryFormOptions(getIt()));
    getIt.registerLazySingleton(() => SaveAssetCategory(getIt()));
    getIt.registerLazySingleton(() => DeleteAssetCategory(getIt()));
    getIt.registerLazySingleton<AssetCategoryController>(
      () => AssetCategoryController(
        getList: getIt(), getDetail: getIt(), getFormOptions: getIt(),
        saveAC: getIt(), deleteAC: getIt(),
      ),
    );

    // ==================== ACCOUNTING FIXED ASSET ====================
    getIt.registerLazySingleton<FixedAssetRemoteDataSource>(() => FixedAssetRemoteDataSource(getIt<DioClient>().dio));
    getIt.registerLazySingleton<FixedAssetRepository>(() => FixedAssetRepository(getIt()));
    getIt.registerLazySingleton(() => GetFixedAssetList(getIt()));
    getIt.registerLazySingleton(() => GetFixedAssetDetail(getIt()));
    getIt.registerLazySingleton(() => GetFixedAssetFormOptions(getIt()));
    getIt.registerLazySingleton(() => SaveFixedAsset(getIt()));
    getIt.registerLazySingleton(() => DeleteFixedAsset(getIt()));
    getIt.registerLazySingleton<FixedAssetController>(
      () => FixedAssetController(
        getList: getIt(), getDetail: getIt(), getFormOptions: getIt(),
        saveFA: getIt(), deleteFA: getIt(),
      ),
    );

    // ==================== ACCOUNTING CASH BANK ====================
    getIt.registerLazySingleton<CashBankRemoteDataSource>(() => CashBankRemoteDataSource(getIt<DioClient>().dio));
    getIt.registerLazySingleton<CashBankRepository>(() => CashBankRepository(getIt()));
    getIt.registerLazySingleton(() => GetCashBankList(getIt()));
    getIt.registerLazySingleton(() => GetCashBankDetail(getIt()));
    getIt.registerLazySingleton(() => GetCashBankFormOptions(getIt()));
    getIt.registerLazySingleton(() => SaveCashBank(getIt()));
    getIt.registerLazySingleton(() => PostCashBank(getIt()));
    getIt.registerLazySingleton(() => UnpostCashBank(getIt()));
    getIt.registerLazySingleton(() => DeleteCashBank(getIt()));
    getIt.registerLazySingleton(() => BulkPostCashBank(getIt()));
    getIt.registerLazySingleton<CashBankController>(
      () => CashBankController(
        getList: getIt(),
        getDetail: getIt(),
        getFormOptions: getIt(),
        saveCB: getIt(),
        postCB: getIt(),
        unpostCB: getIt(),
        deleteCB: getIt(),
        bulkPostCB: getIt(),
      ),
    );

    // ==================== ACCOUNTING JOURNAL ENTRY ====================
    getIt.registerLazySingleton<JournalEntryRemoteDataSource>(() => JournalEntryRemoteDataSource(getIt<DioClient>().dio));
    getIt.registerLazySingleton<JournalEntryRepository>(() => JournalEntryRepository(getIt()));
    getIt.registerLazySingleton(() => GetJournalEntryList(getIt()));
    getIt.registerLazySingleton(() => GetJournalEntryDetail(getIt()));
    getIt.registerLazySingleton(() => GetJournalEntryFormOptions(getIt()));
    getIt.registerLazySingleton(() => SaveJournalEntry(getIt()));
    getIt.registerLazySingleton(() => PostJournalEntry(getIt()));
    getIt.registerLazySingleton(() => UnpostJournalEntry(getIt()));
    getIt.registerLazySingleton(() => DeleteJournalEntry(getIt()));
    getIt.registerLazySingleton<JournalEntryController>(
      () => JournalEntryController(
        getList: getIt(),
        getDetail: getIt(),
        getFormOptions: getIt(),
        saveJE: getIt(),
        postJE: getIt(),
        unpostJE: getIt(),
        deleteJE: getIt(),
      ),
    );

    // ==================== ACCOUNTING BILL PAYMENT ====================
    getIt.registerLazySingleton<BillPaymentRemoteDataSource>(() => BillPaymentRemoteDataSource(getIt<DioClient>().dio));
    getIt.registerLazySingleton<BillPaymentRepository>(() => BillPaymentRepository(getIt()));
    getIt.registerLazySingleton(() => GetBillPaymentList(getIt()));
    getIt.registerLazySingleton(() => GetBillPaymentDetail(getIt()));
    getIt.registerLazySingleton(() => GetBillPaymentFormOptions(getIt()));
    getIt.registerLazySingleton(() => GetPayableBills(getIt()));
    getIt.registerLazySingleton(() => SaveBillPayment(getIt()));
    getIt.registerLazySingleton(() => ConfirmBillPayment(getIt()));
    getIt.registerLazySingleton(() => PostBillPayment(getIt()));
    getIt.registerLazySingleton(() => UnpostBillPayment(getIt()));
    getIt.registerLazySingleton(() => CancelBillPayment(getIt()));
    getIt.registerLazySingleton(() => DeleteBillPayment(getIt()));
    getIt.registerLazySingleton<BillPaymentController>(
      () => BillPaymentController(
        getList: getIt(),
        getDetail: getIt(),
        getFormOptions: getIt(),
        getPayableBillsUC: getIt(),
        saveBP: getIt(),
        confirmBP: getIt(),
        postBP: getIt(),
        unpostBP: getIt(),
        cancelBP: getIt(),
        deleteBP: getIt(),
      ),
    );

    // ==================== ACCOUNTING INVOICE PAYMENT ====================
    getIt.registerLazySingleton<InvoicePaymentRemoteDataSource>(() => InvoicePaymentRemoteDataSource(getIt<DioClient>().dio));
    getIt.registerLazySingleton<InvoicePaymentRepository>(() => InvoicePaymentRepository(getIt()));
    getIt.registerLazySingleton(() => GetInvoicePaymentList(getIt()));
    getIt.registerLazySingleton(() => GetInvoicePaymentDetail(getIt()));
    getIt.registerLazySingleton(() => GetInvoicePaymentFormOptions(getIt()));
    getIt.registerLazySingleton(() => GetCustomerInvoices(getIt()));
    getIt.registerLazySingleton(() => SaveInvoicePayment(getIt()));
    getIt.registerLazySingleton(() => ConfirmInvoicePayment(getIt()));
    getIt.registerLazySingleton(() => PostInvoicePayment(getIt()));
    getIt.registerLazySingleton(() => UnpostInvoicePayment(getIt()));
    getIt.registerLazySingleton(() => CancelInvoicePayment(getIt()));
    getIt.registerLazySingleton(() => DeleteInvoicePayment(getIt()));
    getIt.registerLazySingleton(() => BulkConfirmInvoicePayments(getIt()));
    getIt.registerLazySingleton(() => BulkPostInvoicePayments(getIt()));
    getIt.registerLazySingleton<InvoicePaymentController>(
      () => InvoicePaymentController(
        getList: getIt(),
        getDetail: getIt(),
        getFormOptions: getIt(),
        getCustomerInvoicesUC: getIt(),
        saveIP: getIt(),
        confirmIP: getIt(),
        postIP: getIt(),
        unpostIP: getIt(),
        cancelIP: getIt(),
        deleteIP: getIt(),
        bulkConfirmIP: getIt(),
        bulkPostIP: getIt(),
      ),
    );

    // ==================== ACCOUNTING PERIOD CLOSING ====================
    getIt.registerLazySingleton<PeriodClosingRemoteDataSource>(() => PeriodClosingRemoteDataSource(getIt<DioClient>().dio));
    getIt.registerLazySingleton<PeriodClosingRepository>(() => PeriodClosingRepository(getIt()));
    getIt.registerLazySingleton(() => GetPeriodClosingList(getIt()));
    getIt.registerLazySingleton(() => GetPeriodClosingDetail(getIt()));
    getIt.registerLazySingleton(() => SavePeriodClosing(getIt()));
    getIt.registerLazySingleton(() => DeletePeriodClosing(getIt()));
    getIt.registerLazySingleton(() => PostPeriodClosing(getIt()));
    getIt.registerLazySingleton(() => GetPeriodClosingBalanceDetail(getIt()));
    getIt.registerLazySingleton<PeriodClosingController>(
      () => PeriodClosingController(
        getList: getIt(),
        getDetail: getIt(),
        savePC: getIt(),
        deletePC: getIt(),
        postPC: getIt(),
        getBalanceDetail: getIt(),
      ),
    );

    // ==================== ACCOUNTING ASSET DEPRECIATION ====================
    getIt.registerLazySingleton<AssetDepreciationRemoteDataSource>(() => AssetDepreciationRemoteDataSource(getIt<DioClient>().dio));
    getIt.registerLazySingleton<AssetDepreciationRepository>(() => AssetDepreciationRepository(getIt()));
    getIt.registerLazySingleton(() => GetAssetDepreciationList(getIt()));
    getIt.registerLazySingleton(() => GetAssetDepreciationDetail(getIt()));
    getIt.registerLazySingleton(() => GetAssetDepreciationFormOptions(getIt()));
    getIt.registerLazySingleton(() => RunAssetDepreciation(getIt()));
    getIt.registerLazySingleton<AssetDepreciationController>(
      () => AssetDepreciationController(
        getList: getIt(),
        getDetail: getIt(),
        getFormOptions: getIt(),
        runDep: getIt(),
      ),
    );

    // ==================== ACCOUNTING ASSET MOVEMENT ====================
    getIt.registerLazySingleton<AssetMovementRemoteDataSource>(() => AssetMovementRemoteDataSource(getIt<DioClient>().dio));
    getIt.registerLazySingleton<AssetMovementRepository>(() => AssetMovementRepository(getIt()));
    getIt.registerLazySingleton(() => GetAssetMovementList(getIt()));
    getIt.registerLazySingleton(() => GetAssetMovementDetail(getIt()));
    getIt.registerLazySingleton(() => GetAssetMovementFormOptions(getIt()));
    getIt.registerLazySingleton(() => SaveAssetMovement(getIt()));
    getIt.registerLazySingleton<AssetMovementController>(
      () => AssetMovementController(
        getList: getIt(),
        getDetail: getIt(),
        getFormOptions: getIt(),
        saveAM: getIt(),
      ),
    );

    // ==================== ACCOUNTING ASSET DISPOSAL ====================
    getIt.registerLazySingleton<AssetDisposalRemoteDataSource>(() => AssetDisposalRemoteDataSource(getIt<DioClient>().dio));
    getIt.registerLazySingleton<AssetDisposalRepository>(() => AssetDisposalRepository(getIt()));
    getIt.registerLazySingleton(() => GetAssetDisposalList(getIt()));
    getIt.registerLazySingleton(() => GetAssetDisposalDetail(getIt()));
    getIt.registerLazySingleton(() => GetAssetDisposalFormOptions(getIt()));
    getIt.registerLazySingleton(() => SaveAssetDisposal(getIt()));
    getIt.registerLazySingleton(() => ConfirmAssetDisposal(getIt()));
    getIt.registerLazySingleton(() => PostAssetDisposal(getIt()));
    getIt.registerLazySingleton(() => CancelAssetDisposal(getIt()));
    getIt.registerLazySingleton(() => DeleteAssetDisposal(getIt()));
    getIt.registerLazySingleton<AssetDisposalController>(
      () => AssetDisposalController(
        getList: getIt(),
        getDetail: getIt(),
        getFormOptions: getIt(),
        saveAD: getIt(),
        confirmAD: getIt(),
        postAD: getIt(),
        cancelAD: getIt(),
        deleteAD: getIt(),
      ),
    );

    // ==================== ACCOUNTING TAX PAYMENT ====================
    getIt.registerLazySingleton<TaxPaymentRemoteDataSource>(() => TaxPaymentRemoteDataSource(getIt<DioClient>().dio));
    getIt.registerLazySingleton<TaxPaymentRepository>(() => TaxPaymentRepository(getIt()));
    getIt.registerLazySingleton(() => GetTaxPaymentList(getIt()));
    getIt.registerLazySingleton(() => GetTaxPaymentDetail(getIt()));
    getIt.registerLazySingleton(() => SearchTaxTransactions(getIt()));
    getIt.registerLazySingleton(() => SaveTaxPayment(getIt()));
    getIt.registerLazySingleton(() => PostTaxPayment(getIt()));
    getIt.registerLazySingleton(() => UnpostTaxPayment(getIt()));
    getIt.registerLazySingleton(() => DeleteTaxPayment(getIt()));
    getIt.registerLazySingleton<TaxPaymentController>(
      () => TaxPaymentController(
        getList: getIt(),
        getDetail: getIt(),
        searchTransactionsUC: getIt(),
        saveTP: getIt(),
        postTP: getIt(),
        unpostTP: getIt(),
        deleteTP: getIt(),
      ),
    );

    // ==================== ACCOUNTING BPE MANAGEMENT ====================
    getIt.registerLazySingleton<BpeRemoteDataSource>(() => BpeRemoteDataSource(getIt<DioClient>().dio));
    getIt.registerLazySingleton<BpeRepository>(() => BpeRepository(getIt()));
    getIt.registerLazySingleton(() => GetBpeList(getIt()));
    getIt.registerLazySingleton(() => GetBpeDetail(getIt()));
    getIt.registerLazySingleton(() => SaveBpe(getIt()));
    getIt.registerLazySingleton(() => ConfirmBpe(getIt()));
    getIt.registerLazySingleton(() => ValidateBpe(getIt()));
    getIt.registerLazySingleton(() => DeleteBpe(getIt()));
    getIt.registerLazySingleton(() => SearchAvailableInvoices(getIt()));
    getIt.registerLazySingleton<BpeManagementController>(
      () => BpeManagementController(
        getList: getIt(),
        getDetail: getIt(),
        saveBpe: getIt(),
        confirmBpe: getIt(),
        validateBpe: getIt(),
        deleteBpe: getIt(),
        searchInvoices: getIt(),
      ),
    );

    // ==================== ACCOUNTING GENERAL LEDGER ====================
    getIt.registerLazySingleton<GeneralLedgerRemoteDataSource>(() => GeneralLedgerRemoteDataSource(getIt<DioClient>().dio));
    getIt.registerLazySingleton<GeneralLedgerRepository>(() => GeneralLedgerRepository(getIt()));
    getIt.registerLazySingleton(() => GetGeneralLedgerReport(getIt()));
    getIt.registerLazySingleton(() => GetGeneralLedgerFormOptions(getIt()));
    getIt.registerLazySingleton(() => GetGeneralLedgerExportPdfUrl(getIt()));
    getIt.registerLazySingleton(() => GetGeneralLedgerExportExcelUrl(getIt()));
    getIt.registerLazySingleton<GeneralLedgerController>(
      () => GeneralLedgerController(
        getReport: getIt(),
        getFormOptions: getIt(),
        getExportPdfUrl: getIt(),
        getExportExcelUrl: getIt(),
      ),
    );

    // ==================== ACCOUNTING CASH BANK REPORT ====================
    getIt.registerLazySingleton<CashBankReportRemoteDataSource>(() => CashBankReportRemoteDataSource(getIt<DioClient>().dio));
    getIt.registerLazySingleton<CashBankReportRepository>(() => CashBankReportRepository(getIt()));
    getIt.registerLazySingleton(() => GetCashBankReport(getIt()));
    getIt.registerLazySingleton(() => GetCashBankReportFormOptions(getIt()));
    getIt.registerLazySingleton(() => GetCashBankReportExportPdfUrl(getIt()));
    getIt.registerLazySingleton(() => GetCashBankReportExportExcelUrl(getIt()));
    getIt.registerLazySingleton<CashBankReportController>(
      () => CashBankReportController(
        getReport: getIt(),
        getFormOptions: getIt(),
        getExportPdfUrl: getIt(),
        getExportExcelUrl: getIt(),
      ),
    );

    // ==================== ACCOUNTING TRIAL BALANCE ====================
    getIt.registerLazySingleton<TrialBalanceRemoteDataSource>(() => TrialBalanceRemoteDataSource(getIt<DioClient>().dio));
    getIt.registerLazySingleton<TrialBalanceRepository>(() => TrialBalanceRepository(getIt()));
    getIt.registerLazySingleton(() => GetTrialBalanceReport(getIt()));
    getIt.registerLazySingleton(() => GetTrialBalanceExportPdfUrl(getIt()));
    getIt.registerLazySingleton(() => GetTrialBalanceExportExcelUrl(getIt()));
    getIt.registerLazySingleton<TrialBalanceController>(
      () => TrialBalanceController(
        getReport: getIt(),
        getExportPdfUrl: getIt(),
        getExportExcelUrl: getIt(),
      ),
    );

    // ==================== ACCOUNTING CASH FLOW ====================
    getIt.registerLazySingleton<CashFlowRemoteDataSource>(() => CashFlowRemoteDataSource(getIt<DioClient>().dio));
    getIt.registerLazySingleton<CashFlowRepository>(() => CashFlowRepository(getIt()));
    getIt.registerLazySingleton(() => GetCashFlowReport(getIt()));
    getIt.registerLazySingleton(() => GetCashFlowExportPdfUrl(getIt()));
    getIt.registerLazySingleton(() => GetCashFlowExportExcelUrl(getIt()));
    getIt.registerLazySingleton<CashFlowController>(
      () => CashFlowController(
        getReport: getIt(),
        getExportPdfUrl: getIt(),
        getExportExcelUrl: getIt(),
      ),
    );

    // ==================== ACCOUNTING PROFIT LOSS ====================
    getIt.registerLazySingleton<ProfitLossRemoteDataSource>(() => ProfitLossRemoteDataSource(getIt<DioClient>().dio));
    getIt.registerLazySingleton<ProfitLossRepository>(() => ProfitLossRepository(getIt()));
    getIt.registerLazySingleton(() => GetProfitLossReport(getIt()));
    getIt.registerLazySingleton(() => GetProfitLossExportPdfUrl(getIt()));
    getIt.registerLazySingleton(() => GetProfitLossExportExcelUrl(getIt()));
    getIt.registerLazySingleton<ProfitLossController>(
      () => ProfitLossController(
        getReport: getIt(),
        getExportPdfUrl: getIt(),
        getExportExcelUrl: getIt(),
      ),
    );

    // ==================== ACCOUNTING BALANCE SHEET ====================
    getIt.registerLazySingleton<BalanceSheetRemoteDataSource>(() => BalanceSheetRemoteDataSource(getIt<DioClient>().dio));
    getIt.registerLazySingleton<BalanceSheetRepository>(() => BalanceSheetRepository(getIt()));
    getIt.registerLazySingleton(() => GetBalanceSheetReport(getIt()));
    getIt.registerLazySingleton(() => GetBalanceSheetExportPdfUrl(getIt()));
    getIt.registerLazySingleton(() => GetBalanceSheetExportExcelUrl(getIt()));
    getIt.registerLazySingleton<BalanceSheetController>(
      () => BalanceSheetController(
        getReport: getIt(),
        getExportPdfUrl: getIt(),
        getExportExcelUrl: getIt(),
      ),
    );

    // ==================== ACCOUNTING CHECK BALANCE JOURNAL ====================
    getIt.registerLazySingleton<CheckBalanceJournalRemoteDataSource>(() => CheckBalanceJournalRemoteDataSource(getIt<DioClient>().dio));
    getIt.registerLazySingleton<CheckBalanceJournalRepository>(() => CheckBalanceJournalRepository(getIt()));
    getIt.registerLazySingleton(() => GetCheckBalanceJournalReport(getIt()));
    getIt.registerLazySingleton(() => GetCheckBalanceJournalExportPdfUrl(getIt()));
    getIt.registerLazySingleton(() => GetCheckBalanceJournalExportExcelUrl(getIt()));
    getIt.registerLazySingleton<CheckBalanceJournalController>(
      () => CheckBalanceJournalController(
        getReport: getIt(),
        getExportPdfUrl: getIt(),
        getExportExcelUrl: getIt(),
      ),
    );

    // ==================== ACCOUNTING AR AGING REPORT ====================
    getIt.registerLazySingleton<ARAgingReportRemoteDataSource>(() => ARAgingReportRemoteDataSource(getIt<DioClient>().dio));
    getIt.registerLazySingleton<ARAgingReportRepository>(() => ARAgingReportRepository(getIt()));
    getIt.registerLazySingleton(() => GetARAgingReport(getIt()));
    getIt.registerLazySingleton(() => GetARAgingFormOptions(getIt()));
    getIt.registerLazySingleton(() => GetARAgingExportPdfUrl(getIt()));
    getIt.registerLazySingleton(() => GetARAgingExportExcelUrl(getIt()));
    getIt.registerLazySingleton<ARAgingReportController>(
      () => ARAgingReportController(
        getReport: getIt(),
        getFormOptions: getIt(),
        getExportPdfUrl: getIt(),
        getExportExcelUrl: getIt(),
      ),
    );

    // ==================== ACCOUNTING BILLING TAX REPORT ====================
    getIt.registerLazySingleton<BillingTaxReportRemoteDataSource>(() => BillingTaxReportRemoteDataSource(getIt<DioClient>().dio));
    getIt.registerLazySingleton<BillingTaxReportRepository>(() => BillingTaxReportRepository(getIt()));
    getIt.registerLazySingleton(() => GetBillingTaxReport(getIt()));
    getIt.registerLazySingleton(() => GetBillingTaxFormOptions(getIt()));
    getIt.registerLazySingleton(() => GetBillingTaxExportExcelUrl(getIt()));
    getIt.registerLazySingleton<BillingTaxReportController>(
      () => BillingTaxReportController(
        getReport: getIt(),
        getFormOptions: getIt(),
        getExportExcelUrl: getIt(),
      ),
    );

    // ==================== ACCOUNTING DEPRECIATION REPORT ====================
    getIt.registerLazySingleton<DepreciationReportRemoteDataSource>(() => DepreciationReportRemoteDataSource(getIt<DioClient>().dio));
    getIt.registerLazySingleton<DepreciationReportRepository>(() => DepreciationReportRepository(getIt()));
    getIt.registerLazySingleton(() => GetDepreciationReport(getIt()));
    getIt.registerLazySingleton(() => GetDepreciationReportExportPdfUrl(getIt()));
    getIt.registerLazySingleton(() => GetDepreciationReportExportExcelUrl(getIt()));
    getIt.registerLazySingleton<DepreciationReportController>(
      () => DepreciationReportController(
        getReport: getIt(),
        getExportPdfUrl: getIt(),
        getExportExcelUrl: getIt(),
      ),
    );

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

    // ==================== MANUFACTURING ORDER ====================
    getIt.registerLazySingleton<ManufacturingOrderRemoteDataSource>(() => ManufacturingOrderRemoteDataSource(getIt<DioClient>().dio));
    getIt.registerLazySingleton<ManufacturingOrderRepository>(() => ManufacturingOrderRepository(getIt()));
    getIt.registerLazySingleton(() => GetMOList(getIt()));
    getIt.registerLazySingleton(() => GetMODetail(getIt()));
    getIt.registerLazySingleton(() => GetMOFormOptions(getIt()));
    getIt.registerLazySingleton(() => GetMOProductBoms(getIt()));
    getIt.registerLazySingleton(() => GetMOBomDetails(getIt()));
    getIt.registerLazySingleton(() => GetMOBomComponents(getIt()));
    getIt.registerLazySingleton(() => GetMOPlanMaterials(getIt()));
    getIt.registerLazySingleton(() => SaveManufacturingOrder(getIt()));
    getIt.registerLazySingleton(() => DeleteManufacturingOrder(getIt()));
    getIt.registerLazySingleton(() => ApproveManufacturingOrder(getIt()));
    getIt.registerLazySingleton(() => RejectManufacturingOrder(getIt()));
    getIt.registerLazySingleton(() => GetMOSteps(getIt()));
    getIt.registerLazySingleton(() => CreateUnbuildFromMO(getIt()));
    getIt.registerLazySingleton(() => StartMOOperation(getIt()));
    getIt.registerLazySingleton(() => PauseMOOperation(getIt()));
    getIt.registerLazySingleton(() => ResumeMOOperation(getIt()));
    getIt.registerLazySingleton(() => CompleteMOOperation(getIt()));
    getIt.registerLazySingleton<ManufacturingOrderController>(
      () => ManufacturingOrderController(
        getList:                 getIt(),
        getDetail:               getIt(),
        getFormOptions:          getIt(),
        getProductBoms:          getIt(),
        getBomDetails:           getIt(),
        getBomComponents:        getIt(),
        getPlanMaterials:        getIt(),
        saveMO:                  getIt(),
        deleteMO:                getIt(),
        approveMO:               getIt(),
        rejectMO:                getIt(),
        getSteps:                getIt(),
        createUnbuild:           getIt(),
        startOperation:          getIt(),
        pauseOperation:          getIt(),
        resumeOperation:         getIt(),
        completeOperation:       getIt(),
      ),
    );

    // ==================== UNBUILD ORDER ====================
    getIt.registerLazySingleton<UnbuildOrderRemoteDataSource>(() => UnbuildOrderRemoteDataSource(getIt<DioClient>().dio));
    getIt.registerLazySingleton<UnbuildOrderRepository>(() => UnbuildOrderRepository(getIt()));
    getIt.registerLazySingleton(() => GetUOList(getIt()));
    getIt.registerLazySingleton(() => GetUODetail(getIt()));
    getIt.registerLazySingleton(() => GetUOFormOptions(getIt()));
    getIt.registerLazySingleton(() => GenerateUOReference(getIt()));
    getIt.registerLazySingleton(() => GetUOComponentsPreview(getIt()));
    getIt.registerLazySingleton(() => GetUOManufacturingOrderDetails(getIt()));
    getIt.registerLazySingleton(() => SaveUnbuildOrder(getIt()));
    getIt.registerLazySingleton(() => DeleteUnbuildOrder(getIt()));
    getIt.registerLazySingleton(() => ApproveUnbuildOrder(getIt()));
    getIt.registerLazySingleton(() => RejectUnbuildOrder(getIt()));
    getIt.registerLazySingleton(() => GetUOSteps(getIt()));
    getIt.registerLazySingleton<UnbuildOrderController>(
      () => UnbuildOrderController(
        getList:                      getIt(),
        getDetail:                    getIt(),
        getFormOptions:               getIt(),
        generateReference:            getIt(),
        getComponentsPreview:         getIt(),
        getManufacturingOrderDetails: getIt(),
        saveUO:                       getIt(),
        deleteUO:                     getIt(),
        approveUO:                    getIt(),
        rejectUO:                     getIt(),
        getSteps:                     getIt(),
      ),
    );

    // ==================== WORK ORDER ====================
    getIt.registerLazySingleton<WorkOrderRemoteDataSource>(() => WorkOrderRemoteDataSource(getIt<DioClient>().dio));
    getIt.registerLazySingleton<WorkOrderRepository>(() => WorkOrderRepository(getIt()));
    getIt.registerLazySingleton(() => GetWOList(getIt()));
    getIt.registerLazySingleton(() => GetWOFormOptions(getIt()));
    getIt.registerLazySingleton(() => StartWorkOrder(getIt()));
    getIt.registerLazySingleton(() => PauseWorkOrder(getIt()));
    getIt.registerLazySingleton(() => ResumeWorkOrder(getIt()));
    getIt.registerLazySingleton(() => CompleteWorkOrder(getIt()));
    getIt.registerLazySingleton<WorkOrderController>(
      () => WorkOrderController(
        getList:        getIt(),
        getFormOptions: getIt(),
        startWO:        getIt(),
        pauseWO:        getIt(),
        resumeWO:       getIt(),
        completeWO:     getIt(),
      ),
    );
    
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

    // ==================== POS: PRINTER CONFIG ====================
    getIt.registerLazySingleton<PrinterConfigRemoteDataSource>(() => PrinterConfigRemoteDataSource(getIt<DioClient>().dio));
    getIt.registerLazySingleton<PrinterConfigRepository>(() => PrinterConfigRepository(getIt()));
    getIt.registerLazySingleton(() => GetPrinterConfigList(getIt()));
    getIt.registerLazySingleton(() => GetPrinterConfigDetail(getIt()));
    getIt.registerLazySingleton(() => SavePrinterConfig(getIt()));
    getIt.registerLazySingleton(() => DeletePrinterConfig(getIt()));
    getIt.registerLazySingleton(() => SetDefaultPrinterConfig(getIt()));
    getIt.registerLazySingleton<PrinterConfigController>(
      () => PrinterConfigController(
        getList:           getIt(),
        getDetail:         getIt(),
        savePrinter:       getIt(),
        deletePrinter:     getIt(),
        setDefaultPrinter: getIt(),
      ),
    );

    // ==================== POS: TOP CUSTOMER REPORT ====================
    getIt.registerLazySingleton<pos_top_customer_report.TopCustomerReportRemoteDataSource>(
      () => pos_top_customer_report.TopCustomerReportRemoteDataSource(getIt<DioClient>().dio),
    );
    getIt.registerLazySingleton<pos_top_customer_report.TopCustomerReportRepository>(
      () => pos_top_customer_report.TopCustomerReportRepository(
        getIt<pos_top_customer_report.TopCustomerReportRemoteDataSource>(),
      ),
    );
    getIt.registerLazySingleton(
      () => pos_top_customer_report.GetTopCustomerReportList(
        getIt<pos_top_customer_report.TopCustomerReportRepository>(),
      ),
    );
    getIt.registerLazySingleton(
      () => pos_top_customer_report.GetTopCustomerReportFormOptions(
        getIt<pos_top_customer_report.TopCustomerReportRepository>(),
      ),
    );
    getIt.registerFactory<pos_top_customer_report.TopCustomerReportController>(
      () => pos_top_customer_report.TopCustomerReportController(
        getList:        getIt<pos_top_customer_report.GetTopCustomerReportList>(),
        getFormOptions: getIt<pos_top_customer_report.GetTopCustomerReportFormOptions>(),
      ),
    );

    // ==================== POS: SOLD PRODUCT REPORT ====================
    getIt.registerLazySingleton<pos_sold_product_report.SoldProductReportRemoteDataSource>(
      () => pos_sold_product_report.SoldProductReportRemoteDataSource(getIt<DioClient>().dio),
    );
    getIt.registerLazySingleton<pos_sold_product_report.SoldProductReportRepository>(
      () => pos_sold_product_report.SoldProductReportRepository(
        getIt<pos_sold_product_report.SoldProductReportRemoteDataSource>(),
      ),
    );
    getIt.registerLazySingleton(
      () => pos_sold_product_report.GetSoldProductReportList(
        getIt<pos_sold_product_report.SoldProductReportRepository>(),
      ),
    );
    getIt.registerLazySingleton(
      () => pos_sold_product_report.GetSoldProductReportFormOptions(
        getIt<pos_sold_product_report.SoldProductReportRepository>(),
      ),
    );
    getIt.registerFactory<pos_sold_product_report.SoldProductReportController>(
      () => pos_sold_product_report.SoldProductReportController(
        getList:        getIt<pos_sold_product_report.GetSoldProductReportList>(),
        getFormOptions: getIt<pos_sold_product_report.GetSoldProductReportFormOptions>(),
      ),
    );

    // ==================== POS: STORE SESSION REPORT ====================
    getIt.registerLazySingleton<StoreSessionReportRemoteDataSource>(() => StoreSessionReportRemoteDataSource(getIt<DioClient>().dio));
    getIt.registerLazySingleton<StoreSessionReportRepository>(() => StoreSessionReportRepository(getIt()));
    getIt.registerLazySingleton(() => GetStoreSessionList(getIt()));
    getIt.registerLazySingleton(() => GetStoreSessionFormOptions(getIt()));
    getIt.registerLazySingleton(() => GetStoreSessionDetail(getIt()));
    getIt.registerLazySingleton(() => GetStoreSessionTransactions(getIt()));
    getIt.registerLazySingleton(() => GetStoreSessionCashMovements(getIt()));
    getIt.registerLazySingleton(() => GetSessionTransactionDetail(getIt()));
    getIt.registerLazySingleton(() => GetStoreSessionExportUrl(getIt()));
    getIt.registerLazySingleton(() => GetSessionTransactionExportUrl(getIt()));
    getIt.registerFactory<StoreSessionReportController>(() => StoreSessionReportController(
      getList: getIt(),
      getFormOptions: getIt(),
      getDetail: getIt(),
      getTransactions: getIt(),
      getCashMovements: getIt(),
      getTransactionDetail: getIt(),
      getExportSessionUrl: getIt(),
      getExportTransactionUrl: getIt(),
    ));

    // ==================== POS: TRANSACTION HISTORY ====================
    getIt.registerLazySingleton<TransactionHistoryRemoteDataSource>(() => TransactionHistoryRemoteDataSource(getIt<DioClient>().dio));
    getIt.registerLazySingleton<TransactionHistoryRepository>(() => TransactionHistoryRepository(getIt()));
    getIt.registerLazySingleton(() => GetTransactionHistoryList(getIt()));
    getIt.registerLazySingleton(() => GetTransactionHistoryFormOptions(getIt()));
    getIt.registerLazySingleton(() => GetTransactionHistoryDetail(getIt()));
    getIt.registerLazySingleton(() => GetTransactionHistoryExportUrl(getIt()));
    getIt.registerLazySingleton(() => GetTransactionHistoryDetailExportUrl(getIt()));
    getIt.registerFactory<TransactionHistoryController>(() => TransactionHistoryController(
      getList: getIt(),
      getFormOptions: getIt(),
      getDetail: getIt(),
      getExportListUrl: getIt(),
      getExportDetailUrl: getIt(),
    ));

    // ==================== POS: TRANSACTION ====================
    getIt.registerLazySingleton<PosTransactionRemoteDataSource>(() => PosTransactionRemoteDataSource(getIt<DioClient>().dio));
    getIt.registerLazySingleton<PosTransactionRepository>(() => PosTransactionRepository(getIt()));
    getIt.registerLazySingleton(() => GetPosCurrentSession(getIt()));
    getIt.registerLazySingleton(() => OpenPosSession(getIt()));
    getIt.registerLazySingleton(() => GetPosCloseSummary(getIt()));
    getIt.registerLazySingleton(() => ClosePosSession(getIt()));
    getIt.registerLazySingleton(() => GetPosFormOptions(getIt()));
    getIt.registerLazySingleton(() => GetPosProducts(getIt()));
    getIt.registerLazySingleton(() => PollPosStock(getIt()));
    getIt.registerLazySingleton(() => CreatePosMidtransPayment(getIt()));
    getIt.registerLazySingleton(() => SavePosTransaction(getIt()));
    getIt.registerLazySingleton(() => CheckPosPaymentStatus(getIt()));
    getIt.registerLazySingleton(() => SendPosReceiptEmail(getIt()));
    getIt.registerLazySingleton(() => CreatePosCashMovement(getIt()));
    getIt.registerLazySingleton(() => DeletePosCashMovement(getIt()));
    getIt.registerFactory<PosSessionController>(() => PosSessionController(
      getCurrent: getIt(),
      openSessionUC: getIt(),
      getCloseSummaryUC: getIt(),
      closeSessionUC: getIt(),
      createMovementUC: getIt(),
      deleteMovementUC: getIt(),
    ));
    getIt.registerFactory<PosSaleController>(() => PosSaleController(
      getFormOptionsUC: getIt(),
      getProductsUC: getIt(),
      pollStockUC: getIt(),
      createPaymentUC: getIt(),
      saveTransactionUC: getIt(),
      checkStatusUC: getIt(),
      sendReceiptUC: getIt(),
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

    // ==================== SALES QUOTATION REPORT ====================
    getIt.registerLazySingleton<QuotationReportRemoteDataSource>(
      () => QuotationReportRemoteDataSource(getIt<DioClient>().dio),
    );
    getIt.registerLazySingleton<QuotationReportRepository>(
      () => QuotationReportRepository(
        remoteDataSource: getIt<QuotationReportRemoteDataSource>(),
      ),
    );
    getIt.registerLazySingleton(
      () => GetQuotationReportList(getIt<QuotationReportRepository>()),
    );
    getIt.registerLazySingleton(
      () => GetQuotationReportFormOptions(getIt<QuotationReportRepository>()),
    );
    getIt.registerLazySingleton(
      () => GetQuotationReportLocationsByWarehouse(
        getIt<QuotationReportRepository>(),
      ),
    );
    getIt.registerFactory<QuotationReportController>(
      () => QuotationReportController(
        getQuotationReportList: getIt<GetQuotationReportList>(),
        getQuotationReportFormOptions: getIt<GetQuotationReportFormOptions>(),
        getLocationsByWarehouse:
            getIt<GetQuotationReportLocationsByWarehouse>(),
      ),
    );

    // ==================== SALES SALES ORDER REPORT ====================
    getIt.registerLazySingleton<SalesOrderReportRemoteDataSource>(
      () => SalesOrderReportRemoteDataSource(getIt<DioClient>().dio),
    );
    getIt.registerLazySingleton<SalesOrderReportRepository>(
      () => SalesOrderReportRepository(
        remoteDataSource: getIt<SalesOrderReportRemoteDataSource>(),
      ),
    );
    getIt.registerLazySingleton(
      () => GetSalesOrderReportList(getIt<SalesOrderReportRepository>()),
    );
    getIt.registerLazySingleton(
      () => GetSalesOrderReportFormOptions(getIt<SalesOrderReportRepository>()),
    );
    getIt.registerLazySingleton(
      () => GetSalesOrderReportLocationsByWarehouse(
        getIt<SalesOrderReportRepository>(),
      ),
    );
    getIt.registerFactory<SalesOrderReportController>(
      () => SalesOrderReportController(
        getSalesOrderReportList: getIt<GetSalesOrderReportList>(),
        getSalesOrderReportFormOptions: getIt<GetSalesOrderReportFormOptions>(),
        getLocationsByWarehouse:
            getIt<GetSalesOrderReportLocationsByWarehouse>(),
      ),
    );

    // ==================== SALES DIRECT SALES REPORT ====================
    getIt.registerLazySingleton<DirectSalesReportRemoteDataSource>(
      () => DirectSalesReportRemoteDataSource(getIt<DioClient>().dio),
    );
    getIt.registerLazySingleton<DirectSalesReportRepository>(
      () => DirectSalesReportRepository(
        remoteDataSource: getIt<DirectSalesReportRemoteDataSource>(),
      ),
    );
    getIt.registerLazySingleton(
      () => GetDirectSalesReportList(getIt<DirectSalesReportRepository>()),
    );
    getIt.registerLazySingleton(
      () => GetDirectSalesReportFormOptions(getIt<DirectSalesReportRepository>()),
    );
    getIt.registerLazySingleton(
      () => GetDirectSalesReportLocationsByWarehouse(
        getIt<DirectSalesReportRepository>(),
      ),
    );
    getIt.registerFactory<DirectSalesReportController>(
      () => DirectSalesReportController(
        getDirectSalesReportList: getIt<GetDirectSalesReportList>(),
        getDirectSalesReportFormOptions: getIt<GetDirectSalesReportFormOptions>(),
        getLocationsByWarehouse:
            getIt<GetDirectSalesReportLocationsByWarehouse>(),
      ),
    );

    // ==================== SALES INVOICE REPORT ====================
    getIt.registerLazySingleton<InvoiceReportRemoteDataSource>(
      () => InvoiceReportRemoteDataSource(getIt<DioClient>().dio),
    );
    getIt.registerLazySingleton<InvoiceReportRepository>(
      () => InvoiceReportRepository(
        remoteDataSource: getIt<InvoiceReportRemoteDataSource>(),
      ),
    );
    getIt.registerLazySingleton(
      () => GetInvoiceReportList(getIt<InvoiceReportRepository>()),
    );
    getIt.registerLazySingleton(
      () => GetInvoiceReportFormOptions(getIt<InvoiceReportRepository>()),
    );
    getIt.registerFactory<InvoiceReportController>(
      () => InvoiceReportController(
        getInvoiceReportList: getIt<GetInvoiceReportList>(),
        getInvoiceReportFormOptions: getIt<GetInvoiceReportFormOptions>(),
      ),
    );

    // ==================== SALES SERVICE QUOTATION REPORT ====================
    getIt.registerLazySingleton<ServiceQuotationReportRemoteDataSource>(() => ServiceQuotationReportRemoteDataSource(getIt<DioClient>().dio));
    getIt.registerLazySingleton<ServiceQuotationReportRepository>(() => ServiceQuotationReportRepository(remoteDataSource: getIt()));
    getIt.registerLazySingleton(() => GetServiceQuotationReportList(getIt()));
    getIt.registerLazySingleton(() => GetServiceQuotationReportFormOptions(getIt()));
    getIt.registerFactory<ServiceQuotationReportController>(() => ServiceQuotationReportController(
      getServiceQuotationReportList: getIt(),
      getServiceQuotationReportFormOptions: getIt(),
    ));

    // ==================== SALES SERVICE SALES ORDER REPORT ====================
    getIt.registerLazySingleton<ServiceSalesOrderReportRemoteDataSource>(() => ServiceSalesOrderReportRemoteDataSource(getIt<DioClient>().dio));
    getIt.registerLazySingleton<ServiceSalesOrderReportRepository>(() => ServiceSalesOrderReportRepository(remoteDataSource: getIt()));
    getIt.registerLazySingleton(() => GetServiceSalesOrderReportList(getIt()));
    getIt.registerLazySingleton(() => GetServiceSalesOrderReportFormOptions(getIt()));
    getIt.registerFactory<ServiceSalesOrderReportController>(() => ServiceSalesOrderReportController(
      getServiceSalesOrderReportList: getIt(),
      getServiceSalesOrderReportFormOptions: getIt(),
    ));

    // ==================== SALES SERVICE DIRECT SALES REPORT ====================
    getIt.registerLazySingleton<ServiceDirectSalesReportRemoteDataSource>(() => ServiceDirectSalesReportRemoteDataSource(getIt<DioClient>().dio));
    getIt.registerLazySingleton<ServiceDirectSalesReportRepository>(() => ServiceDirectSalesReportRepository(remoteDataSource: getIt()));
    getIt.registerLazySingleton(() => GetServiceDirectSalesReportList(getIt()));
    getIt.registerLazySingleton(() => GetServiceDirectSalesReportFormOptions(getIt()));
    getIt.registerFactory<ServiceDirectSalesReportController>(() => ServiceDirectSalesReportController(
      getServiceDirectSalesReportList: getIt(),
      getServiceDirectSalesReportFormOptions: getIt(),
    ));

    // ==================== SALES SERVICE INVOICE REPORT ====================
    getIt.registerLazySingleton<ServiceInvoiceReportRemoteDataSource>(() => ServiceInvoiceReportRemoteDataSource(getIt<DioClient>().dio));
    getIt.registerLazySingleton<ServiceInvoiceReportRepository>(() => ServiceInvoiceReportRepository(remoteDataSource: getIt()));
    getIt.registerLazySingleton(() => GetServiceInvoiceReportList(getIt()));
    getIt.registerLazySingleton(() => GetServiceInvoiceReportFormOptions(getIt()));
    getIt.registerFactory<ServiceInvoiceReportController>(() => ServiceInvoiceReportController(
      getServiceInvoiceReportList: getIt(),
      getServiceInvoiceReportFormOptions: getIt(),
    ));

    // ==================== SALES PRODUCT REPORT ====================
    getIt.registerLazySingleton<SalesProductReportRemoteDataSource>(() => SalesProductReportRemoteDataSource(getIt<DioClient>().dio));
    getIt.registerLazySingleton<SalesProductReportRepository>(() => SalesProductReportRepository(remoteDataSource: getIt()));
    getIt.registerLazySingleton(() => GetSalesProductReportList(getIt()));
    getIt.registerLazySingleton(() => GetSalesProductReportFormOptions(getIt()));
    getIt.registerFactory<SalesProductReportController>(() => SalesProductReportController(
      getSalesProductReportList: getIt(),
      getSalesProductReportFormOptions: getIt(),
    ));

    // ==================== SALESPERSONS REPORT ====================
    getIt.registerLazySingleton<SalespersonsReportRemoteDataSource>(() => SalespersonsReportRemoteDataSource(getIt<DioClient>().dio));
    getIt.registerLazySingleton<SalespersonsReportRepository>(() => SalespersonsReportRepository(remoteDataSource: getIt()));
    getIt.registerLazySingleton(() => GetSalespersonsReportList(getIt()));
    getIt.registerFactory<SalespersonsReportController>(() => SalespersonsReportController(getSalespersonsReportList: getIt()));

    // ==================== TOP CUSTOMER REPORT ====================
    getIt.registerLazySingleton<TopCustomerReportRemoteDataSource>(() => TopCustomerReportRemoteDataSource(getIt<DioClient>().dio));
    getIt.registerLazySingleton<TopCustomerReportRepository>(() => TopCustomerReportRepository(remoteDataSource: getIt()));
    getIt.registerLazySingleton(() => GetTopCustomerReportList(getIt()));
    getIt.registerLazySingleton(() => GetTopCustomerReportFormOptions(getIt()));
    getIt.registerLazySingleton(() => GetTopCustomerReportLocationsByWarehouse(getIt()));
    getIt.registerFactory<TopCustomerReportController>(() => TopCustomerReportController(
      getTopCustomerReportList: getIt(),
      getTopCustomerReportFormOptions: getIt(),
      getLocationsByWarehouse: getIt(),
    ));

    // ==================== PPN REPORT ====================
    getIt.registerLazySingleton<PPNReportRemoteDataSource>(() => PPNReportRemoteDataSource(getIt<DioClient>().dio));
    getIt.registerLazySingleton<PPNReportRepository>(() => PPNReportRepository(remoteDataSource: getIt()));
    getIt.registerLazySingleton(() => GetPPNReportList(getIt()));
    getIt.registerFactory<PPNReportController>(() => PPNReportController(getPPNReportList: getIt()));

    // ==================== PPH REPORT ====================
    getIt.registerLazySingleton<PPHReportRemoteDataSource>(() => PPHReportRemoteDataSource(getIt<DioClient>().dio));
    getIt.registerLazySingleton<PPHReportRepository>(() => PPHReportRepository(remoteDataSource: getIt()));
    getIt.registerLazySingleton(() => GetPPHReportList(getIt()));
    getIt.registerFactory<PPHReportController>(() => PPHReportController(getPPHReportList: getIt()));

    // ==================== PURCHASE REQUEST REPORT ====================
    getIt.registerLazySingleton<PurchaseRequestReportRemoteDataSource>(() => PurchaseRequestReportRemoteDataSource(getIt<DioClient>().dio));
    getIt.registerLazySingleton<PurchaseRequestReportRepository>(() => PurchaseRequestReportRepository(remoteDataSource: getIt()));
    getIt.registerLazySingleton(() => GetPurchaseRequestReportList(getIt()));
    getIt.registerLazySingleton(() => GetPurchaseRequestReportFormOptions(getIt()));
    getIt.registerLazySingleton(() => GetPurchaseRequestReportLocationsByWarehouse(getIt()));
    getIt.registerFactory<PurchaseRequestReportController>(() => PurchaseRequestReportController(
      getPurchaseRequestReportList: getIt(),
      getPurchaseRequestReportFormOptions: getIt(),
      getLocationsByWarehouse: getIt(),
    ));

    // ==================== RFQ REPORT ====================
    getIt.registerLazySingleton<RequestQuotationReportRemoteDataSource>(() => RequestQuotationReportRemoteDataSource(getIt<DioClient>().dio));
    getIt.registerLazySingleton<RequestQuotationReportRepository>(() => RequestQuotationReportRepository(remoteDataSource: getIt()));
    getIt.registerLazySingleton(() => GetRequestQuotationReportList(getIt()));
    getIt.registerLazySingleton(() => GetRequestQuotationReportFormOptions(getIt()));
    getIt.registerLazySingleton(() => GetRequestQuotationReportLocationsByWarehouse(getIt()));
    getIt.registerFactory<RequestQuotationReportController>(() => RequestQuotationReportController(
      getRequestQuotationReportList: getIt(),
      getRequestQuotationReportFormOptions: getIt(),
      getLocationsByWarehouse: getIt(),
    ));

    // ==================== PURCHASE ORDER REPORT ====================
    getIt.registerLazySingleton<PurchaseOrderReportRemoteDataSource>(() => PurchaseOrderReportRemoteDataSource(getIt<DioClient>().dio));
    getIt.registerLazySingleton<PurchaseOrderReportRepository>(() => PurchaseOrderReportRepository(remoteDataSource: getIt()));
    getIt.registerLazySingleton(() => GetPurchaseOrderReportList(getIt()));
    getIt.registerLazySingleton(() => GetPurchaseOrderReportFormOptions(getIt()));
    getIt.registerLazySingleton(() => GetPurchaseOrderReportLocationsByWarehouse(getIt()));
    getIt.registerFactory<PurchaseOrderReportController>(() => PurchaseOrderReportController(
      getPurchaseOrderReportList: getIt(),
      getPurchaseOrderReportFormOptions: getIt(),
      getLocationsByWarehouse: getIt(),
    ));

    // ==================== DIRECT PURCHASE REPORT ====================
    getIt.registerLazySingleton<DirectPurchaseReportRemoteDataSource>(() => DirectPurchaseReportRemoteDataSource(getIt<DioClient>().dio));
    getIt.registerLazySingleton<DirectPurchaseReportRepository>(() => DirectPurchaseReportRepository(remoteDataSource: getIt()));
    getIt.registerLazySingleton(() => GetDirectPurchaseReportList(getIt()));
    getIt.registerLazySingleton(() => GetDirectPurchaseReportFormOptions(getIt()));
    getIt.registerLazySingleton(() => GetDirectPurchaseReportLocationsByWarehouse(getIt()));
    getIt.registerFactory<DirectPurchaseReportController>(() => DirectPurchaseReportController(
      getDirectPurchaseReportList: getIt(),
      getDirectPurchaseReportFormOptions: getIt(),
      getLocationsByWarehouse: getIt(),
    ));

    // ==================== TOP PURCHASE ORDER REPORT ====================
    getIt.registerLazySingleton<TopPurchaseOrderReportRemoteDataSource>(() => TopPurchaseOrderReportRemoteDataSource(getIt<DioClient>().dio));
    getIt.registerLazySingleton<TopPurchaseOrderReportRepository>(() => TopPurchaseOrderReportRepository(remoteDataSource: getIt()));
    getIt.registerLazySingleton(() => GetTopPurchaseOrderReportList(getIt()));
    getIt.registerLazySingleton(() => GetTopPurchaseOrderReportFormOptions(getIt()));
    getIt.registerFactory<TopPurchaseOrderReportController>(() => TopPurchaseOrderReportController(
      getTopPurchaseOrderReportList: getIt(),
      getTopPurchaseOrderReportFormOptions: getIt(),
    ));

    // ==================== TOP PURCHASING PRODUCT REPORT ====================
    getIt.registerLazySingleton<TopPurchasingProductReportRemoteDataSource>(() => TopPurchasingProductReportRemoteDataSource(getIt<DioClient>().dio));
    getIt.registerLazySingleton<TopPurchasingProductReportRepository>(() => TopPurchasingProductReportRepository(remoteDataSource: getIt()));
    getIt.registerLazySingleton(() => GetTopPurchasingProductReportList(getIt()));
    getIt.registerLazySingleton(() => GetTopPurchasingProductReportFormOptions(getIt()));
    getIt.registerFactory<TopPurchasingProductReportController>(() => TopPurchasingProductReportController(
      getTopPurchasingProductReportList: getIt(),
      getTopPurchasingProductReportFormOptions: getIt(),
    ));

    // ==================== ATTENDANCE REPORT ====================
    getIt.registerLazySingleton<AttendanceReportRemoteDataSource>(() => AttendanceReportRemoteDataSource(getIt<DioClient>().dio));
    getIt.registerLazySingleton<AttendanceReportRepository>(() => AttendanceReportRepository(remoteDataSource: getIt()));
    getIt.registerLazySingleton(() => GetAttendanceReportList(getIt()));
    getIt.registerLazySingleton(() => GetAttendanceReportFormOptions(getIt()));
    getIt.registerFactory<AttendanceReportController>(() => AttendanceReportController(
      getAttendanceReportList: getIt(),
      getAttendanceReportFormOptions: getIt(),
    ));

    // ==================== ATTENDANCE LATE REPORT ====================
    getIt.registerLazySingleton<AttendanceLateReportRemoteDataSource>(() => AttendanceLateReportRemoteDataSource(getIt<DioClient>().dio));
    getIt.registerLazySingleton<AttendanceLateReportRepository>(() => AttendanceLateReportRepository(remoteDataSource: getIt()));
    getIt.registerLazySingleton(() => GetAttendanceLateReportList(getIt()));
    getIt.registerLazySingleton(() => GetAttendanceLateReportFormOptions(getIt()));
    getIt.registerFactory<AttendanceLateReportController>(() => AttendanceLateReportController(
      getAttendanceLateReportList: getIt(),
      getAttendanceLateReportFormOptions: getIt(),
    ));

    // ==================== ATTENDANCE OVERTIME REPORT ====================
    getIt.registerLazySingleton<AttendanceOvertimeReportRemoteDataSource>(() => AttendanceOvertimeReportRemoteDataSource(getIt<DioClient>().dio));
    getIt.registerLazySingleton<AttendanceOvertimeReportRepository>(() => AttendanceOvertimeReportRepository(remoteDataSource: getIt()));
    getIt.registerLazySingleton(() => GetAttendanceOvertimeReportList(getIt()));
    getIt.registerLazySingleton(() => GetAttendanceOvertimeReportFormOptions(getIt()));
    getIt.registerFactory<AttendanceOvertimeReportController>(() => AttendanceOvertimeReportController(
      getAttendanceOvertimeReportList: getIt(),
      getAttendanceOvertimeReportFormOptions: getIt(),
    ));

    // ==================== LEAVE REPORT ====================
    getIt.registerLazySingleton<LeaveReportRemoteDataSource>(() => LeaveReportRemoteDataSource(getIt<DioClient>().dio));
    getIt.registerLazySingleton<LeaveReportRepository>(() => LeaveReportRepository(remoteDataSource: getIt()));
    getIt.registerLazySingleton(() => GetLeaveReportList(getIt()));
    getIt.registerLazySingleton(() => GetLeaveReportFormOptions(getIt()));
    getIt.registerFactory<LeaveReportController>(() => LeaveReportController(
      getLeaveReportList: getIt(),
      getLeaveReportFormOptions: getIt(),
    ));

    // ==================== PAYROLL SUMMARY REPORT ====================
    getIt.registerLazySingleton<PayrollSummaryReportRemoteDataSource>(() => PayrollSummaryReportRemoteDataSource(getIt<DioClient>().dio));
    getIt.registerLazySingleton<PayrollSummaryReportRepository>(() => PayrollSummaryReportRepository(remoteDataSource: getIt()));
    getIt.registerLazySingleton(() => GetPayrollSummaryReportList(getIt()));
    getIt.registerLazySingleton(() => GetPayrollSummaryReportFormOptions(getIt()));
    getIt.registerFactory<PayrollSummaryReportController>(() => PayrollSummaryReportController(
      getPayrollSummaryReportList: getIt(),
      getPayrollSummaryReportFormOptions: getIt(),
    ));

    // ==================== MY PAYSLIP ====================
    getIt.registerLazySingleton<MyPaySlipRemoteDataSource>(() => MyPaySlipRemoteDataSource(getIt<DioClient>().dio));
    getIt.registerLazySingleton<MyPaySlipRepository>(() => MyPaySlipRepository(remoteDataSource: getIt()));
    getIt.registerLazySingleton(() => GetMyPaySlipList(getIt()));
    getIt.registerLazySingleton(() => GetMyPaySlipDetail(getIt()));
    getIt.registerFactory<MyPaySlipController>(() => MyPaySlipController(getMyPaySlipList: getIt()));
    getIt.registerFactory<MyPaySlipDetailController>(() => MyPaySlipDetailController(getMyPaySlipDetail: getIt()));

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

    // ==================== WAREHOUSE REPORT ====================
    getIt.registerLazySingleton<WarehouseReportRemoteDataSource>(
      () => WarehouseReportRemoteDataSource(getIt<DioClient>().dio),
    );
    getIt.registerLazySingleton<WarehouseReportRepository>(
      () => WarehouseReportRepository(
        remoteDataSource: getIt<WarehouseReportRemoteDataSource>(),
      ),
    );
    getIt.registerLazySingleton(
      () => GetWarehouseReportList(getIt<WarehouseReportRepository>()),
    );
    getIt.registerLazySingleton(
      () => GetWarehouseReportDetail(getIt<WarehouseReportRepository>()),
    );
    getIt.registerFactory<WarehouseReportController>(
      () => WarehouseReportController(
        getWarehouseReportList: getIt<GetWarehouseReportList>(),
        getWarehouseReportDetail: getIt<GetWarehouseReportDetail>(),
      ),
    );

    // ==================== LOCATION REPORT ====================
    getIt.registerLazySingleton<LocationReportRemoteDataSource>(
      () => LocationReportRemoteDataSource(getIt<DioClient>().dio),
    );
    getIt.registerLazySingleton<LocationReportRepository>(
      () => LocationReportRepository(
        remoteDataSource: getIt<LocationReportRemoteDataSource>(),
      ),
    );
    getIt.registerLazySingleton(
      () => GetLocationReportList(getIt<LocationReportRepository>()),
    );
    getIt.registerLazySingleton(
      () => GetLocationReportDetail(getIt<LocationReportRepository>()),
    );
    getIt.registerLazySingleton(
      () => GetLocationReportFormOptions(getIt<LocationReportRepository>()),
    );
    getIt.registerFactory<LocationReportController>(
      () => LocationReportController(
        getLocationReportList: getIt<GetLocationReportList>(),
        getLocationReportDetail: getIt<GetLocationReportDetail>(),
        getLocationReportFormOptions: getIt<GetLocationReportFormOptions>(),
      ),
    );

    // ==================== STOCK REPORT ====================
    getIt.registerLazySingleton<StockReportRemoteDataSource>(
      () => StockReportRemoteDataSource(getIt<DioClient>().dio),
    );
    getIt.registerLazySingleton<StockReportRepository>(
      () => StockReportRepository(
        remoteDataSource: getIt<StockReportRemoteDataSource>(),
      ),
    );
    getIt.registerLazySingleton(
      () => GetStockReportList(getIt<StockReportRepository>()),
    );
    getIt.registerLazySingleton(
      () => GetStockReportDetail(getIt<StockReportRepository>()),
    );
    getIt.registerFactory<StockReportController>(
      () => StockReportController(
        getStockReportList: getIt<GetStockReportList>(),
        getStockReportDetail: getIt<GetStockReportDetail>(),
      ),
    );

    // ==================== STOCK MOVEMENT ====================
    getIt.registerLazySingleton<StockMovementRemoteDataSource>(
      () => StockMovementRemoteDataSource(getIt<DioClient>().dio),
    );
    getIt.registerLazySingleton<StockMovementRepository>(
      () => StockMovementRepository(
        remoteDataSource: getIt<StockMovementRemoteDataSource>(),
      ),
    );
    getIt.registerLazySingleton(
      () => GetStockMovementList(getIt<StockMovementRepository>()),
    );
    getIt.registerLazySingleton(
      () => GetStockMovementFormOptions(getIt<StockMovementRepository>()),
    );
    getIt.registerLazySingleton(
      () => GetStockMovementLocationsByWarehouse(
        getIt<StockMovementRepository>(),
      ),
    );
    getIt.registerFactory<StockMovementController>(
      () => StockMovementController(
        getStockMovementList: getIt<GetStockMovementList>(),
        getStockMovementFormOptions: getIt<GetStockMovementFormOptions>(),
        getLocationsByWarehouse: getIt<GetStockMovementLocationsByWarehouse>(),
      ),
    );

    // ==================== STOCK VALUATION ====================
    getIt.registerLazySingleton<StockValuationRemoteDataSource>(
      () => StockValuationRemoteDataSource(getIt<DioClient>().dio),
    );
    getIt.registerLazySingleton<StockValuationRepository>(
      () => StockValuationRepository(
        remoteDataSource: getIt<StockValuationRemoteDataSource>(),
      ),
    );
    getIt.registerLazySingleton(
      () => GetStockValuationWarehouseList(getIt<StockValuationRepository>()),
    );
    getIt.registerLazySingleton(
      () => GetStockValuationWarehouseDetail(getIt<StockValuationRepository>()),
    );
    getIt.registerLazySingleton(
      () => GetStockValuationBranches(getIt<StockValuationRepository>()),
    );
    getIt.registerFactory<StockValuationController>(
      () => StockValuationController(
        getWarehouseList: getIt<GetStockValuationWarehouseList>(),
        getWarehouseDetail: getIt<GetStockValuationWarehouseDetail>(),
        getBranches: getIt<GetStockValuationBranches>(),
      ),
    );

    // ==================== HISTORY STOCK ====================
    getIt.registerLazySingleton<HistoryStockRemoteDataSource>(
      () => HistoryStockRemoteDataSource(getIt<DioClient>().dio),
    );
    getIt.registerLazySingleton<HistoryStockRepository>(
      () => HistoryStockRepository(
        remoteDataSource: getIt<HistoryStockRemoteDataSource>(),
      ),
    );
    getIt.registerLazySingleton(
      () => GetHistoryStockList(getIt<HistoryStockRepository>()),
    );
    getIt.registerLazySingleton(
      () => GetHistoryTransactions(getIt<HistoryStockRepository>()),
    );
    getIt.registerLazySingleton(
      () => GetHistoryStockFormOptions(getIt<HistoryStockRepository>()),
    );
    getIt.registerLazySingleton(
      () =>
          GetHistoryStockLocationsByWarehouse(getIt<HistoryStockRepository>()),
    );
    getIt.registerFactory<HistoryStockController>(
      () => HistoryStockController(
        getHistoryStockList: getIt<GetHistoryStockList>(),
        getHistoryTransactions: getIt<GetHistoryTransactions>(),
        getHistoryStockFormOptions: getIt<GetHistoryStockFormOptions>(),
        getLocationsByWarehouse: getIt<GetHistoryStockLocationsByWarehouse>(),
      ),
    );

    // ==================== EXPIRED REPORT ====================
    getIt.registerLazySingleton<ExpiredReportRemoteDataSource>(
      () => ExpiredReportRemoteDataSource(getIt<DioClient>().dio),
    );
    getIt.registerLazySingleton<ExpiredReportRepository>(
      () => ExpiredReportRepository(
        remoteDataSource: getIt<ExpiredReportRemoteDataSource>(),
      ),
    );
    getIt.registerLazySingleton(
      () => GetExpiredReportList(getIt<ExpiredReportRepository>()),
    );
    getIt.registerLazySingleton(
      () => GetExpiredReportFormOptions(getIt<ExpiredReportRepository>()),
    );
    getIt.registerLazySingleton(
      () => GetExpiredReportLocationsByWarehouse(
        getIt<ExpiredReportRepository>(),
      ),
    );
    getIt.registerFactory<ExpiredReportController>(
      () => ExpiredReportController(
        getExpiredReportList: getIt<GetExpiredReportList>(),
        getExpiredReportFormOptions: getIt<GetExpiredReportFormOptions>(),
        getLocationsByWarehouse: getIt<GetExpiredReportLocationsByWarehouse>(),
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
        getList: getIt(),
        getDetail: getIt(),
        saveTO: getIt(),
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
        getList: getIt(),
        getDetail: getIt(),
        saveTI: getIt(),
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
        getList: getIt(),
        getDetail: getIt(),
        getFormOptions: getIt(),
        getProductsByLocation: getIt(),
        checkStockUC: getIt(),
        saveSO: getIt(),
        confirmSO: getIt(),
        validateSO: getIt(),
        cancelSO: getIt(),
        deleteSO: getIt(),
        approveSO: getIt(),
        rejectSO: getIt(),
        getSteps: getIt(),
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
        getList: getIt(),
        getDetail: getIt(),
        getFormOptions: getIt(),
        createSC: getIt(),
        updateHeader: getIt(),
        confirmSC: getIt(),
        validateSC: getIt(),
        cancelSC: getIt(),
        deleteSC: getIt(),
        storeLocationCount: getIt(),
        loadProducts: getIt(),
        getLocationsByWarehouse: getIt(),
        getIndexLocation: getIt(),
        getSteps: getIt(),
        approveSC: getIt(),
        rejectSC: getIt(),
      ),
    );

    // ==================== RETURN RN ====================
    getIt.registerLazySingleton<ReturnRNRemoteDataSource>(() => ReturnRNRemoteDataSource(getIt<DioClient>().dio));
    getIt.registerLazySingleton<ReturnRNRepository>(() => ReturnRNRepository(getIt()));
    getIt.registerLazySingleton(() => GetRRNList(getIt()));
    getIt.registerLazySingleton(() => GetRRNDetail(getIt()));
    getIt.registerLazySingleton(() => GetRRNFormOptions(getIt()));
    getIt.registerLazySingleton(() => GetValidatedRNs(getIt()));
    getIt.registerLazySingleton(() => GetItemsByRN(getIt()));
    getIt.registerLazySingleton(() => SaveReturnRN(getIt()));
    getIt.registerLazySingleton(() => ConfirmReturnRN(getIt()));
    getIt.registerLazySingleton(() => ValidateReturnRN(getIt()));
    getIt.registerLazySingleton(() => CancelReturnRN(getIt()));
    getIt.registerLazySingleton(() => DeleteReturnRN(getIt()));
    getIt.registerLazySingleton(() => SaveRRNTracking(getIt()));
    getIt.registerLazySingleton(() => GetRRNLotSerialsSorted(getIt()));
    getIt.registerLazySingleton(() => GetRRNSteps(getIt()));
    getIt.registerLazySingleton(() => ApproveReturnRN(getIt()));
    getIt.registerLazySingleton(() => RejectReturnRN(getIt()));
    getIt.registerLazySingleton<ReturnRNController>(
      () => ReturnRNController(
        getList: getIt(), getDetail: getIt(), getFormOptions: getIt(),
        getValidatedRNsUC: getIt(), getItemsByRNUC: getIt(),
        saveRRN: getIt(), confirmRRN: getIt(), validateRRN: getIt(),
        cancelRRN: getIt(), deleteRRN: getIt(), saveTrackingUC: getIt(),
        getLotSerialsSortedUC: getIt(), getSteps: getIt(),
        approveRRN: getIt(), rejectRRN: getIt(),
      ),
    );

    // ==================== RETURN DN ====================
    getIt.registerLazySingleton<ReturnDNRemoteDataSource>(() => ReturnDNRemoteDataSource(getIt<DioClient>().dio));
    getIt.registerLazySingleton<ReturnDNRepository>(() => ReturnDNRepository(getIt()));
    getIt.registerLazySingleton(() => GetRDNList(getIt()));
    getIt.registerLazySingleton(() => GetRDNDetail(getIt()));
    getIt.registerLazySingleton(() => GetRDNFormOptions(getIt()));
    getIt.registerLazySingleton(() => GetValidatedDNs(getIt()));
    getIt.registerLazySingleton(() => GetDNBySO(getIt()));
    getIt.registerLazySingleton(() => GetItemsByDN(getIt()));
    getIt.registerLazySingleton(() => GetReplaceProducts(getIt()));
    getIt.registerLazySingleton(() => GetReplaceProductStock(getIt()));
    getIt.registerLazySingleton(() => SaveReturnDN(getIt()));
    getIt.registerLazySingleton(() => ConfirmReturnDN(getIt()));
    getIt.registerLazySingleton(() => ValidateReturnDN(getIt()));
    getIt.registerLazySingleton(() => CancelReturnDN(getIt()));
    getIt.registerLazySingleton(() => DeleteReturnDN(getIt()));
    getIt.registerLazySingleton(() => SaveRDNTracking(getIt()));
    getIt.registerLazySingleton(() => GetRDNSteps(getIt()));
    getIt.registerLazySingleton(() => ApproveReturnDN(getIt()));
    getIt.registerLazySingleton(() => RejectReturnDN(getIt()));
    getIt.registerLazySingleton<ReturnDNController>(
      () => ReturnDNController(
        getList: getIt(), getDetail: getIt(), getFormOptions: getIt(),
        getValidatedDNsUC: getIt(), getDNBySOUC: getIt(), getItemsByDNUC: getIt(),
        getReplaceProductsUC: getIt(), getReplaceProductStockUC: getIt(),
        saveRDN: getIt(), confirmRDN: getIt(), validateRDN: getIt(),
        cancelRDN: getIt(), deleteRDN: getIt(), saveTrackingUC: getIt(),
        getSteps: getIt(), approveRDN: getIt(), rejectRDN: getIt(),
      ),
    );
  }
}
