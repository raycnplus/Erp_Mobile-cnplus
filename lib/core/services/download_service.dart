import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:erp_mobile_cnplus/core/network/dio_client.dart';

@pragma('vm:entry-point')
class DownloadService {
  DownloadService._();
  static final DownloadService instance = DownloadService._();

  final ReceivePort _port = ReceivePort();
  final Map<String, void Function(DownloadTaskStatus status, int progress)> _listeners = {};
  final Map<String, List<List<dynamic>>> _buffered = {};
  bool _initialized = false;

  void init() {
    if (_initialized) return;
    _initialized = true;

    IsolateNameServer.removePortNameMapping('downloader_send_port');
    final ok = IsolateNameServer.registerPortWithName(_port.sendPort, 'downloader_send_port');
    // debugPrint('DOWNLOADER PORT REGISTERED: $ok');

    _port.listen((dynamic data) {
      // debugPrint('PORT EVENT: $data');
      final taskId = data[0] as String;
      final status = DownloadTaskStatus.fromInt(data[1] as int);
      final progress = data[2] as int;

      final cb = _listeners[taskId];
      if (cb != null) {
        cb(status, progress);
      } else {
        _buffered.putIfAbsent(taskId, () => []).add([status, progress]);
      }
    });
  }

  void listen(String taskId, void Function(DownloadTaskStatus status, int progress) onUpdate) {
    _listeners[taskId] = onUpdate;

    final events = _buffered.remove(taskId);
    if (events != null) {
      for (final e in events) {
        onUpdate(e[0] as DownloadTaskStatus, e[1] as int);
      }
    }
  }

  void unlisten(String taskId) {
    _listeners.remove(taskId);
    _buffered.remove(taskId);
  }

  @pragma('vm:entry-point')
  static void callbackDispatcher(String id, int status, int progress) {
    final SendPort? send = IsolateNameServer.lookupPortByName('downloader_send_port');
    send?.send([id, status, progress]);
  }

  static const String msgAndroidOnly = 'Download is currently supported on Android only.';
  static String msgSuccess(String label, String fileName) =>
      '$label downloaded successfully';
  static String msgFailed(String label) =>
      '$label download failed. Please try again or contact support.';

  Future<void> _requestPermissions() async {
    await Permission.storage.request();
    await Permission.notification.request();
  }

  Future<String?> download({
    required String url,
    required Map<String, String> headers,
    required String fileName,
    required String label,
    void Function(int progress)? onProgress,
    void Function(String message)? onMessage,
    void Function()? onFinished,
  }) async {
    if (!Platform.isAndroid) {
      onMessage?.call(msgAndroidOnly);
      onFinished?.call();
      return null;
    }

    try {
      await _requestPermissions();
      final token = await DioClient().getValidToken();
      final authHeaders = <String, String>{
        ...headers,
        if (token != null) 'Authorization': 'Bearer $token',
      };

      // debugPrint('URL: $url');
      // debugPrint('HEADER KEYS: ${headers.keys.toList()}');

      final taskId = await FlutterDownloader.enqueue(
        url: url,
        headers: authHeaders,
        savedDir: '/storage/emulated/0/Download',
        fileName: fileName,
        saveInPublicStorage: true,
        showNotification: true,
        openFileFromNotification: true,
      );

      if (taskId == null) {
        onMessage?.call(msgFailed(label));
        onFinished?.call();
        return null;
      }

      listen(taskId, (status, progress) {
        // debugPrint('⬇️ DOWNLOAD $taskId => $status ($progress%)');
        onProgress?.call(progress);

        if (status == DownloadTaskStatus.complete) {
          unlisten(taskId);
          onMessage?.call(msgSuccess(label, fileName));
          onFinished?.call();
        } else if (status == DownloadTaskStatus.failed) {
          unlisten(taskId);
          onMessage?.call(msgFailed(label));
          onFinished?.call();
        } else if (status == DownloadTaskStatus.canceled) {
          unlisten(taskId);
          onFinished?.call();
        }
      });

      // Timer.periodic(const Duration(seconds: 1), (t) async {
      //   if (!_listeners.containsKey(taskId)) {
      //     t.cancel();
      //     return;
      //   }
      //   final tasks = await FlutterDownloader.loadTasksWithRawQuery(
      //     query: "SELECT * FROM task WHERE task_id='$taskId'",
      //   );
      //   if (tasks == null || tasks.isEmpty) return;
      //   _listeners[taskId]?.call(tasks.first.status, tasks.first.progress);
      // });

      return taskId;
    } catch (e) {
      onMessage?.call(e.toString().replaceFirst('Exception:', '').trim());
      onFinished?.call();
      return null;
    }
  }
}