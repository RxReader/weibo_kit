import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'resp.g.dart';

abstract class BaseResp {
  const BaseResp({
    required this.errorCode,
    this.errorMessage,
  });

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

  @JsonKey(
    defaultValue: SUCCESS,
  )
  final int errorCode;
  final String? errorMessage;

  bool get isSuccessful => errorCode == SUCCESS;

  bool get isCancelled => errorCode == USERCANCEL;

  Map<String, dynamic> toJson();

  @override
  String toString() => const JsonEncoder.withIndent('  ').convert(toJson());
}

@JsonSerializable(
  explicitToJson: true,
)
class AuthResp extends BaseResp {
  const AuthResp({
    required super.errorCode,
    super.errorMessage,
    this.userId,
    this.accessToken,
    this.refreshToken,
    this.expiresTime,
  });

  factory AuthResp.fromJson(Map<String, dynamic> json) =>
      _$AuthRespFromJson(json);

  final String? userId;
  final String? accessToken;
  final String? refreshToken;
  final int? expiresTime;

  @override
  Map<String, dynamic> toJson() => _$AuthRespToJson(this);
}

@JsonSerializable(
  explicitToJson: true,
)
class ShareMsgResp extends BaseResp {
  const ShareMsgResp({
    required super.errorCode,
    super.errorMessage,
  });

  factory ShareMsgResp.fromJson(Map<String, dynamic> json) =>
      _$ShareMsgRespFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ShareMsgRespToJson(this);
}
