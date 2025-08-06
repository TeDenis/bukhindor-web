// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserEntityImpl _$$UserEntityImplFromJson(Map<String, dynamic> json) =>
    _$UserEntityImpl(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      isActive: json['isActive'] as bool? ?? true,
      photoURL: json['photoURL'] as String?,
      emailVerified: json['emailVerified'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$UserEntityImplToJson(_$UserEntityImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'name': instance.name,
      'isActive': instance.isActive,
      'photoURL': instance.photoURL,
      'emailVerified': instance.emailVerified,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
