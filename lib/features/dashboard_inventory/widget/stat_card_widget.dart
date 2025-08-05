import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../services/api_base.dart';
import '../models/chart_data_model.dart'; // Pastikan path model ini benar

// Tidak ada perubahan pada widget StatCard, ini adalah widget presentasi murni.
class StatCard extends StatelessWidget {
  final String title;
  final String endpoint;
  final String enableAutoRefresh;
  final Duration? refreshInterval;
  final String value;
  final Color? valueColor;
  final TextStyle? valueStyle;
  final TextStyle? titleStyle;
  final double? width;
  final VoidCallback? onTap;

  const StatCard({
    Key? key,
    required this.title,
    required this.enableAutoRefresh,
    this.refreshInterval,
    required this.endpoint,
    required this.value,
    this.valueColor,
    this.valueStyle,
    this.titleStyle,
    this.width,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              value,
              style: valueStyle ??
                  TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: valueColor ?? Colors.black,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: titleStyle ??
                  const TextStyle(fontSize: 14, color: Colors.black54),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

// Widget StatCardLoader (dengan API integration)
class StatCardLoader extends StatefulWidget {
  final String title;
  final String endpoint;
  final Color? valueColor;
  final TextStyle? valueStyle;
  final TextStyle? titleStyle;
  final double? width;
  final Duration? refreshInterval;
  final bool enableAutoRefresh;
  final VoidCallback? onTap;
  final Map<String, String>? headers;

  const StatCardLoader({
    Key? key,
    required this.title,
    required this.endpoint,
    this.valueColor,
    this.valueStyle,
    this.titleStyle,
    this.width,
    this.refreshInterval,
    this.enableAutoRefresh = false,
    this.onTap,
    this.headers,
  }) : super(key: key);

  @override
  State<StatCardLoader> createState() => _StatCardLoaderState();
}

class _StatCardLoaderState extends State<StatCardLoader> {
  late Future<StatValue> _statFuture;
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _statFuture = fetchStat();

    if (widget.enableAutoRefresh && widget.refreshInterval != null) {
      _refreshTimer = Timer.periodic(widget.refreshInterval!, (timer) {
        if (mounted) {
          refreshData();
        }
      });
    }
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  // =======================================================================
  // == PERUBAHAN UTAMA ADA DI DALAM FUNGSI fetchStat() DI BAWAH INI ==
  // =======================================================================
  Future<StatValue> fetchStat() async {
    final secureStorage = FlutterSecureStorage();

    try {
      final url = Uri.parse('${ApiBase.baseUrl}/${widget.endpoint}');
      final token = await secureStorage.read(key: 'user_token');

      if (token == null) {
        throw Exception('User token not found in secure storage');
      }

      final response = await http
          .get(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
              ...?widget.headers,
            },
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        // Prioritas 1: Respons adalah List langsung (e.g., [{}, {}, ...])
        if (jsonData is List) {
          return StatValue(
            value: jsonData.length,
            total: jsonData.length,
            label: widget.title,
          );
        }
        // Prioritas 2: Respons adalah Map (e.g., {"data": [...]})
        else if (jsonData is Map<String, dynamic>) {
          // Cek untuk key 'total' atau 'total_count' untuk data paginasi
          int? totalCount;
          if (jsonData.containsKey('total') && jsonData['total'] is num) {
            totalCount = jsonData['total'];
          } else if (jsonData.containsKey('total_count') && jsonData['total_count'] is num) {
            totalCount = jsonData['total_count'];
          }

          // Cek untuk list data di dalam map
          if (jsonData.containsKey('data') && jsonData['data'] is List) {
            final dataList = jsonData['data'] as List;
            // Jika ada totalCount, gunakan itu. Jika tidak, gunakan panjang list.
            return StatValue(value: totalCount ?? dataList.length, total: totalCount ?? dataList.length, label: widget.title);
          } else if (jsonData.containsKey('items') && jsonData['items'] is List) {
            final itemsList = jsonData['items'] as List;
            return StatValue(value: totalCount ?? itemsList.length, total: totalCount ?? itemsList.length, label: widget.title);
          }

          // Fallback jika formatnya adalah { "value": 123 } atau hanya ada 'total'
          if(totalCount != null) {
            return StatValue(value: totalCount, total: totalCount, label: widget.title);
          }
          // Jaga fungsionalitas lama untuk format standar
          return StatValue.fromJson(jsonData);
        }
        else {
          throw Exception('Invalid response format: Expected a List or a Map.');
        }
      } else {
        throw Exception(
          'HTTP ${response.statusCode}: ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      debugPrint('Error fetching stat from ${widget.endpoint}: $e');
      rethrow;
    }
  }

  void refreshData() {
    if (mounted) {
      setState(() {
        _statFuture = fetchStat();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<StatValue>(
      future: _statFuture,
      builder: (context, snapshot) {
        String displayValue;
        Color displayColor = widget.valueColor ?? Colors.black;

        if (snapshot.connectionState == ConnectionState.waiting) {
          displayValue = "...";
          displayColor = Colors.grey;
        } else if (snapshot.hasError) {
          displayValue = "Err";
          displayColor = Colors.red;
          debugPrint('StatCard Error (${widget.endpoint}): ${snapshot.error}');
        } else if (snapshot.hasData) {
          displayValue = formatValue(snapshot.data!.value);
          if (snapshot.data!.unit != null) {
            displayValue += " ${snapshot.data!.unit}";
          }
        } else {
          displayValue = "N/A";
          displayColor = Colors.orange;
        }

        return StatCard(
          title: widget.title,
          endpoint: widget.endpoint,
          enableAutoRefresh: widget.enableAutoRefresh.toString(),
          value: displayValue,
          valueColor: widget.valueColor ?? displayColor, // Prioritaskan warna dari widget
          valueStyle: widget.valueStyle,
          titleStyle: widget.titleStyle,
          width: widget.width,
          onTap: widget.onTap ?? refreshData,
        );
      },
    );
  }

  String formatValue(dynamic value) {
    if (value == null) return "N/A";

    if (value is String) {
      final numValue = double.tryParse(value);
      if (numValue != null) {
        return _formatNumber(numValue);
      }
      return value;
    } else if (value is num) {
      return _formatNumber(value);
    }

    return value.toString();
  }

  String _formatNumber(num value) {
    if (value >= 1000000000) {
      return "${(value / 1000000000).toStringAsFixed(1)}B";
    }
    if (value >= 1000000) {
      return "${(value / 1000000).toStringAsFixed(1)}M";
    } else if (value >= 1000) {
      return "${(value / 1000).toStringAsFixed(1)}K";
    }
    return value.toInt().toString(); // Tampilkan sebagai integer jika di bawah 1000
  }
}