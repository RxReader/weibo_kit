import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

class FakeWeiboScope {
  FakeWeiboScope._();

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
}

class FakeWeiboErrorCode {
  FakeWeiboErrorCode._();

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
}

abstract class FakeWeiboBaseResp {
  FakeWeiboBaseResp({
    @required this.errorCode,
    this.errorMessage,
  });

  final int errorCode;
  final String errorMessage;
}

class FakeWeiboAuthResp extends FakeWeiboBaseResp {
  FakeWeiboAuthResp._({
    @required int errorCode,
    String errorMessage,
    this.userId,
    this.accessToken,
    this.refreshToken,
    this.expirationDate,
  }) : super(
          errorCode: errorCode,
          errorMessage: errorMessage,
        );

  final String userId;
  final String accessToken;
  final String refreshToken;
  final int expirationDate;
}

class FakeWeiboShareMsgResp extends FakeWeiboBaseResp {
  FakeWeiboShareMsgResp._({
    @required int errorCode,
    String errorMessage,
  }) : super(
          errorCode: errorCode,
          errorMessage: errorMessage,
        );
}

abstract class FakeWeiboApiBaseResp {
  FakeWeiboApiBaseResp({
    @required this.errorCode,
    this.error,
    this.request,
  });

  static const String KEY_ERROR_CODE = 'error_code';
  static const String KEY_ERROR = 'error';
  static const String KEY_REQUEST = 'request';

  static const int ERROR_CODE_SUCCESS = 0;

  /// https://open.weibo.com/wiki/Help/error
  final int errorCode;
  final String error;
  final String request;
}

class FakeWeiboApiUserResp extends FakeWeiboApiBaseResp {
  FakeWeiboApiUserResp._({
    int errorCode,
    String error,
    String request,
    this.id,
    this.idstr,
    this.screenName,
    this.name,
    this.province,
    this.city,
    this.location,
    this.description,
    this.url,
    this.profileImageUrl,
    this.profileUrl,
    this.domain,
    this.weihao,
    this.gender,
    this.verified,
    this.avatarLarge,
    this.avatarHD,
  }) : super(errorCode: errorCode, error: error, request: request);

  static const String KEY_ID = 'id';
  static const String KEY_ID_STR = 'idstr';
  static const String KEY_SCREEN_NAME = 'screen_name';
  static const String KEY_NAME = 'name';
  static const String KEY_PROVINCE = 'province';
  static const String KEY_CITY = 'city';
  static const String KEY_LOCATION = 'location';
  static const String KEY_DESCRIPTION = 'description';
  static const String KEY_URL = 'url';
  static const String KEY_PROFILE_IMAGE_URL = 'profile_image_url';
  static const String KEY_PROFILE_URL = 'profile_url';
  static const String KEY_DOMAIN = 'domain';
  static const String KEY_WEIHAO = 'weihao';
  static const String KEY_GENDER = 'gender';
  static const String KEY_VERIFIED = 'verified';
  static const String KEY_AVATAR_LARGE = 'avatar_large';
  static const String KEY_AVATAR_HD = 'avatar_hd';

  /// 用户UID（int64）
  final int id;

  /// 字符串型的用户 UID
  final String idstr;

  /// 用户昵称
  final String screenName;

  /// 友好显示名称
  final String name;

  /// 用户所在省级ID
  final String province;

  /// 用户所在城市ID
  final String city;

  /// 用户所在地
  final String location;

  /// 用户个人描述
  final String description;

  /// 用户博客地址
  final String url;

  /// 用户头像地址，50×50像素
  final String profileImageUrl;

  /// 用户的微博统一URL地址
  final String profileUrl;

  /// 用户的个性化域名
  final String domain;

  /// 用户的微号
  final String weihao;

  /// 性别，m：男、f：女、n：未知
  final String gender;

//  /// 粉丝数
//  final int followers_count;

//  /// 关注数
//  final int friends_count;

//  /// 微博数
//  final int statuses_count;

//  /// 收藏数
//  final int favourites_count;

//  /// 用户创建（注册）时间
//  final String created_at;

//  /// 暂未支持
//  final bool following;

//  /// 是否允许所有人给我发私信，true：是，false：否
//  final bool allow_all_act_msg;

//  /// 是否允许标识用户的地理位置，true：是，false：否
//  final bool geo_enabled;

  /// 是否是微博认证用户，即加V用户，true：是，false：否
  final bool verified;

//  /// 暂未支持
//  final int verified_type;

//  /// 用户备注信息，只有在查询用户关系时才返回此字段
//  final String remark;

//  /// 用户的最近一条微博信息字段
//  final dynamic status;

//  /// 是否允许所有人对我的微博进行评论，true：是，false：否
//  final bool allow_all_comment;

  /// 用户大头像地址
  final String avatarLarge;

  /// 用户高清大头像地址
  final String avatarHD;

//  /// 认证原因
//  final String verified_reason;

//  /// 该用户是否关注当前登录用户，true：是，false：否
//  final bool follow_me;

//  /// 用户的在线状态，0：不在线、1：在线
//  final int online_status;

//  /// 用户的互粉数
//  final int bi_followers_count;

//  /// 用户当前的语言版本，zh-cn：简体中文，zh-tw：繁体中文，en：英语
//  final String lang;

//  /// 注意：以下字段暂时不清楚具体含义，OpenAPI 说明文档暂时没有同步更新对应字段
//  final String star;
//  final String mbtype;
//  final String mbrank;
//  final String block_word;
}

class FakeWeibo {
  FakeWeibo({
    @required String appKey,
    @required List<String> scope,
    String redirectUrl = _DEFAULT_REDIRECTURL,
  })  : assert(appKey != null && appKey.isNotEmpty),
        assert(scope != null && scope.isNotEmpty),
        _appKey = appKey,
        _scope = scope,
        _redirectUrl = redirectUrl;

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

  static const String _ARGUMENT_KEY_RESULT_ERRORCODE = "errorCode";
  static const String _ARGUMENT_KEY_RESULT_ERRORMESSAGE = "errorMessage";
  static const String _ARGUMENT_KEY_RESULT_USERID = 'userId';
  static const String _ARGUMENT_KEY_RESULT_ACCESSTOKEN = 'accessToken';
  static const String _ARGUMENT_KEY_RESULT_REFRESHTOKEN = 'refreshToken';
  static const String _ARGUMENT_KEY_RESULT_EXPIRATIONDATE = 'expirationDate';

  static const String _DEFAULT_REDIRECTURL =
      'https://api.weibo.com/oauth2/default.html';

  static const MethodChannel _channel =
      MethodChannel('v7lin.github.io/fake_weibo');

  final String _appKey;
  final List<String> _scope;

  /// 新浪微博开放平台 -> 我的应用 -> 应用信息 -> 高级信息 -> OAuth2.0授权设置
  final String _redirectUrl;

  final StreamController<FakeWeiboAuthResp> _authRespStreamController =
      StreamController<FakeWeiboAuthResp>.broadcast();

  final StreamController<FakeWeiboShareMsgResp> _shareMsgRespStreamController =
      StreamController<FakeWeiboShareMsgResp>.broadcast();

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
        _authRespStreamController.add(FakeWeiboAuthResp._(
          errorCode: call.arguments[_ARGUMENT_KEY_RESULT_ERRORCODE] as int,
          errorMessage: call.arguments[_ARGUMENT_KEY_RESULT_ERRORMESSAGE] as String,
          userId: call.arguments[_ARGUMENT_KEY_RESULT_USERID] as String,
          accessToken:
              call.arguments[_ARGUMENT_KEY_RESULT_ACCESSTOKEN] as String,
          refreshToken:
              call.arguments[_ARGUMENT_KEY_RESULT_REFRESHTOKEN] as String,
          expirationDate:
              call.arguments[_ARGUMENT_KEY_RESULT_EXPIRATIONDATE] as int,
        ));
        break;
      case _METHOD_ONSHAREMSGRESP:
        _shareMsgRespStreamController.add(FakeWeiboShareMsgResp._(
          errorCode: call.arguments[_ARGUMENT_KEY_RESULT_ERRORCODE] as int,
          errorMessage: call.arguments[_ARGUMENT_KEY_RESULT_ERRORMESSAGE] as String,
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
    return (await _channel.invokeMethod(_METHOD_ISWEIBOINSTALLED)) as bool;
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

  Future<FakeWeiboApiUserResp> getUserInfo({
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
        Map<dynamic, dynamic> map = json.decode(content) as Map<dynamic, dynamic>;
        int errorCode = map.containsKey(FakeWeiboApiBaseResp.KEY_ERROR_CODE)
            ? map[FakeWeiboApiBaseResp.KEY_ERROR_CODE] as int
            : FakeWeiboApiBaseResp.ERROR_CODE_SUCCESS;
        if (errorCode == FakeWeiboApiBaseResp.ERROR_CODE_SUCCESS) {
          return FakeWeiboApiUserResp._(
            errorCode: errorCode,
            id: map[FakeWeiboApiUserResp.KEY_ID] as int,
            idstr: map[FakeWeiboApiUserResp.KEY_ID_STR] as String,
            screenName: map[FakeWeiboApiUserResp.KEY_SCREEN_NAME] as String,
            name: map[FakeWeiboApiUserResp.KEY_NAME] as String,
            province: map[FakeWeiboApiUserResp.KEY_PROVINCE] as String,
            city: map[FakeWeiboApiUserResp.KEY_CITY] as String,
            location: map[FakeWeiboApiUserResp.KEY_LOCATION] as String,
            description: map[FakeWeiboApiUserResp.KEY_DESCRIPTION] as String,
            url: map[FakeWeiboApiUserResp.KEY_URL] as String,
            profileImageUrl:
                map[FakeWeiboApiUserResp.KEY_PROFILE_IMAGE_URL] as String,
            profileUrl: map[FakeWeiboApiUserResp.KEY_PROFILE_URL] as String,
            domain: map[FakeWeiboApiUserResp.KEY_DOMAIN] as String,
            weihao: map[FakeWeiboApiUserResp.KEY_WEIHAO] as String,
            gender: map[FakeWeiboApiUserResp.KEY_GENDER] as String,
            verified: map[FakeWeiboApiUserResp.KEY_VERIFIED] as bool,
            avatarLarge: map[FakeWeiboApiUserResp.KEY_AVATAR_LARGE] as String,
            avatarHD: map[FakeWeiboApiUserResp.KEY_AVATAR_HD] as String,
          );
        } else {
          return FakeWeiboApiUserResp._(
            errorCode: errorCode,
            error: map[FakeWeiboApiBaseResp.KEY_ERROR] as String,
            request: map[FakeWeiboApiBaseResp.KEY_REQUEST] as String,
          );
        }
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

class FakeWeiboProvider extends InheritedWidget {
  FakeWeiboProvider({
    Key key,
    @required this.weibo,
    @required Widget child,
  }) : super(key: key, child: child);

  final FakeWeibo weibo;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    FakeWeiboProvider oldProvider = oldWidget as FakeWeiboProvider;
    return weibo != oldProvider.weibo;
  }

  static FakeWeiboProvider of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(FakeWeiboProvider)
        as FakeWeiboProvider;
  }
}
