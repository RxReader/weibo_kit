import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pedantic/pedantic.dart';
import 'package:weibo_kit/weibo_kit.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel channel = MethodChannel('v7lin.github.io/weibo_kit');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall call) async {
      switch (call.method) {
        case 'registerApp':
          return null;
        case 'isInstalled':
          return true;
        case 'auth':
          unawaited(channel.binaryMessenger.handlePlatformMessage(
            channel.name,
            channel.codec.encodeMethodCall(
                MethodCall('onAuthResp', json.decode('{"errorCode":-1}'))),
            (ByteData? data) {
              // mock success
            },
          ));
          return null;
        case 'shareText':
        case 'shareImage':
        case 'shareWebpage':
          unawaited(channel.binaryMessenger.handlePlatformMessage(
            channel.name,
            channel.codec.encodeMethodCall(
                MethodCall('onShareMsgResp', json.decode('{"errorCode":-1}'))),
            (ByteData? data) {
              // mock success
            },
          ));
          return null;
      }
      throw PlatformException(code: '0', message: '想啥呢，升级插件不想升级Mock？');
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('isInstalled', () async {
    expect(await Weibo.instance.isInstalled(), true);
  });

  test('auth', () async {
    final StreamSubscription<WeiboAuthResp> sub =
        Weibo.instance.authResp().listen((WeiboAuthResp resp) {
      expect(resp.errorCode, WeiboSdkResp.USERCANCEL);
    });
    await Weibo.instance.auth(
      appKey: 'your weibo app key',
      scope: <String>[WeiboScope.ALL],
    );
    await sub.cancel();
  });

  test('share', () async {
    final StreamSubscription<WeiboSdkResp> sub =
        Weibo.instance.shareMsgResp().listen((WeiboSdkResp resp) {
      expect(resp.errorCode, WeiboSdkResp.USERCANCEL);
    });
    await Weibo.instance.shareText(
      text: 'share text',
    );
    await sub.cancel();
  });
}
