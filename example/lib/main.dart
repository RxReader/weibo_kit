import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fake_weibo/fake_weibo.dart';

void main() {
  runZoned(() {
    runApp(new MyApp());
  }, onError: (dynamic error, dynamic stack) {
    print(error);
    print(stack);
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FakeWeibo weibo = new FakeWeibo(
      appKey: '3393861383',
      scope: [
        FakeWeiboScope.ALL,
      ],
    );
    weibo.registerApp();
    return new FakeWeiboProvider(
      weibo: weibo,
      child: new MaterialApp(
        home: new Home(
          weibo: weibo,
        ),
      ),
    );
  }
}

class Home extends StatefulWidget {
  final FakeWeibo weibo;

  Home({Key key, @required this.weibo}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _HomeState();
  }
}

class _HomeState extends State<Home> {
  StreamSubscription<FakeWeiboAuthResp> _auth;
  StreamSubscription<FakeWeiboShareMsgResp> _share;

  @override
  void initState() {
    super.initState();
    _auth = widget.weibo.authResp().listen(_listenAuth);
    _share = widget.weibo.shareMsgResp().listen(_listenShareMsg);
  }

  void _listenAuth(FakeWeiboAuthResp resp) {
    String content = 'auth: ${resp.statusCode}';
    _showTips('登录', content);
  }

  void _listenShareMsg(FakeWeiboShareMsgResp resp) {
    String content = 'share: ${resp.statusCode}';
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
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Fake Weibo Demo'),
      ),
      body: new ListView(
        children: <Widget>[
          new ListTile(
            title: new Text('环境检查'),
            onTap: () async {
              String content =
                  'weibo: ${await widget.weibo.isWeiboInstalled()}';
              _showTips('环境检查', content);
            },
          ),
          new ListTile(
            title: new Text('登录'),
            onTap: () {
              widget.weibo.auth();
            },
          ),
          new ListTile(
            title: new Text('文字分享'),
            onTap: () {
              widget.weibo.shareText(
                text: 'Share Text',
              );
            },
          ),
          new ListTile(
            title: new Text('图片分享'),
            onTap: () async {
              AssetImage image = new AssetImage('images/icon/timg.jpeg');
              AssetBundleImageKey key =
                  await image.obtainKey(createLocalImageConfiguration(context));
              ByteData imageData = await key.bundle.load(key.name);
              widget.weibo.shareImage(
                imageData: imageData.buffer.asUint8List(),
              );
            },
          ),
          new ListTile(
            title: new Text('网页分享'),
            onTap: () async {
              AssetImage image = new AssetImage('images/icon/ic_launcher.png');
              AssetBundleImageKey key =
                  await image.obtainKey(createLocalImageConfiguration(context));
              ByteData thumbData = await key.bundle.load(key.name);
              widget.weibo.shareWebpage(
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
        return new AlertDialog(
          title: new Text(title),
          content: new Text(content),
        );
      },
    );
  }
}
