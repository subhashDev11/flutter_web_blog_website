import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class AppLogger {
  static final Logger appLogger = Logger();
  static longPrint(String text) {
    if (!kReleaseMode) {
      if (Platform.isAndroid) {
        log(
          '\x1B$text\n\n',
          name: 'long print',
        );
      } else {
        String s = text.toString();
        final pattern = RegExp('.{20,800}');
        pattern.allMatches(s).forEach((match) => print(match.group(0)));
      }
    }
  }

  static e(dynamic e, {dynamic stackTrace, String? reason}) async {
    String printV = (e is String) ? e : e.toString();
    final stackT = stackTrace is StackTrace ? stackTrace : null;
    if (!kReleaseMode) {
      appLogger.e('$printV\n ');
    }
  }

  static e1(dynamic e) {
    String printV = (e is String) ? e : e.toString();
    if (!kReleaseMode) {
      appLogger.e('$printV\n');
    }
  }

  static d(String d, {dynamic stackTrace}) {
    final stackT = stackTrace is StackTrace ? stackTrace : null;
    if (!kReleaseMode) {
      appLogger.d('$d\n');
    }
    // if (stackTrace != null) {
    //   FirebaseCrashlytics.instance.recordError(
    //     d,
    //     stackT,
    //   );
    // }
  }

  static i(dynamic i) {
    if (!kReleaseMode) {
      String printV = (i is String) ? i : i.toString();
      appLogger.i('$printV\n');
    }
  }
}
