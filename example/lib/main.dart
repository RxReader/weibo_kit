import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as image;
import 'package:okhttp_kit/okhttp_kit.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:weibo_kit/weibo_kit.dart';

void main() {
  runZoned(() {
    runApp(MyApp());
  }, onError: (dynamic error, dynamic stack) {
    print(error);
    print(stack);
  });

  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle =
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
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
  static const String _WEIBO_APP_KEY = 'your weibo app key';
  static const List<String> _WEIBO_SCOPE = <String>[
    WeiboScope.ALL,
  ];

  Weibo _weibo = Weibo()
    ..registerApp(
      appKey: _WEIBO_APP_KEY,
      scope: _WEIBO_SCOPE,
    );

  StreamSubscription<WeiboAuthResp> _auth;
  StreamSubscription<WeiboSdkResp> _share;

  WeiboAuthResp _authResp;

  @override
  void initState() {
    super.initState();
    _auth = _weibo.authResp().listen(_listenAuth);
    _share = _weibo.shareMsgResp().listen(_listenShareMsg);
  }

  void _listenAuth(WeiboAuthResp resp) {
    _authResp = resp;
    String content = 'auth: ${resp.errorCode}';
    _showTips('登录', content);
  }

  void _listenShareMsg(WeiboSdkResp resp) {
    String content = 'share: ${resp.errorCode}';
    _showTips('分享', content);
  }

  @override
  void dispose() {
    if (_auth != null) {
      _auth.cancel();
    }
    if (_share != null) {
      _share.cancel();
    }
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
              String content = 'weibo: ${await _weibo.isInstalled()}';
              _showTips('环境检查', content);
            },
          ),
          ListTile(
            title: const Text('登录'),
            onTap: () {
              _weibo.auth(
                appKey: _WEIBO_APP_KEY,
                scope: _WEIBO_SCOPE,
              );
            },
          ),
          ListTile(
            title: const Text('用户信息'),
            onTap: () async {
              if (_authResp != null &&
                  _authResp.errorCode == WeiboSdkResp.SUCCESS) {
                WeiboUserInfoResp userInfoResp = await _weibo.getUserInfo(
                  appkey: _WEIBO_APP_KEY,
                  userId: _authResp.userId,
                  accessToken: _authResp.accessToken,
                );
                if (userInfoResp != null &&
                    userInfoResp.errorCode == WeiboApiResp.ERROR_CODE_SUCCESS) {
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
              _weibo.shareText(
                text: 'Share Text',
              );
            },
          ),
          ListTile(
            title: const Text('图片分享'),
            onTap: () async {
              OkHttpClient client = OkHttpClientBuilder().build();
              Response resp = await client
                  .newCall(RequestBuilder()
                      .get()
                      .url(HttpUrl.parse(
                          'https://www.baidu.com/img/bd_logo1.png?where=super'))
                      .build())
                  .enqueue();
              if (resp.isSuccessful()) {
                Directory saveDir = Platform.isAndroid
                    ? await path_provider.getExternalStorageDirectory()
                    : await path_provider.getApplicationDocumentsDirectory();
                File saveFile = File(path.join(saveDir.path, 'timg.png'));
                if (!saveFile.existsSync()) {
                  saveFile.createSync(recursive: true);
                  saveFile.writeAsBytesSync(
                    await resp.body().bytes(),
                    flush: true,
                  );
                }
                await _weibo.shareImage(
                  text: 'Share Text',
                  imageUri: Uri.file(saveFile.path),
                );
              }
            },
          ),
          ListTile(
            title: const Text('网页分享'),
            onTap: () async {
              OkHttpClient client = OkHttpClientBuilder().build();
              Response resp = await client
                  .newCall(RequestBuilder()
                      .get()
                      .url(HttpUrl.parse(
                          'https://www.baidu.com/img/bd_logo1.png?where=super'))
                      .build())
                  .enqueue();
              if (resp.isSuccessful()) {
                Directory saveDir = Platform.isAndroid
                    ? await path_provider.getExternalStorageDirectory()
                    : await path_provider.getApplicationDocumentsDirectory();
                File saveFile = File(path.join(saveDir.path, 'timg.png'));
                if (!saveFile.existsSync()) {
                  saveFile.createSync(recursive: true);
                  saveFile.writeAsBytesSync(
                    await resp.body().bytes(),
                    flush: true,
                  );
                }
                image.Image thumbnail =
                    image.decodeGif(saveFile.readAsBytesSync());
                Uint8List thumbData = thumbnail.getBytes();
                if (thumbData.length > 32 * 1024) {
                  thumbData = Uint8List.fromList(image.encodeJpg(thumbnail,
                      quality: 100 * 32 * 1024 ~/ thumbData.length));
                }
                await _weibo.shareWebpage(
                  title: 'title',
                  description: 'share webpage',
                  thumbData: thumbData.buffer.asUint8List(),
                  webpageUrl: 'https://www.baidu.com',
                );
              }
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
