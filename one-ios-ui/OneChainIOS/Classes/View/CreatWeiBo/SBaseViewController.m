//
//  SBaseViewController.m
//  CancerDo
//
//  Created by hugaowei on 16/6/3.
//  Copyright © 2016年 lianji. All rights reserved.
//

#import "SBaseViewController.h"

@interface SBaseViewController ()

@end

@implementation SBaseViewController

@synthesize leftButton;
@synthesize rightButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self addBackNavigationBarButtonItem];
    [self addRightBarButton];
    
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
}

- (void)addBackNavigationBarButtonItem{
    leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 18, 30)];
    [leftButton setImage:THMImage(@"nav_back_btn") forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(gotoBack:) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setTitleColor:ColorWithRGB(255.0f, 255.0f, 255.0f, 1) forState:UIControlStateNormal];
    leftButton.titleLabel.font = [MTool navigationItemFont];
    [leftButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [leftButton setExclusiveTouch:YES];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
}

- (void)addRightBarButton{
    rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    [rightButton.titleLabel setFont:[MTool navigationItemFont]];
    [rightButton setTitle:@"" forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightBarButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setTitleColor:ColorWithRGB(255.0f, 255.0f, 255.0f, 1) forState:UIControlStateNormal];
    [rightButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [rightButton.titleLabel setFont:[MTool navigationItemFont]];
    [rightButton setExclusiveTouch:YES];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
}

- (void)rightBarButtonAction:(UIButton*)btn{
    
}

- (void)gotoBack:(UIButton*)btn{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
//    UIViewController *viewController = [[self.navigationController viewControllers] lastObject];
//
//    CGFloat alpha        = 1;
//    UIImage *backImage   = nil;
//    UIImage *goBackImage = [UIImage imageNamed:@"sysNaviBack"];
//    UIColor *color       = [UIColor clearColor];
//    NSDictionary *dict   = [NSDictionary dictionaryWithObjectsAndKeys:ColorWithRGB(28.0f, 28.0f, 28.0f, 1), NSForegroundColorAttributeName, /*[MTool navigationBarTitleFont], NSFontAttributeName,*/ nil];
//
//    if ([viewController isKindOfClass:[SBaseViewController class]]) {
//        color = [UIColor whiteColor];
//        alpha = 0.9;
//    }else{
//
//        goBackImage = [UIImage imageNamed:@"navigationBarBackButon"];
//        backImage   = [[UIImage imageNamed:@"systemColorImage"] stretchableImageWithLeftCapWidth:5 topCapHeight:5];
//        dict        = [NSDictionary dictionaryWithObjectsAndKeys:ColorWithRGB(252.0f, 250.0f, 250.0f, 1), NSForegroundColorAttributeName,/* [MTool navigationBarTitleFont], NSFontAttributeName,*/ nil];
//    }
//
//    viewController.navigationController.navigationBar.alpha = alpha;
//    self.navigationController.navigationBar.barTintColor    = color;
//    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
//
//    [self.leftButton setImage:goBackImage forState:UIControlStateNormal];
//    [viewController.navigationController.navigationBar setTitleTextAttributes:dict];
//    [viewController.navigationController.navigationBar setBackgroundImage:backImage forBarMetrics:UIBarMetricsDefault];
//
////    [MobClick endLogPageView:NSStringFromClass(self.class)];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    if (self.navigationController && [self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
//    }
//
//    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:ColorWithRGB(28.0f, 28.0f, 28.0f, 1), NSForegroundColorAttributeName,/* [MTool navigationBarTitleFont], NSFontAttributeName,*/ nil];
//
//    [self.navigationController.navigationBar setTitleTextAttributes:dict];
//    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
//    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
//    self.navigationController.navigationBar.alpha = 0.9;
//    [leftButton setImage:[UIImage imageNamed:@"sysNaviBack"] forState:UIControlStateNormal];
//
////    [MobClick beginLogPageView:NSStringFromClass(self.class)];
//
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)login:(id)sender{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
//    [MTool login:self];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
