// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weibo_user_info_resp.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$WeiboUserInfoRespSerializer
    implements Serializer<WeiboUserInfoResp> {
  @override
  Map<String, dynamic> toMap(WeiboUserInfoResp model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'id', model.id);
    setMapValue(ret, 'idstr', model.idstr);
    setMapValue(ret, 'screen_name', model.screenName);
    setMapValue(ret, 'name', model.name);
    setMapValue(ret, 'location', model.location);
    setMapValue(ret, 'description', model.description);
    setMapValue(ret, 'profile_image_url', model.profileImageUrl);
    setMapValue(ret, 'gender', model.gender);
    setMapValue(ret, 'avatar_large', model.avatarLarge);
    setMapValue(ret, 'avatar_hd', model.avatarHd);
    setMapValue(ret, 'error_code', model.errorCode);
    setMapValue(ret, 'error', model.error);
    setMapValue(ret, 'request', model.request);
    return ret;
  }

  @override
  WeiboUserInfoResp fromMap(Map map) {
    if (map == null) return null;
    final obj = new WeiboUserInfoResp(
        errorCode: map['error_code'] as int ?? getJserDefault('errorCode'),
        error: map['error'] as String ?? getJserDefault('error'),
        request: map['request'] as String ?? getJserDefault('request'),
        id: map['id'] as int ?? getJserDefault('id'),
        idstr: map['idstr'] as String ?? getJserDefault('idstr'),
        screenName:
            map['screen_name'] as String ?? getJserDefault('screenName'),
        name: map['name'] as String ?? getJserDefault('name'),
        location: map['location'] as String ?? getJserDefault('location'),
        description:
            map['description'] as String ?? getJserDefault('description'),
        profileImageUrl: map['profile_image_url'] as String ??
            getJserDefault('profileImageUrl'),
        gender: map['gender'] as String ?? getJserDefault('gender'),
        avatarLarge:
            map['avatar_large'] as String ?? getJserDefault('avatarLarge'),
        avatarHd: map['avatar_hd'] as String ?? getJserDefault('avatarHd'));
    return obj;
  }
}
