// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_User _$_$_UserFromJson(Map<String, dynamic> json) {
  return _$_User(
    id: json['id'] as String,
    email: json['email'] as String?,
    defaultAddress: json['defaultAddress'] as String?,
    name: json['name'] as String?,
    photourl: json['photourl'] as String?,
    personaldocs: json['personaldocs'] as String?,
    bankdocs: json['bankdocs'] as String?,
    vehicle: json['vehicle'] as String?,
    vehicledocs: json['vehicledocs'] as String?,
    pushToken: json['pushToken'] as String?,
    notification: json['notification'] as List<dynamic>?,
  );
}

Map<String, dynamic> _$_$_UserToJson(_$_User instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'defaultAddress': instance.defaultAddress,
      'name': instance.name,
      'photourl': instance.photourl,
      'personaldocs': instance.personaldocs,
      'bankdocs': instance.bankdocs,
      'vehicle': instance.vehicle,
      'vehicledocs': instance.vehicledocs,
      'pushToken': instance.pushToken,
      'notification': instance.notification,
    };
