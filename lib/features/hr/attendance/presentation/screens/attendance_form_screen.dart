import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../controllers/attendance_controller.dart';

class AttendanceFormScreen extends StatefulWidget {
  final bool isCheckOut;

  const AttendanceFormScreen({super.key, this.isCheckOut = false});

  @override
  State<AttendanceFormScreen> createState() => _AttendanceFormScreenState();
}

class _AttendanceFormScreenState extends State<AttendanceFormScreen> {
  static const Color primaryGreen = Color(0xFF2D6A4F);
  static const Color lightGreen = Color(0xFF40916C);

  // Time
  late Timer _timer;
  String _currentTime = '';
  String _currentDate = '';

  // Location
  bool _isLoadingLocation = false;
  bool _locationVerified = false;
  String _locationStatus = 'Getting your location...';
  double? _latitude;
  double? _longitude;

  // Camera
  CameraController? _cameraController;
  List<CameraDescription> _cameras = [];
  bool _cameraInitialized = false;
  XFile? _capturedPhoto;
  String? _photoBase64;
  bool _isCapturing = false;

  @override
  void initState() {
    super.initState();
    _updateTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateTime());
    _initCamera();
    _checkLocation();
  }

  @override
  void dispose() {
    _timer.cancel();
    _cameraController?.dispose();
    super.dispose();
  }

  void _updateTime() {
    final now = DateTime.now();
    setState(() {
      _currentTime = DateFormat('HH:mm:ss').format(now);
      _currentDate = DateFormat('EEEE, MMMM d, yyyy').format(now);
    });
  }

  Future<void> _initCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras.isEmpty) return;

      final frontCamera = _cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.front,
        orElse: () => _cameras.first,
      );

      _cameraController = CameraController(
        frontCamera,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await _cameraController!.initialize();
      if (mounted) setState(() => _cameraInitialized = true);
    } catch (e) {
      debugPrint('Camera init error: $e');
    }
  }

  Future<void> _checkLocation() async {
    setState(() {
      _isLoadingLocation = true;
      _locationStatus = 'Checking location permission...';
    });

    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        setState(() {
          _isLoadingLocation = false;
          _locationStatus = 'Location permission denied';
          _locationVerified = false;
        });
        return;
      }

      setState(() => _locationStatus = 'Getting location...');

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      _latitude = position.latitude;
      _longitude = position.longitude;

      final controller = context.read<AttendanceController>();
      final locationConfig = controller.data?.locationConfig;

      if (locationConfig != null &&
          locationConfig.lat != 0 &&
          locationConfig.lng != 0) {
        final distance = Geolocator.distanceBetween(
          position.latitude,
          position.longitude,
          locationConfig.lat,
          locationConfig.lng,
        );

        if (distance <= locationConfig.radius) {
          setState(() {
            _locationVerified = true;
            _locationStatus = 'Location Verified';
          });
        } else {
          setState(() {
            _locationVerified = false;
            _locationStatus =
                'Outside allowed area (${distance.toStringAsFixed(0)}m from office, max ${locationConfig.radius}m)';
          });
        }
      } else {
        setState(() {
          _locationVerified = true;
          _locationStatus = 'Location Verified';
        });
      }
    } catch (e) {
      setState(() {
        _locationVerified = false;
        _locationStatus = 'Failed to get location: ${e.toString()}';
      });
    } finally {
      setState(() => _isLoadingLocation = false);
    }
  }

  Future<void> _capturePhoto() async {
    if (_cameraController == null || !_cameraInitialized || _isCapturing) return;

    setState(() => _isCapturing = true);
    try {
      final file = await _cameraController!.takePicture();
      final bytes = await File(file.path).readAsBytes();
      final base64Str = base64Encode(bytes);

      setState(() {
        _capturedPhoto = file;
        _photoBase64 = 'data:image/png;base64,$base64Str';
      });
    } catch (e) {
      _showSnackBar('Failed to capture photo: $e', isError: true);
    } finally {
      setState(() => _isCapturing = false);
    }
  }

  void _retakePhoto() {
    setState(() {
      _capturedPhoto = null;
      _photoBase64 = null;
    });
  }

  Future<void> _submit() async {
    if (!_locationVerified) {
      _showSnackBar('Please verify your location first', isError: true);
      return;
    }
    if (_photoBase64 == null) {
      _showSnackBar('Please take a photo first', isError: true);
      return;
    }
    if (_latitude == null || _longitude == null) {
      _showSnackBar('Location not available', isError: true);
      return;
    }

    final controller = context.read<AttendanceController>();
    final bool success;

    if (widget.isCheckOut) {
      success = await controller.performCheckOut(
        latitude: _latitude!,
        longitude: _longitude!,
        photoBase64: _photoBase64!,
      );
    } else {
      success = await controller.performCheckIn(
        latitude: _latitude!,
        longitude: _longitude!,
        photoBase64: _photoBase64!,
      );
    }

    if (!mounted) return;

    if (success) {
      _showSnackBar(
          widget.isCheckOut ? 'Check-out successful!' : 'Check-in successful!');
      await Future.delayed(const Duration(milliseconds: 800));
      if (mounted) Navigator.pop(context);
    } else {
      _showSnackBar(controller.errorMessage ?? 'Failed', isError: true);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.poppins()),
        backgroundColor: isError ? Colors.red : primaryGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.isCheckOut
        ? 'Mark Attendance - Check Out'
        : 'Mark Attendance - Check In';

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F2),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color: Colors.grey.shade800,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                'Record your attendance for today',
                style: GoogleFonts.poppins(
                    fontSize: 13, color: Colors.grey.shade500),
              ),
              const SizedBox(height: 16),
              _buildClockCard(),
              const SizedBox(height: 12),
              _buildEmployeeCard(),
              const SizedBox(height: 12),
              _buildLocationCard(),
              const SizedBox(height: 12),
              _buildPhotoCard(),
              const SizedBox(height: 20),
              _buildSubmitButton(),
              const SizedBox(height: 10),
              _buildBackButton(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildClockCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [primaryGreen, lightGreen],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Icon(Icons.access_time_rounded, color: Colors.white, size: 36),
          const SizedBox(height: 8),
          Text(
            _currentTime,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 36,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _currentDate,
            style: GoogleFonts.poppins(
              color: Colors.white.withOpacity(0.85),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeeCard() {
    final controller = context.read<AttendanceController>();
    final employee = controller.data?.employee;

    return _buildCard(
      title: 'Employee Information',
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Name',
                    style: GoogleFonts.poppins(
                        fontSize: 11, color: Colors.grey.shade500)),
                Text(
                  employee?.name ?? '-',
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600, fontSize: 14),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Email',
                    style: GoogleFonts.poppins(
                        fontSize: 11, color: Colors.grey.shade500)),
                Text(
                  employee?.email ?? '-',
                  style: GoogleFonts.poppins(fontSize: 13),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationCard() {
    return _buildCard(
      title: 'Location Verification',
      subtitle: 'Your location is required for attendance marking',
      child: _isLoadingLocation
          ? Row(
              children: [
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: primaryGreen),
                ),
                const SizedBox(width: 10),
                Text(_locationStatus,
                    style: GoogleFonts.poppins(
                        fontSize: 13, color: Colors.grey.shade600)),
              ],
            )
          : Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: _locationVerified
                    ? Colors.green.shade50
                    : Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _locationVerified
                      ? Colors.green.shade200
                      : Colors.red.shade200,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _locationVerified
                        ? Icons.location_on
                        : Icons.location_off,
                    color: _locationVerified ? primaryGreen : Colors.red,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _locationStatus,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: _locationVerified
                            ? primaryGreen
                            : Colors.red.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  if (!_locationVerified)
                    TextButton(
                      onPressed: _checkLocation,
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(60, 28),
                      ),
                      child: Text('Retry',
                          style: GoogleFonts.poppins(
                              fontSize: 12, color: primaryGreen)),
                    ),
                ],
              ),
            ),
    );
  }

  Widget _buildPhotoCard() {
    return _buildCard(
      title: 'Take a Photo',
      subtitle: 'Capture your face as proof of attendance',
      child: Column(
        children: [
          if (_capturedPhoto == null) ...[
            if (_cameraInitialized && _cameraController != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: AspectRatio(
                  aspectRatio: 4 / 3,
                  child: CameraPreview(_cameraController!),
                ),
              )
            else
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.camera_alt,
                          size: 48, color: Colors.grey.shade400),
                      Text('Camera not available',
                          style: GoogleFonts.poppins(
                              color: Colors.grey.shade500, fontSize: 13)),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: _isCapturing ? null : _capturePhoto,
                icon: _isCapturing
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.camera_alt, size: 18),
                label: Text(
                  _isCapturing ? 'Capturing...' : 'Take Photo',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ] else ...[
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(
                    File(_capturedPhoto!.path),
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: _retakePhoto,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close,
                          color: Colors.white, size: 18),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: _retakePhoto,
              icon: const Icon(Icons.refresh, size: 16, color: primaryGreen),
              label: Text('Retake Photo',
                  style: GoogleFonts.poppins(
                      color: primaryGreen, fontSize: 13)),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Consumer<AttendanceController>(
      builder: (context, controller, _) {
        final isCheckOut = widget.isCheckOut;
        final color = isCheckOut ? Colors.redAccent : primaryGreen;

        return SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 3,
            ),
            onPressed: controller.isSubmitting ? null : _submit,
            icon: controller.isSubmitting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white),
                  )
                : Icon(isCheckOut ? Icons.logout : Icons.login),
            label: Text(
              controller.isSubmitting
                  ? 'Processing...'
                  : (isCheckOut ? 'Check Out' : 'Check In'),
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w700, fontSize: 16),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBackButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.redAccent,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 2,
        ),
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back_ios, size: 16),
        label: Text(
          'Back',
          style:
              GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 15),
        ),
      ),
    );
  }

  Widget _buildCard({
    required String title,
    String? subtitle,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Colors.grey.shade800,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: GoogleFonts.poppins(
                  fontSize: 12, color: Colors.grey.shade500),
            ),
          ],
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}