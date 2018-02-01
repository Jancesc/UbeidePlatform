//
//  NGGSocial.m
//  sport
//
//  Created by Jan on 19/10/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import "NGGSocial.h"
#import <objc/runtime.h>
#import "WXApi.h"
#import "WXApiObject.h"
#import "WeiboSDK.h"
#import <AlipaySDK/AlipaySDK.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "QQ3.3.0/TencentOpenAPI.framework/Headers/QQApiInterface.h"

#define NGGWechatID @"wxf9f835efedc68448"
#define NGGWeiboKey @"3330737535"
#define NGGQQID @"1104818852"
#define NGGAliPayScheme @"NGGSport"

@interface NGGSocial () <WXApiDelegate, WeiboSDKDelegate, TencentSessionDelegate>

@property (nonatomic, strong) TencentOAuth *tencentOAuth;

@property (nonatomic, strong) NSMutableDictionary *dictionaryOfCallback;
@property (nonatomic, strong) void (^qqCallback)(NSDictionary *info);

//微信支付回调
@property (nonatomic, strong) void (^wechatPayCallback)(NSString *returnKey, NSString *errorMsg);
@end

@implementation NGGSocial

+ (instancetype)sharedInstance {
    
    static NGGSocial *staticSocialObject = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        staticSocialObject = [[NGGSocial alloc] init];
    });
    return staticSocialObject;
}

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        [self configure];
    }
    return self;
}

- (void)configure {
    
    _dictionaryOfCallback = [[NSMutableDictionary alloc] init];
    [WXApi registerApp:NGGWechatID];
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:NGGWeiboKey];
    _tencentOAuth = [[TencentOAuth alloc] initWithAppId:NGGQQID andDelegate:self];


}

- (void)handleOpenURL:(NSURL *)url {
    
    if ([[url scheme] isEqual:NGGWechatID]) {
        [WXApi handleOpenURL:url delegate:self];
    }
    else if ([[url scheme] isEqual:[[NSString alloc] initWithFormat:@"wb%@", NGGWeiboKey]])
    {
        [WeiboSDK handleOpenURL:url delegate:self];
    }
    else if ([[url scheme] isEqual:[[NSString alloc] initWithFormat:@"tencent%@", NGGQQID]])
    {
        [TencentOAuth HandleOpenURL:url];
    }
    else if ([[url scheme] isEqual:NGGAliPayScheme])
    {
        if ([url.host isEqual:@"safepay"]) {
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:nil];
        }
    }
}

#pragma mark - wechatAuthorization

- (void)sendWechatAuthorizeRequestWithViewController:(UIViewController *)viewController completion:(void (^)(NSString *))completion
{
    SendAuthReq *req = [[SendAuthReq alloc] init];
    req.scope = @"snsapi_message,snsapi_userinfo,snsapi_friend,snsapi_contact"; // @"post_timeline,sns"
    req.state = [[NSUUID UUID] UUIDString];
    if (completion != nil) {
        [_dictionaryOfCallback setObject:completion forKey:req.state];
    }
    req.openID = NGGWechatID;
    [WXApi sendAuthReq:req viewController:viewController delegate:self];
}

#pragma mark - weibo

- (void)sendWeiboAuthorizeRequestCompletion:(void (^)(NSDictionary *))completion
{
    NSString *requestID = [[NSUUID UUID] UUIDString];
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = @"https://api.weibo.com/oauth2/default.html";
    request.scope = @"all";
    request.userInfo = @{@"state": requestID};
    
    [_dictionaryOfCallback setObject:completion forKey:requestID];
    [WeiboSDK sendRequest:request];
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    NSString *requestID = [response.requestUserInfo objectForKey:@"state"];
    void (^completion)(NSDictionary *) = [_dictionaryOfCallback objectForKey:requestID];
    if (completion) {
        [_dictionaryOfCallback removeObjectForKey:requestID];
    }
    if (response.statusCode != WeiboSDKResponseStatusCodeSuccess) {
        NSLog(@"WEIBO ERROR CODE: %ld", (long)response.statusCode);
        return;
    }
    
    if (completion) {
        completion(response.userInfo);
    }
    
}

#pragma mark - QQ
- (void)sendQQAuthorizeRequestCompletion:(void (^)(NSDictionary *))completion
{
    _qqCallback = completion;
    [_tencentOAuth authorize:@[@"get_user_info", @"get_simple_userinfo"] inSafari:NO];
}

- (void)tencentDidLogin
{
    if (!_qqCallback) {
        return;
    }
    
    _qqCallback(@{@"accessToken":_tencentOAuth.accessToken, @"openID": _tencentOAuth.openId, @"expirationDate": _tencentOAuth.expirationDate});
    _qqCallback = nil;
}

#pragma mark - 微信支付
- (void)sendWechatPayRequestWithMessage:(NSDictionary *)message completion:(void (^)(NSString *, NSString *))completion {
    
    PayReq* req             = [[PayReq alloc] init];
    req.openID              = [message objectForKey:@"appid"];
    req.partnerId           = [message objectForKey:@"partnerid"];
    req.prepayId            = [message objectForKey:@"prepayid"];
    req.nonceStr            = [message objectForKey:@"noncestr"];
    req.timeStamp           = [message intForKey:@"timestamp"];
    req.package             = [message objectForKey:@"package"];
    req.sign                = [message objectForKey:@"sign"];
    
    _wechatPayCallback = completion;
    [WXApi sendReq:req];
}

- (void) handleWxPayResponse:(PayResp *) resp {
    
    if (resp.errCode != WXSuccess) {
        NSString *msg = resp.errCode == WXErrCodeUserCancel ? @"支付失败, 用户取消" : @"支付失败";
        _wechatPayCallback(resp.returnKey, msg);
        return;
    }
    
    _wechatPayCallback(resp.returnKey, nil);
}

#pragma mark - WXApiDelegate
- (void)onResp:(BaseResp *)resp {
    
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        
        [self handleWxSendAuthResponse:(SendAuthResp *)resp];
    } else if ([resp isKindOfClass:[PayResp class]]) {
        
        [self handleWxPayResponse:(PayResp *) resp];
    }
}

- (void) handleWxSendAuthResponse:(SendAuthResp *) resp {
    
    void (^completion)(NSString *) = [_dictionaryOfCallback objectForKey:resp.state];
    //remove callback
    if (completion) {
    
        [_dictionaryOfCallback removeObjectForKey:resp.state];
    }
    //handle error
    if (resp.errCode != WXSuccess) {
     
        NSLog(@"WX ERROR CODE: %d", resp.errCode);
        return;
    }
    //call callback
    if (completion) {
     
        completion(resp.code);
    }
}

#pragma mark - share Wechat(url)
- (void)sendWechatRequestMessage:(NSDictionary *) message scene:(int) scene {
    
    NSData *imageData = nil;
    id imgObj = [message objectForKey:@"image"];
    if ([imgObj isKindOfClass:[UIImage class]]) {
        imageData = UIImagePNGRepresentation(imgObj);
    }
    NSString *title = [message objectForKey:@"title"];
    NSString *desc = [message objectForKey:@"desc"];
    NSString *urlStr = [message objectForKey:@"url"];
    
    WXMediaMessage *wxMessage = [WXMediaMessage message];
    wxMessage.title = title;
    wxMessage.description = desc;
    wxMessage.thumbData = imageData;
    
    WXWebpageObject *webpageObj = [WXWebpageObject object];
    webpageObj.webpageUrl = urlStr;
    wxMessage.mediaObject = webpageObj;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.message = wxMessage;
    req.bText = NO;
    req.scene = scene;
    [WXApi sendReq:req];
}

- (void)sendWechatSessionRequestWithMessage:(NSDictionary *)message {
    
    [self sendWechatRequestMessage:message scene:WXSceneSession];
}

- (void)sendWechatTimelineRequestWithMessage:(NSDictionary *)message {
    
    [self sendWechatRequestMessage:message scene:WXSceneTimeline];
}

- (void)sendWechatFavoriteRequestWithMessage:(NSDictionary *)message {
    
    [self sendWechatRequestMessage:message scene:WXSceneFavorite];
}

#pragma mark - share Weibo
- (void) sendWeiboRequestWithMessage:(NSDictionary *)message
{
    NSData *imageData = nil;
    id imgObj = [message objectForKey:@"image"];
    if ([imgObj isKindOfClass:[UIImage class]]) {
        imageData = UIImagePNGRepresentation(imgObj);
    }
    
    NSString *title = [message objectForKey:@"title"];
    NSString *desc = [message objectForKey:@"desc"];
    NSString *urlStr = [message objectForKey:@"url"];
    
    WBWebpageObject *webObj = [WBWebpageObject object];
    webObj.objectID = [[NSUUID UUID] UUIDString];
    webObj.webpageUrl = urlStr;
    webObj.title = title;
    webObj.description = desc;
    webObj.thumbnailData = imageData;
    WBMessageObject *msgObj = [WBMessageObject message];
    msgObj.mediaObject = webObj;
    WBSendMessageToWeiboRequest *req = [WBSendMessageToWeiboRequest requestWithMessage:msgObj];
    [WeiboSDK sendRequest:req];
}

#pragma mark - share QQ
- (void)sendQQShareRequestWithMessage:(NSDictionary *)message
{
    NSData *imageData = nil;
    id imgObj = [message objectForKey:@"image"];
    if ([imgObj isKindOfClass:[UIImage class]]) {
        imageData = UIImagePNGRepresentation(imgObj);
    }
    NSString *title = [message objectForKey:@"title"];
    NSString *desc = [message objectForKey:@"desc"];
    NSString *urlStr = [message objectForKey:@"url"];
    
    QQApiNewsObject *newsObj = [[QQApiNewsObject alloc] initWithURL:[[NSURL alloc] initWithString:urlStr]
                                                              title:title description:desc
                                                    previewImageURL:nil
                                                  targetContentType:QQApiURLTargetTypeNews];
    newsObj.previewImageData = imageData;
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
    [QQApiInterface sendReq:req];
}

- (void)sendQZoneShareRequestWithMessage:(NSDictionary *)message
{
    NSData *imageData = nil;
    id imgObj = [message objectForKey:@"image"];
    if ([imgObj isKindOfClass:[UIImage class]]) {
        imageData = UIImagePNGRepresentation(imgObj);
    }
    NSString *title = [message objectForKey:@"title"];
    NSString *desc = [message objectForKey:@"desc"];
    NSString *urlStr = [message objectForKey:@"url"];
    
    QQApiNewsObject *newsObj = [[QQApiNewsObject alloc] initWithURL:[[NSURL alloc] initWithString:urlStr]
                                                              title:title description:desc
                                                    previewImageURL:nil
                                                  targetContentType:QQApiURLTargetTypeNews];
    newsObj.previewImageData = imageData;
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
    [QQApiInterface SendReqToQZone:req];
}


#pragma marl - check installation
- (BOOL)isWechatInstalled {
    
    return [WXApi isWXAppInstalled];
}

- (BOOL)isQQinstalled {
    
    return [TencentOAuth iphoneQQInstalled];
}

- (BOOL)isWeiboInstalled {
    
    return [WeiboSDK isWeiboAppInstalled];
}
@end
