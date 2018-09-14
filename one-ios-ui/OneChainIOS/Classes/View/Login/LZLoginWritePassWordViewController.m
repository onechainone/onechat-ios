//
//  LZLoginWritePassWordViewController.m
//  LZEasemob3
//
//  Created by chunzheng wang on 2017/12/5.
//  Copyright © 2017年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "LZLoginWritePassWordViewController.h"
#import "LZLoginModalPasswordViewController.h"
#import "LZRecoverViewController.h"
#import "RedPacketMngr.h"
#import "UIView+DebugMode.h"
@interface LZLoginWritePassWordViewController ()
@property (weak, nonatomic) IBOutlet UILabel *changeWallet;
@property (weak, nonatomic) IBOutlet UILabel *changeTouch;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

@end

@implementation LZLoginWritePassWordViewController
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //去掉透明后导航栏下边的黑边
    [self.navigationController.navigationBar setHidden:YES];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.themeMap = @{
                           BGColorName:@"bg_white_color"
                           };
    self.bgImageView.hidden = YES;
//    self.bgImageView.image = nil;
//    self.bgImageView.backgroundColor = [UIColor clearColor];
    self.changeWallet.themeMap = @{
                                   TextColorName:@"common_text_color"
                                   };
    self.changeTouch.themeMap = @{
                                  TextColorName:@"common_text_color"
                                  };
    //钱包已加密 wallet_locked_message
    self.changeWallet.text = NSLocalizedString(@"wallet_locked_message", nil);
    //触摸解锁touch_to_decrypt_wallet
    self.changeTouch.text = NSLocalizedString(@"touch_to_decrypt_wallet", nil);
    
    [self modalPasswordVC];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (IBAction)lockBtnClick:(id)sender {
    [self modalPasswordVC];
    
}
-(void)modalPasswordVC {
    //    LZLoginModalPasswordViewController *modalVC = [LZLoginModalPasswordViewController new];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"LZLoginModalPasswordViewController" bundle:nil];
    
    LZLoginModalPasswordViewController *modalVC = [sb instantiateViewControllerWithIdentifier:@"LZLoginModalPasswordViewController"];
//    modalVC.block = ^{
//
//        !self.succBlock ?: self.succBlock();
////    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SWITCH_ROOT_VIEWCONTROLLER object:nil];
//
//    };
    modalVC.block = ^(NSString *seed) {
//        !self.succBlock ?: self.succBlock();
//        !self.succBlock ?:self.succ
        self.succBlock(seed);
        
    };
    
    modalVC.forgetPasswordblock = ^{
        
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_SWITCHROOT object:@(RootControllerTypeRegister)];

    };
    
    modalVC.type = CONFIRMLOGIN_TYPE;
    modalVC.modalPresentationStyle = UIModalPresentationCustom;
    
    [self presentViewController:modalVC animated:NO completion:nil];
    
}

- (void)clearNavi
{
    NSMutableArray *mVcs = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    __block LZRecoverViewController *recover = nil;
    [mVcs enumerateObjectsUsingBlock:^(UIViewController *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (![obj isKindOfClass:[LZRecoverViewController class]]) {
            
            [mVcs removeObject:obj];
            *stop = NO;
        }
    }];
    self.navigationController.viewControllers = mVcs;
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
}



@end
