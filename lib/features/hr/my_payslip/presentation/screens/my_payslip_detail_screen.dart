import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:erp_mobile_cnplus/core/injector/injector.dart';

import 'package:erp_mobile_cnplus/features/hr/my_payslip/presentation/controllers/my_payslip_detail_controller.dart';

class MyPaySlipDetailScreen
    extends StatefulWidget {
  final String encryption;

  const MyPaySlipDetailScreen({
    super.key,
    required this.encryption,
  });

  @override
  State<MyPaySlipDetailScreen>
      createState() =>
          _MyPaySlipDetailScreenState();
}

class _MyPaySlipDetailScreenState
    extends State<MyPaySlipDetailScreen> {
  late MyPaySlipDetailController
      _controller;

  static const Color _themeColor =
      Color(0xFF2D6A4F);

  @override
  void initState() {
    super.initState();

    _controller =
        getIt<MyPaySlipDetailController>();

    WidgetsBinding.instance
        .addPostFrameCallback((_) {
      _controller.fetchDetail(
        widget.encryption,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<
        MyPaySlipDetailController>.value(
      value: _controller,
      child: Scaffold(
        backgroundColor:
            Colors.grey[100],
        appBar: AppBar(
          backgroundColor:
              Colors.white,
          elevation: 1,
          title: Text(
            'Payslip Detail',
            style: GoogleFonts.poppins(
              color: Colors.black87,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          iconTheme:
              const IconThemeData(
            color: Colors.black,
          ),
        ),
        body: Consumer<
            MyPaySlipDetailController>(
          builder:
              (context, controller, _) {
            if (controller.isLoading) {
              return const Center(
                child:
                    CircularProgressIndicator(
                  color: _themeColor,
                ),
              );
            }

            if (controller.status ==
                MyPaySlipDetailStatus
                    .error) {
              return _buildError(
                controller,
              );
            }

            if (!controller
                .hasData) {
              return const Center(
                child: Text(
                  'No data available',
                ),
              );
            }

            return _buildContent(
              controller,
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent(
    MyPaySlipDetailController controller,
  ) {
    final data =
        controller.data!;

    final employee =
        data.employee;

    final period =
        data.payrollPeriod;

    final payslip =
        data.payslip;

    final currency =
        NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return RefreshIndicator(
      color: _themeColor,
      onRefresh: () {
        return controller.fetchDetail(
          widget.encryption,
        );
      },
      child: ListView(
        padding:
            const EdgeInsets.all(16),
        children: [
          _buildEmployeeCard(
            employee.employeeName,
            employee.departmentName,
          ),

          const SizedBox(
            height: 16,
          ),

          _buildPeriodCard(
            period,
          ),

          const SizedBox(
            height: 16,
          ),

          _buildSalaryCard(
            payslip,
            currency,
          ),

          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeeCard(
    String name,
    String department,
  ) {
    return _whiteCard(
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration:
                BoxDecoration(
              color: _themeColor
                  .withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person_outline,
              color: _themeColor,
              size: 28,
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
              children: [
                Text(
                  name,
                  style:
                      GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight:
                        FontWeight.w700,
                  ),
                ),
                const SizedBox(
                  height: 3,
                ),
                Text(
                  department.isEmpty
                      ? '-'
                      : department,
                  style:
                      GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors
                        .grey
                        .shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodCard(
    dynamic period,
  ) {
    return _whiteCard(
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          _sectionTitle(
            Icons
                .calendar_month_outlined,
            'Payroll Period',
          ),
          const SizedBox(
            height: 16,
          ),
          _detailRow(
            'Period',
            period.periodName,
          ),
          _detailRow(
            'Date',
            period.dateRange,
          ),
          _detailRow(
            'Status',
            period.status,
          ),
        ],
      ),
    );
  }

  Widget _buildSalaryCard(
    dynamic payslip,
    NumberFormat currency,
  ) {
    return _whiteCard(
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          _sectionTitle(
            Icons.payments_outlined,
            'Salary Detail',
          ),

          const SizedBox(
            height: 16,
          ),

          _moneyRow(
            'Basic Salary',
            currency.format(
              payslip.basicSalary,
            ),
          ),

          _moneyRow(
            'Allowance',
            currency.format(
              payslip.totalAllowance,
            ),
          ),

          _moneyRow(
            'Overtime',
            currency.format(
              payslip.overtime,
            ),
          ),

          const Divider(
            height: 24,
          ),

          _moneyRow(
            'Deduction',
            currency.format(
              payslip.totalDeduction,
            ),
            valueColor:
                Colors.red.shade600,
          ),

          const SizedBox(
            height: 12,
          ),

          Container(
            width: double.infinity,
            padding:
                const EdgeInsets.all(
              16,
            ),
            decoration:
                BoxDecoration(
              color: _themeColor
                  .withOpacity(
                0.08,
              ),
              borderRadius:
                  BorderRadius.circular(
                12,
              ),
            ),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment
                      .spaceBetween,
              children: [
                Text(
                  'Take Home Pay',
                  style:
                      GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),
                Text(
                  payslip
                      .takeHomePayDisplay,
                  style:
                      GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight:
                        FontWeight.w700,
                    color:
                        _themeColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(
    IconData icon,
    String title,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          color: _themeColor,
          size: 22,
        ),
        const SizedBox(
          width: 8,
        ),
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 17,
            fontWeight:
                FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _detailRow(
    String label,
    String value,
  ) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(
        vertical: 6,
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style:
                  GoogleFonts.poppins(
                fontSize: 12,
                color: Colors
                    .grey
                    .shade600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? '-' : value,
              style:
                  GoogleFonts.poppins(
                fontSize: 13,
                fontWeight:
                    FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _moneyRow(
    String label,
    String value, {
    Color? valueColor,
  }) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(
        vertical: 6,
      ),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment
                .spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: Colors
                  .grey
                  .shade700,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight:
                  FontWeight.w600,
              color: valueColor ??
                  Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _whiteCard({
    required Widget child,
  }) {
    return Container(
      padding:
          const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(
          16,
        ),
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(
              0.05,
            ),
            blurRadius: 10,
            offset:
                const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildError(
    MyPaySlipDetailController
        controller,
  ) {
    return Center(
      child: Padding(
        padding:
            const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 56,
              color: Colors.red,
            ),
            const SizedBox(
              height: 12,
            ),
            Text(
              controller
                      .errorMessage ??
                  'Failed to load payslip',
              textAlign:
                  TextAlign.center,
              style: GoogleFonts.poppins(
                color: Colors.red,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}