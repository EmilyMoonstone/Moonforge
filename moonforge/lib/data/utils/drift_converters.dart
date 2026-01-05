import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:intl/intl.dart';

class StringArrayConverter extends TypeConverter<List<String>, String> {
  const StringArrayConverter();

  @override
  List<String> fromSql(String fromDb) {
    return (json.decode(fromDb) as List<dynamic>).cast<String>();
  }

  @override
  String toSql(List<String> value) {
    return json.encode(value);
  }
}

class IntArrayConverter extends TypeConverter<List<int>, String> {
  const IntArrayConverter();

  @override
  List<int> fromSql(String fromDb) {
    return (json.decode(fromDb) as List<dynamic>).cast<int>();
  }

  @override
  String toSql(List<int> value) {
    return json.encode(value);
  }
}

class DoubleArrayConverter extends TypeConverter<List<double>, String> {
  const DoubleArrayConverter();

  @override
  List<double> fromSql(String fromDb) {
    return (json.decode(fromDb) as List<dynamic>).cast<double>();
  }

  @override
  String toSql(List<double> value) {
    return json.encode(value);
  }
}

class DateTimeConverter extends TypeConverter<DateTime, String> {
  const DateTimeConverter();

  @override
  DateTime fromSql(String fromDb) {
    return DateTime.parse(fromDb);
  }

  @override
  String toSql(DateTime value) {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(value);
  }
}

class JsonConverter extends TypeConverter<Map<String, dynamic>, String> {
  const JsonConverter();

  @override
  Map<String, dynamic> fromSql(String fromDb) {
    final decoded = json.decode(fromDb);
    if (decoded is Map<String, dynamic>) {
      return decoded;
    }
    if (decoded is String) {
      final nested = json.decode(decoded);
      if (nested is Map<String, dynamic>) {
        return nested;
      }
    }
    return <String, dynamic>{};
  }

  @override
  String toSql(Map<String, dynamic> value) {
    return json.encode(value);
  }
}
