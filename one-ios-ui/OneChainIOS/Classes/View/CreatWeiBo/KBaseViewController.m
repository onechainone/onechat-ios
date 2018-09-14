//
//  KBaseViewController.m
//  ChatDemo
//
//  Created by hugaowei on 16/5/21.
//  Copyright © 2016年 lianji. All rights reserved.
//

#import "KBaseViewController.h"

@interface KBaseViewController ()

@end

@implementation KBaseViewController

@synthesize leftButton;
@synthesize rightButton;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addBackNavigationBarButtonItem];
    [self addRightBarButton];
}

- (void)addBackNavigationBarButtonItem{
    leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 18, 30)];
    [leftButton setImage:[UIImage imageNamed:@"navigationBarBackButon"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(gotoBack:) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setTitleColor:ColorWithRGB(255.0f, 255.0f, 255.0f, 1) forState:UIControlStateNormal];
    leftButton.titleLabel.font = [MTool navigationItemFont];
    [leftButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [leftButton setExclusiveTouch:YES];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
}

- (void)addRightBarButton{
    rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    [rightButton setTitle:NULL_STRING forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightBarButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [rightButton setTitleColor:ColorWithRGB(255.0f, 255.0f, 255.0f, 1) forState:UIControlStateNormal];
    [rightButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.navigationController && [self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
    
//    [MobClick beginLogPageView:NSStringFromClass(self.class)];
    
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [MobClick endLogPageView:NSStringFromClass(self.class)];
}

- (void)login:(id)sender{
    
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
