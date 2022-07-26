import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:weibo_kit/src/model/resp.dart';
import 'package:weibo_kit/src/weibo.dart';
import 'package:weibo_kit/src/weibo_constant.dart';
import 'package:weibo_kit/src/weibo_kit_method_channel.dart';
import 'package:weibo_kit/src/weibo_kit_platform_interface.dart';

class MockWeiboKitPlatform
    with MockPlatformInterfaceMixin
    implements WeiboKitPlatform {
  @override
  Future<void> registerApp({
    required String appKey,
    required String? universalLink,
    required List<String> scope,
    String redirectUrl = WeiboRegister.DEFAULT_REDIRECTURL,
  }) {
    throw UnimplementedError();
  }

  @override
  Stream<BaseResp> respStream() {
    throw UnimplementedError();
  }

  @override
  Future<bool> isInstalled() {
    throw UnimplementedError();
  }

  @override
  Future<bool> isSupportMultipleImage() {
    throw UnimplementedError();
  }

  @override
  Future<void> auth({
    required String appKey,
    required List<String> scope,
    String redirectUrl = WeiboRegister.DEFAULT_REDIRECTURL,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<void> shareText({
    required String text,
    bool clientOnly = false,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<void> shareImage({
    String? text,
    Uint8List? imageData,
    Uri? imageUri,
    bool clientOnly = false,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<void> shareMultiImage({
    String? text,
    required List<Uri> imageUris,
    bool clientOnly = false,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<void> shareVideo({
    String? text,
    required Uri videoUri,
    bool clientOnly = false,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<void> shareWebpage({
    required String title,
    required String description,
    required Uint8List thumbData,
    required String webpageUrl,
    bool clientOnly = false,
  }) {
    throw UnimplementedError();
  }
}

void main() {
  final WeiboKitPlatform initialPlatform = WeiboKitPlatform.instance;

  test('$MethodChannelWeiboKit is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelWeiboKit>());
  });

  test('isInstalled', () async {
    final MockWeiboKitPlatform fakePlatform = MockWeiboKitPlatform();
    WeiboKitPlatform.instance = fakePlatform;

    expect(await Weibo.instance.isInstalled(), true);
  });
}
