import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../transactions/presentation/providers/transaction_providers.dart';
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
    } catch (_) {
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
Future<double> currentYearSavings(Ref ref) async {
  final transactions = await ref.watch(transactionControllerProvider.future);
  final now = DateTime.now();
  final currentYearTransactions = transactions.where(
    (tx) => tx.timestamp.year == now.year,
  );

  double savings = 0;
  for (final tx in currentYearTransactions) {
    savings += tx.amount; // amount sign is already handled in domain logic
  }
  return savings;
}
