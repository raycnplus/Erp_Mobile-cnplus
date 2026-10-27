import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:erp_mobile_cnplus/core/utils/colors.dart';
import 'package:erp_mobile_cnplus/core/injector/injector.dart';
import 'package:erp_mobile_cnplus/core/services/download_service.dart';

class AttachmentViewer extends StatefulWidget {
  final String url;
  final String? fileName;

  const AttachmentViewer({super.key, required this.url, this.fileName});

  @override
  State<AttachmentViewer> createState() => _AttachmentViewerState();
}

class _AttachmentViewerState extends State<AttachmentViewer> {
  static const _imageExtensions = ['jpg', 'jpeg', 'png', 'gif', 'webp'];

  String? _token;
  String? _taskId;
  DownloadTaskStatus? _status;
  Timer? _pollTimer;

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  @override
  void dispose() {
    if (_taskId != null) DownloadService.instance.unlisten(_taskId!);
    _pollTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadToken() async {
    final storage = getIt<FlutterSecureStorage>();
    final token = await storage.read(key: 'token');
    if (mounted) setState(() => _token = token);
  }

  String get _extension {
    final source = (widget.fileName?.isNotEmpty == true) ? widget.fileName! : widget.url;
    final withoutQuery = source.split('?').first;
    final parts = withoutQuery.split('.');
    return parts.length > 1 ? parts.last.toLowerCase() : '';
  }

  bool get _isImage => _imageExtensions.contains(_extension);

  Map<String, String> get _authHeaders =>
      _token != null ? {'Authorization': 'Bearer $_token'} : {};

  void _snack(String msg, {Color? color}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: color ?? colorPrimary,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ));
  }

  bool get _isDownloading =>
      _status == DownloadTaskStatus.running || _status == DownloadTaskStatus.enqueued;

  void _handleStatusUpdate(DownloadTaskStatus status) {
    if (!mounted) return;
    if (_status == status) return; 
    setState(() => _status = status);

    if (status == DownloadTaskStatus.complete) {
      _pollTimer?.cancel();
      if (_taskId != null) DownloadService.instance.unlisten(_taskId!);
      _snack('Download complete', color: colorSuccess);
    } else if (status == DownloadTaskStatus.failed) {
      _pollTimer?.cancel();
      if (_taskId != null) DownloadService.instance.unlisten(_taskId!);
      _snack('Failed to download attachment', color: colorError);
    } else if (status == DownloadTaskStatus.canceled) {
      _pollTimer?.cancel();
      if (_taskId != null) DownloadService.instance.unlisten(_taskId!);
    }
  }

  void _startPolling(String taskId) {
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(const Duration(milliseconds: 800), (timer) async {
      final tasks = await FlutterDownloader.loadTasksWithRawQuery(
        query: "SELECT * FROM task WHERE task_id='$taskId'",
      );
      if (tasks != null && tasks.isNotEmpty) {
        final status = tasks.first.status;
        _handleStatusUpdate(status);
        if (status == DownloadTaskStatus.complete ||
            status == DownloadTaskStatus.failed ||
            status == DownloadTaskStatus.canceled) {
          timer.cancel();
        }
      }
    });
  }

  Future<void> _startDownload() async {
    if (_isDownloading) return;
    if (_token == null) {
      _snack('Not authenticated', color: colorError);
      return;
    }

    try {
      final dir = Platform.isAndroid
          ? await getExternalStorageDirectory()
          : await getApplicationDocumentsDirectory();
      if (dir == null) throw Exception('Storage not accessible');

      final ext = _extension.isNotEmpty ? _extension : 'file';
      final fileName = 'attachment_${DateTime.now().millisecondsSinceEpoch}.$ext';

      final taskId = await FlutterDownloader.enqueue(
        url: widget.url,
        headers: _authHeaders,
        savedDir: dir.path,
        fileName: fileName,
        showNotification: true,
        openFileFromNotification: false,
        saveInPublicStorage: true,
      );

      if (taskId == null) throw Exception('Failed to start download');

      setState(() {
        _taskId = taskId;
        _status = DownloadTaskStatus.running;
      });

      DownloadService.instance.listen(taskId, (status, progress) {
        _handleStatusUpdate(status);
      });

      _startPolling(taskId);

      _snack('Downloading attachment...', color: colorPrimary);
    } catch (e) {
      _snack('Failed to download attachment', color: colorError);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isImage) {
      return InkWell(
        onTap: () => _openImageModal(context),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: colorGreyLight),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              AspectRatio(
                aspectRatio: 16 / 10,
                child: _token == null
                    ? Container(
                        color: colorBackground,
                        alignment: Alignment.center,
                        child: const CircularProgressIndicator(color: colorPrimary, strokeWidth: 2),
                      )
                    : Image.network(
                        widget.url,
                        headers: _authHeaders,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        loadingBuilder: (ctx, child, progress) {
                          if (progress == null) return child;
                          return Container(
                            color: colorBackground,
                            alignment: Alignment.center,
                            child: const CircularProgressIndicator(color: colorPrimary, strokeWidth: 2),
                          );
                        },
                        errorBuilder: (ctx, error, stack) => Container(
                          color: colorBackground,
                          alignment: Alignment.center,
                          child: Icon(Icons.broken_image_outlined, color: colorGrey, size: 32),
                        ),
                      ),
              ),
              Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(6)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.zoom_in, color: colorWhite, size: 14),
                    const SizedBox(width: 4),
                    Text('Tap to view', style: GoogleFonts.poppins(fontSize: 10, color: colorWhite)),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    final isComplete = _status == DownloadTaskStatus.complete;
    final isFailed = _status == DownloadTaskStatus.failed;

    return InkWell(
      onTap: _isDownloading ? null : _startDownload,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colorBackground,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: colorGreyLight),
        ),
        child: Row(
          children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: (isComplete ? colorSuccess : colorPrimary).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.insert_drive_file_outlined,
                color: isComplete ? colorSuccess : colorPrimary,
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                isComplete ? 'Attachment — downloaded' : 'Attachment',
                style: GoogleFonts.poppins(fontSize: 13, color: colorTextPrimary, fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(width: 8),
            if (_isDownloading)
              const SizedBox(
                width: 20, height: 20,
                child: CircularProgressIndicator(strokeWidth: 2, color: colorPrimary),
              )
            else if (isComplete)
              const Icon(Icons.check_circle, color: colorSuccess, size: 20)
            else if (isFailed)
              const Icon(Icons.error_outline, color: colorError, size: 20)
            else
              const Icon(Icons.download_outlined, color: colorPrimary, size: 20),
          ],
        ),
      ),
    );
  }

  void _openImageModal(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (_) => Dialog(
        insetPadding: const EdgeInsets.all(12),
        backgroundColor: Colors.transparent,
        child: Stack(
          children: [
            Positioned.fill(
              child: InteractiveViewer(
                minScale: 0.5,
                maxScale: 4,
                child: Center(
                  child: Image.network(
                    widget.url,
                    headers: _authHeaders,
                    fit: BoxFit.contain,
                    loadingBuilder: (ctx, child, progress) {
                      if (progress == null) return child;
                      return const Center(child: CircularProgressIndicator(color: colorWhite));
                    },
                    errorBuilder: (ctx, error, stack) => Center(
                      child: Text('Failed to load image', style: GoogleFonts.poppins(color: colorWhite)),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 8, right: 8,
              child: IconButton(
                icon: const Icon(Icons.close, color: colorWhite, size: 28),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Positioned(
              bottom: 16, right: 16,
              child: FloatingActionButton.small(
                heroTag: 'attachment_download_${widget.url.hashCode}',
                backgroundColor: colorPrimary,
                onPressed: _isDownloading ? null : _startDownload,
                child: _isDownloading
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: colorWhite))
                    : const Icon(Icons.download_outlined, color: colorWhite),
              ),
            ),
          ],
        ),
      ),
    );
  }
}