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
            
        }
        else {
            doneBlock(nil, nil);
        }
        NSLog(@"code: %@, state: %@, error code: %d", response.code, response.state, response.errCode);
    }
}

@end
