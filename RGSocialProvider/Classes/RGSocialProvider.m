//
//  RGSocialProvider.m
//  ruogu
//
//  Created by HyanCat on 15/10/19.
//  Copyright © 2015年 ruogu. All rights reserved.
//

#import "RGSocialProvider.h"

NSString *const kRGSocialOptionAppIdKey       = @"RGSocialOptionAppIdKey";
NSString *const kRGSocialOptionAppSecertKey   = @"RGSocialOptionAppSecretKey";
NSString *const kRGSocialOptionRedirectUrlKey = @"RGSocialOptionRedirectUrlKey";
NSString *const kRGSocialOptionUserInfoKey    = @"RGSocialOptionUserInfoKey";

NSString *const kRGSocialResultTokenKey  = @"RGSocialResultTokenKey";
NSString *const kRGSocialResultUserKey   = @"RGSocialResultUserKey";
NSString *const kRGSocialResultUserIdKey = @"RGSocialResultUserIdKey";

@interface RGSocialProvider ()

@property (nonatomic, strong) NSMutableDictionary <NSString *, id <RGSocialProtocol>> *providers;

@end

@implementation RGSocialProvider

- (instancetype)init
{
	self = [super init];
	if (self) {
		_providers = [NSMutableDictionary dictionary];
	}
	return self;
}

+ (instancetype)sharedInstance
{
	static RGSocialProvider *provider = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		provider = [[RGSocialProvider alloc] init];
	});
	return provider;
}

+ (id <RGSocialProtocol>)with:(NSString *)socialType
{
	return [[[self sharedInstance] providers] objectForKey:socialType];
}

- (BOOL)handleOpenUrl:(NSURL *)url
{
	__block BOOL handle = NO;
	[self.providers enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id<RGSocialProtocol>  _Nonnull obj, BOOL * _Nonnull stop) {
		handle = handle || [obj handleOpenUrl:url];
	}];
	return handle;
}

- (void)registerProvider:(id<RGSocialProtocol>)provider withSocialType:(nonnull NSString *)socialType
{
	[self.providers setObject:provider forKey:socialType];
}

@end
