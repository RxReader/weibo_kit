import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image/image.dart' as image;
import 'package:weibo_kit/weibo_kit.dart';

const String _WEIBO_APP_KEY = 'your weibo app key';
const String _WEIBO_UNIVERSAL_LINK = 'your weibo universal link';
const List<String> _WEIBO_SCOPE = <String>[
  WeiboScope.ALL,
];

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Weibo.instance.registerApp(
    appKey: _WEIBO_APP_KEY,
    universalLink: _WEIBO_UNIVERSAL_LINK,
    scope: _WEIBO_SCOPE,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  late final StreamSubscription<WeiboAuthResp> _auth =
      Weibo.instance.authResp().listen(_listenAuth);
  late final StreamSubscription<WeiboSdkResp> _share =
      Weibo.instance.shareMsgResp().listen(_listenShareMsg);

  WeiboAuthResp? _authResp;

  @override
  void initState() {
    super.initState();
  }

  void _listenAuth(WeiboAuthResp resp) {
    _authResp = resp;
    final String content = 'auth: ${resp.errorCode}';
    _showTips('登录', content);
  }

  void _listenShareMsg(WeiboSdkResp resp) {
    final String content = 'share: ${resp.errorCode}';
    _showTips('分享', content);
  }

  @override
  void dispose() {
    _auth.cancel();
    _share.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weibo Kit Demo'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: const Text('环境检查'),
            onTap: () async {
              final String content =
                  'weibo: ${await Weibo.instance.isInstalled()}';
              _showTips('环境检查', content);
            },
          ),
          ListTile(
            title: const Text('登录'),
            onTap: () {
              Weibo.instance.auth(
                appKey: _WEIBO_APP_KEY,
                scope: _WEIBO_SCOPE,
              );
            },
          ),
          ListTile(
            title: const Text('用户信息'),
            onTap: () async {
              if (_authResp?.isSuccessful ?? false) {
                final WeiboUserInfoResp userInfoResp =
                    await Weibo.instance.getUserInfo(
                  appkey: _WEIBO_APP_KEY,
                  userId: _authResp!.userId!,
                  accessToken: _authResp!.accessToken!,
                );
                if (userInfoResp.isSuccessful) {
                  _showTips('用户信息',
                      '${userInfoResp.screenName}\n${userInfoResp.description}\n${userInfoResp.location}\n${userInfoResp.profileImageUrl}');
                } else {
                  _showTips('用户信息',
                      '获取用户信息失败\n${userInfoResp.errorCode}:${userInfoResp.error}');
                }
              }
            },
          ),
          ListTile(
            title: const Text('文字分享'),
            onTap: () {
              Weibo.instance.shareText(
                text: 'Share Text',
              );
            },
          ),
          ListTile(
            title: const Text('图片分享'),
            onTap: () async {
              final File file = await DefaultCacheManager().getSingleFile(
                  'https://www.baidu.com/img/bd_logo1.png?where=super');
              await Weibo.instance.shareImage(
                text: 'Share Text',
                imageUri: Uri.file(file.path),
              );
            },
          ),
          ListTile(
            title: const Text('网页分享'),
            onTap: () async {
              final File file = await DefaultCacheManager().getSingleFile(
                  'https://www.baidu.com/img/bd_logo1.png?where=super');
              final image.Image thumbnail =
                  image.decodeImage(file.readAsBytesSync())!;
              Uint8List thumbData = thumbnail.getBytes();
              if (thumbData.length > 32 * 1024) {
                thumbData = Uint8List.fromList(image.encodeJpg(thumbnail,
                    quality: 100 * 32 * 1024 ~/ thumbData.length));
              }
              await Weibo.instance.shareWebpage(
                title: 'title',
                description: 'share webpage',
                thumbData: thumbData.buffer.asUint8List(),
                webpageUrl: 'https://www.baidu.com',
              );
            },
          ),
        ],
      ),
    );
  }

  void _showTips(String title, String content) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
        );
      },
    );
  }
}
