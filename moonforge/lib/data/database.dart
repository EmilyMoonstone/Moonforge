import 'package:drift/drift.dart';
import 'package:drift_sqlite_async/drift_sqlite_async.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moonforge/data/powersync.dart';
import 'package:moonforge/data/utils/drift_converters.dart';
import 'package:powersync/powersync.dart' as powersync;

part 'database.g.dart';
part 'models/database_classes.g.dart';
part 'views.dart';

@DriftDatabase(
  tables: tables,
  views: [
    LocationsWithScopes,
    OrganizationsWithScopes,
    ItemsWithScopes,
    CreaturesWithScopes,
    EncountersWithScopes,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (m) async {
        // We don't have to call createAll(), PowerSync instantiates the schema
        // for us. We can use the opportunity to create fts5 indexes though.

        /*        await createFts5Tables(
          db: this,
          tableName: 'todos',
          columns: ['description', 'list_id'],
        );*/
      },
      onUpgrade: (m, from, to) async {
        if (from == 1) {
          /*          await createFts5Tables(
            db: this,
            tableName: 'todos',
            columns: ['description', 'list_id'],
          );*/
        }
      },
    );
  }
}

final driftDatabase = Provider((ref) {
  return AppDatabase(
    DatabaseConnection.delayed(
      Future(() async {
        final database = await ref.read(powerSyncInstanceProvider.future);
        return SqliteAsyncDriftConnection(database);
      }),
    ),
  );
});
