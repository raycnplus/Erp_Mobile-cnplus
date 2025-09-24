import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Import widget dan screen
import '../widget/index_location_widget.dart';
import '../../show/screen/show_location_screen.dart';
import '../../create/screen/create_location_screen.dart';
import '../models/index_location_models.dart';

// Widget diubah menjadi StatefulWidget untuk mengelola state refresh dan notifikasi
class LocationIndexScreen extends StatefulWidget {
  const LocationIndexScreen({super.key});

  @override
  State<LocationIndexScreen> createState() => _LocationIndexScreenState();
}

class _LocationIndexScreenState extends State<LocationIndexScreen> {
  // Kunci global untuk mengakses fungsi reloadData() di child widget
  final GlobalKey<LocationListWidgetState> _listKey = GlobalKey<LocationListWidgetState>();

  // Fungsi untuk mentrigger refresh
  Future<void> _refreshData() async {
    // Memanggil fungsi reloadData yang ada di dalam LocationListWidgetState
    _listKey.currentState?.reloadData();
  }

  // ▼▼▼ FUNGSI NOTIFIKASI SUKSES CREATE BARU ▼▼▼
  void _showCreateSuccessMessage() {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("New location has been successfully created."),
        backgroundColor: const Color(0xFF679436), // Warna hijau
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // Fungsi notifikasi untuk hapus data
  void _showDeleteSuccessMessage(String locationName) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("'$locationName' has been successfully removed."),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Locations", style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.black87, fontSize: 20)),
            Text('Swipe an item for actions', style: GoogleFonts.poppins(fontWeight: FontWeight.normal, color: Colors.grey.shade600, fontSize: 12)),
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
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: LocationListWidget(
          key: _listKey,
          onTap: (LocationIndexModel location) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LocationShowScreen(idLocation: location.idLocation),
              ),
            );
          },
          onDeleteSuccess: (String locationName) {
            _showDeleteSuccessMessage(locationName);
          },
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: const Color(0xFF679436).withAlpha(102), blurRadius: 15, spreadRadius: 2, offset: const Offset(0, 5)),
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
            // ▼▼▼ LOGIKA DIPERBARUI DI SINI ▼▼▼
            if (result == true) {
              _refreshData();
              _showCreateSuccessMessage(); // Panggil notifikasi hijau
            }
          },
          tooltip: 'Add Location',
          backgroundColor: const Color(0xFF679436),
          elevation: 0,
          child: const Icon(Icons.add, color: Color(0xFFF0E68C)),
        ),
      ),
    );
  }
}