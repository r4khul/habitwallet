// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NotificationSettings _$NotificationSettingsFromJson(
  Map<String, dynamic> json,
) => _NotificationSettings(
  isEnabled: json['isEnabled'] as bool? ?? false,
  reminderTimeStr: json['reminderTimeStr'] as String? ?? '20:00',
);

Map<String, dynamic> _$NotificationSettingsToJson(
  _NotificationSettings instance,
) => <String, dynamic>{
  'isEnabled': instance.isEnabled,
  'reminderTimeStr': instance.reminderTimeStr,
};
