#import "WeiboKitPlugin.h"
#import <Weibo_SDK/WeiboSDK.h>

@interface WeiboKitPlugin () <WeiboSDKDelegate>

@end

@implementation WeiboKitPlugin {
    FlutterMethodChannel * _channel;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
  FlutterMethodChannel *channel =
      [FlutterMethodChannel methodChannelWithName:@"v7lin.github.io/weibo_kit"
                                  binaryMessenger:[registrar messenger]];
  WeiboKitPlugin *instance = [[WeiboKitPlugin alloc] initWithChannel:channel];
  [registrar addApplicationDelegate:instance];
  [registrar addMethodCallDelegate:instance channel:channel];
}

static NSString * const METHOD_REGISTERAPP = @"registerApp";
static NSString * const METHOD_ISINSTALLED = @"isInstalled";
static NSString * const METHOD_AUTH = @"auth";
static NSString * const METHOD_SHARETEXT = @"shareText";
static NSString * const METHOD_SHAREIMAGE = @"shareImage";
static NSString * const METHOD_SHAREWEBPAGE = @"shareWebpage";

static NSString * const METHOD_ONAUTHRESP = @"onAuthResp";
static NSString * const METHOD_ONSHAREMSGRESP = @"onShareMsgResp";

static NSString * const ARGUMENT_KEY_APPKEY = @"appKey";
static NSString * const ARGUMENT_KEY_SCOPE = @"scope";
static NSString * const ARGUMENT_KEY_REDIRECTURL = @"redirectUrl";
static NSString * const ARGUMENT_KEY_TEXT = @"text";
static NSString * const ARGUMENT_KEY_TITLE = @"title";
static NSString * const ARGUMENT_KEY_DESCRIPTION = @"description";
static NSString * const ARGUMENT_KEY_THUMBDATA = @"thumbData";
static NSString * const ARGUMENT_KEY_IMAGEDATA = @"imageData";
static NSString * const ARGUMENT_KEY_IMAGEURI = @"imageUri";
static NSString * const ARGUMENT_KEY_WEBPAGEURL = @"webpageUrl";

static NSString * const ARGUMENT_KEY_RESULT_ERRORCODE = @"errorCode";
static NSString * const ARGUMENT_KEY_RESULT_ERRORMESSAGE = @"errorMessage";
static NSString * const ARGUMENT_KEY_RESULT_USERID = @"userId";
static NSString * const ARGUMENT_KEY_RESULT_ACCESSTOKEN = @"accessToken";
static NSString * const ARGUMENT_KEY_RESULT_REFRESHTOKEN = @"refreshToken";
static NSString * const ARGUMENT_KEY_RESULT_EXPIRESIN = @"expiresIn";

-(instancetype)initWithChannel:(FlutterMethodChannel *)channel {
    self = [super init];
    if (self) {
        _channel = channel;
    }
    return self;
}

- (void)handleMethodCall:(FlutterMethodCall *)call
                  result:(FlutterResult)result {
  if ([METHOD_REGISTERAPP isEqualToString:call.method]) {
      NSString * appKey = call.arguments[ARGUMENT_KEY_APPKEY];
      [WeiboSDK registerApp:appKey];
      result(nil);
  } else if ([METHOD_ISINSTALLED isEqualToString:call.method]) {
      result([NSNumber numberWithBool:[WeiboSDK isWeiboAppInstalled]]);
  } else if ([METHOD_AUTH isEqualToString:call.method]) {
      [self handleAuthCall:call result:result];
  } else if ([METHOD_SHARETEXT isEqualToString:call.method]) {
      [self handleShareTextCall:call result:result];
  } else if ([METHOD_SHAREIMAGE isEqualToString:call.method] ||
             [METHOD_SHAREWEBPAGE isEqualToString:call.method]) {
      [self handleShareMediaCall:call result:result];
  } else {
      result(FlutterMethodNotImplemented);
  }
}

-(void)handleAuthCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    WBAuthorizeRequest * request = [WBAuthorizeRequest request];
    request.scope = call.arguments[ARGUMENT_KEY_SCOPE];
    request.redirectURI = call.arguments[ARGUMENT_KEY_REDIRECTURL];
    request.shouldShowWebViewForAuthIfCannotSSO = YES;
    request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
    [WeiboSDK sendRequest:request];
    result(nil);
}

-(void)handleShareTextCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    WBSendMessageToWeiboRequest * request = [WBSendMessageToWeiboRequest request];
    WBMessageObject * message = [WBMessageObject message];
    message.text = call.arguments[ARGUMENT_KEY_TEXT];
    request.message = message;
    [WeiboSDK sendRequest:request];
    result(nil);
}

-(void)handleShareMediaCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    WBSendMessageToWeiboRequest * request = [WBSendMessageToWeiboRequest request];
    WBMessageObject * message = [WBMessageObject message];
    if ([METHOD_SHAREIMAGE isEqualToString:call.method]) {
        message.text = call.arguments[ARGUMENT_KEY_TEXT];
        WBImageObject * object = [WBImageObject object];
        FlutterStandardTypedData * imageData = call.arguments[ARGUMENT_KEY_IMAGEDATA];
        if (imageData != nil) {
            object.imageData = imageData.data;
        } else {
            NSString * imageUri = call.arguments[ARGUMENT_KEY_IMAGEURI];
            NSURL * imageUrl = [NSURL URLWithString:imageUri];
            object.imageData = [NSData dataWithContentsOfFile:imageUrl.path];
        }
        message.imageObject = object;
    } else if ([METHOD_SHAREWEBPAGE isEqualToString:call.method]) {
        WBWebpageObject * object = [WBWebpageObject object];
        object.objectID = [[NSUUID UUID].UUIDString stringByReplacingOccurrencesOfString:@"-" withString:@""];
        object.title = call.arguments[ARGUMENT_KEY_TITLE];
        object.description = call.arguments[ARGUMENT_KEY_DESCRIPTION];
        FlutterStandardTypedData * thumbData = call.arguments[ARGUMENT_KEY_THUMBDATA];
        if (thumbData != nil) {
            object.thumbnailData = thumbData.data;
        }
        object.webpageUrl = call.arguments[ARGUMENT_KEY_WEBPAGEURL];
        message.mediaObject = object;
    }
    request.message = message;
    [WeiboSDK sendRequest:request];
    result(nil);
}

# pragma mark - AppDelegate

-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [WeiboSDK handleOpenURL:url delegate:self];
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [WeiboSDK handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    return [WeiboSDK handleOpenURL:url delegate:self];
}

# pragma mark - WeiboSDKDelegate

-(void)didReceiveWeiboRequest:(WBBaseRequest *)request {
    
}

-(void)didReceiveWeiboResponse:(WBBaseResponse *)response {
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
    [dictionary setValue:[NSNumber numberWithInteger:response.statusCode] forKey:ARGUMENT_KEY_RESULT_ERRORCODE];
    if ([response isKindOfClass:[WBAuthorizeResponse class]]) {
        if (response.statusCode == WeiboSDKResponseStatusCodeSuccess) {
            WBAuthorizeResponse * authorizeResponse = (WBAuthorizeResponse *) response;
            NSString * userId = authorizeResponse.userID;
            NSString * accessToken = authorizeResponse.accessToken;
            NSString * refreshToken = authorizeResponse.refreshToken;
            long long expiresIn = ceil(authorizeResponse.expirationDate.timeIntervalSinceNow);// 向上取整
            [dictionary setValue:userId forKey:ARGUMENT_KEY_RESULT_USERID];
            [dictionary setValue:accessToken forKey:ARGUMENT_KEY_RESULT_ACCESSTOKEN];
            [dictionary setValue:refreshToken forKey:ARGUMENT_KEY_RESULT_REFRESHTOKEN];
            [dictionary setValue:[NSNumber numberWithLongLong:expiresIn] forKey:ARGUMENT_KEY_RESULT_EXPIRESIN];
        }
        [_channel invokeMethod:METHOD_ONAUTHRESP arguments:dictionary];
    } else if ([response isKindOfClass:[WBSendMessageToWeiboResponse class]]) {
        if (response.statusCode == WeiboSDKResponseStatusCodeSuccess) {
            WBSendMessageToWeiboResponse * sendMessageToWeiboResponse = (WBSendMessageToWeiboResponse *) response;
        }
        [_channel invokeMethod:METHOD_ONSHAREMSGRESP arguments:dictionary];
    }
}

@end
