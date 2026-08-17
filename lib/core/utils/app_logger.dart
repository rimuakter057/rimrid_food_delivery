import 'package:flutter/foundation.dart';

abstract class AppLogger {
  // ANSI Escape Codes for Bright Console Colors
  static const String _reset = '\x1B[0m';
  static const String _boldRed = '\x1B[1;31m';
  static const String _boldGreen = '\x1B[1;32m';
  static const String _boldYellow = '\x1B[1;33m';
  static const String _boldCyan = '\x1B[1;36m';
  static const String _boldMagenta = '\x1B[1;35m';

  static void screen(String screenName) {
    if (kDebugMode) {
      // ignore: avoid_print
      print('$_boldMagenta==================================================$_reset');
      // ignore: avoid_print
      print('$_boldMagenta📱 [SCREEN NAVIGATED]: $screenName$_reset');
      // ignore: avoid_print
      print('$_boldMagenta==================================================$_reset');
    }
  }

  static void info(String tag, String message) {
    if (kDebugMode) {
      // ignore: avoid_print
      print('$_boldGreenℹ️ [$tag]: $message$_reset');
    }
  }

  static void api(String method, String endpoint, {int? statusCode, String? extra}) {
    if (kDebugMode) {
      final statusStr = statusCode != null ? '[$statusCode]' : '';
      // ignore: avoid_print
      print('$_boldCyan🌐 [API $method] $endpoint $statusStr ${extra ?? ''}$_reset');
    }
  }

  static void error(String tag, String message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      // Print in BRIGHT BOLD RED COLOR in console
      // ignore: avoid_print
      print('$_boldRed❌ [$tag ERROR]: $message$_reset');
      if (error != null) {
        // ignore: avoid_print
        print('$_boldRed   Details: $error$_reset');
      }
      if (stackTrace != null) {
        // ignore: avoid_print
        print('$_boldRed   StackTrace: $stackTrace$_reset');
      }
    }
  }

  static void provider(String providerName, String action) {
    if (kDebugMode) {
      // ignore: avoid_print
      print('$_boldYellow⚡ [$providerName]: $action$_reset');
    }
  }
}
