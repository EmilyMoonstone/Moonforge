// ignore_for_file: avoid_print

import 'dart:io';

import 'package:collection/collection.dart';
import 'package:path/path.dart' as p;

const String tableSubfix = 'Table';
const List<String> doubleFields = [
  ];
final Set<String> arrayColumns = {};
final String outputPath = p.normalize(
  p.join(p.current, 'moonforge/lib/data/models/database_classes.g.dart'),
);
final filePath = p.normalize(p.join(p.current, 'supabase/supabase.g.ts'));
final partOfPrefix = '../';

List<Map<String, dynamic>> _parseRelationships(String relationshipsSection) {
  final entryRegex = RegExp(
    r'\{\s*foreignKeyName:\s*"([^"]+)"\s*'
    r'columns:\s*\["([^"]+)"\]\s*'
    r'isOneToOne:\s*(true|false)\s*'
    r'referencedRelation:\s*"([^"]+)"\s*'
    r'referencedColumns:\s*\["([^"]+)"\]\s*\}',
    dotAll: true,
  );
  final matches = entryRegex.allMatches(relationshipsSection);

  return matches.map((match) {
    return {
      'foreignKeyName': match.group(1),
      'column': match.group(2),
      'isOneToOne': match.group(3) == 'true',
      'referencedTable': match.group(4),
      'referencedColumn': match.group(5),
    };
  }).toList();
}

void main() {
  final file = File(filePath);
  if (!file.existsSync()) {
    print('${file.path} file not found!');
    print('FilePath: $filePath');
    throw Exception('File not found');
  }

  final content = file.readAsStringSync();
  final tableSchemas = <String, String>{};
  final classes = StringBuffer();
  final tables = <String>[];
  final classNames = <String>{};
  final relationships = <String, List<Map<String, dynamic>>>{};

  final schemaRegex = RegExp(
    r'(\w+): {\s+Tables: {([\s\S]*?)}\s*}',
    multiLine: true,
  );
  final tableRegex = RegExp(
    r'(\w+): {\s+Row: {([\s\S]*?)}\s+Insert',
    multiLine: true,
  );
  final relationshipsRegex = RegExp(
    r'Relationships:\s*\[((?:\s*\{[\s\S]*?\}\s*,?\s*)*)\]\s*(?:,|\n|})',
    dotAll: true,
  );

  final schemaMatches = schemaRegex.allMatches(content).toList();

  print('Found ${schemaMatches.length} schemas.');

  for (final schemaMatch in schemaMatches) {
    final schema = schemaMatch.group(1);
    final tablesSection = schemaMatch.group(2);

    if (tablesSection == null) continue;

    final tableMatches = tableRegex.allMatches(tablesSection).toList();

    print('Found ${tableMatches.length} tables in schema $schema.');

    for (final tableMatch in tableMatches) {
      final tableName = tableMatch.group(1);
      if (tableName == null) continue;

      tableSchemas[tableName] = schema!;
      var capitalizedTableName = _capitalize(_toCamelCase(tableName));

      if (capitalizedTableName.startsWith('Versorgungen')) {
        capitalizedTableName = _capitalize(_toCamelCaseReverse(tableName));
      }

      classNames.add(capitalizedTableName);
      tables.add('$capitalizedTableName$tableSubfix');
    }
  }

  // Generate classes after all tables have been added
  for (final schemaMatch in schemaMatches) {
    // final schema = schemaMatch.group(1);
    final tablesSection = schemaMatch.group(2);

    if (tablesSection == null) continue;

    final tableMatches = tableRegex.allMatches(tablesSection).toList();

    for (final tableMatch in tableMatches) {
      final tableName = tableMatch.group(1);
      final fields = tableMatch.group(2);

      if (tableName == null || fields == null) continue;

      var capitalizedTableName = _capitalize(_toCamelCase(tableName));
      if (capitalizedTableName.startsWith('Versorgungen')) {
        capitalizedTableName = _capitalize(_toCamelCaseReverse(tableName));
      }

      classes.writeln(
        'class $capitalizedTableName$tableSubfix extends Table {',
      );

      classes.writeln('  @override');
      classes.writeln(
        '  String get tableName => \'${tableName.toLowerCase()}\';',
      );

      final relationshipsMatch = relationshipsRegex.firstMatch(tablesSection);
      if (relationshipsMatch != null) {
        final relationshipsSection = relationshipsMatch.group(1);
        if (relationshipsSection != null &&
            relationshipsSection.trim().isNotEmpty) {
          final relationshipEntries = _parseRelationships(relationshipsSection);
          relationships[tableName] = relationshipEntries;
        }
      }

      bool hasIdColumn = _generateFields(
        fields,
        classes,
        tableName,
        relationships,
        tableSchemas.keys.toSet(),
      );

      if (hasIdColumn) {
        classes.writeln('  @override');
        classes.writeln('  Set<Column> get primaryKey => {id};');
      }
      classes.writeln('}');
      classes.writeln();
    }
  }

  final schemaFunction = _generateSchemaFunction(tableSchemas);
  final isArrayFunction = _generateIsArrayFunction(arrayColumns);

  final output = StringBuffer()
    ..writeln("// GENERATED CODE - DO NOT MODIFY BY HAND")
    ..writeln()
    ..writeln("part of '${partOfPrefix}database.dart';")
    ..writeln()
    ..writeln(classes)
    ..writeln(_generateTablesList(tables))
    ..writeln(schemaFunction)
    ..writeln(isArrayFunction);

  final outputFile = File(outputPath);
  outputFile.writeAsStringSync(output.toString());
  print(
    'Generated classes and schema function in ./lib/generell/services/database_classes.g.dart',
  );
}

bool _generateFields(
  String fields,
  StringBuffer buffer,
  String tableName,
  Map<String, List<Map<String, dynamic>>> relationships,
  Set<String> validTables,
) {
  final fieldLines = fields.split('\n');
  bool hasIdColumn = false;

  for (int i = 0; i < fieldLines.length; i++) {
    final line = fieldLines[i].trim();

    if (line.isEmpty) continue;

    final match = RegExp(r'(\w+): ([^|]+)(\s*\|\s*null)?').firstMatch(line);
    if (match != null) {
      String? fieldName = match.group(1);
      String fieldNameNamed = fieldName!;
      final fieldType = match.group(2)?.trim();
      final isNullable = match.group(3) != null;
      final columnType = _mapType(fieldType!, fieldName);
      final columnBuilder = _mapBuilder(fieldType, fieldName);
      final converterType = _mapConverterType(fieldType, fieldName);

      if (fieldName == 'id') {
        hasIdColumn = true;
      }

      // Special case for field name 'text'
      if (fieldNameNamed == 'text') {
        fieldNameNamed = 'textValue';
      }

      final reference = _findReference(
        tableName,
        fieldName,
        relationships,
        validTables,
      );

      // Add @ReferenceName annotation if references exist
      if (reference != null) {
        final referenceName =
            '${_toCamelCase(tableName)}${_capitalize(fieldName)}';
        buffer.writeln('  @ReferenceName(\'$referenceName\')');
      }

      buffer.write(
        '  ${columnType}Column get ${_toCamelCaseLower(fieldNameNamed)} => ${_generateColumn(fieldName, columnBuilder, isNullable, converterType, fieldName == 'id' && columnType == 'Text')}',
      );

      if (reference != null) {
        buffer.write(
          '.references(${reference['table']}, #${reference['column']})',
        );
      }

      buffer.writeln('(); // $fieldType${isNullable ? ' | null' : ''}');

      if (converterType.contains('Array')) {
        arrayColumns.add('$tableName.$fieldName');
      }
    }
  }
  return hasIdColumn;
}

String _generateColumn(
  String fieldName,
  String columnBuilder,
  bool isNullable,
  String converterType,
  bool isId,
) {
  final nullableStr = isNullable ? '.nullable()' : '';
  final converterStr = converterType == 'none'
      ? ''
      : '.map(const ${converterType}Converter())';
  final clientDefaultStr = isId && columnBuilder == 'text'
      ? ".clientDefault(() => powersync.uuid.v8())"
      : '';
  return '$columnBuilder().named(\'$fieldName\')$nullableStr$converterStr$clientDefaultStr';
}

String _mapType(String type, String fieldName) {
  if (doubleFields.contains(fieldName)) {
    return 'Real';
  }
  // if (fieldName.toLowerCase().contains('datetime')) {
  //   return 'DateTime';
  // }
  switch (type.replaceAll(' | null', '').trim()) {
    case 'string':
    case 'string[]':
    case 'Json':
      return 'Text';
    case 'number':
      return 'Int';
    case 'boolean':
      return 'Bool';
    default:
      return 'Text';
  }
}

String _mapBuilder(String type, String fieldName) {
  if (doubleFields.contains(fieldName)) {
    return 'real';
  }
  // if (fieldName.toLowerCase().contains('datetime')) {
  //   return 'dateTime';
  // }
  switch (type.replaceAll(' | null', '').trim()) {
    case 'string':
    case 'string[]':
    case 'Json':
      return 'text';
    case 'number':
      return 'integer';
    case 'boolean':
      return 'boolean';
    default:
      return 'text';
  }
}

String _mapConverterType(String type, String fieldName) {
  if (fieldName.toLowerCase().contains('datetime')) {
    return 'DateTime';
  }

  switch (type.replaceAll(' | null', '').trim()) {
    case 'string[]':
      return 'StringArray';
    case 'number[]':
      if (doubleFields.contains(fieldName)) {
        return 'DoubleArray';
      }
      return 'IntArray';
    case 'Json':
      return 'Json';
    default:
      return 'none';
  }
}

String _capitalize(String text) => text[0].toUpperCase() + text.substring(1);

String _toCamelCase(String text) {
  final parts = text.split('_');
  return parts.mapIndexed((i, part) {
    if (i == 0) return part;
    return _capitalize(part);
  }).join();
}

String _toCamelCaseLower(String text) {
  final parts = text.split('_');
  return parts.mapIndexed((i, part) {
    if (i == 0 && part.toUpperCase() == part) {
      return part.toLowerCase();
    } else if (i == 0) {
      return part;
    } else if (part.toUpperCase() == part) {
      return _capitalize(part.toLowerCase());
    } else {
      return _capitalize(part);
    }
  }).join();
}

String _toCamelCaseReverse(String text) {
  final parts = text.split('_');
  return parts.reversed.map((part) => _capitalize(part)).join();
}

String _generateSchemaFunction(Map<String, String> tableSchemas) {
  final buffer = StringBuffer()
    ..writeln('Map<String, String> get schema => {')
    ..writeln(
      tableSchemas.entries
          .map((entry) {
            return "  '${entry.key}': '${entry.value}',";
          })
          .join('\n'),
    )
    ..writeln('};');
  return buffer.toString();
}

String _generateIsArrayFunction(Set<String> arrayColumns) {
  final buffer = StringBuffer()
    ..writeln('/// Returns true if the given column is an array column')
    ..writeln(
      '/// [tableColumn] should be in the format: `tableName.columnName`',
    )
    ..writeln('bool isArray(String tableColumn) {')
    ..writeln('  final arrayCols = ["${arrayColumns.join('", "')}"];')
    ..writeln('  return arrayCols.contains(tableColumn);')
    ..writeln('}');
  return buffer.toString();
}

String _generateTablesList(List<String> tables) {
  final buffer = StringBuffer()
    ..writeln('const List<Type> tables = [')
    ..writeln(tables.map((table) => '  $table,').join('\n'))
    ..writeln('];');
  return buffer.toString();
}

Map<String, String>? _findReference(
  String tableName,
  String fieldName,
  Map<String, List<Map<String, dynamic>>> relationships,
  Set<String> validTables,
) {
  final tableRelationships = relationships[tableName];
  if (tableRelationships == null) {
    return null;
  }

  final relationship = tableRelationships.firstWhereOrNull(
    (rel) => rel['column'] == fieldName,
  );
  if (relationship == null) {
    return null;
  }

  if (!validTables.contains(relationship['referencedTable'])) {
    return null;
  }

  return {
    'table': _capitalize(
      _toCamelCase('${relationship['referencedTable']}$tableSubfix'),
    ),
    'column': _toCamelCaseLower(relationship['referencedColumn']),
  };
}
