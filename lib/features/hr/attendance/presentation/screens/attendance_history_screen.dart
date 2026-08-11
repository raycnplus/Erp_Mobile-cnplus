import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../controllers/attendance_controller.dart';
import '../../domain/entities/attendance_entity.dart';

class AttendanceHistoryScreen extends StatefulWidget {
  const AttendanceHistoryScreen({super.key});

  @override
  State<AttendanceHistoryScreen> createState() =>
      _AttendanceHistoryScreenState();
}

class _AttendanceHistoryScreenState extends State<AttendanceHistoryScreen> {
  static const Color primaryGreen = Color(0xFF2D6A4F);

  int _selectedMonth = DateTime.now().month;
  int _selectedYear = DateTime.now().year;

  final List<String> _months = [
    'January', 'February', 'March', 'April',
    'May', 'June', 'July', 'August',
    'September', 'October', 'November', 'December',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadHistory());
  }

  void _loadHistory() {
    context.read<AttendanceController>().loadHistory(
          month: _selectedMonth,
          year: _selectedYear,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F5),
      appBar: AppBar(
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Attendance History',
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600, fontSize: 18, color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          // Filter bar
          Container(
            color: primaryGreen,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              children: [
                Expanded(
                  child: _buildDropdown<int>(
                    value: _selectedMonth,
                    items: List.generate(
                      12,
                      (i) => DropdownMenuItem(
                        value: i + 1,
                        child: Text(_months[i],
                            style: GoogleFonts.poppins(
                                color: Colors.grey.shade800, fontSize: 13)),
                      ),
                    ),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => _selectedMonth = val);
                        _loadHistory();
                      }
                    },
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 100,  
                  child: _buildDropdown<int>(
                    value: _selectedYear,
                    items: [2024, 2025, 2026].map((y) {
                      return DropdownMenuItem(
                        value: y,
                        child: Text('$y',
                            style: GoogleFonts.poppins(
                                color: Colors.grey.shade800, fontSize: 13)),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => _selectedYear = val);
                        _loadHistory();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: Consumer<AttendanceController>(
              builder: (context, controller, _) {
                final history = controller.history;
                if (history == null) {
                  return const Center(
                    child: CircularProgressIndicator(color: primaryGreen),
                  );
                }

                if (history.attendances.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.event_busy,
                            size: 64, color: Colors.grey.shade300),
                        const SizedBox(height: 12),
                        Text(
                          'No attendance records found',
                          style: GoogleFonts.poppins(
                              color: Colors.grey.shade500),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: history.attendances.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) =>
                      _buildHistoryItem(history.attendances[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown<T>({
    required T value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          dropdownColor: Colors.white,
          style: GoogleFonts.poppins(color: Colors.grey.shade800, fontSize: 13),
          iconEnabledColor: Colors.white,
          isExpanded: true,  // ← ganti jadi true
          items: items,
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildHistoryItem(RecentAttendanceEntity att) {
    Color statusColor;
    IconData statusIcon;
    switch (att.status) {
      case 'present':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle_outline;
        break;
      case 'late':
        statusColor = Colors.orange;
        statusIcon = Icons.access_time;
        break;
      case 'absent':
        statusColor = Colors.red;
        statusIcon = Icons.cancel_outlined;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.help_outline;
    }

    String formattedDate = att.attendanceDate;
    try {
      final parts = att.attendanceDate.split('-');
      final date = DateTime(
        int.parse(parts[0]),
        int.parse(parts[1]), 
        int.parse(parts[2].substring(0, 2)), 
      );
      formattedDate = DateFormat('EEE, d MMM yyyy').format(date);
    } catch (_) {}

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(statusIcon, color: statusColor, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  formattedDate,
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600, fontSize: 13),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(Icons.login, size: 12, color: Colors.grey.shade500),
                    const SizedBox(width: 3),
                    Text(
                      att.checkInTime ?? '--:--',
                      style: GoogleFonts.poppins(
                          fontSize: 12, color: Colors.grey.shade600),
                    ),
                    const SizedBox(width: 12),
                    Icon(Icons.logout, size: 12, color: Colors.grey.shade500),
                    const SizedBox(width: 3),
                    Text(
                      att.checkOutTime ?? '--:--',
                      style: GoogleFonts.poppins(
                          fontSize: 12, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: statusColor.withOpacity(0.3)),
                ),
                child: Text(
                  att.status ?? '-',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (att.workingHours != null) ...[
                const SizedBox(height: 4),
                Text(
                  '${att.workingHours!.toStringAsFixed(1)} hrs',
                  style: GoogleFonts.poppins(
                      fontSize: 11, color: Colors.grey.shade500),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}