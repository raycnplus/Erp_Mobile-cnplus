import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../../../../services/api_base.dart';
import '../models/index_location_models.dart';
import 'location_list_shimmer.dart';

class LocationListWidget extends StatefulWidget {
  final Function(LocationIndexModel) onTap;
  final Function(String name)? onDeleteSuccess;
  final String searchQuery;

  const LocationListWidget({
    super.key,
    required this.onTap,
    this.onDeleteSuccess,
    this.searchQuery = "",
  });

  @override
  State<LocationListWidget> createState() => LocationListWidgetState();
}

class LocationListWidgetState extends State<LocationListWidget> {
  final List<LocationIndexModel> _locations = [];
  final ScrollController _scrollController = ScrollController();
  
  bool _isLoading = false;
  bool _hasMoreData = true;
  int _currentPage = 1;
  final int _limit = 15;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    _scrollController.addListener(_onScroll);
  }

  @override
  void didUpdateWidget(LocationListWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.searchQuery != oldWidget.searchQuery) {
      reloadData();
    }
  }

  Future<void> _loadInitialData() async {
    setState(() {
      _isLoading = true;
    });
    await _fetchLocations(isInitialLoad: true);
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _fetchLocations({bool isInitialLoad = false}) async {
    if (isInitialLoad) {
      _currentPage = 1;
      _locations.clear();
      _hasMoreData = true;
    }
    
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');
    if (token == null) throw Exception("Token not found");

    final uri = Uri.parse('${ApiBase.baseUrl}/inventory/location').replace(
      queryParameters: {
        'page': _currentPage.toString(),
        'limit': _limit.toString(),
        if (widget.searchQuery.isNotEmpty) 'search': widget.searchQuery,
      },
    );

    final response = await http.get(uri, headers: {
      "Authorization": "Bearer $token", 
      "Accept": "application/json",
      "Cache-Control": "no-cache, no-store, must-revalidate",
    });

    if (response.statusCode == 200) {
      final List<dynamic> decodedData = jsonDecode(response.body);
      final List<LocationIndexModel> newLocations = decodedData
          .map((json) => LocationIndexModel.fromJson(json as Map<String, dynamic>))
          .toList();

      if (!mounted) return;
      setState(() {
        if (newLocations.length < _limit) {
          _hasMoreData = false;
        }
        _locations.addAll(newLocations);
        _currentPage++;
      });
    } else {
      throw Exception('Failed to load locations: ${response.statusCode}');
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200 &&
        !_isLoading && _hasMoreData) {
      _loadMoreData();
    }
  }

  Future<void> _loadMoreData() async {
    setState(() {
      _isLoading = true;
    });
    await _fetchLocations();
    setState(() {
      _isLoading = false;
    });
  }
  
  void reloadData() {
    _loadInitialData();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  Future<bool> _deleteLocation(int id) async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');
    final response = await http.delete(
      Uri.parse('${ApiBase.baseUrl}/inventory/location/$id'),
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
    );
    return response.statusCode == 200;
  }

  @override
  Widget build(BuildContext context) {
    if (_locations.isEmpty && _isLoading) {
      return const LocationListShimmer();
    }
    
    if (_locations.isEmpty && !_isLoading) {
      return Center(child: Text(widget.searchQuery.isNotEmpty ? "No results found." : "No locations available."));
    }
    
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16.0),
      itemCount: _locations.length + (_isLoading && _hasMoreData ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _locations.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        final location = _locations[index];
        return _buildLocationCard(location);
      },
    );
  }

  Widget _buildLocationCard(LocationIndexModel location) {
    final cardBorderRadius = BorderRadius.circular(12);
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      decoration: BoxDecoration(
        borderRadius: cardBorderRadius,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(26),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Dismissible(
        key: Key(location.idLocation.toString()),
        background: _buildSwipeActionContainer(
          color: Colors.blue,
          icon: Icons.edit,
          text: 'Edit',
          alignment: Alignment.centerLeft,
        ),
        secondaryBackground: _buildSwipeActionContainer(
          color: Colors.red,
          icon: Icons.delete,
          text: 'Delete',
          alignment: Alignment.centerRight,
        ),
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.endToStart) {
            bool? deleteConfirmed = await _showDeleteConfirmationDialog(
              location,
            );
            if (deleteConfirmed == true) {
              final success = await _deleteLocation(location.idLocation);
              if (success) {
                widget.onDeleteSuccess?.call(location.locationName);
                reloadData(); 
              } else {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Failed to delete item."),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                }
              }
              return success;
            }
            return false;
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Edit feature is not yet available."),
              ),
            );
            return false;
          }
        },
        child: ClipRRect(
          borderRadius: cardBorderRadius,
          child: Material(
            color: Colors.white,
            child: InkWell(
              onTap: () => widget.onTap(location),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      location.locationName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildInfoRow(
                      Icons.warehouse_outlined,
                      location.warehouseName,
                    ),
                    const SizedBox(height: 4),
                    _buildInfoRow(Icons.qr_code, location.locationCode),
                    if (location.parentLocationName.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      _buildInfoRow(
                        Icons.call_split,
                        "Parent: ${location.parentLocationName}",
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey.shade600),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Container _buildSwipeActionContainer({
    required Color color,
    required IconData icon,
    required String text,
    required Alignment alignment,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      alignment: alignment,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (alignment == Alignment.centerLeft) ...[
            Icon(icon, color: Colors.white),
            const SizedBox(width: 8),
          ],
          Text(text, style: const TextStyle(color: Colors.white)),
          if (alignment == Alignment.centerRight) ...[
            const SizedBox(width: 8),
            Icon(icon, color: Colors.white),
          ],
        ],
      ),
    );
  }

  Future<bool?> _showDeleteConfirmationDialog(LocationIndexModel location) {
    return showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withAlpha(102),
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Dialog(
            backgroundColor: Colors.white.withAlpha(230),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.0),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Icon(
                    Icons.delete_sweep_rounded,
                    color: Color(0xFFF35D5D),
                    size: 50.0,
                  ),
                  const SizedBox(height: 28),
                  Text(
                    "Are you sure you want to delete ${location.locationName}?",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF35D5D),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text(
                      "Yes, Delete",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text(
                      "Keep It",
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}