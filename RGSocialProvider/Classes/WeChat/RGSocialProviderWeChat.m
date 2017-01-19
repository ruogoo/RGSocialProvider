//
//  RGSocialProviderWeChat.m
//  ruogu
//
//  Created by HyanCat on 15/10/20.
//  Copyright © 2015年 ruogu. All rights reserved.
//

#import "RGSocialProviderWeChat.h"
#import "RGSocialProvider.h"
#import "RGSocialUser.h"
#import "WXApi.h"

NSString *const kRGSocialTypeWeChat = @"RGSocialType_WeChat";

NSString *const kWeChatAccessTokenURL = @"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code";
NSString *const kWeChatUserInfoURL = @"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@";

@interface RGSocialProviderWeChat () <WXApiDelegate>

@property (nonatomic, copy) NSString *appKey;
@property (nonatomic, copy) RGSocialCompledBlock completedBlock;

@end

@implementation RGSocialProviderWeChat
@synthesize options;

+ (void)load
{
    [[RGSocialProvider sharedInstance] registerProvider:[[RGSocialProviderWeChat alloc] init] withSocialType:kRGSocialTypeWeChat];
}

- (BOOL)registerAppKey:(NSString *)appKey
{
    self.appKey = appKey;

    return [WXApi registerApp:appKey withDescription:nil];
}

- (BOOL)handleOpenUrl:(NSURL *)url
{
    return [WXApi handleOpenURL:url delegate:self];
}

- (void)authenticateCompleted:(RGSocialCompledBlock)completed
{
    self.completedBlock = completed;

    SendAuthReq* authReq = [[SendAuthReq alloc] init];
    authReq.scope = @"snsapi_userinfo";
    authReq.state = @"RGSocialProviderWeChat";
    authReq.openID = self.appKey;
    [WXApi sendAuthReq:authReq viewController:nil delegate:self];
}

- (BOOL)isInstalled
{
    return [WXApi isWXAppInstalled];
}

#pragma mark - Delegate

- (void)onReq:(BaseReq *)req
{
    if ([req isKindOfClass:[SendAuthReq class]])
    {

    }
}

- (void)onResp:(BaseResp *)resp
{
    RGSocialCompledBlock doneBlock = self.completedBlock;
    self.completedBlock = nil;

    if ([resp isKindOfClass:[SendAuthResp class]])
    {
        SendAuthResp *response = resp;

        if (WXSuccess == response.errCode) {
            [self _requestAccessTokenWithCode:response.code completion:^(NSString *accessToken, NSString *openID) {
                if (accessToken && openID) {
                    [self _requestUserInfoWithOpenID:openID accessToken:accessToken completion:^(RGSocialUser *socialUser) {
                        if (socialUser) {
                            NSMutableDictionary *result = [NSMutableDictionary dictionaryWithCapacity:3];
                            [result setObject:accessToken forKey:kRGSocialResultTokenKey];
                            [result setObject:openID forKey:kRGSocialResultUserIdKey];
                            [result setObject:socialUser forKey:kRGSocialResultUserKey];
                            doneBlock(result, nil);
                        }
                        else {
                            doneBlock(nil, nil);
                        }
                    }];
                }
                else {
                    doneBlock(nil, nil);
                }
            }];
        }
        else {
            doneBlock(nil, nil);
        }
        NSLog(@"code: %@, state: %@, error code: %d", response.code, response.state, response.errCode);
    }
}

- (void)_requestAccessTokenWithCode:(NSString *)code completion:(nonnull void (^)(NSString *accessToken, NSString *openID))completion
{
    NSString *appSecret = [self.options objectForKey:kRGSocialOptionAppSecertKey];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:kWeChatAccessTokenURL, self.appKey, appSecret, code]];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithURL:url
                                        completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                                            if (dic) {
                                                completion(dic[@"access_token"], dic[@"openid"]);
                                            }
                                            else {
                                                completion(nil, nil);
                                            }
                                        }];
    [task resume];

}

- (void)_requestUserInfoWithOpenID:(NSString *)openID accessToken:(NSString *)accessToken completion:(void (^)(RGSocialUser *socialUser))completion
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:kWeChatUserInfoURL, accessToken, openID]];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithURL:url
                                        completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                            NSDictionary *userInfo = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                                            if (userInfo) {
                                                RGSocialUser *user = [[RGSocialUser alloc] init];
                                                {
                                                    user.openId   = openID;
                                                    user.name     = [userInfo objectForKey:@"nickname"];
                                                    user.nickName = [userInfo objectForKey:@"nickname"];
                                                    user.gender   = @{@0: @"unknown", @1: @"male", @2: @"female"}[[userInfo objectForKey:@"sex"]];
                                                    user.avatar   = [userInfo objectForKey:@"headimgurl"];
                                                    user.provider = kRGSocialTypeWeChat;
                                                    user.rawData  = userInfo;
                                                }
                                                completion(user);
                                            }
                                            else {
                                                completion(nil);
                                            }
                                        }];
    [task resume];
}

@end
