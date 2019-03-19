import 'package:jaguar_serializer/jaguar_serializer.dart';
import 'package:fake_weibo/src/domain/api/weibo_api_resp.dart';

part 'weibo_user_info_resp.jser.dart';

@GenSerializer(nameFormatter: toSnakeCase)
class WeiboUserInfoRespSerializer extends Serializer<WeiboUserInfoResp>
    with _$WeiboUserInfoRespSerializer {}

class WeiboUserInfoResp extends WeiboApiResp {
  WeiboUserInfoResp({
    int errorCode,
    String error,
    String request,
    this.id,
    this.idstr,
    this.screenName,
    this.name,
    this.location,
    this.description,
    this.profileImageUrl,
    this.gender,
    this.avatarLarge,
    this.avatarHd,
  }) : super(errorCode: errorCode, error: error, request: request);

  /// 用户UID（int64）
  final int id;

  /// 字符串型的用户 UID
  final String idstr;

  /// 用户昵称
  final String screenName;

  /// 友好显示名称
  final String name;

  /// 用户所在地
  final String location;

  /// 用户个人描述
  final String description;

  /// 用户头像地址，50×50像素
  final String profileImageUrl;

  /// 性别，m：男、f：女、n：未知
  final String gender;

  /// 用户大头像地址
  final String avatarLarge;

  /// 用户高清大头像地址
  final String avatarHd;

  bool isMale() {
    return gender == 'm';
  }

  bool isFemale() {
    return gender == 'f';
  }
}
