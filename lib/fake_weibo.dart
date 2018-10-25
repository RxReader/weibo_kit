import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

class FakeWeiboScope {
  static const String EMAIL = 'email';
  static const String DIRECT_MESSAGES_READ = 'direct_messages_read';
  static const String DIRECT_MESSAGES_WRITE = 'direct_messages_write';
  static const String FRIENDSHIPS_GROUPS_READ = 'friendships_groups_read';
  static const String FRIENDSHIPS_GROUPS_WRITE = 'friendships_groups_write';
  static const String STATUSES_TO_ME_READ = 'statuses_to_me_read';
  static const String FOLLOW_APP_OFFICIAL_MICROBLOG =
      'follow_app_official_microblog';
  static const String INVITATION_WRITE = 'invitation_write';
  static const String ALL = 'all';

  FakeWeiboScope._();
}

class FakeWeiboStatusCode {
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

  FakeWeiboStatusCode._();
}

abstract class FakeWeiboBaseResp {
  final int statusCode;

  FakeWeiboBaseResp({
    @required this.statusCode,
  });
}

class FakeWeiboAuthResp extends FakeWeiboBaseResp {
  final String userId;
  final String accessToken;
  final String refreshToken;
  final String expirationDate;

  FakeWeiboAuthResp._internal({
    @required int statusCode,
    this.userId,
    this.accessToken,
    this.refreshToken,
    this.expirationDate,
  }) : super(statusCode: statusCode);
}

class FakeWeiboShareMsgResp extends FakeWeiboBaseResp {
  FakeWeiboShareMsgResp._internal({@required int statusCode})
      : super(statusCode: statusCode);
}

class FakeWeibo {
  static const String _METHOD_REGISTERAPP = 'registerApp';
  static const String _METHOD_ISWEIBOINSTALLED = 'isWeiboInstalled';
  static const String _METHOD_AUTH = 'auth';
  static const String _METHOD_SHARETEXT = 'shareText';
  static const String _METHOD_SHAREIMAGE = 'shareImage';
  static const String _METHOD_SHAREWEBPAGE = 'shareWebpage';

  static const String _METHOD_ONAUTHRESP = 'onAuthResp';
  static const String _METHOD_ONSHAREMSGRESP = 'onShareMsgResp';

  static const String _ARGUMENT_KEY_APPKEY = 'appKey';
  static const String _ARGUMENT_KEY_SCOPE = 'scope';
  static const String _ARGUMENT_KEY_REDIRECTURL = 'redirectUrl';
  static const String _ARGUMENT_KEY_TEXT = 'text';
  static const String _ARGUMENT_KEY_TITLE = 'title';
  static const String _ARGUMENT_KEY_DESCRIPTION = 'description';
  static const String _ARGUMENT_KEY_THUMBDATA = 'thumbData';
  static const String _ARGUMENT_KEY_IMAGEDATA = 'imageData';
  static const String _ARGUMENT_KEY_WEBPAGEURL = 'webpageUrl';

  static const String _ARGUMENT_KEY_RESULT_STATUSCODE = 'statusCode';
  static const String _ARGUMENT_KEY_RESULT_USERID = 'userId';
  static const String _ARGUMENT_KEY_RESULT_ACCESSTOKEN = 'accessToken';
  static const String _ARGUMENT_KEY_RESULT_REFRESHTOKEN = 'refreshToken';
  static const String _ARGUMENT_KEY_RESULT_EXPIRATIONDATE = 'expirationDate';

  static const MethodChannel _channel =
      const MethodChannel('plugins.flutter.io/fake_weibo');

  static const String _DEFAULT_REDIRECTURL =
      'https://api.weibo.com/oauth2/default.html';

  final String _appKey;
  final List<String> _scope;
  final String _redirectUrl;

  final StreamController<FakeWeiboAuthResp> _authRespStreamController =
      new StreamController.broadcast();

  final StreamController<FakeWeiboShareMsgResp> _shareMsgRespStreamController =
      new StreamController.broadcast();

  FakeWeibo({
    @required String appKey,
    @required List<String> scope,
    String redirectUrl: _DEFAULT_REDIRECTURL,
  })  : assert(appKey != null && appKey.isNotEmpty),
        assert(scope != null && scope.isNotEmpty),
        _appKey = appKey,
        _scope = scope,
        _redirectUrl = redirectUrl;

  Future<void> registerApp() {
    _channel.setMethodCallHandler(_handleMethod);
    return _channel.invokeMethod(
      _METHOD_REGISTERAPP,
      <String, dynamic>{
        _ARGUMENT_KEY_APPKEY: _appKey,
        _ARGUMENT_KEY_SCOPE: _scope.join(','),
        _ARGUMENT_KEY_REDIRECTURL: _redirectUrl,
      },
    );
  }

  Future<dynamic> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case _METHOD_ONAUTHRESP:
        _authRespStreamController.add(new FakeWeiboAuthResp._internal(
            statusCode: call.arguments[_ARGUMENT_KEY_RESULT_STATUSCODE],
            userId: call.arguments[_ARGUMENT_KEY_RESULT_USERID],
            accessToken: call.arguments[_ARGUMENT_KEY_RESULT_ACCESSTOKEN],
            refreshToken: call.arguments[_ARGUMENT_KEY_RESULT_REFRESHTOKEN],
            expirationDate:
                call.arguments[_ARGUMENT_KEY_RESULT_EXPIRATIONDATE]));
        break;
      case _METHOD_ONSHAREMSGRESP:
        _shareMsgRespStreamController.add(new FakeWeiboShareMsgResp._internal(
          statusCode: call.arguments[_ARGUMENT_KEY_RESULT_STATUSCODE],
        ));
        break;
    }
  }

  Stream<FakeWeiboAuthResp> authResp() {
    return _authRespStreamController.stream;
  }

  Stream<FakeWeiboShareMsgResp> shareMsgResp() {
    return _shareMsgRespStreamController.stream;
  }

  Future<bool> isWeiboInstalled() async {
    return await _channel.invokeMethod(_METHOD_ISWEIBOINSTALLED);
  }

  Future<void> auth() {
    return _channel.invokeMethod(
      _METHOD_AUTH,
      <String, dynamic>{
        _ARGUMENT_KEY_APPKEY: _appKey,
        _ARGUMENT_KEY_SCOPE: _scope.join(','),
        _ARGUMENT_KEY_REDIRECTURL: _redirectUrl,
      },
    );
  }

  Future<void> shareText({
    @required String text,
  }) {
    assert(text != null && text.isNotEmpty && text.length <= 1024);
    return _channel.invokeMethod(
      _METHOD_SHARETEXT,
      <String, dynamic>{
        _ARGUMENT_KEY_TEXT: text,
      },
    );
  }

  Future<void> shareImage({
    @required Uint8List imageData,
  }) {
    assert(imageData != null && imageData.lengthInBytes <= 2 * 1024 * 1024);
    return _channel.invokeMethod(
      _METHOD_SHAREIMAGE,
      <String, dynamic>{
        _ARGUMENT_KEY_IMAGEDATA: imageData,
      },
    );
  }

  Future<void> shareWebpage({
    @required String title,
    @required String description,
    @required Uint8List thumbData,
    @required String webpageUrl,
  }) {
    assert(title != null && title.isNotEmpty && title.length <= 512);
    assert(description != null &&
        description.isNotEmpty &&
        description.length <= 1024);
    assert(thumbData != null && thumbData.lengthInBytes <= 32 * 1024);
    assert(webpageUrl != null &&
        webpageUrl.isNotEmpty &&
        webpageUrl.length <= 255);
    return _channel.invokeMethod(
      _METHOD_SHAREWEBPAGE,
      <String, dynamic>{
        _ARGUMENT_KEY_TITLE: title,
        _ARGUMENT_KEY_DESCRIPTION: description,
        _ARGUMENT_KEY_THUMBDATA: thumbData,
        _ARGUMENT_KEY_WEBPAGEURL: webpageUrl,
      },
    );
  }
}

class FakeWeiboProvider extends InheritedWidget {
  final FakeWeibo weibo;

  FakeWeiboProvider({
    Key key,
    @required this.weibo,
    @required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    FakeWeiboProvider oldProvider = oldWidget as FakeWeiboProvider;
    return weibo != oldProvider.weibo;
  }

  static FakeWeiboProvider of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(FakeWeiboProvider);
  }
}
