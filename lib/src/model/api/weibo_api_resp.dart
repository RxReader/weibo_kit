import 'package:json_annotation/json_annotation.dart';

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
