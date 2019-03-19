import 'package:jaguar_serializer/jaguar_serializer.dart';
import 'package:fake_weibo/src/domain/sdk/weibo_sdk_resp.dart';

part 'weibo_auth_resp.jser.dart';

@GenSerializer()
class WeiboAuthRespSerializer extends Serializer<WeiboAuthResp>
    with _$WeiboAuthRespSerializer {}

class WeiboAuthResp extends WeiboSdkResp {
  WeiboAuthResp({
    int errorCode,
    String errorMessage,
    this.userId,
    this.accessToken,
    this.refreshToken,
    this.expiresIn,
  }) : super(errorCode: errorCode, errorMessage: errorMessage);

  final String userId;
  final String accessToken;
  final String refreshToken;
  final int expiresIn;
}
