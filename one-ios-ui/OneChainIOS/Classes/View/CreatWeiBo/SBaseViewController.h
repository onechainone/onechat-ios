//
//  SBaseViewController.h
//  CancerDo
//
//  Created by hugaowei on 16/6/3.
//  Copyright © 2016年 lianji. All rights reserved.
//

#import "KBaseViewController.h"

@interface SBaseViewController : UIViewController

@property (nonatomic,strong) UIButton *leftButton;
@property (nonatomic,strong) UIButton *rightButton;
/*
 *rightNavBarItem的点击响应
 */
- (void)rightBarButtonAction:(UIButton*)btn;

/*
 *leftNavBarItem的点击响应
 */
- (void)gotoBack:(UIButton*)btn;

- (void)login:(id)sender;

@end
