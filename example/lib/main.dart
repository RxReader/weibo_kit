import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fake_weibo/fake_weibo.dart';

const String _WEIBO_APP_KEY = '3393861383';

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
    FakeWeibo weibo = FakeWeibo(
      appKey: _WEIBO_APP_KEY,
      scope: [
        FakeWeiboScope.ALL,
      ],
    );
    weibo.registerApp();
    return FakeWeiboProvider(
      weibo: weibo,
      child: MaterialApp(
        home: Home(
          weibo: weibo,
        ),
      ),
    );
  }
}

class Home extends StatefulWidget {
  Home({Key key, @required this.weibo}) : super(key: key);

  final FakeWeibo weibo;

  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  StreamSubscription<FakeWeiboAuthResp> _auth;
  StreamSubscription<FakeWeiboShareMsgResp> _share;

  FakeWeiboAuthResp _authResp;

  @override
  void initState() {
    super.initState();
    _auth = widget.weibo.authResp().listen(_listenAuth);
    _share = widget.weibo.shareMsgResp().listen(_listenShareMsg);
  }

  void _listenAuth(FakeWeiboAuthResp resp) {
    _authResp = resp;
    String content = 'auth: ${resp.errorCode}';
    _showTips('登录', content);
  }

  void _listenShareMsg(FakeWeiboShareMsgResp resp) {
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
        title: Text('Fake Weibo Demo'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('环境检查'),
            onTap: () async {
              String content =
                  'weibo: ${await widget.weibo.isWeiboInstalled()}';
              _showTips('环境检查', content);
            },
          ),
          ListTile(
            title: Text('登录'),
            onTap: () {
              widget.weibo.auth();
            },
          ),
          ListTile(
            title: Text('用户信息'),
            onTap: () async {
              if (_authResp != null &&
                  _authResp.errorCode == FakeWeiboErrorCode.SUCCESS) {
                FakeWeiboApiUserResp userResp = await widget.weibo.getUserInfo(
                    appkey: _WEIBO_APP_KEY,
                    userId: _authResp.userId,
                    accessToken: _authResp.accessToken);
                if (userResp != null &&
                    userResp.errorCode ==
                        FakeWeiboApiBaseResp.ERROR_CODE_SUCCESS) {
                  _showTips('用户信息',
                      '${userResp.screenName}\n${userResp.description}\n${userResp.location}\n${userResp.profileImageUrl}');
                } else {
                  _showTips('用户信息',
                      '获取用户信息失败\n${userResp.errorCode}:${userResp.error}');
                }
              }
            },
          ),
          ListTile(
            title: Text('文字分享'),
            onTap: () {
              widget.weibo.shareText(
                text: 'Share Text',
              );
            },
          ),
          ListTile(
            title: Text('图片分享'),
            onTap: () async {
              AssetImage image = AssetImage('images/icon/timg.jpeg');
              AssetBundleImageKey key =
                  await image.obtainKey(createLocalImageConfiguration(context));
              ByteData imageData = await key.bundle.load(key.name);
              await widget.weibo.shareImage(
                imageData: imageData.buffer.asUint8List(),
              );
            },
          ),
          ListTile(
            title: Text('网页分享'),
            onTap: () async {
              AssetImage image = AssetImage('images/icon/ic_launcher.png');
              AssetBundleImageKey key =
                  await image.obtainKey(createLocalImageConfiguration(context));
              ByteData thumbData = await key.bundle.load(key.name);
              await widget.weibo.shareWebpage(
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
    showDialog(
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
