import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'daos/category_dao.dart';
import 'daos/transaction_dao.dart';
import 'database.dart';

part 'database_providers.g.dart';

/// Provider for the central database instance.
/// Responsibility: Singleton access to the Drift database.
@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  final db = AppDatabase(_openConnection());

  // Clean up the database when the provider is disposed
  ref.onDispose(db.close);

  return db;
}

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}

/// Provider for [TransactionDao].
@riverpod
TransactionDao transactionDao(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return TransactionDao(db);
}

/// Provider for [CategoryDao].
@riverpod
CategoryDao categoryDao(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return CategoryDao(db);
}
