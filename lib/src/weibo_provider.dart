import 'package:fake_weibo/src/weibo.dart';
import 'package:flutter/widgets.dart';

class WeiboProvider extends InheritedWidget {
  WeiboProvider({
    Key key,
    @required this.weibo,
    @required Widget child,
  }) : super(key: key, child: child);

  final Weibo weibo;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    WeiboProvider oldProvider = oldWidget as WeiboProvider;
    return weibo != oldProvider.weibo;
  }

  static WeiboProvider of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(WeiboProvider) as WeiboProvider;
  }
}
