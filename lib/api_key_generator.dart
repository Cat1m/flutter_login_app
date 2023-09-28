// api_key_generator.dart
import 'package:crypto/crypto.dart';
import 'dart:convert'; // for utf8.encode
import 'package:intl/intl.dart'; // for DateFormat

class ApiKeyGenerator {
  static String getAPIKey() {
    String passcode = 'dkkbpasscode';
    final currentYearMonth = DateFormat('yyyyMM').format(DateTime.now());
    return _getSha512fromString('$passcode$currentYearMonth');
  }

  static String _getSha512fromString(String input) {
    final bytes = utf8.encode(input); // data being hashed
    final digest = sha512.convert(bytes);
    return digest.toString().toUpperCase();
  }
}
