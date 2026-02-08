// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => _UserProfile(
  name: json['name'] as String? ?? 'User',
  yearlySavingsGoal: (json['yearlySavingsGoal'] as num?)?.toDouble() ?? 10000.0,
);

Map<String, dynamic> _$UserProfileToJson(_UserProfile instance) =>
    <String, dynamic>{
      'name': instance.name,
      'yearlySavingsGoal': instance.yearlySavingsGoal,
    };
