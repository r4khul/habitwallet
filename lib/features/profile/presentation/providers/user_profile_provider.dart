import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../transactions/data/transaction_repository_provider.dart';
import '../../domain/user_profile.dart';

part 'user_profile_provider.g.dart';

@riverpod
class UserProfileController extends _$UserProfileController {
  static const _storageKey = 'user_profile';

  @override
  FutureOr<UserProfile> build() async {
    const storage = FlutterSecureStorage();
    final jsonString = await storage.read(key: _storageKey);
    if (jsonString == null) return const UserProfile();

    try {
      return UserProfile.fromJson(
        json.decode(jsonString) as Map<String, dynamic>,
      );
    } on Object catch (_) {
      return const UserProfile();
    }
  }

  Future<void> updateProfile({String? name, double? yearlySavingsGoal}) async {
    final currentProfile = state.value ?? const UserProfile();
    final newProfile = currentProfile.copyWith(
      name: name ?? currentProfile.name,
      yearlySavingsGoal: yearlySavingsGoal ?? currentProfile.yearlySavingsGoal,
    );

    state = AsyncValue.data(newProfile);

    const storage = FlutterSecureStorage();
    await storage.write(
      key: _storageKey,
      value: json.encode(newProfile.toJson()),
    );
  }
}

@riverpod
Stream<double> currentYearSavings(Ref ref) {
  final now = DateTime.now();
  final start = DateTime(now.year);
  final end = DateTime(now.year, 12, 31, 23, 59, 59);

  return ref.watch(transactionRepositoryProvider).watchInRange(start, end).map((
    transactions,
  ) {
    return transactions.fold<double>(0, (sum, tx) => sum + tx.amount);
  });
}
