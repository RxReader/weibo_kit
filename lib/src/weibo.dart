import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:fake_weibo/src/domain/api/weibo_user_info_resp.dart';
import 'package:fake_weibo/src/domain/sdk/weibo_auth_resp.dart';
import 'package:fake_weibo/src/domain/sdk/weibo_sdk_resp.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

class Weibo {
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

  static const String _DEFAULT_REDIRECTURL =
      'https://api.weibo.com/oauth2/default.html';

  static const MethodChannel _channel =
      MethodChannel('v7lin.github.io/fake_weibo');

  final StreamController<WeiboAuthResp> _authRespStreamController =
      StreamController<WeiboAuthResp>.broadcast();

  final StreamController<WeiboSdkResp> _shareMsgRespStreamController =
      StreamController<WeiboSdkResp>.broadcast();

  Future<void> registerApp({
    @required String appKey,
    @required List<String> scope,
    String redirectUrl =
        _DEFAULT_REDIRECTURL, // 新浪微博开放平台 -> 我的应用 -> 应用信息 -> 高级信息 -> OAuth2.0授权设置
  }) {
    assert(appKey != null && appKey.isNotEmpty);
    assert(scope != null && scope.isNotEmpty);
    _channel.setMethodCallHandler(_handleMethod);
    return _channel.invokeMethod(
      _METHOD_REGISTERAPP,
      <String, dynamic>{
        _ARGUMENT_KEY_APPKEY: appKey,
        _ARGUMENT_KEY_SCOPE: scope.join(','),
        _ARGUMENT_KEY_REDIRECTURL: redirectUrl,
      },
    );
  }

  Future<dynamic> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case _METHOD_ONAUTHRESP:
        _authRespStreamController.add(WeiboAuthRespSerializer()
            .fromMap(call.arguments as Map<dynamic, dynamic>));
        break;
      case _METHOD_ONSHAREMSGRESP:
        _shareMsgRespStreamController.add(WeiboSdkRespSerializer()
            .fromMap(call.arguments as Map<dynamic, dynamic>));
        break;
    }
  }

  Stream<WeiboAuthResp> authResp() {
    return _authRespStreamController.stream;
  }

  Stream<WeiboSdkResp> shareMsgResp() {
    return _shareMsgRespStreamController.stream;
  }

  Future<bool> isWeiboInstalled() async {
    return (await _channel.invokeMethod(_METHOD_ISWEIBOINSTALLED)) as bool;
  }

  Future<void> auth({
    @required String appKey,
    @required List<String> scope,
    String redirectUrl = _DEFAULT_REDIRECTURL,
  }) {
    assert(appKey != null && appKey.isNotEmpty);
    assert(scope != null && scope.isNotEmpty);
    return _channel.invokeMethod(
      _METHOD_AUTH,
      <String, dynamic>{
        _ARGUMENT_KEY_APPKEY: appKey,
        _ARGUMENT_KEY_SCOPE: scope.join(','),
        _ARGUMENT_KEY_REDIRECTURL: redirectUrl,
      },
    );
  }

  Future<WeiboUserInfoResp> getUserInfo({
    @required String appkey,
    @required String userId,
    @required String accessToken,
  }) {
    assert(userId != null && userId.isNotEmpty);
    assert(accessToken != null && accessToken.isNotEmpty);
    Map<String, String> params = <String, String>{
      'uid': userId,
    };
    return HttpClient()
        .getUrl(_encodeUrl('https://api.weibo.com/2/users/show.json', appkey,
            accessToken, params))
        .then((HttpClientRequest request) {
      return request.close();
    }).then((HttpClientResponse response) async {
      if (response.statusCode == HttpStatus.ok) {
        String content = await utf8.decodeStream(response);
        return WeiboUserInfoRespSerializer()
            .fromMap(json.decode(content) as Map<dynamic, dynamic>);
      }
      throw HttpException(
          'HttpResponse statusCode: ${response.statusCode}, reasonPhrase: ${response.reasonPhrase}.');
    });
  }

  Uri _encodeUrl(
    String baseUrl,
    String appkey,
    String accessToken,
    Map<String, String> params,
  ) {
    params.putIfAbsent('source', () => appkey);
    params.putIfAbsent('access_token', () => accessToken);

    Uri baseUri = Uri.parse(baseUrl);
    Map<String, List<String>> queryParametersAll =
        Map<String, List<String>>.of(baseUri.queryParametersAll);
    params.forEach((String key, String value) {
      queryParametersAll.remove(key);
      queryParametersAll.putIfAbsent(key, () => <String>[value]);
    });

    return baseUri.replace(queryParameters: queryParametersAll);
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

class WeiboProvider extends InheritedWidget {
  WeiboProvider({
    Key key,
    @required this.weibo,
    @required Widget child,
  }) : super(key: key, child: child);

  final Weibo weibo;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    WeiboProvider oldProvider = oldWidget as WeiboProvider;
    return weibo != oldProvider.weibo;
  }

  static WeiboProvider of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(WeiboProvider) as WeiboProvider;
  }
}
