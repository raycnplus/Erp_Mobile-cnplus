// index_location_screen.dart

import 'dart:async'; // Import untuk Timer (Debouncing)
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widget/index_location_widget.dart';
import '../../show/screen/show_location_screen.dart';
import '../../create/screen/create_location_screen.dart';
import '../models/index_location_models.dart';
import '../../../../../../../shared/widgets/success_bottom_sheet.dart';

class LocationIndexScreen extends StatefulWidget {
  const LocationIndexScreen({super.key});

  @override
  State<LocationIndexScreen> createState() => _LocationIndexScreenState();
}

class _LocationIndexScreenState extends State<LocationIndexScreen> {
  final GlobalKey<LocationListWidgetState> _listKey = GlobalKey<LocationListWidgetState>();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  Timer? _debounce; // Variabel Timer untuk debouncing

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel(); // Batalkan timer saat widget dihancurkan
    super.dispose();
  }

  // Fungsi Debouncing: Menunggu user berhenti mengetik sebelum mencari
  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _searchQuery = query;
      });
    });
  }

  Future<void> _refreshData() async {
    _listKey.currentState?.reloadData();
  }

  // --- Fungsi Notifikasi ---
  void _showCreateSuccessMessage() {
    if (!mounted) return;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => const SuccessBottomSheet(
        title: "Successfully Created!",
        message: "New location has been added to the list.",
      ),
    );
  }

  void _showUpdateSuccessMessage() {
    if (!mounted) return;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => const SuccessBottomSheet(
        title: "Successfully Updated!",
        message: "The location has been updated.",
        themeColor: Color(0xFF4A90E2),
      ),
    );
  }

  void _showDeleteSuccessMessage(String locationName) {
    if (!mounted) return;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => SuccessBottomSheet(
        title: "Successfully Deleted!",
        message: "'$locationName' has been removed.",
        themeColor: const Color(0xFFF35D5D),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ▼▼▼ APPBAR DIKEMBALIKAN KE VERSI SEBELUMNYA ▼▼▼
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Locations",
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                    fontSize: 20)),
            Text('Swipe an item for actions',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.normal,
                    color: Colors.grey.shade600,
                    fontSize: 12)),
          ],
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        shape: Border(
          bottom: BorderSide(
            color: Colors.grey.shade200,
            width: 1.0,
          ),
        ),
      ),
      // ▼▼▼ BODY DIKEMBALIKAN KE VERSI SEBELUMNYA (DENGAN SEARCH BAR DI DALAMNYA) ▼▼▼
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged, // Tetap menggunakan debouncing
              decoration: InputDecoration(
                hintText: "Search locations...",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          // Perbaikan kecil: langsung panggil _onSearchChanged
                          _onSearchChanged("");
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshData,
              child: LocationListWidget(
                key: _listKey,
                searchQuery: _searchQuery,
                onTap: (LocationIndexModel location) async {
                  final result = await Navigator.push<bool>(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          LocationShowScreen(idLocation: location.idLocation),
                    ),
                  );
                  if (result == true) {
                    _refreshData();
                    _showUpdateSuccessMessage();
                  }
                },
                onDeleteSuccess: (String locationName) {
                  _showDeleteSuccessMessage(locationName);
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
                color: const Color(0xFF679436).withAlpha(102),
                blurRadius: 15,
                spreadRadius: 2,
                offset: const Offset(0, 5)),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LocationCreateScreen(),
              ),
            );
            if (result == true) {
              _refreshData();
              _showCreateSuccessMessage();
            }
          },
          tooltip: 'Add Location',
          backgroundColor: const Color(0xFF679436),
          elevation: 0,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}