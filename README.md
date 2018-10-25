# fake_weibo

A new Flutter plugin.

# android

````
# 微博混淆
-keep class com.sina.deviceidjnisdk.** { *; }
-keep class com.sina.weibo.sdk.** { *; }
````

# ios

````
Capabilities
Background Modes: Background fetch & Remote notifications
````

````
在Xcode中，选择你的工程设置项，选中“TARGETS”一栏，在“info”标签栏的“URL type“添加“URL scheme”为你所注册的应用程序id

URL Types
weibosdk: identifier=com.weibo schemes=wb${appKey}
````

````
iOS 9系统策略更新，限制了http协议的访问，此外应用需要在“Info.plist”中将要使用的URL Schemes列为白名单，才可正常检查其他应用是否安装。
<key>LSApplicationQueriesSchemes</key>
<array>
    <string>sinaweibo</string>
    <string>sinaweibohd</string>
    <string>weibosdk</string>
    <string>weibosdk2.5</string>
</array>
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
    <key>NSExceptionDomains</key>
    <dict>
        <key>sina.com.cn</key>
        <dict>
            <key>NSIncludesSubdomains</key>
            <true/>
            <key>NSThirdPartyExceptionAllowsInsecureHTTPLoads</key>
            <true/>
            <key>NSExceptionMinimumTLSVersion</key>
            <string>TLSv1.0</string>
            <key>NSThirdPartyExceptionRequiresForwardSecrecy</key>
            <false/>
        </dict>
    </dict>
</dict>
````

# flutter

````
# pubspec.yml

dependencies:
  fake_weibo:
    git:
      url: http://git.xrjiot.cn/flutter/packages/fake_weibo.git
````

[示例](./example/lib/main.dart)

## Getting Started

For help getting started with Flutter, view our online
[documentation](https://flutter.io/).

For help on editing plugin code, view the [documentation](https://flutter.io/developing-packages/#edit-plugin-package).
