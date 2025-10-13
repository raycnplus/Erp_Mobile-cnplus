// show_location_widget.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import '../../../../../../../services/api_base.dart';
import '../models/show_location_models.dart';

class LocationShowWidget extends StatefulWidget {
  final int idLocation;

  const LocationShowWidget({super.key, required this.idLocation});

  @override
  State<LocationShowWidget> createState() => _LocationShowWidgetState();
}

class _LocationShowWidgetState extends State<LocationShowWidget> {
  final storage = const FlutterSecureStorage();
  late Future<LocationShowModel> futureLocation;

  @override
  void initState() {
    super.initState();
    futureLocation = fetchLocation();
  }

  Future<LocationShowModel> fetchLocation() async {
    final token = await storage.read(key: 'token');
    final response = await http.get(
      Uri.parse('${ApiBase.baseUrl}/inventory/location/${widget.idLocation}'),
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
    );

    if (response.statusCode == 200) {
      // debugPrint("Raw JSON Response: ${response.body}");
      return LocationShowModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load location detail');
    }
  }

  // Helper untuk menangani nilai null
  String _safe(String? value, {String suffix = ''}) {
    if (value == null || value.isEmpty || value == '0') return '-';
    return '$value$suffix';
  }

  // Helper untuk memformat tanggal
  String _formatDate(String? dateString) {
    if (dateString == null) return '-';
    try {
      final dateTime = DateTime.parse(dateString);
      return DateFormat('d MMMM yyyy, HH:mm').format(dateTime);
    } catch (e) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Skema Warna
    const primaryColor =  Color(0xFF679436);
    const backgroundColor = Color(0xFFF8F9FA);
    const cardColor = Colors.white;
    const textColor = Color(0xFF333333);
    const subtleTextColor = Color(0xFF757575);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: FutureBuilder<LocationShowModel>(
        future: futureLocation,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData) {
            return const Center(child: Text("No data available"));
          }

          final location = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildInfoCard(
                  title: location.locationName,
                  subtitle: location.locationCode,
                  icon: Icons.location_on_outlined,
                  iconColor: primaryColor,
                  cardColor: cardColor,
                  textColor: textColor,
                ),
                const SizedBox(height: 16),
                _buildDetailCard(
                  title: "Association",
                  icon: Icons.group_work_outlined,
                  cardColor: cardColor,
                  textColor: textColor,
                  subtleTextColor: subtleTextColor,
                  children: [
                    _buildListDetailItem(
                        Icons.warehouse_outlined, "Warehouse", location.warehouseName),
                    if (location.parentLocationName.isNotEmpty)
                      _buildListDetailItem(
                          Icons.call_split_outlined, "Parent Location", location.parentLocationName),
                  ],
                ),
                const SizedBox(height: 16),
                _buildDetailCard(
                  title: "Dimensions",
                  icon: Icons.straighten_outlined,
                  cardColor: cardColor,
                  textColor: textColor,
                  subtleTextColor: subtleTextColor,
                  children: [
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      childAspectRatio: 2.5,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      children: [
                        _buildGridDetailItem("Length", _safe(location.length, suffix: " m"), textColor, subtleTextColor),
                        _buildGridDetailItem("Width", _safe(location.width, suffix: " m"), textColor, subtleTextColor),
                        _buildGridDetailItem("Height", _safe(location.height, suffix: " m"), textColor, subtleTextColor),
                        _buildGridDetailItem("Volume", _safe(location.volume, suffix: " m³"), textColor, subtleTextColor),
                      ],
                    ),
                  ],
                ),
                 const SizedBox(height: 16),
                _buildDetailCard(
                  title: "Additional Info",
                  icon: Icons.info_outline,
                  cardColor: cardColor,
                  textColor: textColor,
                  subtleTextColor: subtleTextColor,
                  children: [
                     if (location.description != null && location.description!.isNotEmpty)
                      _buildListDetailItem(Icons.notes_outlined, "Description", location.description!),
                    _buildListDetailItem(Icons.person_outline, "Created By", _safe(location.createdBy)),
                    _buildListDetailItem(Icons.calendar_today_outlined, "Created On", _formatDate(location.createdOn)),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // --- Widget Helper untuk UI ---

  Widget _buildInfoCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required Color cardColor,
    required Color textColor,
  }) {
    return Card(
      elevation: 4,
      shadowColor: iconColor.withOpacity(0.2),
      color: cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: iconColor.withOpacity(0.1),
              child: Icon(icon, size: 32, color: iconColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: textColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard({
    required String title,
    required IconData icon,
    required Color cardColor,
    required Color textColor,
    required Color subtleTextColor,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.05),
      color: cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: textColor,
              ),
            ),
            const Divider(height: 24),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildListDetailItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.grey.shade500),
          const SizedBox(width: 12),
          Text(label, style: TextStyle(color: Colors.grey.shade700)),
          const Spacer(),
          Expanded(
            flex: 2,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridDetailItem(String label, String value, Color textColor, Color subtleTextColor) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            value,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textColor),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: subtleTextColor),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}