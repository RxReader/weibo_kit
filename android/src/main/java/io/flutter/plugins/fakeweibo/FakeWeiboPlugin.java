package io.flutter.plugins.fakeweibo;

import android.content.Intent;

import com.sina.weibo.sdk.WbSdk;
import com.sina.weibo.sdk.api.ImageObject;
import com.sina.weibo.sdk.api.TextObject;
import com.sina.weibo.sdk.api.WebpageObject;
import com.sina.weibo.sdk.api.WeiboMultiMessage;
import com.sina.weibo.sdk.auth.AuthInfo;
import com.sina.weibo.sdk.auth.Oauth2AccessToken;
import com.sina.weibo.sdk.auth.WbAuthListener;
import com.sina.weibo.sdk.auth.WbConnectErrorMessage;
import com.sina.weibo.sdk.auth.sso.SsoHandler;
import com.sina.weibo.sdk.share.WbShareCallback;
import com.sina.weibo.sdk.share.WbShareHandler;
import com.sina.weibo.sdk.utils.Utility;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** FakeWeiboPlugin */
public class FakeWeiboPlugin implements MethodCallHandler, PluginRegistry.ActivityResultListener {
  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "plugins.flutter.io/fake_weibo");
    FakeWeiboPlugin plugin = new FakeWeiboPlugin(registrar, channel);
    registrar.addActivityResultListener(plugin);
    channel.setMethodCallHandler(plugin);
  }

  private static class FakeWeiboStatusCode {
    public static final int SUCCESS               = 0;//成功
    public static final int USERCANCEL            = -1;//用户取消发送
    public static final int SENT_FAIL             = -2;//发送失败
    public static final int AUTH_DENY             = -3;//授权失败
    public static final int USERCANCEL_INSTALL    = -4;//用户取消安装微博客户端
    public static final int PAY_FAIL              = -5;//支付失败
    public static final int SHARE_IN_SDK_FAILED   = -8;//分享失败 详情见response UserInfo
    public static final int UNSUPPORT             = -99;//不支持的请求
    public static final int UNKNOWN               = -100;
  }

  private static final String METHOD_REGISTERAPP = "registerApp";
  private static final String METHOD_ISWEIBOINSTALLED = "isWeiboInstalled";
  private static final String METHOD_AUTH = "auth";
  private static final String METHOD_SHARETEXT = "shareText";
  private static final String METHOD_SHAREIMAGE = "shareImage";
  private static final String METHOD_SHAREWEBPAGE = "shareWebpage";

  private static final String METHOD_ONAUTHRESP = "onAuthResp";
  private static final String METHOD_ONSHAREMSGRESP = "onShareMsgResp";

  private static final String ARGUMENT_KEY_APPKEY = "appKey";
  private static final String ARGUMENT_KEY_SCOPE = "scope";
  private static final String ARGUMENT_KEY_REDIRECTURL = "redirectUrl";
  private static final String ARGUMENT_KEY_TEXT = "text";
  private static final String ARGUMENT_KEY_TITLE = "title";
  private static final String ARGUMENT_KEY_DESCRIPTION = "description";
  private static final String ARGUMENT_KEY_THUMBDATA = "thumbData";
  private static final String ARGUMENT_KEY_IMAGEDATA = "imageData";
  private static final String ARGUMENT_KEY_WEBPAGEURL = "webpageUrl";

  private static final String ARGUMENT_KEY_RESULT_STATUSCODE = "statusCode";
  private static final String ARGUMENT_KEY_RESULT_USERID = "userId";
  private static final String ARGUMENT_KEY_RESULT_ACCESSTOKEN = "accessToken";
  private static final String ARGUMENT_KEY_RESULT_REFRESHTOKEN = "refreshToken";
  private static final String ARGUMENT_KEY_RESULT_EXPIRATIONDATE = "expirationDate";

  private final Registrar registrar;
  private final MethodChannel channel;

  private SsoHandler ssoHandler;
  private WbShareHandler shareHandler;

  FakeWeiboPlugin(Registrar registrar, MethodChannel channel) {
    this.registrar = registrar;
    this.channel = channel;
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    if (METHOD_REGISTERAPP.equals(call.method)) {
      String appKey = call.argument(ARGUMENT_KEY_APPKEY);
      String scope = call.argument(ARGUMENT_KEY_SCOPE);
      String redirectUrl = call.argument(ARGUMENT_KEY_REDIRECTURL);

      WbSdk.install(registrar.context(), new AuthInfo(registrar.context(), appKey, redirectUrl, scope));
      ssoHandler = new SsoHandler(registrar.activity());
      shareHandler = new WbShareHandler(registrar.activity());
      shareHandler.registerApp();
      result.success(null);
    } else if (METHOD_ISWEIBOINSTALLED.equals(call.method)) {
      result.success(WbSdk.isWbInstall(registrar.context()));
    } else if (METHOD_AUTH.equals(call.method)) {
      handleAuthCall(call, result);
    } else if (METHOD_SHARETEXT.equals(call.method)) {
      handleShareTextCall(call, result);
    } else if (METHOD_SHAREIMAGE.equals(call.method) ||
            METHOD_SHAREWEBPAGE.equals(call.method)) {
      handleShareMediaCall(call, result);
    } else {
      result.notImplemented();
    }
  }

  private void handleAuthCall(MethodCall call, Result result) {
    if (ssoHandler != null) {
      ssoHandler.authorize(new WbAuthListener() {
        @Override
        public void onSuccess(Oauth2AccessToken oauth2AccessToken) {
          Map<String, Object> map = new HashMap<>();
          if (oauth2AccessToken.isSessionValid()) {
            map.put(ARGUMENT_KEY_RESULT_STATUSCODE, FakeWeiboStatusCode.SUCCESS);
            map.put(ARGUMENT_KEY_RESULT_USERID, oauth2AccessToken.getUid());
            map.put(ARGUMENT_KEY_RESULT_ACCESSTOKEN, oauth2AccessToken.getToken());
            map.put(ARGUMENT_KEY_RESULT_REFRESHTOKEN, oauth2AccessToken.getRefreshToken());
            map.put(ARGUMENT_KEY_RESULT_EXPIRATIONDATE, oauth2AccessToken.getExpiresTime());
          } else {
            // 以下几种情况，您会收到 Code：
            // 1. 当您未在平台上注册的应用程序的包名与签名时；
            // 2. 当您注册的应用程序包名与签名不正确时；
            // 3. 当您在平台上注册的包名和签名与您当前测试的应用的包名和签名不匹配时。
            map.put(ARGUMENT_KEY_RESULT_STATUSCODE, FakeWeiboStatusCode.AUTH_DENY);
          }
          channel.invokeMethod(METHOD_ONAUTHRESP, map);
        }

        @Override
        public void cancel() {
          Map<String, Object> map = new HashMap<>();
          map.put(ARGUMENT_KEY_RESULT_STATUSCODE, FakeWeiboStatusCode.USERCANCEL);
          channel.invokeMethod(METHOD_ONAUTHRESP, map);
        }

        @Override
        public void onFailure(WbConnectErrorMessage wbConnectErrorMessage) {
          Map<String, Object> map = new HashMap<>();
          map.put(ARGUMENT_KEY_RESULT_STATUSCODE, FakeWeiboStatusCode.AUTH_DENY);// FIXME 待验证
          channel.invokeMethod(METHOD_ONAUTHRESP, map);
        }
      });
    }
    result.success(null);
  }

  private void handleShareTextCall(MethodCall call, Result result) {
    if (shareHandler != null) {
      WeiboMultiMessage message = new WeiboMultiMessage();

      TextObject object = new TextObject();
      object.text = call.argument(ARGUMENT_KEY_TEXT);// 1024

      message.textObject = object;

      shareHandler.shareMessage(message, false);
    }
    result.success(null);
  }

  private void handleShareMediaCall(MethodCall call, Result result) {
    if (shareHandler != null) {
      WeiboMultiMessage message = new WeiboMultiMessage();

      if (METHOD_SHAREIMAGE.equals(call.method)) {
        ImageObject object = new ImageObject();
        object.imageData = call.argument(ARGUMENT_KEY_IMAGEDATA);// 2 * 1024 * 1024

        message.mediaObject = object;
      } else if (METHOD_SHAREWEBPAGE.equals(call.method)) {
        WebpageObject object = new WebpageObject();
        object.identify = Utility.generateGUID();
        object.title = call.argument(ARGUMENT_KEY_TITLE);// 512
        object.description = call.argument(ARGUMENT_KEY_DESCRIPTION);// 1024
        object.thumbData = call.argument(ARGUMENT_KEY_THUMBDATA);// 32 * 1024
        object.defaultText = call.argument(ARGUMENT_KEY_DESCRIPTION);
        object.actionUrl = call.argument(ARGUMENT_KEY_WEBPAGEURL);// 512

        message.mediaObject = object;
      }

      shareHandler.shareMessage(message, false);
    }
    result.success(null);
  }

  // --- ActivityResultListener

  @Override
  public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
    if (requestCode == 32973) {
      if (ssoHandler != null) {
        ssoHandler.authorizeCallBack(requestCode, resultCode, data);
      }
      return true;
    }
    if (requestCode == WbShareHandler.WB_SHARE_REQUEST) {
      if (shareHandler != null) {
        shareHandler.doResultIntent(data, new WbShareCallback() {
          @Override
          public void onWbShareSuccess() {
            Map<String, Object> map = new HashMap<>();
            map.put(ARGUMENT_KEY_RESULT_STATUSCODE, FakeWeiboStatusCode.SUCCESS);
            channel.invokeMethod(METHOD_ONSHAREMSGRESP, map);
          }

          @Override
          public void onWbShareCancel() {
            Map<String, Object> map = new HashMap<>();
            map.put(ARGUMENT_KEY_RESULT_STATUSCODE, FakeWeiboStatusCode.USERCANCEL);
            channel.invokeMethod(METHOD_ONSHAREMSGRESP, map);
          }

          @Override
          public void onWbShareFail() {
            Map<String, Object> map = new HashMap<>();
            map.put(ARGUMENT_KEY_RESULT_STATUSCODE, FakeWeiboStatusCode.SHARE_IN_SDK_FAILED);
            channel.invokeMethod(METHOD_ONSHAREMSGRESP, map);
          }
        });
      }
    }
    return false;
  }
}
