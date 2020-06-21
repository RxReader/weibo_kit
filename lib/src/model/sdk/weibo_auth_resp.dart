import 'package:json_annotation/json_annotation.dart';
import 'package:weibo_kit/src/model/sdk/weibo_sdk_resp.dart';

part 'weibo_auth_resp.g.dart';

@JsonSerializable(
  anyMap: true,
  explicitToJson: true,
)
class WeiboAuthResp extends WeiboSdkResp {
  WeiboAuthResp({
    int errorCode,
    String errorMessage,
    this.userId,
    this.accessToken,
    this.refreshToken,
    this.expiresIn,
  }) : super(errorCode: errorCode, errorMessage: errorMessage);

  factory WeiboAuthResp.fromJson(Map<dynamic, dynamic> json) => _$WeiboAuthRespFromJson(json);

  final String userId;
  final String accessToken;
  final String refreshToken;
  final int expiresIn;

  @override
  Map<dynamic, dynamic> toJson() => _$WeiboAuthRespToJson(this);
}
