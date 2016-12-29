//
//  RGSocialProtocol.h
//  ruogu
//
//  Created by HyanCat on 15/10/19.
//  Copyright © 2015年 ruogu. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kRGSocialOptionAppIdKey;
extern NSString *const kRGSocialOptionAppSecertKey;
extern NSString *const kRGSocialOptionRedirectUrlKey;
extern NSString *const kRGSocialOptionUserInfoKey;

extern NSString *const kRGSocialResultTokenKey;
extern NSString *const kRGSocialResultUserKey;
extern NSString *const kRGSocialResultUserIdKey;

typedef void(^RGSocialCompledBlock)(NSDictionary *result, NSError *error);

@protocol RGSocialProtocol <NSObject>

@property (nonatomic, copy) NSDictionary *options;

- (BOOL)registerAppKey:(NSString *)appKey;

- (BOOL)handleOpenUrl:(NSURL *)url;

- (void)authenticateCompleted:(RGSocialCompledBlock)completed;

- (BOOL)isInstalled;

@end
