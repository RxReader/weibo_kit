import 'package:json_annotation/json_annotation.dart';

part 'weibo_api_resp.g.dart';

abstract class WeiboApiResp {
  const WeiboApiResp({
    required this.errorCode,
    this.error,
    this.request,
  });

  static const int ERROR_CODE_SUCCESS = 0;

  /// https://open.weibo.com/wiki/Help/error
  @JsonKey(
    defaultValue: ERROR_CODE_SUCCESS,
  )
  final int errorCode;
  final String? error;
  final String? request;

  bool get isSuccessful => errorCode == ERROR_CODE_SUCCESS;
}

@JsonSerializable(
  explicitToJson: true,
  fieldRename: FieldRename.snake,
)
class WeiboUserInfoResp extends WeiboApiResp {
  const WeiboUserInfoResp({
    required super.errorCode,
    super.error,
    super.request,
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
  });

  factory WeiboUserInfoResp.fromJson(Map<String, dynamic> json) =>
      _$WeiboUserInfoRespFromJson(json);

  /// 用户UID（int64）
  final int? id;

  /// 字符串型的用户 UID
  final String? idstr;

  /// 用户昵称
  final String? screenName;

  /// 友好显示名称
  final String? name;

  /// 用户所在地
  final String? location;

  /// 用户个人描述
  final String? description;

  /// 用户头像地址，50×50像素
  final String? profileImageUrl;

  /// 性别，m：男、f：女、n：未知
  final String? gender;

  /// 用户大头像地址
  final String? avatarLarge;

  /// 用户高清大头像地址
  final String? avatarHd;

  bool get isMale => gender == 'm';

  bool get isFemale => gender == 'f';

  Map<String, dynamic> toJson() => _$WeiboUserInfoRespToJson(this);
}
