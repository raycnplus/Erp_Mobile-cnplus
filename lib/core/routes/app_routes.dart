import 'package:flutter/material.dart';

import 'package:erp_mobile_cnplus/features/auth/presentation/screens/login_screen.dart';
import 'package:erp_mobile_cnplus/features/splash/presentation/screens/splash_screen.dart';
import 'package:erp_mobile_cnplus/features/profile/presentation/screens/profile_screen.dart';
import 'package:erp_mobile_cnplus/features/modul/presentation/screens/modul_screen.dart';
import 'package:erp_mobile_cnplus/features/general_dashboard/presentation/screens/general_dashboard_screen.dart';

// DASHBOARD
import 'package:erp_mobile_cnplus/features/inventory/dashboard/presentation/screens/dashboard_inventory_screen.dart';
import 'package:erp_mobile_cnplus/features/purchase/dashboard/presentation/screens/dashboard_purchase_screen.dart';
import 'package:erp_mobile_cnplus/features/sales/dashboard/presentation/screens/dashboard_sales_screen.dart';
import 'package:erp_mobile_cnplus/features/hr/dashboard/presentation/screens/dashboard_hr_screen.dart';
import 'package:erp_mobile_cnplus/features/accounting/dashboard/presentation/screens/dashboard_accounting_screen.dart';
import 'package:erp_mobile_cnplus/features/manufacturing/dashboard/presentation/screens/dashboard_manufacturing_screen.dart';
import 'package:erp_mobile_cnplus/features/crm/dashboard/presentation/screens/dashboard_crm_screen.dart';
import 'package:erp_mobile_cnplus/features/pos/dashboard/presentation/screens/dashboard_pos_screen.dart';

// MASTER DATA
// -- Product
import 'package:erp_mobile_cnplus/features/master/product/presentation/screens/product_list_screen.dart';
import 'package:erp_mobile_cnplus/features/master/product/presentation/screens/product_detail_screen.dart';
import 'package:erp_mobile_cnplus/features/master/product/presentation/screens/product_form_screen.dart';

// -- Brand
import 'package:erp_mobile_cnplus/features/master/brand/presentation/screens/brand_list_screen.dart';
import 'package:erp_mobile_cnplus/features/master/brand/presentation/screens/brand_detail_screen.dart';
import 'package:erp_mobile_cnplus/features/master/brand/presentation/screens/brand_form_screen.dart';

// -- Product Category
import 'package:erp_mobile_cnplus/features/master/product_category/presentation/screens/product_category_list_screen.dart';
import 'package:erp_mobile_cnplus/features/master/product_category/presentation/screens/product_category_detail_screen.dart';
import 'package:erp_mobile_cnplus/features/master/product_category/presentation/screens/product_category_form_screen.dart';

// -- Product Type
import 'package:erp_mobile_cnplus/features/master/product_type/presentation/screens/product_type_list_screen.dart';
import 'package:erp_mobile_cnplus/features/master/product_type/presentation/screens/product_type_detail_screen.dart';
import 'package:erp_mobile_cnplus/features/master/product_type/presentation/screens/product_type_form_screen.dart';

// -- UOM
import 'package:erp_mobile_cnplus/features/master/uom/presentation/screens/uom_list_screen.dart';
import 'package:erp_mobile_cnplus/features/master/uom/presentation/screens/uom_detail_screen.dart';
import 'package:erp_mobile_cnplus/features/master/uom/presentation/screens/uom_form_screen.dart';

// -- Vendor
import 'package:erp_mobile_cnplus/features/master/vendor/presentation/screens/vendor_list_screen.dart';
import 'package:erp_mobile_cnplus/features/master/vendor/presentation/screens/vendor_detail_screen.dart';
import 'package:erp_mobile_cnplus/features/master/vendor/presentation/screens/vendor_form_screen.dart';

// -- Customer
import 'package:erp_mobile_cnplus/features/master/customer/presentation/screens/customer_list_screen.dart';
import 'package:erp_mobile_cnplus/features/master/customer/presentation/screens/customer_detail_screen.dart';
import 'package:erp_mobile_cnplus/features/master/customer/presentation/screens/customer_form_screen.dart';

// -- Customer Category
import 'package:erp_mobile_cnplus/features/master/customer_category/presentation/screens/customer_category_list_screen.dart';
import 'package:erp_mobile_cnplus/features/master/customer_category/presentation/screens/customer_category_detail_screen.dart';
import 'package:erp_mobile_cnplus/features/master/customer_category/presentation/screens/customer_category_form_screen.dart';

// -- Location
import 'package:erp_mobile_cnplus/features/master/location/presentation/screens/location_list_screen.dart';
import 'package:erp_mobile_cnplus/features/master/location/presentation/screens/location_detail_screen.dart';
import 'package:erp_mobile_cnplus/features/master/location/presentation/screens/location_form_screen.dart';

// -- Warehouse
import 'package:erp_mobile_cnplus/features/master/warehouse/presentation/screens/warehouse_list_screen.dart';
import 'package:erp_mobile_cnplus/features/master/warehouse/presentation/screens/warehouse_detail_screen.dart';
import 'package:erp_mobile_cnplus/features/master/warehouse/presentation/screens/warehouse_form_screen.dart';

// -- Sales Team
import 'package:erp_mobile_cnplus/features/master/sales_team/presentation/screens/sales_team_list_screen.dart';
import 'package:erp_mobile_cnplus/features/master/sales_team/presentation/screens/sales_team_detail_screen.dart';
import 'package:erp_mobile_cnplus/features/master/sales_team/presentation/screens/sales_team_form_screen.dart';

// -- Purchase Team
import 'package:erp_mobile_cnplus/features/master/purchase_team/presentation/screens/purchase_team_list_screen.dart';
import 'package:erp_mobile_cnplus/features/master/purchase_team/presentation/screens/purchase_team_detail_screen.dart';
import 'package:erp_mobile_cnplus/features/master/purchase_team/presentation/screens/purchase_team_form_screen.dart';

// -- Employee
import 'package:erp_mobile_cnplus/features/master/employee/presentation/screens/employee_list_screen.dart';
import 'package:erp_mobile_cnplus/features/master/employee/presentation/screens/employee_detail_screen.dart';
import 'package:erp_mobile_cnplus/features/master/employee/presentation/screens/employee_form_screen.dart';

// -- Project
import 'package:erp_mobile_cnplus/features/master/project/presentation/screens/project_list_screen.dart';
import 'package:erp_mobile_cnplus/features/master/project/presentation/screens/project_detail_screen.dart';
import 'package:erp_mobile_cnplus/features/master/project/presentation/screens/project_form_screen.dart';

// -- User
import 'package:erp_mobile_cnplus/features/master/user/presentation/screens/user_list_screen.dart';
import 'package:erp_mobile_cnplus/features/master/user/presentation/screens/user_detail_screen.dart';

// INVENTORY
// -- Receipt Note
import 'package:erp_mobile_cnplus/features/inventory/receipt_note/presentation/screens/receipt_note_list_screen.dart';
import 'package:erp_mobile_cnplus/features/inventory/receipt_note/presentation/screens/receipt_note_detail_screen.dart';
import 'package:erp_mobile_cnplus/features/inventory/receipt_note/presentation/screens/receipt_note_form_screen.dart';

// -- Delivery Note
import 'package:erp_mobile_cnplus/features/inventory/delivery_note/presentation/screens/delivery_note_list_screen.dart';
import 'package:erp_mobile_cnplus/features/inventory/delivery_note/presentation/screens/delivery_note_detail_screen.dart';
import 'package:erp_mobile_cnplus/features/inventory/delivery_note/presentation/screens/delivery_note_form_screen.dart';

// -- Internal Transfer
import 'package:erp_mobile_cnplus/features/inventory/internal_transfer/presentation/screens/internal_transfer_list_screen.dart';
import 'package:erp_mobile_cnplus/features/inventory/internal_transfer/presentation/screens/internal_transfer_detail_screen.dart';
import 'package:erp_mobile_cnplus/features/inventory/internal_transfer/presentation/screens/internal_transfer_form_screen.dart';

// -- Transfer In
import 'package:erp_mobile_cnplus/features/inventory/transfer_in/presentation/screens/transfer_in_list_screen.dart';
import 'package:erp_mobile_cnplus/features/inventory/transfer_in/presentation/screens/transfer_in_detail_screen.dart';

// -- Transfer Out
import 'package:erp_mobile_cnplus/features/inventory/transfer_out/presentation/screens/transfer_out_list_screen.dart';
import 'package:erp_mobile_cnplus/features/inventory/transfer_out/presentation/screens/transfer_out_detail_screen.dart';

// -- Scrap Order
import 'package:erp_mobile_cnplus/features/inventory/scrap_order/presentation/screens/scrap_order_list_screen.dart';
import 'package:erp_mobile_cnplus/features/inventory/scrap_order/presentation/screens/scrap_order_detail_screen.dart';
import 'package:erp_mobile_cnplus/features/inventory/scrap_order/presentation/screens/scrap_order_form_screen.dart';

// -- Stock Count
import 'package:erp_mobile_cnplus/features/inventory/stock_count/presentation/screens/stock_count_list_screen.dart';
import 'package:erp_mobile_cnplus/features/inventory/stock_count/presentation/screens/stock_count_detail_screen.dart';
import 'package:erp_mobile_cnplus/features/inventory/stock_count/presentation/screens/stock_count_form_screen.dart';

// -- Return RN
import 'package:erp_mobile_cnplus/features/inventory/return_rn/presentation/screens/return_rn_list_screen.dart';
import 'package:erp_mobile_cnplus/features/inventory/return_rn/presentation/screens/return_rn_detail_screen.dart';
import 'package:erp_mobile_cnplus/features/inventory/return_rn/presentation/screens/return_rn_form_screen.dart';

// -- Return DN
import 'package:erp_mobile_cnplus/features/inventory/return_dn/presentation/screens/return_dn_list_screen.dart';
import 'package:erp_mobile_cnplus/features/inventory/return_dn/presentation/screens/return_dn_detail_screen.dart';
import 'package:erp_mobile_cnplus/features/inventory/return_dn/presentation/screens/return_dn_form_screen.dart';

// -- Reports
import 'package:erp_mobile_cnplus/features/inventory/warehouse_report/presentation/screens/warehouse_report_list_screen.dart';
import 'package:erp_mobile_cnplus/features/inventory/location_report/presentation/screens/location_report_list_screen.dart';
import 'package:erp_mobile_cnplus/features/inventory/stock_report/presentation/screens/stock_report_list_screen.dart';
import 'package:erp_mobile_cnplus/features/inventory/stock_movement/presentation/screens/stock_movement_list_screen.dart';
import 'package:erp_mobile_cnplus/features/inventory/stock_valuation/presentation/screens/stock_valuation_list_screen.dart';
import 'package:erp_mobile_cnplus/features/inventory/history_stock/presentation/screens/history_stock_list_screen.dart';
import 'package:erp_mobile_cnplus/features/inventory/expired_report/presentation/screens/expired_report_list_screen.dart';

// SALES
// -- Price List
import 'package:erp_mobile_cnplus/features/sales/price_list/presentation/screens/price_list_list_screen.dart';
import 'package:erp_mobile_cnplus/features/sales/price_list/presentation/screens/price_list_detail_screen.dart';
import 'package:erp_mobile_cnplus/features/sales/price_list/presentation/screens/price_list_form_screen.dart';

// -- Quotation
import 'package:erp_mobile_cnplus/features/sales/quotation/presentation/screens/quotation_list_screen.dart';
import 'package:erp_mobile_cnplus/features/sales/quotation/presentation/screens/quotation_detail_screen.dart';
import 'package:erp_mobile_cnplus/features/sales/quotation/presentation/screens/quotation_form_screen.dart';

// -- Sales Order
import 'package:erp_mobile_cnplus/features/sales/sales_order/presentation/screens/sales_order_list_screen.dart';
import 'package:erp_mobile_cnplus/features/sales/sales_order/presentation/screens/sales_order_detail_screen.dart';
import 'package:erp_mobile_cnplus/features/sales/sales_order/presentation/screens/sales_order_form_screen.dart';

// -- Direct Sales
import 'package:erp_mobile_cnplus/features/sales/direct_sales/presentation/screens/direct_sales_list_screen.dart';
import 'package:erp_mobile_cnplus/features/sales/direct_sales/presentation/screens/direct_sales_detail_screen.dart';
import 'package:erp_mobile_cnplus/features/sales/direct_sales/presentation/screens/direct_sales_form_screen.dart';

// -- Invoice
import 'package:erp_mobile_cnplus/features/sales/invoice/presentation/screens/invoice_list_screen.dart';
import 'package:erp_mobile_cnplus/features/sales/invoice/presentation/screens/invoice_detail_screen.dart';
import 'package:erp_mobile_cnplus/features/sales/invoice/presentation/screens/invoice_form_screen.dart';

// -- Service Sales: Quotation
import 'package:erp_mobile_cnplus/features/sales/service_sales/service_quotation/presentation/screens/service_quotation_list_screen.dart';
import 'package:erp_mobile_cnplus/features/sales/service_sales/service_quotation/presentation/screens/service_quotation_detail_screen.dart';
import 'package:erp_mobile_cnplus/features/sales/service_sales/service_quotation/presentation/screens/service_quotation_form_screen.dart';

// -- Service Sales: Sales Order
import 'package:erp_mobile_cnplus/features/sales/service_sales/service_sales_order/presentation/screens/service_sales_order_list_screen.dart';
import 'package:erp_mobile_cnplus/features/sales/service_sales/service_sales_order/presentation/screens/service_sales_order_detail_screen.dart';
import 'package:erp_mobile_cnplus/features/sales/service_sales/service_sales_order/presentation/screens/service_sales_order_form_screen.dart';

// -- Service Sales: Direct Sales
import 'package:erp_mobile_cnplus/features/sales/service_sales/service_direct_sales/presentation/screens/service_direct_sales_list_screen.dart';
import 'package:erp_mobile_cnplus/features/sales/service_sales/service_direct_sales/presentation/screens/service_direct_sales_detail_screen.dart';
import 'package:erp_mobile_cnplus/features/sales/service_sales/service_direct_sales/presentation/screens/service_direct_sales_form_screen.dart';

// -- Service Sales: Invoice
import 'package:erp_mobile_cnplus/features/sales/service_sales/service_invoice/presentation/screens/service_invoice_list_screen.dart';
import 'package:erp_mobile_cnplus/features/sales/service_sales/service_invoice/presentation/screens/service_invoice_detail_screen.dart';
import 'package:erp_mobile_cnplus/features/sales/service_sales/service_invoice/presentation/screens/service_invoice_form_screen.dart';

// -- Reports
import 'package:erp_mobile_cnplus/features/sales/quotation_report/presentation/screens/quotation_report_list_screen.dart';
import 'package:erp_mobile_cnplus/features/sales/sales_order_report/presentation/screens/sales_order_report_list_screen.dart';
import 'package:erp_mobile_cnplus/features/sales/direct_sales_report/presentation/screens/direct_sales_report_list_screen.dart';
import 'package:erp_mobile_cnplus/features/sales/invoice_report/presentation/screens/invoice_report_list_screen.dart';
import 'package:erp_mobile_cnplus/features/sales/service_quotation_report/presentation/screens/service_quotation_report_list_screen.dart';
import 'package:erp_mobile_cnplus/features/sales/service_sales_order_report/presentation/screens/service_sales_order_report_list_screen.dart';
import 'package:erp_mobile_cnplus/features/sales/service_direct_sales_report/presentation/screens/service_direct_sales_report_list_screen.dart';
import 'package:erp_mobile_cnplus/features/sales/service_invoice_report/presentation/screens/service_invoice_report_list_screen.dart';
import 'package:erp_mobile_cnplus/features/sales/sales_product_report/presentation/screens/sales_product_report_list_screen.dart';
import 'package:erp_mobile_cnplus/features/sales/salespersons_report/presentation/screens/salespersons_report_list_screen.dart';
import 'package:erp_mobile_cnplus/features/sales/top_customer_report/presentation/screens/top_customer_report_list_screen.dart';
import 'package:erp_mobile_cnplus/features/sales/ppn_report/presentation/screens/ppn_report_list_screen.dart';
import 'package:erp_mobile_cnplus/features/sales/pph_report/presentation/screens/pph_report_list_screen.dart';

// PURCHASE
// -- Purchase Request
import 'package:erp_mobile_cnplus/features/purchase/purchase_request/presentation/screens/purchase_request_list_screen.dart';
import 'package:erp_mobile_cnplus/features/purchase/purchase_request/presentation/screens/purchase_request_detail_screen.dart';
import 'package:erp_mobile_cnplus/features/purchase/purchase_request/presentation/screens/purchase_request_form_screen.dart';

// -- RFQ
import 'package:erp_mobile_cnplus/features/purchase/request_quotation/presentation/screens/rfq_list_screen.dart';
import 'package:erp_mobile_cnplus/features/purchase/request_quotation/presentation/screens/rfq_detail_screen.dart';
import 'package:erp_mobile_cnplus/features/purchase/request_quotation/presentation/screens/rfq_form_screen.dart';

// -- Direct Purchase
import 'package:erp_mobile_cnplus/features/purchase/direct_purchase/presentation/screens/direct_purchase_list_screen.dart';
import 'package:erp_mobile_cnplus/features/purchase/direct_purchase/presentation/screens/direct_purchase_detail_screen.dart';
import 'package:erp_mobile_cnplus/features/purchase/direct_purchase/presentation/screens/direct_purchase_form_screen.dart';

// -- Purchase Order
import 'package:erp_mobile_cnplus/features/purchase/purchase_order/presentation/screens/purchase_order_list_screen.dart';
import 'package:erp_mobile_cnplus/features/purchase/purchase_order/presentation/screens/purchase_order_detail_screen.dart';
import 'package:erp_mobile_cnplus/features/purchase/purchase_order/presentation/screens/purchase_order_form_screen.dart';

// -- Bill
import 'package:erp_mobile_cnplus/features/purchase/bill/presentation/screens/bill_list_screen.dart';
import 'package:erp_mobile_cnplus/features/purchase/bill/presentation/screens/bill_detail_screen.dart';
import 'package:erp_mobile_cnplus/features/purchase/bill/presentation/screens/bill_form_screen.dart';

// -- Reports
import 'package:erp_mobile_cnplus/features/purchase/purchase_request_report/presentation/screens/purchase_request_report_list_screen.dart';
import 'package:erp_mobile_cnplus/features/purchase/request_quotation_report/presentation/screens/request_quotation_report_list_screen.dart';
import 'package:erp_mobile_cnplus/features/purchase/purchase_order_report/presentation/screens/purchase_order_report_list_screen.dart';
import 'package:erp_mobile_cnplus/features/purchase/direct_purchase_report/presentation/screens/direct_purchase_report_list_screen.dart';
import 'package:erp_mobile_cnplus/features/purchase/top_purchase_order_report/presentation/screens/top_purchase_order_report_list_screen.dart';
import 'package:erp_mobile_cnplus/features/purchase/top_purchasing_product_report/presentation/screens/top_purchasing_product_report_list_screen.dart';

// HR
// -- Attendance
import 'package:erp_mobile_cnplus/features/hr/attendance/presentation/screens/attendance_screen.dart';
import 'package:erp_mobile_cnplus/features/hr/attendance/presentation/screens/attendance_form_screen.dart';
import 'package:erp_mobile_cnplus/features/hr/attendance/presentation/screens/attendance_history_screen.dart';

// -- Department
import 'package:erp_mobile_cnplus/features/hr/department/presentation/screens/department_list_screen.dart';
import 'package:erp_mobile_cnplus/features/hr/department/presentation/screens/department_detail_screen.dart';
import 'package:erp_mobile_cnplus/features/hr/department/presentation/screens/department_form_screen.dart';

// -- Employee Status
import 'package:erp_mobile_cnplus/features/hr/employee_status/presentation/screens/employee_status_list_screen.dart';
import 'package:erp_mobile_cnplus/features/hr/employee_status/presentation/screens/employee_status_detail_screen.dart';
import 'package:erp_mobile_cnplus/features/hr/employee_status/presentation/screens/employee_status_form_screen.dart';

// -- National Holiday
import 'package:erp_mobile_cnplus/features/hr/national_holiday/presentation/screens/national_holiday_list_screen.dart';
import 'package:erp_mobile_cnplus/features/hr/national_holiday/presentation/screens/national_holiday_detail_screen.dart';
import 'package:erp_mobile_cnplus/features/hr/national_holiday/presentation/screens/national_holiday_form_screen.dart';

// -- Position
import 'package:erp_mobile_cnplus/features/hr/position/presentation/screens/position_list_screen.dart';
import 'package:erp_mobile_cnplus/features/hr/position/presentation/screens/position_detail_screen.dart';
import 'package:erp_mobile_cnplus/features/hr/position/presentation/screens/position_form_screen.dart';

// -- Leave Type
import 'package:erp_mobile_cnplus/features/hr/leave_type/presentation/screens/leave_type_list_screen.dart';
import 'package:erp_mobile_cnplus/features/hr/leave_type/presentation/screens/leave_type_detail_screen.dart';
import 'package:erp_mobile_cnplus/features/hr/leave_type/presentation/screens/leave_type_form_screen.dart';

// -- Collective Leave
import 'package:erp_mobile_cnplus/features/hr/collective_leave/presentation/screens/collective_leave_list_screen.dart';
import 'package:erp_mobile_cnplus/features/hr/collective_leave/presentation/screens/collective_leave_detail_screen.dart';
import 'package:erp_mobile_cnplus/features/hr/collective_leave/presentation/screens/collective_leave_form_screen.dart';

// -- Leave Allocation
import 'package:erp_mobile_cnplus/features/hr/leave_allocation/presentation/screens/leave_allocation_list_screen.dart';
import 'package:erp_mobile_cnplus/features/hr/leave_allocation/presentation/screens/leave_allocation_detail_screen.dart';
import 'package:erp_mobile_cnplus/features/hr/leave_allocation/presentation/screens/leave_allocation_form_screen.dart';

// -- Leave Quota
import 'package:erp_mobile_cnplus/features/hr/leave_quota/presentation/screens/leave_quota_list_screen.dart';
import 'package:erp_mobile_cnplus/features/hr/leave_quota/presentation/screens/leave_quota_detail_screen.dart';

// -- Leave Request
import 'package:erp_mobile_cnplus/features/hr/leave_request/presentation/screens/leave_request_list_screen.dart';
import 'package:erp_mobile_cnplus/features/hr/leave_request/presentation/screens/leave_request_detail_screen.dart';
import 'package:erp_mobile_cnplus/features/hr/leave_request/presentation/screens/leave_request_form_screen.dart';

// -- Overtime Type
import 'package:erp_mobile_cnplus/features/hr/overtime_type/presentation/screens/overtime_type_list_screen.dart';
import 'package:erp_mobile_cnplus/features/hr/overtime_type/presentation/screens/overtime_type_detail_screen.dart';
import 'package:erp_mobile_cnplus/features/hr/overtime_type/presentation/screens/overtime_type_form_screen.dart';

// -- Overtime Request
import 'package:erp_mobile_cnplus/features/hr/overtime_request/presentation/screens/overtime_request_list_screen.dart';
import 'package:erp_mobile_cnplus/features/hr/overtime_request/presentation/screens/overtime_request_detail_screen.dart';
import 'package:erp_mobile_cnplus/features/hr/overtime_request/presentation/screens/overtime_request_form_screen.dart';

// -- My Payslip
import 'package:erp_mobile_cnplus/features/hr/my_payslip/presentation/screens/my_payslip_list_screen.dart';
import 'package:erp_mobile_cnplus/features/hr/my_payslip/presentation/screens/my_payslip_detail_screen.dart';

// -- Reports
import 'package:erp_mobile_cnplus/features/hr/attendance_report/presentation/screens/attendance_report_list_screen.dart';
import 'package:erp_mobile_cnplus/features/hr/attendance_late_report/presentation/screens/attendance_late_report_list_screen.dart';
import 'package:erp_mobile_cnplus/features/hr/attendance_overtime_report/presentation/screens/attendance_overtime_report_list_screen.dart';
import 'package:erp_mobile_cnplus/features/hr/leave_report/presentation/screens/leave_report_list_screen.dart';
import 'package:erp_mobile_cnplus/features/hr/payroll_summary_report/presentation/screens/payroll_summary_report_list_screen.dart';

// ACCOUNTING
// -- COA
import 'package:erp_mobile_cnplus/features/accounting/coa/presentation/screens/coa_list_screen.dart';
import 'package:erp_mobile_cnplus/features/accounting/coa/presentation/screens/coa_detail_screen.dart';
import 'package:erp_mobile_cnplus/features/accounting/coa/presentation/screens/coa_form_screen.dart';

// -- Bank Account
import 'package:erp_mobile_cnplus/features/accounting/bank_account/presentation/screens/bank_account_list_screen.dart';
import 'package:erp_mobile_cnplus/features/accounting/bank_account/presentation/screens/bank_account_detail_screen.dart';
import 'package:erp_mobile_cnplus/features/accounting/bank_account/presentation/screens/bank_account_form_screen.dart';

// -- Asset Category
import 'package:erp_mobile_cnplus/features/accounting/asset_category/presentation/screens/asset_category_list_screen.dart';
import 'package:erp_mobile_cnplus/features/accounting/asset_category/presentation/screens/asset_category_detail_screen.dart';
import 'package:erp_mobile_cnplus/features/accounting/asset_category/presentation/screens/asset_category_form_screen.dart';

// -- Fixed Asset
import 'package:erp_mobile_cnplus/features/accounting/fixed_asset/presentation/screens/fixed_asset_list_screen.dart';
import 'package:erp_mobile_cnplus/features/accounting/fixed_asset/presentation/screens/fixed_asset_detail_screen.dart';
import 'package:erp_mobile_cnplus/features/accounting/fixed_asset/presentation/screens/fixed_asset_form_screen.dart';

// -- Cash Bank
import 'package:erp_mobile_cnplus/features/accounting/cash_bank/presentation/screens/cash_bank_list_screen.dart';
import 'package:erp_mobile_cnplus/features/accounting/cash_bank/presentation/screens/cash_bank_detail_screen.dart';
import 'package:erp_mobile_cnplus/features/accounting/cash_bank/presentation/screens/cash_bank_form_screen.dart';

// -- Journal Entry
import 'package:erp_mobile_cnplus/features/accounting/journal_entry/presentation/screens/journal_entry_list_screen.dart';
import 'package:erp_mobile_cnplus/features/accounting/journal_entry/presentation/screens/journal_entry_detail_screen.dart';
import 'package:erp_mobile_cnplus/features/accounting/journal_entry/presentation/screens/journal_entry_form_screen.dart';

// -- Bill Payment
import 'package:erp_mobile_cnplus/features/accounting/bill_payment/presentation/screens/bill_payment_list_screen.dart';
import 'package:erp_mobile_cnplus/features/accounting/bill_payment/presentation/screens/bill_payment_detail_screen.dart';
import 'package:erp_mobile_cnplus/features/accounting/bill_payment/presentation/screens/bill_payment_form_screen.dart';

// -- Invoice Payment
import 'package:erp_mobile_cnplus/features/accounting/invoice_payment/presentation/screens/invoice_payment_list_screen.dart';
import 'package:erp_mobile_cnplus/features/accounting/invoice_payment/presentation/screens/invoice_payment_detail_screen.dart';
import 'package:erp_mobile_cnplus/features/accounting/invoice_payment/presentation/screens/invoice_payment_form_screen.dart';

// -- Period Closing
import 'package:erp_mobile_cnplus/features/accounting/period_closing/presentation/screens/period_closing_list_screen.dart';
import 'package:erp_mobile_cnplus/features/accounting/period_closing/presentation/screens/period_closing_detail_screen.dart';
import 'package:erp_mobile_cnplus/features/accounting/period_closing/presentation/screens/period_closing_form_screen.dart';

// -- Asset Depreciation
import 'package:erp_mobile_cnplus/features/accounting/asset_depreciation/presentation/screens/asset_depreciation_list_screen.dart';
import 'package:erp_mobile_cnplus/features/accounting/asset_depreciation/presentation/screens/asset_depreciation_detail_screen.dart';
import 'package:erp_mobile_cnplus/features/accounting/asset_depreciation/presentation/screens/asset_depreciation_form_screen.dart';

// -- Asset Movement
import 'package:erp_mobile_cnplus/features/accounting/asset_movement/presentation/screens/asset_movement_list_screen.dart';
import 'package:erp_mobile_cnplus/features/accounting/asset_movement/presentation/screens/asset_movement_detail_screen.dart';
import 'package:erp_mobile_cnplus/features/accounting/asset_movement/presentation/screens/asset_movement_form_screen.dart';

// -- Asset Disposal
import 'package:erp_mobile_cnplus/features/accounting/asset_disposal/presentation/screens/asset_disposal_list_screen.dart';
import 'package:erp_mobile_cnplus/features/accounting/asset_disposal/presentation/screens/asset_disposal_detail_screen.dart';
import 'package:erp_mobile_cnplus/features/accounting/asset_disposal/presentation/screens/asset_disposal_form_screen.dart';

// -- Tax Payment
import 'package:erp_mobile_cnplus/features/accounting/tax_payment/presentation/screens/tax_payment_list_screen.dart';
import 'package:erp_mobile_cnplus/features/accounting/tax_payment/presentation/screens/tax_payment_detail_screen.dart';
import 'package:erp_mobile_cnplus/features/accounting/tax_payment/presentation/screens/tax_payment_form_screen.dart';

// -- BPE Management
import 'package:erp_mobile_cnplus/features/accounting/bpe_management/presentation/screens/bpe_management_list_screen.dart';
import 'package:erp_mobile_cnplus/features/accounting/bpe_management/presentation/screens/bpe_management_detail_screen.dart';
import 'package:erp_mobile_cnplus/features/accounting/bpe_management/presentation/screens/bpe_management_form_screen.dart';

// -- Reports
import 'package:erp_mobile_cnplus/features/accounting/general_ledger/presentation/screens/general_ledger_list_screen.dart';
import 'package:erp_mobile_cnplus/features/accounting/cash_bank_report/presentation/screens/cash_bank_report_list_screen.dart';
import 'package:erp_mobile_cnplus/features/accounting/trial_balance/presentation/screens/trial_balance_list_screen.dart';
import 'package:erp_mobile_cnplus/features/accounting/cash_flow/presentation/screens/cash_flow_list_screen.dart';
import 'package:erp_mobile_cnplus/features/accounting/profit_loss/presentation/screens/profit_loss_list_screen.dart';
import 'package:erp_mobile_cnplus/features/accounting/balance_sheet/presentation/screens/balance_sheet_list_screen.dart';
import 'package:erp_mobile_cnplus/features/accounting/ar_aging_report/presentation/screens/ar_aging_report_list_screen.dart';
import 'package:erp_mobile_cnplus/features/accounting/billing_tax_report/presentation/screens/billing_tax_report_list_screen.dart';
import 'package:erp_mobile_cnplus/features/accounting/check_balance_journal/presentation/screens/check_balance_journal_list_screen.dart';
import 'package:erp_mobile_cnplus/features/accounting/depreciation_report/presentation/screens/depreciation_report_list_screen.dart';

// MANUFACTURING
// -- Workstation
import 'package:erp_mobile_cnplus/features/manufacturing/workstation/presentation/screens/workstation_list_screen.dart';
import 'package:erp_mobile_cnplus/features/manufacturing/workstation/presentation/screens/workstation_detail_screen.dart';
import 'package:erp_mobile_cnplus/features/manufacturing/workstation/presentation/screens/workstation_form_screen.dart';

// -- Bill of Material
import 'package:erp_mobile_cnplus/features/manufacturing/bom/presentation/screens/bom_list_screen.dart';
import 'package:erp_mobile_cnplus/features/manufacturing/bom/presentation/screens/bom_detail_screen.dart';
import 'package:erp_mobile_cnplus/features/manufacturing/bom/presentation/screens/bom_form_screen.dart';

// -- Manufacturing Order
import 'package:erp_mobile_cnplus/features/manufacturing/manufacturing_order/presentation/screens/manufacturing_order_list_screen.dart';
import 'package:erp_mobile_cnplus/features/manufacturing/manufacturing_order/presentation/screens/manufacturing_order_detail_screen.dart';
import 'package:erp_mobile_cnplus/features/manufacturing/manufacturing_order/presentation/screens/manufacturing_order_form_screen.dart';

// -- Unbuild Order
import 'package:erp_mobile_cnplus/features/manufacturing/unbuild_order/presentation/screens/unbuild_order_list_screen.dart';
import 'package:erp_mobile_cnplus/features/manufacturing/unbuild_order/presentation/screens/unbuild_order_detail_screen.dart';
import 'package:erp_mobile_cnplus/features/manufacturing/unbuild_order/presentation/screens/unbuild_order_form_screen.dart';

// -- Work Order
import 'package:erp_mobile_cnplus/features/manufacturing/work_order/presentation/screens/work_order_list_screen.dart';

// POS
// -- Transaction
import 'package:erp_mobile_cnplus/features/pos/transaction/presentation/screens/pos_transaction_screen.dart';
import 'package:erp_mobile_cnplus/features/pos/transaction/presentation/screens/pos_cart_screen.dart';
import 'package:erp_mobile_cnplus/features/pos/transaction/presentation/screens/pos_payment_screen.dart';
import 'package:erp_mobile_cnplus/features/pos/transaction/presentation/screens/pos_receipt_screen.dart';
import 'package:erp_mobile_cnplus/features/pos/transaction/presentation/screens/pos_close_session_screen.dart';
import 'package:erp_mobile_cnplus/features/pos/transaction/presentation/screens/pos_store_select_screen.dart';

// -- Transaction History
import 'package:erp_mobile_cnplus/features/pos/transaction_history/presentation/screens/transaction_history_list_screen.dart';
import 'package:erp_mobile_cnplus/features/pos/transaction_history/presentation/screens/transaction_history_detail_screen.dart';

// -- Store
import 'package:erp_mobile_cnplus/features/pos/store/presentation/screens/store_list_screen.dart';
import 'package:erp_mobile_cnplus/features/pos/store/presentation/screens/store_detail_screen.dart';
import 'package:erp_mobile_cnplus/features/pos/store/presentation/screens/store_form_screen.dart';

// -- Printer Config
import 'package:erp_mobile_cnplus/features/pos/printer_config/presentation/screens/printer_config_list_screen.dart';
import 'package:erp_mobile_cnplus/features/pos/printer_config/presentation/screens/printer_config_detail_screen.dart';
import 'package:erp_mobile_cnplus/features/pos/printer_config/presentation/screens/printer_config_form_screen.dart';

// -- Reports
import 'package:erp_mobile_cnplus/features/pos/top_customer_report/presentation/screens/top_customer_report_list_screen.dart' as pos_top_customer_report;
import 'package:erp_mobile_cnplus/features/pos/sold_product_report/presentation/screens/sold_product_report_list_screen.dart' as pos_sold_product_report;

import 'package:erp_mobile_cnplus/features/pos/store_session_report/presentation/screens/store_session_report_list_screen.dart';
import 'package:erp_mobile_cnplus/features/pos/store_session_report/presentation/screens/store_session_report_detail_screen.dart';
import 'package:erp_mobile_cnplus/features/pos/store_session_report/presentation/screens/store_session_transaction_detail_screen.dart';

class AppRoutes {
  // GENERAL
  static const String splash = '/';
  static const String initial = '/login';
  static const String profile = '/profile';
  static const String modul = '/modul';
  static const String generalDashboard = '/general-dashboard';
 
  // DASHBOARD
  static const String dashboardInventory = '/inventory';
  static const String dashboardPurchase = '/purchase';
  static const String dashboardSales = '/sales';
  static const String dashboardHr = '/hr';
  static const String dashboardAccounting = '/accounting';
  static const String dashboardManufacturing = '/manufacturing';
  static const String dashboardCrm = '/crm';
  static const String dashboardPos = '/pos';
 
  // MASTER DATA
  // -- Product
  static const String productList = '/master/products';
  static const String productDetail = '/master/products/detail';
  static const String productCreate = '/master/products/create';
  static const String productEdit = '/master/products/edit';
 
  // -- Brand
  static const String brandList = '/master/brands';
  static const String brandDetail = '/master/brands/detail';
  static const String brandCreate = '/master/brands/create';
  static const String brandEdit = '/master/brands/edit';
 
  // -- Product Category
  static const String productCategoryList = '/master/product-categories';
  static const String productCategoryDetail = '/master/product-categories/detail';
  static const String productCategoryCreate = '/master/product-categories/create';
  static const String productCategoryEdit = '/master/product-categories/edit';
 
  // -- Product Type
  static const String productTypeList = '/master/product-types';
  static const String productTypeDetail = '/master/product-types/detail';
  static const String productTypeCreate = '/master/product-types/create';
  static const String productTypeEdit = '/master/product-types/edit';
 
  // -- UOM
  static const String uomList = '/master/uom';
  static const String uomDetail = '/master/uom/detail';
  static const String uomCreate = '/master/uom/create';
  static const String uomEdit = '/master/uom/edit';
 
  // -- Vendor
  static const String vendorList = '/master/vendors';
  static const String vendorDetail = '/master/vendors/detail';
  static const String vendorCreate = '/master/vendors/create';
  static const String vendorEdit = '/master/vendors/edit';
 
  // -- Customer
  static const String customerList = '/master/customers';
  static const String customerDetail = '/master/customers/detail';
  static const String customerCreate = '/master/customers/create';
  static const String customerEdit = '/master/customers/edit';
 
  // -- Customer Category
  static const String customerCategoryList = '/master/customer-categories';
  static const String customerCategoryDetail = '/master/customer-categories/detail';
  static const String customerCategoryCreate = '/master/customer-categories/create';
  static const String customerCategoryEdit = '/master/customer-categories/edit';
 
  // -- Location
  static const String locationList = '/master/locations';
  static const String locationDetail = '/master/locations/detail';
  static const String locationCreate = '/master/locations/create';
  static const String locationEdit = '/master/locations/edit';
 
  // -- Warehouse
  static const String warehouseList = '/master/warehouses';
  static const String warehouseDetail = '/master/warehouses/detail';
  static const String warehouseCreate = '/master/warehouses/create';
  static const String warehouseEdit = '/master/warehouses/edit';
 
  // -- Sales Team
  static const String salesTeamList = '/master/sales-teams';
  static const String salesTeamDetail = '/master/sales-teams/detail';
  static const String salesTeamCreate = '/master/sales-teams/create';
  static const String salesTeamEdit = '/master/sales-teams/edit';
 
  // -- Purchase Team
  static const String purchaseTeamList = '/master/purchase-teams';
  static const String purchaseTeamDetail = '/master/purchase-teams/detail';
  static const String purchaseTeamCreate = '/master/purchase-teams/create';
  static const String purchaseTeamEdit = '/master/purchase-teams/edit';
 
  // -- Employee
  static const String employeeList = '/hr/employee';
  static const String employeeDetail = '/hr/employee/detail';
  static const String employeeCreate = '/hr/employee/create';
  static const String employeeEdit = '/hr/employee/edit';
 
  // -- Project
  static const String projectList = '/master/project';
  static const String projectDetail = '/master/project/detail';
  static const String projectCreate = '/master/project/create';
  static const String projectEdit = '/master/project/edit';
 
  // -- User
  static const String userList = '/master/user';
  static const String userDetail = '/master/user/detail';
  static const String userCreate = '/master/user/create';
  static const String userEdit = '/master/user/edit';
 
  // INVENTORY
  // -- Receipt Note
  static const String receiptNoteList = '/inventory/receipt-note';
  static const String receiptNoteDetail = '/inventory/receipt-note/detail';
  static const String receiptNoteCreate = '/inventory/receipt-note/create';
  static const String receiptNoteEdit = '/inventory/receipt-note/edit';
 
  // -- Delivery Note
  static const String deliveryNoteList = '/inventory/delivery-note';
  static const String deliveryNoteDetail = '/inventory/delivery-note/detail';
  static const String deliveryNoteCreate = '/inventory/delivery-note/create';
  static const String deliveryNoteEdit = '/inventory/delivery-note/edit';
 
  // -- Internal Transfer
  static const String internalTransferList = '/inventory/internal-transfer';
  static const String internalTransferDetail = '/inventory/internal-transfer/detail';
  static const String internalTransferCreate = '/inventory/internal-transfer/create';
  static const String internalTransferEdit = '/inventory/internal-transfer/edit';
 
  // -- Transfer In
  static const String transferInList = '/inventory/transfer-in';
  static const String transferInDetail = '/inventory/transfer-in/detail';
 
  // -- Transfer Out
  static const String transferOutList = '/inventory/transfer-out';
  static const String transferOutDetail = '/inventory/transfer-out/detail';
 
  // -- Scrap Order
  static const String scrapOrderList = '/inventory/scrap-order';
  static const String scrapOrderDetail = '/inventory/scrap-order/detail';
  static const String scrapOrderCreate = '/inventory/scrap-order/create';
  static const String scrapOrderEdit = '/inventory/scrap-order/edit';
 
  // -- Stock Count
  static const String stockCountList = '/inventory/stock-count';
  static const String stockCountDetail = '/inventory/stock-count/detail';
  static const String stockCountCreate = '/inventory/stock-count/create';
  static const String stockCountEdit = '/inventory/stock-count/edit';
 
  // -- Return RN
  static const String returnRNList = '/inventory/return-rn';
  static const String returnRNDetail = '/inventory/return-rn/detail';
  static const String returnRNCreate = '/inventory/return-rn/create';
  static const String returnRNEdit = '/inventory/return-rn/edit';
 
  // -- Return DN
  static const String returnDNList = '/inventory/return-dn';
  static const String returnDNDetail = '/inventory/return-dn/detail';
  static const String returnDNCreate = '/inventory/return-dn/create';
  static const String returnDNEdit = '/inventory/return-dn/edit';
 
  // -- Reports
  static const String warehouseReport = '/inventory/warehouse-report';
  static const String locationReport = '/inventory/location-report';
  static const String stockReport = '/inventory/stock-report';
  static const String stockMovement = '/inventory/stock-movement';
  static const String stockValuation = '/inventory/stock-valuation';
  static const String historyStock = '/inventory/history-stock-report';
  static const String expiredReport = '/inventory/expired-report';
 
  // SALES
  // -- Price List
  static const String priceListList = '/sales/price-list';
  static const String priceListDetail = '/sales/price-list/detail';
  static const String priceListCreate = '/sales/price-list/create';
  static const String priceListEdit = '/sales/price-list/edit';
 
  // -- Quotation
  static const String quotationList = '/sales/quotation';
  static const String quotationDetail = '/sales/quotation/detail';
  static const String quotationCreate = '/sales/quotation/create';
  static const String quotationEdit = '/sales/quotation/edit';
 
  // -- Sales Order
  static const String salesOrderList = '/sales/sales-order';
  static const String salesOrderDetail = '/sales/sales-order/detail';
  static const String salesOrderCreate = '/sales/sales-order/create';
  static const String salesOrderEdit = '/sales/sales-order/edit';
 
  // -- Direct Sales
  static const String directSalesList = '/sales/direct-sales';
  static const String directSalesDetail = '/sales/direct-sales/detail';
  static const String directSalesCreate = '/sales/direct-sales/create';
  static const String directSalesEdit = '/sales/direct-sales/edit';
 
  // -- Invoice
  static const String invoiceList = '/sales/invoices';
  static const String invoiceDetail = '/sales/invoices/detail';
  static const String invoiceCreate = '/sales/invoices/create';
  static const String invoiceEdit = '/sales/invoices/edit';
 
  // -- Service Sales: Quotation
  static const String serviceQuotationList = '/sales/service/quotation';
  static const String serviceQuotationDetail = '/sales/service/quotation/detail';
  static const String serviceQuotationCreate = '/sales/service/quotation/create';
  static const String serviceQuotationEdit = '/sales/service/quotation/edit';
 
  // -- Service Sales: Sales Order
  static const String serviceSalesOrderList = '/sales/service/sales-order';
  static const String serviceSalesOrderDetail = '/sales/service/sales-order/detail';
  static const String serviceSalesOrderCreate = '/sales/service/sales-order/create';
  static const String serviceSalesOrderEdit = '/sales/service/sales-order/edit';
 
  // -- Service Sales: Direct Sales
  static const String serviceDirectSalesList = '/sales/service/direct-sales';
  static const String serviceDirectSalesDetail = '/sales/service/direct-sales/detail';
  static const String serviceDirectSalesCreate = '/sales/service/direct-sales/create';
  static const String serviceDirectSalesEdit = '/sales/service/direct-sales/edit';
 
  // -- Service Sales: Invoice
  static const String serviceInvoiceList = '/sales/service/invoice';
  static const String serviceInvoiceDetail = '/sales/service/invoice/detail';
  static const String serviceInvoiceCreate = '/sales/service/invoice/create';
  static const String serviceInvoiceEdit = '/sales/service/invoice/edit';
 
  // -- Reports
  static const String quotationReportList = '/sales/quotation-report';
  static const String salesOrderReportList = '/sales/sales-order-report';
  static const String directSalesReportList = '/sales/direct-sales-report';
  static const String invoiceReportList = '/sales/invoice-report';
  static const String serviceQuotationReportList = '/sales/service/quotation-report';
  static const String serviceSalesOrderReportList = '/sales/service/sales-order-report';
  static const String serviceDirectSalesReportList = '/sales/service/direct-sales-report';
  static const String serviceInvoiceReportList = '/sales/service/invoice-report';
  static const String salesProductReportList = '/sales/sales-product-report';
  static const String salespersonsReportList = '/sales/salespersons-report';
  static const String topCustomerReportList = '/sales/top-customer-report';
  static const String ppnReportList = '/sales/ppn-report';
  static const String pphReportList = '/sales/pph-report';
 
  // PURCHASE
  // -- Purchase Request
  static const String purchaseRequestList = '/purchase/purchase-request';
  static const String purchaseRequestDetail = '/purchase/purchase-request/detail';
  static const String purchaseRequestCreate = '/purchase/purchase-request/create';
  static const String purchaseRequestEdit = '/purchase/purchase-request/edit';
 
  // -- RFQ
  static const String rfqList = '/purchase/rfq';
  static const String rfqDetail = '/purchase/rfq/detail';
  static const String rfqCreate = '/purchase/rfq/create';
  static const String rfqEdit = '/purchase/rfq/edit';
 
  // -- Direct Purchase
  static const String directPurchaseList = '/purchase/direct-purchase';
  static const String directPurchaseDetail = '/purchase/direct-purchase/detail';
  static const String directPurchaseCreate = '/purchase/direct-purchase/create';
  static const String directPurchaseEdit = '/purchase/direct-purchase/edit';
 
  // -- Purchase Order
  static const String purchaseOrderList = '/purchase/purchase-order';
  static const String purchaseOrderDetail = '/purchase/purchase-order/detail';
  static const String purchaseOrderCreate = '/purchase/purchase-order/create';
  static const String purchaseOrderEdit = '/purchase/purchase-order/edit';
 
  // -- Bill
  static const String billList = '/purchase/bill';
  static const String billDetail = '/purchase/bill/detail';
  static const String billCreate = '/purchase/bill/create';
  static const String billEdit = '/purchase/bill/edit';
 
  // -- Reports
  static const String purchaseRequestReportList = '/purchase/purchase-request-report';
  static const String requestQuotationReportList = '/purchase/rfq-report';
  static const String purchaseOrderReportList = '/purchase/purchase-order-report';
  static const String directPurchaseReportList = '/purchase/direct-purchase-report';
  static const String topPurchaseOrderReportList = '/purchase/top-purchase-order-report';
  static const String topPurchasingProductReportList = '/purchase/top-purchasing-product-report';
 
  // HR
  // -- Attendance
  static const String attendance = '/hr/attendance';
  static const String attendanceCheckIn = '/hr/attendance/check-in';
  static const String attendanceCheckOut = '/hr/attendance/check-out';
  static const String attendanceHistory = '/hr/attendance/history';
 
  // -- Department
  static const String departmentList = '/hr/departments';
  static const String departmentDetail = '/hr/departments/detail';
  static const String departmentCreate = '/hr/departments/create';
  static const String departmentEdit = '/hr/departments/edit';
 
  // -- Employee Status
  static const String employeeStatusList = '/hr/employee-statuses';
  static const String employeeStatusDetail = '/hr/employee-statuses/detail';
  static const String employeeStatusCreate = '/hr/employee-statuses/create';
  static const String employeeStatusEdit = '/hr/employee-statuses/edit';
 
  // -- National Holiday
  static const String nationalHolidayList = '/hr/national-holidays';
  static const String nationalHolidayDetail = '/hr/national-holidays/detail';
  static const String nationalHolidayCreate = '/hr/national-holidays/create';
  static const String nationalHolidayEdit = '/hr/national-holidays/edit';
 
  // -- Position
  static const String positionList = '/hr/positions';
  static const String positionDetail = '/hr/positions/detail';
  static const String positionCreate = '/hr/positions/create';
  static const String positionEdit = '/hr/positions/edit';
 
  // -- Leave Type
  static const String leaveTypeList = '/hr/leave-types';
  static const String leaveTypeDetail = '/hr/leave-types/detail';
  static const String leaveTypeCreate = '/hr/leave-types/create';
  static const String leaveTypeEdit = '/hr/leave-types/edit';
 
  // -- Collective Leave
  static const String collectiveLeaveList = '/hr/collective-leave';
  static const String collectiveLeaveDetail = '/hr/collective-leave/detail';
  static const String collectiveLeaveCreate = '/hr/collective-leave/create';
  static const String collectiveLeaveEdit = '/hr/collective-leave/edit';
 
  // -- Leave Allocation
  static const String leaveAllocationList = '/hr/leave-allocation';
  static const String leaveAllocationDetail = '/hr/leave-allocation/detail';
  static const String leaveAllocationCreate = '/hr/leave-allocation/create';
  static const String leaveAllocationEdit = '/hr/leave-allocation/edit';
 
  // -- Leave Quota
  static const String leaveQuotaList = '/hr/leave-quota';
  static const String leaveQuotaDetail = '/hr/leave-quota/detail';
 
  // -- Leave Request
  static const String leaveRequestList = '/hr/leave-request';
  static const String leaveRequestDetail = '/hr/leave-request/detail';
  static const String leaveRequestCreate = '/hr/leave-request/create';
  static const String leaveRequestEdit = '/hr/leave-request/edit';
 
  // -- Overtime Type
  static const String overtimeTypeList = '/hr/overtime-type';
  static const String overtimeTypeDetail = '/hr/overtime-type/detail';
  static const String overtimeTypeCreate = '/hr/overtime-type/create';
  static const String overtimeTypeEdit = '/hr/overtime-type/edit';
 
  // -- Overtime Request
  static const String overtimeRequestList = '/hr/overtime-request';
  static const String overtimeRequestDetail = '/hr/overtime-request/detail';
  static const String overtimeRequestCreate = '/hr/overtime-request/create';
  static const String overtimeRequestEdit = '/hr/overtime-request/edit';
 
  // -- My Payslip
  static const String myPaySlipList = '/hr/my-payslip';
  static const String myPaySlipDetail = '/hr/my-payslip/detail';
 
  // -- Reports
  static const String attendanceReportList = '/hr/attendance-report';
  static const String attendanceLateReportList = '/hr/attendance-late-report';
  static const String attendanceOvertimeReportList = '/hr/attendance-overtime-report';
  static const String leaveReportList = '/hr/leave-report';
  static const String payrollSummaryReportList = '/hr/payroll-summary-report';
 
  // ACCOUNTING
  // -- COA
  static const String coaList = '/accounting/coa';
  static const String coaDetail = '/accounting/coa/detail';
  static const String coaCreate = '/accounting/coa/create';
  static const String coaEdit = '/accounting/coa/edit';
 
  // -- Bank Account
  static const String bankAccountList = '/accounting/bank-account';
  static const String bankAccountDetail = '/accounting/bank-account/detail';
  static const String bankAccountCreate = '/accounting/bank-account/create';
  static const String bankAccountEdit = '/accounting/bank-account/edit';

  // -- Asset Category
  static const String assetCategoryList = '/accounting/asset-category';
  static const String assetCategoryDetail = '/accounting/asset-category/detail';
  static const String assetCategoryCreate = '/accounting/asset-category/create';
  static const String assetCategoryEdit = '/accounting/asset-category/edit';

  // -- Fixed Asset
  static const String fixedAssetList = '/accounting/fixed-asset';
  static const String fixedAssetDetail = '/accounting/fixed-asset/detail';
  static const String fixedAssetCreate = '/accounting/fixed-asset/create';
  static const String fixedAssetEdit = '/accounting/fixed-asset/edit';
 
  // -- Cash Bank
  static const String cashBankList = '/accounting/cash-bank';
  static const String cashBankDetail = '/accounting/cash-bank/detail';
  static const String cashBankCreate = '/accounting/cash-bank/create';
  static const String cashBankEdit = '/accounting/cash-bank/edit';
 
  // -- Journal Entry
  static const String journalEntryList = '/accounting/journal-entry';
  static const String journalEntryDetail = '/accounting/journal-entry/detail';
  static const String journalEntryCreate = '/accounting/journal-entry/create';
  static const String journalEntryEdit = '/accounting/journal-entry/edit';
 
  // -- Bill Payment
  static const String billPaymentList = '/accounting/bill-payment';
  static const String billPaymentDetail = '/accounting/bill-payment/detail';
  static const String billPaymentCreate = '/accounting/bill-payment/create';
  static const String billPaymentEdit = '/accounting/bill-payment/edit';
 
  // -- Invoice Payment
  static const String invoicePaymentList = '/accounting/invoice-payment';
  static const String invoicePaymentDetail = '/accounting/invoice-payment/detail';
  static const String invoicePaymentCreate = '/accounting/invoice-payment/create';
  static const String invoicePaymentEdit = '/accounting/invoice-payment/edit';
 
  // -- Period Closing
  static const String periodClosingList = '/accounting/period-closing';
  static const String periodClosingDetail = '/accounting/period-closing/detail';
  static const String periodClosingCreate = '/accounting/period-closing/create';
  static const String periodClosingEdit = '/accounting/period-closing/edit';

  // -- Asset Depreciation
  static const String assetDepreciationList = '/accounting/asset-depreciation';
  static const String assetDepreciationDetail = '/accounting/asset-depreciation/detail';
  static const String assetDepreciationCreate = '/accounting/asset-depreciation/create';

  // -- Asset Movement
  static const String assetMovementList = '/accounting/asset-movement';
  static const String assetMovementDetail = '/accounting/asset-movement/detail';
  static const String assetMovementCreate = '/accounting/asset-movement/create';

  // -- Asset Disposal
  static const String assetDisposalList = '/accounting/asset-disposal';
  static const String assetDisposalDetail = '/accounting/asset-disposal/detail';
  static const String assetDisposalCreate = '/accounting/asset-disposal/create';
  static const String assetDisposalEdit = '/accounting/asset-disposal/edit';
 
  // -- Tax Payment
  static const String taxPaymentList = '/accounting/tax-payment';
  static const String taxPaymentDetail = '/accounting/tax-payment/detail';
  static const String taxPaymentCreate = '/accounting/tax-payment/create';
  static const String taxPaymentEdit = '/accounting/tax-payment/edit';

  // -- BPE Management
  static const String bpeManagementList = '/accounting/bpe-management';
  static const String bpeManagementDetail = '/accounting/bpe-management/detail';
  static const String bpeManagementCreate = '/accounting/bpe-management/create';
  static const String bpeManagementEdit = '/accounting/bpe-management/edit';
 
  // -- Reports
  static const String generalLedger = '/accounting/general-ledger';
  static const String cashBankReport = '/accounting/cash-bank-report';
  static const String trialBalance = '/accounting/trial-balance';
  static const String cashFlow = '/accounting/cash-flow';
  static const String profitLoss = '/accounting/profit-loss';
  static const String balanceSheet = '/accounting/balance-sheet';
  static const String arAgingReport = '/accounting/ar-aging-report';
  static const String billingTaxReport = '/accounting/billing-tax-report';
  static const String checkBalanceJournal = '/accounting/check-balance-journal';
  static const String depreciationReport = '/accounting/depreciation-report';
 
  // MANUFACTURING
  // -- Workstation
  static const String workstationList = '/manufacturing/workstation';
  static const String workstationDetail = '/manufacturing/workstation/detail';
  static const String workstationCreate = '/manufacturing/workstation/create';
  static const String workstationEdit = '/manufacturing/workstation/edit';
 
  // -- Bill of Material
  static const String bomList = '/manufacturing/bom';
  static const String bomDetail = '/manufacturing/bom/detail';
  static const String bomCreate = '/manufacturing/bom/create';
  static const String bomEdit = '/manufacturing/bom/edit';
 
  // -- Manufacturing Order
  static const String manufacturingOrderList = '/manufacturing/manufacturing-order';
  static const String manufacturingOrderDetail = '/manufacturing/manufacturing-order/detail';
  static const String manufacturingOrderCreate = '/manufacturing/manufacturing-order/create';
  static const String manufacturingOrderEdit = '/manufacturing/manufacturing-order/edit';
 
  // -- Unbuild Order
  static const String unbuildOrderList = '/manufacturing/unbuild-order';
  static const String unbuildOrderDetail = '/manufacturing/unbuild-order/detail';
  static const String unbuildOrderCreate = '/manufacturing/unbuild-order/create';
  static const String unbuildOrderEdit = '/manufacturing/unbuild-order/edit';
 
  // -- Work Order
  static const String workOrderList = '/manufacturing/work-order';
 
  // POS
  // -- Store
  static const String storeList = '/master/store';
  static const String storeDetail = '/master/store/detail';
  static const String storeCreate = '/master/store/create';
  static const String storeEdit = '/master/store/edit';
 
  // -- Printer Config
  static const String printerConfigList = '/pos/printer-config';
  static const String printerConfigDetail = '/pos/printer-config/detail';
  static const String printerConfigCreate = '/pos/printer-config/create';
  static const String printerConfigEdit = '/pos/printer-config/edit';

  // -- Top Customer Report (POS)
  static const String posTopCustomerReportList = '/pos/top-customer-report';

  // -- Sold Product Report (POS)
  static const String posSoldProductReportList = '/pos/sold-product-report';

  // -- Store Session Report (POS)
  static const String posStoreSessionReportList = '/pos/store-session-report';
  static const String posStoreSessionReportDetail = '/pos/store-session-report/detail';
  static const String posStoreSessionTransactionDetail = '/pos/store-session-report/transaction';

  // -- Transaction History (POS)
  static const String posTransactionHistoryList = '/pos/transaction-history';
  static const String posTransactionHistoryDetail = '/pos/transaction-history/detail';

  // -- POS Transaction
  static const String posTransaction = '/pos/transaction';
  static const String posTransactionCart = '/pos/transaction/cart';
  static const String posTransactionPayment = '/pos/transaction/payment';
  static const String posTransactionReceipt = '/pos/transaction/receipt';
  static const String posTransactionCloseSession = '/pos/transaction/close-session';
  static const String posTransactionStoreSelect = '/pos/transaction/select-store';
 
  static Map<String, WidgetBuilder> routes = {
    // -- General
    splash: (context) => const SplashScreen(),
    initial: (context) => const LoginScreen(),
    profile: (context) => const ProfileScreen(),
    modul: (context) => const ModulScreen(),
    generalDashboard: (context) => const GeneralDashboardScreen(),
 
    // -- Dashboard
    dashboardInventory: (context) => const DashboardInventoryScreen(),
    dashboardPurchase: (context) => const DashboardPurchaseScreen(),
    dashboardSales: (context) => const DashboardSalesScreen(),
    dashboardHr: (context) => const DashboardHrScreen(),
    dashboardAccounting: (context) => const DashboardAccountingScreen(),
    dashboardManufacturing: (context) => const DashboardManufacturingScreen(),
    dashboardCrm: (context) => const DashboardCrmScreen(),
    dashboardPos: (context) => const DashboardPosScreen(),
 
    // -- Master Data: Product
    productList: (context) => const ProductListScreen(),
    productDetail: (context) => ProductDetailScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
    productCreate: (context) => const ProductFormScreen(),
    productEdit: (context) => ProductFormScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
 
    // -- Master Data: Brand
    brandList: (context) => const BrandListScreen(),
    brandDetail: (context) => BrandDetailScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
    brandCreate: (context) => const BrandFormScreen(),
    brandEdit: (context) => BrandFormScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
 
    // -- Master Data: Product Category
    productCategoryList: (context) => const ProductCategoryListScreen(),
    productCategoryDetail: (context) => ProductCategoryDetailScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
    productCategoryCreate: (context) => const ProductCategoryFormScreen(),
    productCategoryEdit: (context) => ProductCategoryFormScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
 
    // -- Master Data: Product Type
    productTypeList: (context) => const ProductTypeListScreen(),
    productTypeDetail: (context) => ProductTypeDetailScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
    productTypeCreate: (context) => const ProductTypeFormScreen(),
    productTypeEdit: (context) => ProductTypeFormScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
 
    // -- Master Data: UOM
    uomList: (context) => const UomListScreen(),
    uomDetail: (context) => UomDetailScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
    uomCreate: (context) => const UomFormScreen(),
    uomEdit: (context) => UomFormScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
 
    // -- Master Data: Vendor
    vendorList: (context) => const VendorListScreen(),
    vendorDetail: (context) => VendorDetailScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
    vendorCreate: (context) => const VendorFormScreen(),
    vendorEdit: (context) => VendorFormScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
 
    // -- Master Data: Customer
    customerList: (context) => const CustomerListScreen(),
    customerDetail: (context) => CustomerDetailScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
    customerCreate: (context) => const CustomerFormScreen(),
    customerEdit: (context) => CustomerFormScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
 
    // -- Master Data: Customer Category
    customerCategoryList: (context) => const CustomerCategoryListScreen(),
    customerCategoryDetail: (context) => CustomerCategoryDetailScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
    customerCategoryCreate: (context) => const CustomerCategoryFormScreen(),
    customerCategoryEdit: (context) => CustomerCategoryFormScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
 
    // -- Master Data: Location
    locationList: (context) => const LocationListScreen(),
    locationDetail: (context) => LocationDetailScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
    locationCreate: (context) => const LocationFormScreen(),
    locationEdit: (context) => LocationFormScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
 
    // -- Master Data: Warehouse
    warehouseList: (context) => const WarehouseListScreen(),
    warehouseDetail: (context) => WarehouseDetailScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
    warehouseCreate: (context) => const WarehouseFormScreen(),
    warehouseEdit: (context) => WarehouseFormScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
 
    // -- Master Data: Sales Team
    salesTeamList: (context) => const SalesTeamListScreen(),
    salesTeamDetail: (context) => SalesTeamDetailScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
    salesTeamCreate: (context) => const SalesTeamFormScreen(),
    salesTeamEdit: (context) => SalesTeamFormScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
 
    // -- Master Data: Purchase Team
    purchaseTeamList: (context) => const PurchaseTeamListScreen(),
    purchaseTeamDetail: (context) => PurchaseTeamDetailScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
    purchaseTeamCreate: (context) => const PurchaseTeamFormScreen(),
    purchaseTeamEdit: (context) => PurchaseTeamFormScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
 
    // -- Master Data: Employee
    employeeList: (context) => const EmployeeListScreen(),
    employeeDetail: (context) => EmployeeDetailScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
    employeeCreate: (context) => const EmployeeFormScreen(),
    employeeEdit: (context) => EmployeeFormScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
 
    // -- Master Data: Project
    projectList: (context) => const ProjectListScreen(),
    projectDetail: (context) => ProjectDetailScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
    projectCreate: (context) => const ProjectFormScreen(),
    projectEdit: (context) => ProjectFormScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
 
    // -- Master Data: User
    userList: (context) => const UserListScreen(),
    userDetail: (context) => UserDetailScreen(userId: ModalRoute.of(context)!.settings.arguments as int),
 
    // -- Inventory: Receipt Note
    receiptNoteList: (context) => const ReceiptNoteListScreen(),
    receiptNoteDetail: (context) => ReceiptNoteDetailScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
    receiptNoteCreate: (context) => const ReceiptNoteFormScreen(),
    receiptNoteEdit: (context) => ReceiptNoteFormScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
 
    // -- Inventory: Delivery Note
    deliveryNoteList: (context) => const DeliveryNoteListScreen(),
    deliveryNoteDetail: (context) => DeliveryNoteDetailScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
    deliveryNoteCreate: (context) => const DeliveryNoteFormScreen(),
    deliveryNoteEdit: (context) => DeliveryNoteFormScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
 
    // -- Inventory: Internal Transfer
    internalTransferList: (context) => const InternalTransferListScreen(),
    internalTransferDetail: (context) => InternalTransferDetailScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
    internalTransferCreate: (context) => const InternalTransferFormScreen(),
    internalTransferEdit: (context) => InternalTransferFormScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
 
    // -- Inventory: Transfer In
    transferInList: (context) => const TransferInListScreen(),
    transferInDetail: (context) => TransferInDetailScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
 
    // -- Inventory: Transfer Out
    transferOutList: (context) => const TransferOutListScreen(),
    transferOutDetail: (context) => TransferOutDetailScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
 
    // -- Inventory: Scrap Order
    scrapOrderList: (context) => const ScrapOrderListScreen(),
    scrapOrderDetail: (context) => ScrapOrderDetailScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
    scrapOrderCreate: (context) => const ScrapOrderFormScreen(),
    scrapOrderEdit: (context) => ScrapOrderFormScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
 
    // -- Inventory: Stock Count
    stockCountList: (context) => const StockCountListScreen(),
    stockCountDetail: (context) => StockCountDetailScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
    stockCountCreate: (context) => const StockCountFormScreen(),
 
    // -- Inventory: Return RN
    returnRNList: (context) => const ReturnRNListScreen(),
    returnRNDetail: (context) => ReturnRNDetailScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
    returnRNCreate: (context) => const ReturnRNFormScreen(),
    returnRNEdit: (context) => ReturnRNFormScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
 
    // -- Inventory: Return DN
    returnDNList: (context) => const ReturnDNListScreen(),
    returnDNDetail: (context) => ReturnDNDetailScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
    returnDNCreate: (context) => const ReturnDNFormScreen(),
    returnDNEdit: (context) => ReturnDNFormScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
 
    // -- Inventory: Reports
    warehouseReport: (context) => const WarehouseReportListScreen(),
    locationReport: (context) => const LocationReportListScreen(),
    stockReport: (context) => const StockReportListScreen(),
    stockMovement: (context) => const StockMovementListScreen(),
    stockValuation: (context) => const StockValuationListScreen(),
    historyStock: (context) => const HistoryStockListScreen(),
    expiredReport: (context) => const ExpiredReportListScreen(),
 
    // -- Sales: Price List
    priceListList: (context) => const PriceListListScreen(),
    priceListDetail: (context) => PriceListDetailScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
    priceListCreate: (context) => const PriceListFormScreen(),
    priceListEdit: (context) => PriceListFormScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
 
    // -- Sales: Quotation
    quotationList: (context) => const QuotationListScreen(),
    quotationDetail: (context) => QuotationDetailScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
    quotationCreate: (context) => const QuotationFormScreen(),
    quotationEdit: (context) => QuotationFormScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
 
    // -- Sales: Sales Order
    salesOrderList: (context) => const SalesOrderListScreen(),
    salesOrderDetail: (context) => SalesOrderDetailScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
    salesOrderCreate: (context) => const SalesOrderFormScreen(),
    salesOrderEdit: (context) => SalesOrderFormScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
 
    // -- Sales: Direct Sales
    directSalesList: (context) => const DirectSalesListScreen(),
    directSalesDetail: (context) => DirectSalesDetailScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
    directSalesCreate: (context) => const DirectSalesFormScreen(),
    directSalesEdit: (context) => DirectSalesFormScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
 
    // -- Sales: Invoice
    invoiceList: (context) => const InvoiceListScreen(),
    invoiceDetail: (context) => InvoiceDetailScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
    invoiceCreate: (context) => const InvoiceFormScreen(),
    invoiceEdit: (context) => InvoiceFormScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
 
    // -- Sales: Service Quotation
    serviceQuotationList: (context) => const ServiceQuotationListScreen(),
    serviceQuotationDetail: (context) => ServiceQuotationDetailScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
    serviceQuotationCreate: (context) => const ServiceQuotationFormScreen(),
    serviceQuotationEdit: (context) => ServiceQuotationFormScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
 
    // -- Sales: Service Sales Order
    serviceSalesOrderList: (context) => const ServiceSalesOrderListScreen(),
    serviceSalesOrderDetail: (context) => ServiceSalesOrderDetailScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
    serviceSalesOrderCreate: (context) => const ServiceSalesOrderFormScreen(),
    serviceSalesOrderEdit: (context) => ServiceSalesOrderFormScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
 
    // -- Sales: Service Direct Sales
    serviceDirectSalesList: (context) => const ServiceDirectSalesListScreen(),
    serviceDirectSalesDetail: (context) => ServiceDirectSalesDetailScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
    serviceDirectSalesCreate: (context) => const ServiceDirectSalesFormScreen(),
    serviceDirectSalesEdit: (context) => ServiceDirectSalesFormScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
 
    // -- Sales: Service Invoice
    serviceInvoiceList: (context) => const ServiceInvoiceListScreen(),
    serviceInvoiceDetail: (context) => ServiceInvoiceDetailScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
    serviceInvoiceCreate: (context) => const ServiceInvoiceFormScreen(),
    serviceInvoiceEdit: (context) => ServiceInvoiceFormScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
 
    // -- Sales: Reports
    quotationReportList: (context) => const QuotationReportListScreen(),
    salesOrderReportList: (context) => const SalesOrderReportListScreen(),
    directSalesReportList: (context) => const DirectSalesReportListScreen(),
    invoiceReportList: (context) => const InvoiceReportListScreen(),
    serviceQuotationReportList: (context) => const ServiceQuotationReportListScreen(),
    serviceSalesOrderReportList: (context) => const ServiceSalesOrderReportListScreen(),
    serviceDirectSalesReportList: (context) => const ServiceDirectSalesReportListScreen(),
    serviceInvoiceReportList: (context) => const ServiceInvoiceReportListScreen(),
    salesProductReportList: (context) => const SalesProductReportListScreen(),
    salespersonsReportList: (context) => const SalespersonsReportListScreen(),
    topCustomerReportList: (context) => const TopCustomerReportListScreen(),
    ppnReportList: (context) => const PPNReportListScreen(),
    pphReportList: (context) => const PPHReportListScreen(),
 
    // -- Purchase: Purchase Request
    purchaseRequestList: (context) => const PurchaseRequestListScreen(),
    purchaseRequestDetail: (context) => PurchaseRequestDetailScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
    purchaseRequestCreate: (context) => const PurchaseRequestFormScreen(),
    purchaseRequestEdit: (context) => PurchaseRequestFormScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
 
    // -- Purchase: RFQ
    rfqList: (context) => const RfqListScreen(),
    rfqDetail: (context) => RfqDetailScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
    rfqCreate: (context) => const RfqFormScreen(),
    rfqEdit: (context) => RfqFormScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
 
    // -- Purchase: Direct Purchase
    directPurchaseList: (context) => const DirectPurchaseListScreen(),
    directPurchaseDetail: (context) => DirectPurchaseDetailScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
    directPurchaseCreate: (context) => const DirectPurchaseFormScreen(),
    directPurchaseEdit: (context) => DirectPurchaseFormScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
 
    // -- Purchase: Purchase Order
    purchaseOrderList: (context) => const PurchaseOrderListScreen(),
    purchaseOrderDetail: (context) => PurchaseOrderDetailScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
    purchaseOrderCreate: (context) => const PurchaseOrderFormScreen(),
    purchaseOrderEdit: (context) => PurchaseOrderFormScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
 
    // -- Purchase: Bill
    billList: (context) => const BillListScreen(),
    billDetail: (context) => BillDetailScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
    billCreate: (context) => const BillFormScreen(),
    billEdit: (context) => BillFormScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
 
    // -- Purchase: Reports
    purchaseRequestReportList: (context) => const PurchaseRequestReportListScreen(),
    requestQuotationReportList: (context) => const RequestQuotationReportListScreen(),
    purchaseOrderReportList: (context) => const PurchaseOrderReportListScreen(),
    directPurchaseReportList: (context) => const DirectPurchaseReportListScreen(),
    topPurchaseOrderReportList: (context) => const TopPurchaseOrderReportListScreen(),
    topPurchasingProductReportList: (context) => const TopPurchasingProductReportListScreen(),
 
    // -- HR: Attendance
    attendance: (context) => const AttendanceScreen(),
    attendanceCheckIn: (context) => const AttendanceFormScreen(isCheckOut: false),
    attendanceCheckOut: (context) => const AttendanceFormScreen(isCheckOut: true),
    attendanceHistory: (context) => const AttendanceHistoryScreen(),
 
    // -- HR: Department
    departmentList: (context) => const DepartmentListScreen(),
    departmentDetail: (context) => DepartmentDetailScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
    departmentCreate: (context) => const DepartmentFormScreen(),
    departmentEdit: (context) => DepartmentFormScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
 
    // -- HR: Employee Status
    employeeStatusList: (context) => const EmployeeStatusListScreen(),
    employeeStatusDetail: (context) => EmployeeStatusDetailScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
    employeeStatusCreate: (context) => const EmployeeStatusFormScreen(),
    employeeStatusEdit: (context) => EmployeeStatusFormScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
 
    // -- HR: National Holiday
    nationalHolidayList: (context) => const NationalHolidayListScreen(),
    nationalHolidayDetail: (context) => NationalHolidayDetailScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
    nationalHolidayCreate: (context) => const NationalHolidayFormScreen(),
    nationalHolidayEdit: (context) => NationalHolidayFormScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
 
    // -- HR: Position
    positionList: (context) => const PositionListScreen(),
    positionDetail: (context) => PositionDetailScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
    positionCreate: (context) => const PositionFormScreen(),
    positionEdit: (context) => PositionFormScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
 
    // -- HR: Leave Type
    leaveTypeList: (context) => const LeaveTypeListScreen(),
    leaveTypeDetail: (context) => LeaveTypeDetailScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
    leaveTypeCreate: (context) => const LeaveTypeFormScreen(),
    leaveTypeEdit: (context) => LeaveTypeFormScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
 
    // -- HR: Collective Leave
    collectiveLeaveList: (context) => const CollectiveLeaveListScreen(),
    collectiveLeaveDetail: (context) => CollectiveLeaveDetailScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
    collectiveLeaveCreate: (context) => const CollectiveLeaveFormScreen(),
    collectiveLeaveEdit: (context) => CollectiveLeaveFormScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
 
    // -- HR: Leave Allocation
    leaveAllocationList: (context) => const LeaveAllocationListScreen(),
    leaveAllocationDetail: (context) => LeaveAllocationDetailScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
    leaveAllocationCreate: (context) => const LeaveAllocationFormScreen(),
    leaveAllocationEdit: (context) => LeaveAllocationFormScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
 
    // -- HR: Overtime Type
    overtimeTypeList: (context) => const OvertimeTypeListScreen(),
    overtimeTypeDetail: (context) => OvertimeTypeDetailScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
    overtimeTypeCreate: (context) => const OvertimeTypeFormScreen(),
    overtimeTypeEdit: (context) => OvertimeTypeFormScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
 
    // -- HR: Leave Quota
    leaveQuotaList: (context) => const LeaveQuotaListScreen(),
    leaveQuotaDetail: (context) {
      final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      return LeaveQuotaDetailScreen(
        employeeEncryption: args['employeeEncryption'],
        employeeName: args['employeeName'],
        leaveTypeName: args['leaveTypeName'],
        leaveTypeId: args['leaveTypeId'],
        period: args['period'],
      );
    },
 
    // -- HR: Leave Request
    leaveRequestList: (context) => const LeaveRequestListScreen(),
    leaveRequestDetail: (context) => LeaveRequestDetailScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
    leaveRequestCreate: (context) => const LeaveRequestFormScreen(),
    leaveRequestEdit: (context) => LeaveRequestFormScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
 
    // -- HR: Overtime Request
    overtimeRequestList: (context) => const OvertimeRequestListScreen(),
    overtimeRequestDetail: (context) => OvertimeRequestDetailScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
    overtimeRequestCreate: (context) => const OvertimeRequestFormScreen(),
    overtimeRequestEdit: (context) => OvertimeRequestFormScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
 
    // -- HR: My Payslip
    myPaySlipList: (context) => const MyPaySlipListScreen(),
    myPaySlipDetail: (context) => MyPaySlipDetailScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
 
    // -- HR: Reports
    attendanceReportList: (context) => const AttendanceReportListScreen(),
    attendanceLateReportList: (context) => const AttendanceLateReportListScreen(),
    attendanceOvertimeReportList: (context) => const AttendanceOvertimeReportListScreen(),
    leaveReportList: (context) => const LeaveReportListScreen(),
    payrollSummaryReportList: (context) => const PayrollSummaryReportListScreen(),
 
    // -- Accounting: COA
    coaList: (context) => const CoaListScreen(),
    coaDetail: (context) => CoaDetailScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
    coaCreate: (context) => const CoaFormScreen(),
    coaEdit: (context) => CoaFormScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
 
    // -- Accounting: Bank Account
    bankAccountList: (context) => const BankAccountListScreen(),
    bankAccountDetail: (context) => BankAccountDetailScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
    bankAccountCreate: (context) => const BankAccountFormScreen(),
    bankAccountEdit: (context) => BankAccountFormScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
 
    // -- Accounting: Asset Category
    assetCategoryList: (context) => const AssetCategoryListScreen(),
    assetCategoryDetail: (context) => AssetCategoryDetailScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
    assetCategoryCreate: (context) => const AssetCategoryFormScreen(),
    assetCategoryEdit: (context) => AssetCategoryFormScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
 
    // -- Accounting: Fixed Asset
    fixedAssetList: (context) => const FixedAssetListScreen(),
    fixedAssetDetail: (context) => FixedAssetDetailScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
    fixedAssetCreate: (context) => const FixedAssetFormScreen(),
    fixedAssetEdit: (context) => FixedAssetFormScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
 
    // -- Accounting: Cash Bank
    cashBankList: (context) => const CashBankListScreen(),
    cashBankDetail: (context) => CashBankDetailScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
    cashBankCreate: (context) => const CashBankFormScreen(),
    cashBankEdit: (context) => CashBankFormScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
 
    // -- Accounting: Journal Entry
    journalEntryList: (context) => const JournalEntryListScreen(),
    journalEntryDetail: (context) => JournalEntryDetailScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
    journalEntryCreate: (context) => const JournalEntryFormScreen(),
    journalEntryEdit: (context) => JournalEntryFormScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
 
    // -- Accounting: Bill Payment
    billPaymentList: (context) => const BillPaymentListScreen(),
    billPaymentDetail: (context) => BillPaymentDetailScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
    billPaymentCreate: (context) => const BillPaymentFormScreen(),
    billPaymentEdit: (context) => BillPaymentFormScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
 
    // -- Accounting: Invoice Payment
    invoicePaymentList: (context) => const InvoicePaymentListScreen(),
    invoicePaymentDetail: (context) => InvoicePaymentDetailScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
    invoicePaymentCreate: (context) => const InvoicePaymentFormScreen(),
    invoicePaymentEdit: (context) => InvoicePaymentFormScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
 
    // -- Accounting: Period Closing
    periodClosingList: (context) => const PeriodClosingListScreen(),
    periodClosingDetail: (context) => PeriodClosingDetailScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
    periodClosingCreate: (context) => const PeriodClosingFormScreen(),
    periodClosingEdit: (context) => PeriodClosingFormScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),

    // -- Accounting: Asset Depreciation
    assetDepreciationList: (context) => const AssetDepreciationListScreen(),
    assetDepreciationDetail: (context) => AssetDepreciationDetailScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
    assetDepreciationCreate: (context) => const AssetDepreciationFormScreen(),
    
    // -- Accounting: Asset Movement
    assetMovementList: (context) => const AssetMovementListScreen(),
    assetMovementDetail: (context) => AssetMovementDetailScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
    assetMovementCreate: (context) => const AssetMovementFormScreen(),

    // -- Accounting: Asset Disposal
    assetDisposalList: (context) => const AssetDisposalListScreen(),
    assetDisposalDetail: (context) => AssetDisposalDetailScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
    assetDisposalCreate: (context) => const AssetDisposalFormScreen(),
    assetDisposalEdit: (context) => AssetDisposalFormScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),

    // -- Accounting: Tax Payment
    taxPaymentList: (context) => const TaxPaymentListScreen(),
    taxPaymentDetail: (context) => TaxPaymentDetailScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
    taxPaymentCreate: (context) => const TaxPaymentFormScreen(),
    taxPaymentEdit: (context) => TaxPaymentFormScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),

    // -- Accounting: BPE Management
    bpeManagementList: (context) => const BpeManagementListScreen(),
    bpeManagementDetail: (context) => BpeManagementDetailScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
    bpeManagementCreate: (context) => const BpeManagementFormScreen(),
    bpeManagementEdit: (context) => BpeManagementFormScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
 
    // -- Accounting: Reports
    generalLedger: (context) => const GeneralLedgerListScreen(),
    cashBankReport: (context) => const CashBankReportListScreen(),
    trialBalance: (context) => const TrialBalanceListScreen(),
    cashFlow: (context) => const CashFlowListScreen(),
    profitLoss: (context) => const ProfitLossListScreen(),
    balanceSheet: (context) => const BalanceSheetListScreen(),
    arAgingReport: (context) => const ARAgingReportListScreen(),
    billingTaxReport: (context) => const BillingTaxReportListScreen(),
    checkBalanceJournal: (context) => const CheckBalanceJournalListScreen(),
    depreciationReport: (context) => const DepreciationReportListScreen(),
 
    // -- Manufacturing: Workstation
    workstationList: (context) => const WorkstationListScreen(),
    workstationDetail: (context) => WorkstationDetailScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
    workstationCreate: (context) => const WorkstationFormScreen(),
    workstationEdit: (context) => WorkstationFormScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
 
    // -- Manufacturing: Bill of Material
    bomList: (context) => const BomListScreen(),
    bomDetail: (context) => BomDetailScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
    bomCreate: (context) => const BomFormScreen(),
    bomEdit: (context) => BomFormScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
 
    // -- Manufacturing: Manufacturing Order
    manufacturingOrderList: (context) => const ManufacturingOrderListScreen(),
    manufacturingOrderDetail: (context) => ManufacturingOrderDetailScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
    manufacturingOrderCreate: (context) => const ManufacturingOrderFormScreen(),
    manufacturingOrderEdit: (context) => ManufacturingOrderFormScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
 
    // -- Manufacturing: Unbuild Order
    unbuildOrderList: (context) => const UnbuildOrderListScreen(),
    unbuildOrderDetail: (context) => UnbuildOrderDetailScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
    unbuildOrderCreate: (context) => const UnbuildOrderFormScreen(),
    unbuildOrderEdit: (context) => UnbuildOrderFormScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
 
    // -- Manufacturing: Work Order
    workOrderList: (context) => const WorkOrderListScreen(),
 
    // -- POS: Store
    storeList: (context) => const StoreListScreen(),
    storeDetail: (context) => StoreDetailScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
    storeCreate: (context) => const StoreFormScreen(),
    storeEdit: (context) => StoreFormScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
 
    // -- POS: Printer Config
    printerConfigList: (context) => const PrinterConfigListScreen(),
    printerConfigDetail: (context) => PrinterConfigDetailScreen(id: ModalRoute.of(context)!.settings.arguments as int),
    printerConfigCreate: (context) => const PrinterConfigFormScreen(),
    printerConfigEdit: (context) => PrinterConfigFormScreen(id: ModalRoute.of(context)!.settings.arguments as int),
  
    // -- POS: Top Customer Report
    posTopCustomerReportList: (context) => const pos_top_customer_report.TopCustomerReportListScreen(),

    // -- POS: Sold Product Report
    posSoldProductReportList: (context) => const pos_sold_product_report.SoldProductReportListScreen(),
    
    // -- POS: Store Session Report
    posStoreSessionReportList: (context) => const StoreSessionReportListScreen(),
    posStoreSessionReportDetail: (context) => StoreSessionReportDetailScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
    posStoreSessionTransactionDetail: (context) => StoreSessionTransactionDetailScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),

    // -- POS: Transaction History
    posTransactionHistoryList: (context) => const TransactionHistoryListScreen(),
    posTransactionHistoryDetail: (context) => TransactionHistoryDetailScreen(encryption: ModalRoute.of(context)!.settings.arguments as String),
  
    // -- POS: Transaction
    posTransactionStoreSelect: (context) => const PosStoreSelectScreen(),
    posTransaction: (context) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is! PosTransactionArgs) return const PosStoreSelectScreen();
      return PosTransactionScreen(args: args);
    },
    posTransactionCart: (context) => const PosCartScreen(),
    posTransactionPayment: (context) => const PosPaymentScreen(),
    posTransactionReceipt: (context) => const PosReceiptScreen(),
    posTransactionCloseSession: (context) => const PosCloseSessionScreen(),
  };
}
 