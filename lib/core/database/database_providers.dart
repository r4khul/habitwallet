import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'daos/category_dao.dart';
import 'daos/transaction_dao.dart';
import 'daos/attachment_dao.dart';
import 'database.dart';

import '../../features/auth/presentation/providers/auth_providers.dart';

part 'database_providers.g.dart';

/// Derives the database name from auth state.
@riverpod
String dbName(Ref ref) {
  final authState = ref.watch(authControllerProvider);
  final user = authState.asData?.value;

  return user != null
      ? 'db_${user.email.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_')}.sqlite'
      : 'db_default.sqlite';
}

/// Provider for the central database instance.
@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  final name = ref.watch(dbNameProvider);

  final db = AppDatabase(_openConnection(name));

  // Clean up the database when the provider is disposed or the name changes
  ref.onDispose(() async {
    await db.close();
  });

  return db;
}

LazyDatabase _openConnection(String dbName) {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file into the documents folder
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, dbName));
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

/// Provider for [AttachmentDao].
@riverpod
AttachmentDao attachmentDao(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return AttachmentDao(db);
}
