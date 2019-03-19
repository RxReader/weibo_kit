library fake_weibo;

export 'src/domain/api/weibo_api_resp.dart';
export 'src/domain/api/weibo_user_info_resp.dart'
    hide WeiboUserInfoRespSerializer;
export 'src/domain/sdk/weibo_auth_resp.dart' hide WeiboAuthRespSerializer;
export 'src/domain/sdk/weibo_sdk_resp.dart' hide WeiboSdkRespSerializer;
export 'src/weibo.dart';
export 'src/weibo_provider.dart';
export 'src/weibo_scope.dart';
