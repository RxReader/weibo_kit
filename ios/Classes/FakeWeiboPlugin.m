#import "FakeWeiboPlugin.h"
#import <Weibo_SDK/WeiboSDK.h>

@interface FakeWeiboPlugin () <WeiboSDKDelegate>

@end

@implementation FakeWeiboPlugin {
    FlutterMethodChannel * _channel;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel methodChannelWithName:@"plugins.flutter.io/fake_weibo" binaryMessenger:[registrar messenger]];
    FakeWeiboPlugin* instance = [[FakeWeiboPlugin alloc] initWithChannel:channel];
    [registrar addMethodCallDelegate:instance channel:channel];
}

static NSString * const METHOD_REGISTERAPP = @"registerApp";
static NSString * const METHOD_ISWEIBOINSTALLED = @"isWeiboInstalled";
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
static NSString * const ARGUMENT_KEY_WEBPAGEURL = @"webpageUrl";

static NSString * const ARGUMENT_KEY_RESULT_STATUSCODE = @"statusCode";
static NSString * const ARGUMENT_KEY_RESULT_USERID = @"userId";
static NSString * const ARGUMENT_KEY_RESULT_ACCESSTOKEN = @"accessToken";
static NSString * const ARGUMENT_KEY_RESULT_REFRESHTOKEN = @"refreshToken";
static NSString * const ARGUMENT_KEY_RESULT_EXPIRATIONDATE = @"expirationDate";

-(instancetype)initWithChannel:(FlutterMethodChannel *)channel {
    self = [super init];
    if (self) {
        _channel = channel;
    }
    return self;
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([METHOD_REGISTERAPP isEqualToString:call.method]) {
        NSString * appKey = call.arguments[ARGUMENT_KEY_APPKEY];
        [WeiboSDK registerApp:appKey];
        result(nil);
    } else if ([METHOD_ISWEIBOINSTALLED isEqualToString:call.method]) {
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
        WBImageObject * object = [WBImageObject object];
        FlutterStandardTypedData * imageData = call.arguments[ARGUMENT_KEY_IMAGEDATA];
        object.imageData = imageData.data;
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

# pragma mark - WeiboSDKDelegate

-(void)didReceiveWeiboRequest:(WBBaseRequest *)request {
    
}

-(void)didReceiveWeiboResponse:(WBBaseResponse *)response {
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:[NSNumber numberWithInteger:response.statusCode] forKey:ARGUMENT_KEY_RESULT_STATUSCODE];
    if ([response isKindOfClass:[WBAuthorizeResponse class]]) {
        if (response.statusCode == WeiboSDKResponseStatusCodeSuccess) {
            WBAuthorizeResponse * authorizeResponse = (WBAuthorizeResponse *) response;
            NSString * userId = authorizeResponse.userID;
            NSString * accessToken = authorizeResponse.accessToken;
            NSString * refreshToken = authorizeResponse.refreshToken;
            long long expirationDate = authorizeResponse.expirationDate.timeIntervalSince1970 * 1000;
            [dictionary setObject:userId forKey:ARGUMENT_KEY_RESULT_USERID];
            [dictionary setObject:accessToken forKey:ARGUMENT_KEY_RESULT_ACCESSTOKEN];
            [dictionary setObject:refreshToken forKey:ARGUMENT_KEY_RESULT_REFRESHTOKEN];
            [dictionary setObject:[NSNumber numberWithLongLong:expirationDate] forKey:ARGUMENT_KEY_RESULT_EXPIRATIONDATE];
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
