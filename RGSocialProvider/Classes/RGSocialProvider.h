//
//  RGSocialProvider.h
//  ruogu
//
//  Created by HyanCat on 15/10/19.
//  Copyright © 2015年 ruogu. All rights reserved.
//

#import "RGSocialProtocol.h"

@interface RGSocialProvider : NSObject

+ (nonnull instancetype)sharedInstance;

+ (nullable id <RGSocialProtocol>)with:(nonnull NSString *)socialType;

- (BOOL)handleOpenUrl:(nullable NSURL *)url;

- (void)registerProvider:(nonnull id <RGSocialProtocol>)provider withSocialType:(nonnull NSString *)socialType;

@end
