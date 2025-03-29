import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class LogService {
  static final LogService _instance = LogService._internal();
  factory LogService() => _instance;
  LogService._internal();

  late Logger _logger;
  late File _logFile;
  String? _currentDate;
  ReceivePort? _receivePort;
  // SendPort? _sendPort;
  Isolate? _isolate;

  Future<void> init() async {
    // Request storage permission
    if (await _requestPermission(Permission.storage)) {
      Directory directory = Directory('/storage/emulated/0/KioskAppLogs');
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
      await _updateLogFile(directory);
    } else {
      throw Exception("Storage permission denied");
    }

    // Create the logger with file output
    _logger = Logger(
      printer: PrettyPrinter(
        methodCount: 0, // No method details
        errorMethodCount: 8,
        lineLength: 100,
        colors: false, // Disable colors for file writing
        printEmojis: true,
        printTime: true, // Adds time to logs
      ),
      output: FileOutput(() async => Future.value(_logFile)),
    );

    // Start the isolate to monitor date change
    _startIsolateForDailyCheck();
  }

  Logger get logger => _logger;

  /// Start isolate to check for daily log file update
  Future<void> _startIsolateForDailyCheck() async {
    _receivePort = ReceivePort();
    _isolate = await Isolate.spawn(_dailyCheckIsolate, _receivePort!.sendPort);

    _receivePort!.listen((data) async {
      if (data == 'update_log') {
        Directory? directory = await getExternalStorageDirectory();
        if (directory != null) {
          await _updateLogFile(directory);
        }
      }
    });
  }

  /// Update log file if the date changes
  Future<void> _updateLogFile(Directory directory) async {
    String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    if (_currentDate != formattedDate) {
      _currentDate = formattedDate;
      String logPath = '${directory.path}/app_logs_$_currentDate.txt';
      _logFile = File(logPath);

      // Create the file if it doesn't exist
      if (!await _logFile.exists()) {
        await _logFile.create(recursive: true);
      }
    }
  }

  Future<bool> _requestPermission(Permission permission) async {
    if (Platform.isAndroid) {
      if (await Permission.manageExternalStorage.isGranted) {
        return true;
      }

      var status = await Permission.manageExternalStorage.request();
      if (status.isGranted) {
        return true;
      } else if (status.isPermanentlyDenied) {
        // Open app settings if denied permanently
        await openAppSettings();
        return false;
      }
    } else {
      var status = await permission.request();
      return status.isGranted;
    }
    return false;
  }

  /// Stop and clean up the isolate
  void dispose() {
    _receivePort?.close();
    _isolate?.kill(priority: Isolate.immediate);
  }
}

/// Isolate logic to check for date change
void _dailyCheckIsolate(SendPort sendPort) async {
  String? lastCheckedDate;

  while (true) {
    String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    if (currentDate != lastCheckedDate) {
      lastCheckedDate = currentDate;
      sendPort.send('update_log');
    }

    // Check every minute (or increase to reduce CPU usage)
    await Future.delayed(const Duration(minutes: 1));
  }
}

class FileOutput extends LogOutput {
  final Future<File> Function() getFile;
  FileOutput(this.getFile);

  @override
  void output(OutputEvent event) async {
    File logFile = await getFile();
    for (var line in event.lines) {
      logFile.writeAsStringSync('$line\n', mode: FileMode.append);
    }
  }
}
