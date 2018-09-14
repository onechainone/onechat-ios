//
//  SeedSegmentController.m
//  OneChainIOS
//
//  Created by lifei on 2018/3/6.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "SeedSegmentController.h"
//#import "LBSegmentControl.h"
#import "LZRecoverViewController.h"
#import "UIImage+Extension.h"
#import "EncryptSeedRecoverController.h"
#import "NetworkStatusController.h"
static const CGFloat kBOTTOMVIEW_WIDTH = 40.f;
static const CGFloat kBOTTOMVIEW_HEIGHT = 3.f;
static const CGFloat kSEGMENTCONTROL_HEIGHT = 40.f;
static const CGFloat kSEGMENTCONTROL_TITLE_FONT_SIZE = 14.f;

#define kSEGMENTCONTROL_SELECT_COLOR RGBACOLOR(239, 242, 249, 1)

@interface SeedSegmentController ()

@property (nonatomic, strong) LZRecoverViewController *recoverVC;

@property (nonatomic, strong) EncryptSeedRecoverController *encryptSeedVC;

@property (nonatomic, strong) UISegmentedControl *segControl;
@end


@implementation SeedSegmentController

- (UIView *)bottomView
{
    if (!_bottomView) {
        
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kBOTTOMVIEW_WIDTH, kBOTTOMVIEW_HEIGHT)];
        _bottomView.backgroundColor = [UIColor colorWithHex:THEME_COLOR];
    }
    return _bottomView;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = NSLocalizedString(@"accountname_restore_title", @"Restore Account");
//    [self setupSegmentControl];
    [self _setupSegment];
    [self initNodeCheck];
}
- (void)setupSegmentControl
{
    _segControl = [[UISegmentedControl alloc] initWithItems:[self getTitles]];
    [_segControl setFrame:CGRectMake(0, 0, self.view.width, kSEGMENTCONTROL_HEIGHT)];

    [_segControl setTintColor:[UIColor whiteColor]];
    [_segControl addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventValueChanged];
    [_segControl setBackgroundImage:[UIImage imageFromColor:kSEGMENTCONTROL_SELECT_COLOR withCGRect:CGRectMake(0, 0, self.view.width / 2, kSEGMENTCONTROL_HEIGHT)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [_segControl setBackgroundImage:[UIImage imageFromColor:[UIColor whiteColor] withCGRect:CGRectMake(0, 0, self.view.width / 2, kSEGMENTCONTROL_HEIGHT)] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    [_segControl setBackgroundImage:[UIImage imageFromColor:[UIColor whiteColor] withCGRect:CGRectMake(0, 0, self.view.width / 2, kSEGMENTCONTROL_HEIGHT)] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:DEFAULT_BLACK_COLOR,NSForegroundColorAttributeName,[UIFont fontWithName:FONT_NAME_REGULAR size:kSEGMENTCONTROL_TITLE_FONT_SIZE],NSFontAttributeName, nil];
    [_segControl setTitleTextAttributes:dic forState:UIControlStateNormal];
    NSDictionary *secDic = [NSDictionary dictionaryWithObjectsAndKeys:DEFAULT_BLACK_COLOR,NSForegroundColorAttributeName,[UIFont fontWithName:FONT_NAME_MEDIUM size:kSEGMENTCONTROL_TITLE_FONT_SIZE],NSFontAttributeName, nil];
    [_segControl setTitleTextAttributes:secDic forState:UIControlStateSelected];
    _segControl.selectedSegmentIndex = 0;

    [self.view addSubview:_segControl];
    
    [self.view addSubview:self.bottomView];
    [self.bottomView setCenter:CGPointMake(self.view.width / 4, _segControl.height - kBOTTOMVIEW_HEIGHT / 2)];
    
    

    [self initSubVC];
}

- (NSArray *)getTitles
{
    return @[NSLocalizedString(@"seed_recover", @"助记词恢复"),NSLocalizedString(@"encrypt_seed_recover", @"加密助记词恢复")];
}

- (void)initSubVC {
    
    _recoverVC = [[LZRecoverViewController alloc] init];
    _recoverVC.view.frame = CGRectMake(0, kSEGMENTCONTROL_HEIGHT, self.view.width, self.view.height - kSEGMENTCONTROL_HEIGHT);
    [self addChildViewController:_recoverVC];
    _encryptSeedVC = [[EncryptSeedRecoverController alloc] init];
    _encryptSeedVC.view.frame = CGRectMake(0, kSEGMENTCONTROL_HEIGHT, self.view.width, self.view.height - kSEGMENTCONTROL_HEIGHT);
    [self addChildViewController:_encryptSeedVC];
    
    _currentVC = _recoverVC;
    [self.view addSubview:_recoverVC.view];
    [self.view sendSubviewToBack:_recoverVC.view];
}


- (void)segmentChanged:(UISegmentedControl *)control
{
    if (control.selectedSegmentIndex == 0) {
        
        [self replaceFromOldViewController:_encryptSeedVC toNewViewController:_recoverVC];

    } else if (control.selectedSegmentIndex == 1) {
        
        [self replaceFromOldViewController:_recoverVC toNewViewController:_encryptSeedVC];

    }
    [self changeBottomViewToIndex:control.selectedSegmentIndex animation:YES];

}

- (void)replaceFromOldViewController:(UIViewController *)oldVc toNewViewController:(UIViewController *)newVc{

    [self addChildViewController:newVc];
    [self transitionFromViewController:oldVc toViewController:newVc duration:0.1 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:^(BOOL finished) {
        if (finished) {
            [newVc didMoveToParentViewController:self];
            [oldVc willMoveToParentViewController:nil];
            [oldVc removeFromParentViewController];
            self.currentVC = newVc;
        }else{
            self.currentVC = oldVc;
        }
        [self.view bringSubviewToFront:_segControl];
        [self.view bringSubviewToFront:self.bottomView];
    }];
    
}

- (void)changeBottomViewToIndex:(NSUInteger)index animation:(BOOL)animation
{
    CGFloat centerX = 0;
    if (index == 0) {
        centerX = self.view.width / 4;
        [_segControl setImage:[[self imageAtIndex:0 selectedState:YES] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forSegmentAtIndex:0];
        [_segControl setImage:[[self imageAtIndex:1 selectedState:NO] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forSegmentAtIndex:1];
    } else {
        centerX = self.view.width * 3 / 4;
        [_segControl setImage:[[self imageAtIndex:0 selectedState:NO] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forSegmentAtIndex:0];
        [_segControl setImage:[[self imageAtIndex:1 selectedState:YES] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forSegmentAtIndex:1];
    }
    if (animation) {
        
        [UIView animateWithDuration:0.3 animations:^{
            
            [self.bottomView setCenterX:centerX];
        }];
    } else {
        
        [self.bottomView setCenterX:centerX];
    }
}

#define KCHECK_BTN_TITLE_SIZE 14.f
- (void)initNodeCheck
{
    UIButton *checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    checkBtn.titleLabel.font = [UIFont fontWithName:FONT_NAME_REGULAR size:KCHECK_BTN_TITLE_SIZE];
    
    UIColor *btn_title_color = [UIColor blackColor];
    
    [checkBtn setFrame:CGRectMake(0, 0, 80,40)];
    [checkBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [checkBtn setTitle:NSLocalizedString(@"switch_service_node", @"") forState:UIControlStateNormal];
    [checkBtn addTarget:self action:@selector(checkNode:) forControlEvents:UIControlEventTouchUpInside];
    checkBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:checkBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)checkNode:(UIButton *)sender {
    
    NetworkStatusController *networkStatus = [[NetworkStatusController alloc] init];
    [self.navigationController pushViewController:networkStatus animated:YES];
}

#pragma mark - New Init SegmentedControl
- (void)_setupSegment
{
    // UIImageRenderingModeAlwaysOriginal 不传显示不出来
    UIImage *image1 = [[self imageAtIndex:0 selectedState:YES] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *image2 = [[self imageAtIndex:1 selectedState:NO] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _segControl = [[UISegmentedControl alloc] initWithItems:@[image1, image2]];
    [_segControl setFrame:CGRectMake(0, 0, self.view.width, kSEGMENTCONTROL_HEIGHT)];
    [_segControl setTintColor:[UIColor clearColor]];

    [_segControl addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventValueChanged];
    _segControl.selectedSegmentIndex = 0;
    
    [self.view addSubview:_segControl];
    
    [self.view addSubview:self.bottomView];
    [self.bottomView setCenter:CGPointMake(self.view.width / 4, _segControl.height - kBOTTOMVIEW_HEIGHT / 2)];

    [self initSubVC];
}
// 根据index和选中状态 生成图片
- (UIImage *)imageAtIndex:(NSInteger)index selectedState:(BOOL)l_isSelected
{
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.width / 2, kSEGMENTCONTROL_HEIGHT)];
    lbl.backgroundColor = !l_isSelected ? kSEGMENTCONTROL_SELECT_COLOR : [UIColor whiteColor];
    lbl.font = [UIFont fontWithName:l_isSelected ? FONT_NAME_MEDIUM : FONT_NAME_REGULAR size:kSEGMENTCONTROL_TITLE_FONT_SIZE];
    lbl.textColor = DEFAULT_BLACK_COLOR;
    lbl.text = [[self getTitles] objectAtIndex:index];
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.adjustsFontSizeToFitWidth = YES;
    UIImage *image = [UIImage imageFromView:lbl];
    return image;
}


@end
