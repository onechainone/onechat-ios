//
//  ONEWebController.m
//  OneChainIOS
//
//  Created by 李飞 on 2018/6/16.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "ONEWebController.h"
#import "UIImage+Extension.h"
@interface ONEWebController ()

@end

@implementation ONEWebController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack; //状态栏改为白色
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:17], NSForegroundColorAttributeName : [UIColor whiteColor]};
    NSString *imageName = nil;
    if (IS_IPHONE_X) {
        imageName = [imageName stringByAppendingString:@"_x"];
    }
    if (IS_IPHONE_5) {
        imageName = [imageName stringByAppendingString:@"_5s"];
    }
    UIImage *nav_bg = [UIImage imageNamed:imageName];

    [self.navigationController.navigationBar setBackgroundImage:[nav_bg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:17], NSForegroundColorAttributeName : [UIColor blackColor]};
    [ONEThemeManager resetStatusBarStyle];
}


- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)addProgressBar
{
    // do nothing
}

- (void)addLeftButton
{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    backBtn.titleLabel.font = [UIFont fontWithName:FONT_NAME_REGULAR size:15];
    [backBtn setImage:[UIImage imageNamed:@"icon_back_white"] forState:UIControlStateNormal];
    [backBtn setTitle:NSLocalizedString(@"head_return", @"") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backNative) forControlEvents:UIControlEventTouchUpInside];
    [backBtn sizeToFit];
    backBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    backBtn.frame = CGRectMake(0, 0, 40, 40);
    self.backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    UIButton *close = [UIButton buttonWithType:UIButtonTypeCustom];
    [close setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    close.titleLabel.font = [UIFont fontWithName:FONT_NAME_REGULAR size:15];
    [close setTitle:NSLocalizedString(@"string_close", @"") forState:UIControlStateNormal];
    [close addTarget:self action:@selector(closeNative) forControlEvents:UIControlEventTouchUpInside];
    [close sizeToFit];
    close.contentEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    close.frame = CGRectMake(0, 0, 40, 40);
    self.closeItem = [[UIBarButtonItem alloc] initWithCustomView:close];
    self.navigationItem.leftBarButtonItems = @[self.backItem, self.closeItem];
}

- (void)addRightButton
{
    UIButton *right = [UIButton buttonWithType:UIButtonTypeCustom];
    [right setFrame:CGRectMake(0, 0, 40, 40)];
    [right setTitle:NSLocalizedString(@"action_refresh", nil) forState:UIControlStateNormal];
    [right setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    right.titleLabel.font = [UIFont fontWithName:FONT_NAME_REGULAR size:15];
    [right addTarget:self action:@selector(shuaXinWeb) forControlEvents:UIControlEventTouchUpInside];
    [right sizeToFit];
    UIBarButtonItem *rightBut = [[UIBarButtonItem alloc]initWithCustomView:right];
    self.navigationItem.rightBarButtonItem = rightBut;
}


- (void)closeNative
{
    [self.navigationController popViewControllerAnimated:NO];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
