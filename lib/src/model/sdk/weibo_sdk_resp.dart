import 'package:json_annotation/json_annotation.dart';

part 'weibo_sdk_resp.g.dart';

@JsonSerializable(
  anyMap: true,
  explicitToJson: true,
)
class WeiboSdkResp {
  WeiboSdkResp({
    int errorCode,
    this.errorMessage,
  }) : errorCode = errorCode ?? SUCCESS;

  factory WeiboSdkResp.fromJson(Map<dynamic, dynamic> json) =>
      _$WeiboSdkRespFromJson(json);

  /// 成功
  static const int SUCCESS = 0;

  /// 用户取消发送
  static const int USERCANCEL = -1;

  /// 发送失败
  static const int SENT_FAIL = -2;

  /// 授权失败
  static const int AUTH_DENY = -3;

  /// 用户取消安装微博客户端
  static const int USERCANCEL_INSTALL = -4;

  /// 支付失败
  static const int PAY_FAIL = -5;

  /// 分享失败 详情见response UserInfo
  static const int SHARE_IN_SDK_FAILED = -8;

  /// 不支持的请求
  static const int UNSUPPORT = -99;

  /// 未知
  static const int UNKNOWN = -100;

  /// sso package or sign error
  static const int SSO_PKG_SIGN_ERROR = 21338;

  final int errorCode;
  final String errorMessage;

  Map<dynamic, dynamic> toJson() => _$WeiboSdkRespToJson(this);
}
