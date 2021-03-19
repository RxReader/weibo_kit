import 'package:json_annotation/json_annotation.dart';
import 'package:weibo_kit/src/model/sdk/weibo_sdk_resp.dart';

part 'weibo_auth_resp.g.dart';

@JsonSerializable(
  explicitToJson: true,
)
class WeiboAuthResp extends WeiboSdkResp {
  WeiboAuthResp({
    required int errorCode,
    String? errorMessage,
    this.userId,
    this.accessToken,
    this.refreshToken,
    this.expiresIn,
  }) : super(errorCode: errorCode, errorMessage: errorMessage);

  factory WeiboAuthResp.fromJson(Map<String, dynamic> json) =>
      _$WeiboAuthRespFromJson(json);

  final String? userId;
  final String? accessToken;
  final String? refreshToken;
  final int? expiresIn;

  @override
  Map<String, dynamic> toJson() => _$WeiboAuthRespToJson(this);
}
