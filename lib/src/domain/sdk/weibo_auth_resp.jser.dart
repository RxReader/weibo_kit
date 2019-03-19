// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weibo_auth_resp.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$WeiboAuthRespSerializer implements Serializer<WeiboAuthResp> {
  @override
  Map<String, dynamic> toMap(WeiboAuthResp model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'userId', model.userId);
    setMapValue(ret, 'accessToken', model.accessToken);
    setMapValue(ret, 'refreshToken', model.refreshToken);
    setMapValue(ret, 'expiresIn', model.expiresIn);
    setMapValue(ret, 'errorCode', model.errorCode);
    setMapValue(ret, 'errorMessage', model.errorMessage);
    return ret;
  }

  @override
  WeiboAuthResp fromMap(Map map) {
    if (map == null) return null;
    final obj = new WeiboAuthResp(
        errorCode: map['errorCode'] as int ?? getJserDefault('errorCode'),
        errorMessage:
            map['errorMessage'] as String ?? getJserDefault('errorMessage'),
        userId: map['userId'] as String ?? getJserDefault('userId'),
        accessToken:
            map['accessToken'] as String ?? getJserDefault('accessToken'),
        refreshToken:
            map['refreshToken'] as String ?? getJserDefault('refreshToken'),
        expiresIn: map['expiresIn'] as int ?? getJserDefault('expiresIn'));
    return obj;
  }
}
