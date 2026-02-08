import 'package:drift/drift.dart';

/// Categories table schema.
/// Unique classifications for transactions, acting as a lookup for the Transactions table.
class Categories extends Table {
  /// Unique stable identifier. Primary Key.
  TextColumn get id => text()();

  /// The display name of the category.
  TextColumn get name => text()();

  /// Icon name or code point.
  TextColumn get icon => text()();

  /// Color value (ARGB hex or int).
  IntColumn get color => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Transactions table schema.
/// Represents the authoritative local record of all financial events.
class Transactions extends Table {
  /// Unique stable identifier. Primary Key.
  /// This ID is preserved across syncs to ensure idempotency.
  TextColumn get id => text()();

  /// Monetary amount. Sign determines income (+) vs expense (-).
  /// Aligned with the TransactionEntity domain invariant.
  RealColumn get amount => real()();

  /// The category ID associated with this transaction.
  /// References [Categories.id].
  TextColumn get categoryId => text()();

  /// Authoritative domain timestamp (stored as epoch millis).
  /// Represents when the transaction actually occurred.
  IntColumn get timestamp => integer()();

  /// Optional user-provided description or context.
  TextColumn get note => text().nullable()();

  /// Synchronization state: true if the record was modified locally
  /// and needs to be pushed to the remote source.
  BoolColumn get editedLocally =>
      boolean().withDefault(const Constant(false))();

  /// Metadata: Timestamp of when the record was first inserted into the local DB.
  IntColumn get createdAt => integer()();

  /// Metadata: Timestamp of when the record was last modified in the local DB.
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}
