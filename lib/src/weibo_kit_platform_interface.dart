import 'dart:typed_data';

import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:weibo_kit/src/model/resp.dart';
import 'package:weibo_kit/src/weibo_constant.dart';
import 'package:weibo_kit/src/weibo_kit_method_channel.dart';

abstract class WeiboKitPlatform extends PlatformInterface {
  /// Constructs a WeiboKitPlatform.
  WeiboKitPlatform() : super(token: _token);

  static final Object _token = Object();

  static WeiboKitPlatform _instance = MethodChannelWeiboKit();

  /// The default instance of [WeiboKitPlatform] to use.
  ///
  /// Defaults to [MethodChannelWeiboKit].
  static WeiboKitPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [WeiboKitPlatform] when
  /// they register themselves.
  static set instance(WeiboKitPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  ///
  Future<void> registerApp({
    required String appKey,
    required String? universalLink,
    required List<String> scope,
    String redirectUrl = WeiboRegister
        .DEFAULT_REDIRECTURL, // 新浪微博开放平台 -> 我的应用 -> 应用信息 -> 高级信息 -> OAuth2.0授权设置
  }) {
    throw UnimplementedError(
        'registerApp({required appKey, required universalLink, required scope, redirectUrl}) has not been implemented.');
  }

  ///
  Stream<BaseResp> respStream() {
    throw UnimplementedError('respStream() has not been implemented.');
  }

  ///
  Future<bool> isInstalled() {
    throw UnimplementedError('isInstalled() has not been implemented.');
  }

  /// 登录
  Future<void> auth({
    required String appKey,
    required List<String> scope,
    String redirectUrl = WeiboRegister.DEFAULT_REDIRECTURL,
  }) {
    throw UnimplementedError(
        'auth({required appKey, required scope, redirectUrl}) has not been implemented.');
  }

  /// 分享 - 文本
  Future<void> shareText({
    required String text,
  }) {
    throw UnimplementedError(
        'shareText({required text}) has not been implemented.');
  }

  /// 分享 - 图片
  Future<void> shareImage({
    String? text,
    Uint8List? imageData,
    Uri? imageUri,
  }) {
    throw UnimplementedError(
        'shareImage({text, imageData, imageUri}) has not been implemented.');
  }

  /// 分享 - 网页
  @Deprecated('iOS：分享多媒体已经弃用 请不要用相关api')
  Future<void> shareWebpage({
    required String title,
    required String description,
    required Uint8List thumbData,
    required String webpageUrl,
  }) {
    throw UnimplementedError(
        'shareWebpage({required title, required description, required thumbData, required webpageUrl}) has not been implemented.');
  }
}
