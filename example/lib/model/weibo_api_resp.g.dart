// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weibo_api_resp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeiboUserInfoResp _$WeiboUserInfoRespFromJson(Map<String, dynamic> json) {
  return WeiboUserInfoResp(
    errorCode: json['error_code'] as int? ?? 0,
    error: json['error'] as String?,
    request: json['request'] as String?,
    id: json['id'] as int?,
    idstr: json['idstr'] as String?,
    screenName: json['screen_name'] as String?,
    name: json['name'] as String?,
    location: json['location'] as String?,
    description: json['description'] as String?,
    profileImageUrl: json['profile_image_url'] as String?,
    gender: json['gender'] as String?,
    avatarLarge: json['avatar_large'] as String?,
    avatarHd: json['avatar_hd'] as String?,
  );
}

Map<String, dynamic> _$WeiboUserInfoRespToJson(WeiboUserInfoResp instance) =>
    <String, dynamic>{
      'error_code': instance.errorCode,
      'error': instance.error,
      'request': instance.request,
      'id': instance.id,
      'idstr': instance.idstr,
      'screen_name': instance.screenName,
      'name': instance.name,
      'location': instance.location,
      'description': instance.description,
      'profile_image_url': instance.profileImageUrl,
      'gender': instance.gender,
      'avatar_large': instance.avatarLarge,
      'avatar_hd': instance.avatarHd,
    };
