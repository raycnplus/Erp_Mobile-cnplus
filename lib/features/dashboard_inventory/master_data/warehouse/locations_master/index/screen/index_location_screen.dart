import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widget/index_location_widget.dart';
import '../../show/screen/show_location_screen.dart';
import '../../create/screen/create_location_screen.dart';
import '../models/index_location_models.dart';

class LocationIndexScreen extends StatefulWidget {
  const LocationIndexScreen({super.key});

  @override
  State<LocationIndexScreen> createState() => _LocationIndexScreenState();
}

class _LocationIndexScreenState extends State<LocationIndexScreen> {
  final GlobalKey<LocationListWidgetState> _listKey = GlobalKey<LocationListWidgetState>();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  Future<void> _refreshData() async {
    _listKey.currentState?.reloadData();
  }

  void _showCreateSuccessMessage() {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("New location has been successfully created."),
        backgroundColor: const Color(0xFF679436),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

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
      body: Column(
        children: [
          // 🔎 Search Bar
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() => _searchQuery = value);
              },
              decoration: InputDecoration(
                hintText: "Search locations...",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = "");
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
                searchQuery: _searchQuery, // << dikirim ke child
                onTap: (LocationIndexModel location) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          LocationShowScreen(idLocation: location.idLocation),
                    ),
                  );
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
          child: const Icon(Icons.add, color: Color(0xFFF0E68C)),
        ),
      ),
    );
  }
}
