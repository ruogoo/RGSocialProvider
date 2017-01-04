//
//  RGAppDelegate.m
//  RGSocialProvider
//
//  Created by HyanCat on 12/29/2016.
//  Copyright (c) 2016 HyanCat. All rights reserved.
//

#import "RGAppDelegate.h"
@import RGSocialProvider;

#define SOCIAL_WEIBO_SDK_KEY @"123"
#define SOCIAL_WEIBO_SDK_REDIRECT @""
#define SOCIAL_QQ_SDK_KEY @"123"
#define SOCIAL_WECHAT_SDK_KEY @"wx123"

@implementation RGAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    [[RGSocialProvider with:kRGSocialTypeWeibo] registerAppKey:SOCIAL_WEIBO_SDK_KEY];
    [[RGSocialProvider with:kRGSocialTypeWeibo] setOptions:@{kRGSocialOptionRedirectUrlKey: SOCIAL_WEIBO_SDK_REDIRECT}];
    [[RGSocialProvider with:kRGSocialTypeQQ] registerAppKey:SOCIAL_QQ_SDK_KEY];
//    [[RGSocialProvider with:kRGSocialTypeQQ] setOptions:@{kRGSocialOptionPermissions: @[kOPEN_PERMISSION_GET_USER_INFO, kOPEN_PERMISSION_GET_SIMPLE_USER_INFO, kOPEN_PERMISSION_ADD_TOPIC]}];
    [[RGSocialProvider with:kRGSocialTypeWeChat] registerAppKey:SOCIAL_WECHAT_SDK_KEY];

    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    return [[RGSocialProvider sharedInstance] handleOpenUrl:url];
}

@end
