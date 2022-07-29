# weibo_kit

[![Pub Package](https://img.shields.io/pub/v/weibo_kit.svg)](https://pub.dev/packages/weibo_kit)
[![License](https://img.shields.io/github/license/RxReader/weibo_kit)](https://github.com/RxReader/weibo_kit/blob/master/LICENSE)

flutter版新浪微博SDK

## 相关工具

* [Flutter版微信SDK](https://github.com/RxReader/wechat_kit)
* [Flutter版腾讯(QQ)SDK](https://github.com/RxReader/tencent_kit)
* [Flutter版新浪微博SDK](https://github.com/RxReader/weibo_kit)
* [Flutter版支付宝SDK](https://github.com/RxReader/alipay_kit)
* [Flutter版深度链接](https://github.com/RxReader/link_kit)
* [Flutter版walle渠道打包工具](https://github.com/RxReader/walle_kit)

## dart/flutter 私服

* [simple_pub_server](https://github.com/rxreader/simple_pub_server)

## docs

* [Android 应用接入](https://open.weibo.com/wiki/Sdk/android)
* [iOS 应用接入](https://open.weibo.com/wiki/Sdk/ios)
* [Android Github](https://github.com/sinaweibosdk/weibo_android_sdk)
* [iOS Github](https://github.com/sinaweibosdk/weibo_ios_sdk)
* [Universal Links](https://developer.apple.com/documentation/uikit/inter-process_communication/allowing_apps_and_websites_to_link_to_your_content)

## android

```
# 不需要做任何额外接入工作
# 混淆已打入 Library，随 Library 引用，自动添加到 apk 打包混淆
```

* [获取 Android 签名信息](https://github.com/RxReader/wechat_kit#android)

## ios

```
iOS 9.0
```

```
在Xcode中，选择你的工程设置项，选中“TARGETS”一栏，在“info”标签栏的“URL type“添加“URL scheme”为你所注册的应用程序id

URL Types
weibosdk: identifier=weibo schemes=wb${appKey}
```

```
iOS 9系统策略更新，限制了http协议的访问，此外应用需要在“Info.plist”中将要使用的URL Schemes列为白名单，才可正常检查其他应用是否安装。
<key>LSApplicationQueriesSchemes</key>
<array>
    <string>sinaweibo</string>
    <string>sinaweibohd</string>
    <string>weibosdk</string>
    <string>weibosdk2.5</string>
    <string>weibosdk3.3</string>
</array>
```

```
由于iOS9/10的发布，原有ATS设置在iOS10上会出现https网络访问限制的问题，为了确保好的应用体验，我们需要采取如下措施：
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
    <key>NSExceptionDomains</key>
    <dict>
        <key>sina.cn</key>
        <dict>
            <key>NSExceptionMinimumTLSVersion</key>
            <string>TLSv1.0</string>
            <key>NSIncludesSubdomains</key>
            <true/>
            <key>NSThirdPartyExceptionAllowsInsecureHTTPLoads</key>
            <true/>
            <key>NSThirdPartyExceptionRequiresForwardSecrecy</key>
            <false/>
        </dict>
        <key>sina.com.cn</key>
        <dict>
            <key>NSExceptionMinimumTLSVersion</key>
            <string>TLSv1.0</string>
            <key>NSIncludesSubdomains</key>
            <true/>
            <key>NSThirdPartyExceptionAllowsInsecureHTTPLoads</key>
            <true/>
            <key>NSThirdPartyExceptionRequiresForwardSecrecy</key>
            <false/>
        </dict>
        <key>sinaimg.cn</key>
        <dict>
            <key>NSExceptionMinimumTLSVersion</key>
            <string>TLSv1.0</string>
            <key>NSIncludesSubdomains</key>
            <true/>
            <key>NSThirdPartyExceptionAllowsInsecureHTTPLoads</key>
            <true/>
            <key>NSThirdPartyExceptionRequiresForwardSecrecy</key>
            <false/>
        </dict>
        <key>sinajs.cn</key>
        <dict>
            <key>NSExceptionMinimumTLSVersion</key>
            <string>TLSv1.0</string>
            <key>NSIncludesSubdomains</key>
            <true/>
            <key>NSThirdPartyExceptionAllowsInsecureHTTPLoads</key>
            <true/>
            <key>NSThirdPartyExceptionRequiresForwardSecrecy</key>
            <false/>
        </dict>
        <key>weibo.cn</key>
        <dict>
            <key>NSExceptionMinimumTLSVersion</key>
            <string>TLSv1.0</string>
            <key>NSIncludesSubdomains</key>
            <true/>
            <key>NSThirdPartyExceptionAllowsInsecureHTTPLoads</key>
            <true/>
            <key>NSThirdPartyExceptionRequiresForwardSecrecy</key>
            <false/>
        </dict>
        <key>weibo.com</key>
        <dict>
            <key>NSExceptionMinimumTLSVersion</key>
            <string>TLSv1.0</string>
            <key>NSIncludesSubdomains</key>
            <true/>
            <key>NSThirdPartyExceptionAllowsInsecureHTTPLoads</key>
            <true/>
            <key>NSThirdPartyExceptionRequiresForwardSecrecy</key>
            <false/>
        </dict>
    </dict>
</dict>
```

## flutter

* break change
    * 4.0.1: expiresIn -> expiresTime
    * 4.0.0: 按标准插件书写重构
    * 3.0.0: 重构
    * 2.0.2: iOS Universal Links
    * 2.0.0: nullsafety & 不再支持 Android embedding v1 & Weibo 单例

* snapshot

```
dependencies:
  weibo_kit:
    git:
      url: https://github.com/rxreader/weibo_kit.git
```

* release

```
dependencies:
  weibo_kit: ^${latestTag}
```

* example

[示例](./example/lib/main.dart)

## Star History

![stars](https://starchart.cc/rxreader/weibo_kit.svg)
