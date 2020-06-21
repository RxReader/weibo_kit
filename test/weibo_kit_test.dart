import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pedantic/pedantic.dart';
import 'package:weibo_kit/weibo_kit.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel channel = MethodChannel('v7lin.github.io/weibo_kit');
  final Weibo weibo = Weibo();

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
            channel.codec.encodeMethodCall(MethodCall('onAuthResp', json.decode('{"errorCode":-1}'))),
            (ByteData data) {
              // mock success
            },
          ));
          return null;
        case 'shareText':
        case 'shareImage':
        case 'shareWebpage':
          unawaited(channel.binaryMessenger.handlePlatformMessage(
            channel.name,
            channel.codec.encodeMethodCall(MethodCall('onShareMsgResp', json.decode('{"errorCode":-1}'))),
            (ByteData data) {
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
    expect(await weibo.isInstalled(), true);
  });

  test('auth', () async {
    StreamSubscription<WeiboAuthResp> sub = weibo.authResp().listen((WeiboAuthResp resp) {
      expect(resp.errorCode, WeiboSdkResp.USERCANCEL);
    });
    await weibo.auth(
      appKey: 'your weibo app key',
      scope: <String>[WeiboScope.ALL],
    );
    await sub.cancel();
  });

  test('share', () async {
    StreamSubscription<WeiboSdkResp> sub = weibo.shareMsgResp().listen((WeiboSdkResp resp) {
      expect(resp.errorCode, WeiboSdkResp.USERCANCEL);
    });
    await weibo.shareText(
      text: 'share text',
    );
    await sub.cancel();
  });
}
