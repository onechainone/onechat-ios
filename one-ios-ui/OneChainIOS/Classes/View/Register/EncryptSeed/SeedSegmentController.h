//
//  SeedSegmentController.h
//  OneChainIOS
//
//  Created by lifei on 2018/3/6.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SeedSegmentController : UIViewController

@property (nonatomic, strong) UIViewController *currentVC;

@property (nonatomic, strong) UIView *bottomView;

- (NSArray *)getTitles;

- (void)initSubVC;

- (void)segmentChanged:(UISegmentedControl *)control;

- (void)replaceFromOldViewController:(UIViewController *)oldVc toNewViewController:(UIViewController *)newVc;

- (void)changeBottomViewToIndex:(NSUInteger)index animation:(BOOL)animation;

- (void)initNodeCheck;

- (UIImage *)imageAtIndex:(NSInteger)index selectedState:(BOOL)l_isSelected;
@end
