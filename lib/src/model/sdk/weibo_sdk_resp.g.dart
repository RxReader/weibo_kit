// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weibo_sdk_resp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeiboSdkResp _$WeiboSdkRespFromJson(Map json) {
  return WeiboSdkResp(
    errorCode: json['errorCode'] as int,
    errorMessage: json['errorMessage'] as String,
  );
}

Map<String, dynamic> _$WeiboSdkRespToJson(WeiboSdkResp instance) =>
    <String, dynamic>{
      'errorCode': instance.errorCode,
      'errorMessage': instance.errorMessage,
    };
