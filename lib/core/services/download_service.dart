import 'dart:isolate';
import 'dart:ui';
import 'package:flutter_downloader/flutter_downloader.dart';

@pragma('vm:entry-point')
class DownloadService {
  DownloadService._();
  static final DownloadService instance = DownloadService._();

  final ReceivePort _port = ReceivePort();
  final Map<String, void Function(DownloadTaskStatus status, int progress)> _listeners = {};
  bool _initialized = false;

  void init() {
    if (_initialized) return;
    _initialized = true;

    IsolateNameServer.registerPortWithName(_port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      final taskId = data[0] as String;
      final status = DownloadTaskStatus.fromInt(data[1] as int);
      final progress = data[2] as int;
      _listeners[taskId]?.call(status, progress);
    });
  }

  void listen(String taskId, void Function(DownloadTaskStatus status, int progress) onUpdate) {
    _listeners[taskId] = onUpdate;
  }

  void unlisten(String taskId) {
    _listeners.remove(taskId);
  }

  @pragma('vm:entry-point')
  static void callbackDispatcher(String id, int status, int progress) {
    final SendPort? send = IsolateNameServer.lookupPortByName('downloader_send_port');
    send?.send([id, status, progress]);
  }
}