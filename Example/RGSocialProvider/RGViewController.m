//
//  RGViewController.m
//  RGSocialProvider
//
//  Created by HyanCat on 12/29/2016.
//  Copyright (c) 2016 HyanCat. All rights reserved.
//

#import "RGViewController.h"
@import RGSocialProvider;

@interface RGViewController ()
@property (weak, nonatomic) IBOutlet UIButton *qqButton;
@property (weak, nonatomic) IBOutlet UIButton *wechatButton;
@property (weak, nonatomic) IBOutlet UIButton *weiboButton;

@end

@implementation RGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (IBAction)qqButtonTouched:(id)sender {
    [[RGSocialProvider with:kRGSocialTypeQQ] authenticateCompleted:^(NSDictionary *result, NSError *error) {
        NSLog(@"login QQ.");
    }];
}

- (IBAction)wechatButtonTouched:(id)sender {
    [[RGSocialProvider with:kRGSocialTypeWeChat] authenticateCompleted:^(NSDictionary *result, NSError *error) {
        NSLog(@"login Wechat.");
    }];
}

- (IBAction)weiboButtonTouched:(id)sender {
    [[RGSocialProvider with:kRGSocialTypeWeibo] authenticateCompleted:^(NSDictionary *result, NSError *error) {
        NSLog(@"login Weibo.");
    }];
}

@end
