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

/// Provider for the central database instance.
/// Responsibility: Singleton access to the Drift database.
@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  // Listen to auth state to determine the database file
  final authState = ref.watch(authControllerProvider);
  final user = authState.asData?.value;

  // Derive a unique database name from the user's email
  // If not logged in, use 'default' but typically we'd be redirected to login
  final dbName = user != null
      ? 'db_${user.email.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_')}.sqlite'
      : 'db_default.sqlite';

  final db = AppDatabase(_openConnection(dbName));

  // Clean up the database when the provider is disposed or the user changes
  ref.onDispose(db.close);

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
