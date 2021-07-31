// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthResp _$AuthRespFromJson(Map<String, dynamic> json) {
  return AuthResp(
    errorCode: json['errorCode'] as int? ?? 0,
    errorMessage: json['errorMessage'] as String?,
    userId: json['userId'] as String?,
    accessToken: json['accessToken'] as String?,
    refreshToken: json['refreshToken'] as String?,
    expiresIn: json['expiresIn'] as int?,
  );
}

Map<String, dynamic> _$AuthRespToJson(AuthResp instance) => <String, dynamic>{
      'errorCode': instance.errorCode,
      'errorMessage': instance.errorMessage,
      'userId': instance.userId,
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
      'expiresIn': instance.expiresIn,
    };

ShareMsgResp _$ShareMsgRespFromJson(Map<String, dynamic> json) {
  return ShareMsgResp(
    errorCode: json['errorCode'] as int? ?? 0,
    errorMessage: json['errorMessage'] as String?,
  );
}

Map<String, dynamic> _$ShareMsgRespToJson(ShareMsgResp instance) =>
    <String, dynamic>{
      'errorCode': instance.errorCode,
      'errorMessage': instance.errorMessage,
    };
