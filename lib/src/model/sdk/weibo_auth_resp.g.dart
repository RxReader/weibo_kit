// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weibo_auth_resp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeiboAuthResp _$WeiboAuthRespFromJson(Map json) {
  return WeiboAuthResp(
    errorCode: json['errorCode'] as int,
    errorMessage: json['errorMessage'] as String,
    userId: json['userId'] as String,
    accessToken: json['accessToken'] as String,
    refreshToken: json['refreshToken'] as String,
    expiresIn: json['expiresIn'] as int,
  );
}

Map<String, dynamic> _$WeiboAuthRespToJson(WeiboAuthResp instance) =>
    <String, dynamic>{
      'errorCode': instance.errorCode,
      'errorMessage': instance.errorMessage,
      'userId': instance.userId,
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
      'expiresIn': instance.expiresIn,
    };
