//
//  MJRefreshNormalHeader+Title.m
//  OneChainIOS
//
//  Created by lifei on 2018/4/14.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "MJRefreshNormalHeader+Title.h"
#import <objc/runtime.h>
@implementation MJRefreshNormalHeader (Title)

+ (void)load
{
    Method normalMethod = class_getInstanceMethod([self class], @selector(prepare));
    Method exMethod = class_getInstanceMethod([self class], @selector(lf_prepare));
    method_exchangeImplementations(normalMethod, exMethod);
}

- (void)lf_prepare
{
    [self lf_prepare];

    self.stateLabel.themeMap = @{
                                 TextColorName:@"common_text_color"
                                 };
    self.activityIndicatorViewStyle = THMACStyle(@"activity_view_style");
    [self setTitle:NSLocalizedString(@"refresh_pull_down", @"") forState:MJRefreshStateIdle];
    [self setTitle:NSLocalizedString(@"refresh_release", @"") forState:MJRefreshStatePulling];
    [self setTitle:NSLocalizedString(@"refresh_loading", @"") forState:MJRefreshStateRefreshing];
    [self.lastUpdatedTimeLabel setHidden:YES];
}

@end
