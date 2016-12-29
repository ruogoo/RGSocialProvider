//
//  RGSocialProviderWeibo.m
//  ruogu
//
//  Created by HyanCat on 15/10/19.
//  Copyright © 2015年 ruogu. All rights reserved.
//

#import "RGSocialProviderWeibo.h"
#import "RGSocialProvider.h"
#import "RGSocialUser.h"
#import "WeiboSDK.h"
#import "WeiboUser.h"

NSString *const kRGSocialTypeWeibo = @"RGSocialType_Weibo";

@interface RGSocialProviderWeibo () <WeiboSDKDelegate>

@property (nonatomic, copy) NSString *appKey;
@property (nonatomic, copy) RGSocialCompledBlock completedBlock;

@end

@implementation RGSocialProviderWeibo
@synthesize options;

+ (void)load
{
	[[RGSocialProvider sharedInstance] registerProvider:[[RGSocialProviderWeibo alloc] init] withSocialType:kRGSocialTypeWeibo];
}

- (BOOL)registerAppKey:(NSString *)appKey
{
	self.appKey = appKey;
	
	return [WeiboSDK registerApp:appKey];
}

- (BOOL)handleOpenUrl:(NSURL *)url
{
	return [WeiboSDK handleOpenURL:url delegate:self];
}

- (void)authenticateCompleted:(RGSocialCompledBlock)completed
{
	self.completedBlock = completed;
	
	WBAuthorizeRequest *request = [WBAuthorizeRequest request];
	request.redirectURI = [self.options objectForKey:kRGSocialOptionRedirectUrlKey] ?: @"";
	request.scope = @"all";
	request.userInfo = [self.options objectForKey:kRGSocialOptionUserInfoKey];
	request.shouldShowWebViewForAuthIfCannotSSO = YES;
	[WeiboSDK sendRequest:request];
}

- (BOOL)isInstalled
{
	return [WeiboSDK isWeiboAppInstalled];
}


#pragma mark - Delegate

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
	
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
	RGSocialCompledBlock doneBlock = self.completedBlock;
	self.completedBlock = nil;
	if (response.statusCode != WeiboSDKResponseStatusCodeSuccess) {
		if (doneBlock) {
			NSError *error = [NSError errorWithDomain:@"weibo_domain" code:response.statusCode userInfo:@{}];
			doneBlock(nil, error);
		}
		return;
	}
	if ([response isKindOfClass:[WBAuthorizeResponse class]]) {
		NSString *token = [(WBAuthorizeResponse *)response accessToken];
		NSString *userId = [(WBAuthorizeResponse *)response userID];
		[self _requestUserProfile:userId accessToken:token completed:doneBlock];
	}
}

- (void)_requestUserProfile:(NSString *)userId accessToken:(NSString *)accessToken completed:(RGSocialCompledBlock)completedBlock
{
	[WBHttpRequest requestForUserProfile:userId
						 withAccessToken:accessToken
					  andOtherProperties:nil
								   queue:nil
				   withCompletionHandler:^(WBHttpRequest *httpRequest, WeiboUser *weiboUser, NSError *error) {
					   RGSocialUser *user = [[RGSocialUser alloc] init];
					   {
                           user.openId   = weiboUser.userID;
                           user.name     = weiboUser.name;
                           user.nickName = weiboUser.screenName;
                           user.email    = @"";
                           user.avatar   = weiboUser.avatarHDUrl;
                           user.gender   = [@{@"m": @"male", @"f": @"female", @"n": @"unknown"} objectForKey:weiboUser.gender];
                           user.rawData  = weiboUser.originParaDict;
                           user.provider = kRGSocialTypeWeibo;
					   }
					   NSMutableDictionary *result = [NSMutableDictionary dictionaryWithCapacity:3];
					   [result setObject:accessToken forKey:kRGSocialResultTokenKey];
					   [result setObject:userId forKey:kRGSocialResultUserIdKey];
					   [result setObject:user forKey:kRGSocialResultUserKey];
					   if (completedBlock) {
						   completedBlock(result.copy, error);
					   }
				   }];
}

@end
