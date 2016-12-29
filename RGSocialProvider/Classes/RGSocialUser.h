//
//  RGSocialUser.h
//  ruogu
//
//  Created by HyanCat on 15/10/19.
//  Copyright © 2015年 ruogu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RGSocialUser : NSObject

@property (nonatomic, copy) NSString *openId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *gender;
@property (nonatomic, copy) NSDictionary *rawData;
@property (nonatomic, copy) NSString *provider;

@end
