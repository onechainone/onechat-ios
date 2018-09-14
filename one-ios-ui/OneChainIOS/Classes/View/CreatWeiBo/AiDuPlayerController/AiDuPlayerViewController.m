//
//  AiDuPlayerViewController.m
//  CancerDo
//
//  Created by hugaowei on 2017/2/14.
//  Copyright © 2017年 hepingtianxia. All rights reserved.
//

#import "AiDuPlayerViewController.h"

@interface AiDuPlayerViewController ()

@property (nonatomic,strong)AiDuVideoPlayer *playerView;

@end

@implementation AiDuPlayerViewController

@synthesize titleView;

- (AiDuVideoPlayer *)playerView {
    if (!_playerView) {
        _playerView = [[AiDuVideoPlayer alloc] init];
        _playerView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        
        _playerView.completedPlayingBlock = ^(AiDuVideoPlayer *player) {
            [player playPause];
        };
        
        __weak typeof(self) weakSelf = self;
        
        _playerView.showBottomBlock = ^(AiDuVideoPlayer *player){
            if (weakSelf) {
                if (player.barHiden) {
                    weakSelf.titleView.hidden = NO;
                    [UIApplication sharedApplication].statusBarHidden = NO;
                }else{
                    weakSelf.titleView.hidden = YES;
                    [UIApplication sharedApplication].statusBarHidden = YES;
                }
            }
        };
    }
    return _playerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBarHidden = YES;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoBack) name:@"AVPlayerStatusFailed" object:nil];
    
    titleView = [[YouKuVideoTitleView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    titleView.delegate = self;
//    titleView.title = [NSString stringWithFormat:@"%@的视频",self.nickName];
    titleView.title = @"";
    
    [self.view addSubview:titleView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.playerView.videoUrl = self.videoURL;
    
    [self.view addSubview:self.playerView];
    
    [self.view bringSubviewToFront:titleView];
    
    [self.playerView playPause];
    [self.playerView show];
}

#pragma mark 返回


- (void)gotoBack{
    if ([self isDeviceOrientationPortrait]) {
        if (self.navigationController && self.navigationController.presentingViewController) {
            [UIApplication sharedApplication].statusBarHidden = NO;
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
        
    }else{
        [self qieHuanScreen:nil];
    }
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.playerView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    titleView.frame  = CGRectMake(0, 0, self.view.frame.size.width, 64);
}

- (void)interfaceOrientation:(UIInterfaceOrientation)orientation
{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector             = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val                  = orientation;
        
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

- (BOOL)shouldAutorotate{
    return NO;
}

#pragma mark  切换横竖屏
- (void)qieHuanScreen:(UIButton *)btn{
    
    if ([self isDeviceOrientationPortrait]) {
        [self interfaceOrientation:UIInterfaceOrientationLandscapeRight];
    }else{
        [self interfaceOrientation:UIInterfaceOrientationPortrait];
    }
}

- (BOOL)isDeviceOrientationPortrait
{
    UIInterfaceOrientation o = [[UIApplication sharedApplication] statusBarOrientation];
    
    return o == UIInterfaceOrientationPortrait;
}

- (void)dealloc{
    [_playerView destroyPlayer];
    _playerView = nil;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
