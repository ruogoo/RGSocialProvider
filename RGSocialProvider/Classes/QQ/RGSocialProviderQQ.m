//
//  RGSocialProviderQQ.m
//  ruogu
//
//  Created by HyanCat on 15/10/20.
//  Copyright © 2015年 ruogu. All rights reserved.
//

#import "RGSocialProviderQQ.h"
#import "RGSocialProvider.h"
#import "RGSocialUser.h"
#import <TencentOpenAPI/TencentOpenApiUmbrellaHeader.h>

NSString *const kRGSocialTypeQQ = @"RGSocialType_QQ";
NSString *const kRGSocialOptionPermissions = @"RGSocialOptionPermissionsKey";

@interface RGSocialProviderQQ () <TencentSessionDelegate>

@property (nonatomic, strong) TencentOAuth *oauth;
@property (nonatomic, copy) NSString *appKey;
@property (nonatomic, copy) RGSocialCompledBlock completedBlock;

@end

@implementation RGSocialProviderQQ
@synthesize options;

+ (void)load
{
	[[RGSocialProvider sharedInstance] registerProvider:[[RGSocialProviderQQ alloc] init] withSocialType:kRGSocialTypeQQ];
}

- (BOOL)registerAppKey:(NSString *)appKey
{
	self.appKey = appKey;
	
    [TencentOAuth setIsUserAgreedAuthorization:YES];
    
	self.oauth = [[TencentOAuth alloc] initWithAppId:self.appKey andDelegate:self];
    
	return YES;
}

- (BOOL)handleOpenUrl:(NSURL *)url
{
	if ([url.absoluteString hasPrefix:@"tencent"]) {
		return [TencentOAuth HandleOpenURL:url];
	}
	return NO;
}

- (void)authenticateCompleted:(RGSocialCompledBlock)completed
{
	self.completedBlock = completed;
	
	NSArray *permissions = [self.options objectForKey:kRGSocialOptionPermissions];
	[self.oauth authorize:permissions];
}

- (BOOL)isInstalled
{
	return [TencentOAuth iphoneQQInstalled];
}

#pragma mark - Delegate

- (void)tencentDidLogin
{
	[self.oauth getUserInfo];
}

- (void)tencentDidNotLogin:(BOOL)cancelled
{
	RGSocialCompledBlock cancelledBlock = self.completedBlock;
    self.completedBlock = nil;
    cancelledBlock(nil, nil);
}

- (void)tencentDidNotNetWork
{

}

- (void)getUserInfoResponse:(APIResponse *)response
{
	RGSocialCompledBlock doneBlock = self.completedBlock;
	self.completedBlock = nil;
	if (response.retCode != URLREQUEST_SUCCEED) {
		NSError *error = [NSError errorWithDomain:@"qq_error_domain" code:response.detailRetCode userInfo:response.jsonResponse];
		doneBlock(nil, error);
		return;
	}
	NSDictionary *userInfo = response.jsonResponse;
	RGSocialUser *user = [[RGSocialUser alloc] init];
	{
        user.openId   = self.oauth.openId;
        user.name     = [userInfo objectForKey:@"nickname"];
        user.nickName = [userInfo objectForKey:@"nickname"];
        user.gender   = [[userInfo objectForKey:@"gender"] isEqualToString:@"男"] ? @"male": @"female";
        user.avatar   = [userInfo objectForKey:@"figureurl_qq_2"];
        user.provider = kRGSocialTypeQQ;
        user.rawData  = userInfo;
	}
	
	NSMutableDictionary *result = [NSMutableDictionary dictionaryWithCapacity:3];
	[result setObject:self.oauth.accessToken forKey:kRGSocialResultTokenKey];
	[result setObject:self.oauth.openId forKey:kRGSocialResultUserIdKey];
	[result setObject:user forKey:kRGSocialResultUserKey];
	
	doneBlock(result, nil);
}

@end
