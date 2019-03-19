abstract class WeiboApiResp {
  WeiboApiResp({
    int errorCode,
    this.error,
    this.request,
  }) : errorCode = errorCode ?? ERROR_CODE_SUCCESS;

  static const int ERROR_CODE_SUCCESS = 0;

  /// https://open.weibo.com/wiki/Help/error
  final int errorCode;
  final String error;
  final String request;
}
