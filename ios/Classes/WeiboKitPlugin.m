#import "WeiboKitPlugin.h"
#import <Weibo_SDK/WeiboSDK.h>

@interface WeiboKitPlugin () <WeiboSDKDelegate>

@end

@implementation WeiboKitPlugin {
    FlutterMethodChannel *_channel;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
    FlutterMethodChannel *channel = [FlutterMethodChannel
        methodChannelWithName:@"v7lin.github.io/weibo_kit"
              binaryMessenger:[registrar messenger]];
    WeiboKitPlugin *instance = [[WeiboKitPlugin alloc] initWithChannel:channel];
    [registrar addApplicationDelegate:instance];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (instancetype)initWithChannel:(FlutterMethodChannel *)channel {
    self = [super init];
    if (self) {
        _channel = channel;
    }
    return self;
}

- (void)handleMethodCall:(FlutterMethodCall *)call
                  result:(FlutterResult)result {
    if ([@"registerApp" isEqualToString:call.method]) {
        NSString *appKey = call.arguments[@"appKey"];
        NSString *universalLink = call.arguments[@"universalLink"];
        [WeiboSDK registerApp:appKey universalLink:universalLink];
        result(nil);
    } else if ([@"isInstalled" isEqualToString:call.method]) {
        result([NSNumber numberWithBool:[WeiboSDK isWeiboAppInstalled]]);
    } else if ([@"isSupportMultipleImage" isEqualToString:call.method]) {
        result([NSNumber numberWithBool:YES]);
    } else if ([@"auth" isEqualToString:call.method]) {
        [self handleAuthCall:call result:result];
    } else if ([@"shareText" isEqualToString:call.method] ||
               [@"shareImage" isEqualToString:call.method] ||
               [@"shareMultiImage" isEqualToString:call.method] ||
               [@"shareVideo" isEqualToString:call.method] ||
               [@"shareWebpage" isEqualToString:call.method]) {
        [self handleShareCall:call result:result];
    } else {
        result(FlutterMethodNotImplemented);
    }
}

- (void)handleAuthCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.scope = call.arguments[@"scope"];
    request.redirectURI = call.arguments[@"redirectUrl"];
    request.shouldShowWebViewForAuthIfCannotSSO = YES;
    request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
    [WeiboSDK sendRequest:request
               completion:^(BOOL success){
                   // do nothing
               }];
    result(nil);
}

- (void)handleShareCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    WBMessageObject *message = [WBMessageObject message];
    if ([@"shareText" isEqualToString:call.method]) {
        message.text = call.arguments[@"text"];
    } else if ([@"shareImage" isEqualToString:call.method]) {
        message.text = call.arguments[@"text"];
        WBImageObject *object = [WBImageObject object];
        FlutterStandardTypedData *imageData = call.arguments[@"imageData"];
        if (imageData != nil) {
            object.imageData = imageData.data;
        } else {
            NSString *imageUri = call.arguments[@"imageUri"];
            NSURL *imageUrl = [NSURL URLWithString:imageUri];
            object.imageData = [NSData dataWithContentsOfFile:imageUrl.path];
        }
        message.imageObject = object;
    } else if ([@"shareMultiImage" isEqualToString:call.method]) {
        message.text = call.arguments[@"text"];
        WBImageObject *object = [WBImageObject object];
        NSArray *imageUris = call.arguments[@"imageUris"];
        NSMutableArray<UIImage *> *images = [[NSMutableArray alloc] init];
        for (NSString *imageUri in imageUris) {
            NSURL *imageUrl = [NSURL URLWithString:imageUri];
            [images addObject:[UIImage imageWithContentsOfFile:imageUrl.path]];
        }
        [object addImages:images];
        message.imageObject = object;
    } else if ([@"shareVideo" isEqualToString:call.method]) {
        message.text = call.arguments[@"text"];
        WBNewVideoObject *object = [WBNewVideoObject object];
        NSString *videoUri = call.arguments[@"videoUri"];
        [object addVideo:[NSURL URLWithString:videoUri]];
        message.videoObject = object;
    } else if ([@"shareWebpage" isEqualToString:call.method]) {
        WBWebpageObject *object = [WBWebpageObject object];
        object.objectID = [[NSUUID UUID].UUIDString stringByReplacingOccurrencesOfString:@"-" withString:@""];
        object.title = call.arguments[@"title"];
        object.description = call.arguments[@"description"];
        FlutterStandardTypedData *thumbData = call.arguments[@"thumbData"];
        if (thumbData != nil) {
            object.thumbnailData = thumbData.data;
        }
        object.webpageUrl = call.arguments[@"webpageUrl"];
        message.mediaObject = object;
    }
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest request];
    request.message = message;
    [WeiboSDK sendRequest:request
               completion:^(BOOL success){
                   // do nothing
               }];
    result(nil);
}

#pragma mark - AppDelegate

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [WeiboSDK handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [WeiboSDK handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
    return [WeiboSDK handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray *_Nonnull))restorationHandler {
    return [WeiboSDK handleOpenUniversalLink:userActivity delegate:self];
}

#pragma mark - WeiboSDKDelegate

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request {
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setValue:[NSNumber numberWithInteger:response.statusCode] forKey:@"errorCode"];
    if ([response isKindOfClass:[WBAuthorizeResponse class]]) {
        if (response.statusCode == WeiboSDKResponseStatusCodeSuccess) {
            WBAuthorizeResponse *authorizeResponse = (WBAuthorizeResponse *)response;
            NSString *userId = authorizeResponse.userID;
            NSString *accessToken = authorizeResponse.accessToken;
            NSString *refreshToken = authorizeResponse.refreshToken;
            long long expiresTime = authorizeResponse.expirationDate.timeIntervalSince1970 * 1000;
            [dictionary setValue:userId forKey:@"userId"];
            [dictionary setValue:accessToken forKey:@"accessToken"];
            [dictionary setValue:refreshToken forKey:@"refreshToken"];
            [dictionary setValue:[NSNumber numberWithLongLong:expiresTime] forKey:@"expiresTime"];
        }
        [_channel invokeMethod:@"onAuthResp" arguments:dictionary];
    } else if ([response isKindOfClass:[WBSendMessageToWeiboResponse class]]) {
        if (response.statusCode == WeiboSDKResponseStatusCodeSuccess) {
            WBSendMessageToWeiboResponse *sendMessageToWeiboResponse = (WBSendMessageToWeiboResponse *)response;
        }
        [_channel invokeMethod:@"onShareMsgResp" arguments:dictionary];
    }
}

@end
