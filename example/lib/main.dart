import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image/image.dart' as imglib;
// import 'package:path/path.dart' as path;
// import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:weibo_kit/weibo_kit.dart';
import 'package:weibo_kit_example/api/model/weibo_api_resp.dart';
import 'package:weibo_kit_example/api/weibo_api.dart';

const String _WEIBO_APP_KEY = 'your weibo app key';
const String _WEIBO_UNIVERSAL_LINK = 'your weibo universal link';
const List<String> _WEIBO_SCOPE = <String>[
  WeiboScope.ALL,
];

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({
    super.key,
  });

  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  late final StreamSubscription<BaseResp> _respSubs;

  AuthResp? _authResp;

  @override
  void initState() {
    super.initState();
    _respSubs = Weibo.instance.respStream().listen(_listenResp);
  }

  void _listenResp(BaseResp resp) {
    if (resp is AuthResp) {
      _authResp = resp;
      final String content = 'auth: ${resp.errorCode}';
      _showTips('登录', content);
    } else if (resp is ShareMsgResp) {
      final String content = 'share: ${resp.errorCode}';
      _showTips('分享', content);
    }
  }

  @override
  void dispose() {
    _respSubs.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weibo Kit Demo'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('注册APP'),
            onTap: () async {
              await Weibo.instance.registerApp(
                appKey: _WEIBO_APP_KEY,
                universalLink: _WEIBO_UNIVERSAL_LINK,
                scope: _WEIBO_SCOPE,
              );
              _showTips('注册APP', '注册成功');
            },
          ),
          ListTile(
            title: Text('环境检查'),
            onTap: () async {
              final String content =
                  'weibo: ${await Weibo.instance.isInstalled()}';
              _showTips('环境检查', content);
            },
          ),
          ListTile(
            title: Text('登录'),
            onTap: () {
              Weibo.instance.auth(
                appKey: _WEIBO_APP_KEY,
                scope: _WEIBO_SCOPE,
              );
            },
          ),
          ListTile(
            title: Text('用户信息'),
            onTap: () async {
              if (_authResp?.isSuccessful ?? false) {
                final WeiboUserInfoResp userInfoResp =
                    await WeiboApi.getUserInfo(
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
            title: Text('文字分享'),
            onTap: () {
              Weibo.instance.shareText(
                text: 'Share Text',
              );
            },
          ),
          ListTile(
            title: Text('图片分享'),
            onTap: () async {
              final File file = await DefaultCacheManager().getSingleFile(
                  'https://www.baidu.com/img/bd_logo1.png?where=super');
              // if (Platform.isAndroid) {
              //   // 仅支持 Context.getExternalFilesDir(null)/Context.getExternalCacheDirs(null) 路径分享
              //   // path_provider.getExternalCacheDirectories();
              //   // path_provider.getExternalStorageDirectory();
              //   final Directory temporaryDir =
              //       await path_provider.getTemporaryDirectory();
              //   if (path.isWithin(temporaryDir.parent.path, file.path)) {
              //     // 复制
              //     final File copyFile = File(path.join(
              //         (await path_provider.getExternalStorageDirectory())!.path,
              //         path.basename(file.path)));
              //     if (copyFile.existsSync()) {
              //       await copyFile.delete();
              //     }
              //     await copyFile.writeAsBytes(await file.readAsBytes());
              //     file = copyFile;
              //   }
              // }
              await Weibo.instance.shareMultiImage(
                text: 'Share Text',
                imageUris: <Uri>[Uri.file(file.path)],
              );
            },
          ),
          ListTile(
            title: Text('网页分享'),
            onTap: () async {
              final File file = await DefaultCacheManager().getSingleFile(
                  'https://www.baidu.com/img/bd_logo1.png?where=super');
              final imglib.Image thumbnail =
                  imglib.decodeImage(file.readAsBytesSync())!;
              Uint8List thumbData = thumbnail.getBytes();
              if (thumbData.length > 32 * 1024) {
                thumbData = Uint8List.fromList(imglib.encodeJpg(thumbnail,
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
