import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moonforge/data/database.dart';

final charactersRepositoryProvider = Provider<CharactersRepository>((ref) {
  final db = ref.watch(driftDatabase);
  return CharactersRepository(db);
});

class CharactersRepository {
  CharactersRepository(this._db);

  final AppDatabase _db;

  Stream<List<CharactersTableData>> watchAll() {
    return _db.select(_db.charactersTable).watch();
  }

  Future<int> add(CharactersTableData character) {
    return _db.into(_db.charactersTable).insert(character);
  }

  Future<bool> update(CharactersTableData character) {
    return _db.update(_db.charactersTable).replace(character);
  }

  Future<void> upsert(CharactersTableData character) async {
    await _db.into(_db.charactersTable).insertOnConflictUpdate(character);
  }

  Future<int> delete(CharactersTableData character) {
    return _db.delete(_db.charactersTable).delete(character);
  }

  Future<int> deleteById(String id) {
    return (_db.delete(_db.charactersTable)
          ..where((t) => t.id.equals(id)))
        .go();
  }
}

class CharactersNotifier extends StreamNotifier<List<CharactersTableData>> {
  @override
  Stream<List<CharactersTableData>> build() {
    return ref.watch(charactersRepositoryProvider).watchAll();
  }
}

final charactersProvider =
    StreamNotifierProvider<CharactersNotifier, List<CharactersTableData>>(
      CharactersNotifier.new,
    );

final charactersCommandsProvider =
    AsyncNotifierProvider<CharactersCommands, void>(
      CharactersCommands.new,
    );

class CharactersCommands extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> addCharacter(CharactersTableData character) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(charactersRepositoryProvider).add(character);
    });
  }

  Future<void> updateCharacter(CharactersTableData character) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(charactersRepositoryProvider).update(character);
    });
  }

  Future<void> upsertCharacter(CharactersTableData character) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(charactersRepositoryProvider).upsert(character);
    });
  }

  Future<void> deleteCharacter(CharactersTableData character) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(charactersRepositoryProvider).delete(character);
    });
  }

  Future<void> deleteCharacterById(String id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(charactersRepositoryProvider).deleteById(id);
    });
  }
}
