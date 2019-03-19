// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weibo_sdk_resp.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$WeiboSdkRespSerializer implements Serializer<WeiboSdkResp> {
  @override
  Map<String, dynamic> toMap(WeiboSdkResp model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'errorCode', model.errorCode);
    setMapValue(ret, 'errorMessage', model.errorMessage);
    return ret;
  }

  @override
  WeiboSdkResp fromMap(Map map) {
    if (map == null) return null;
    final obj = new WeiboSdkResp(
        errorCode: map['errorCode'] as int ?? getJserDefault('errorCode'),
        errorMessage:
            map['errorMessage'] as String ?? getJserDefault('errorMessage'));
    return obj;
  }
}
