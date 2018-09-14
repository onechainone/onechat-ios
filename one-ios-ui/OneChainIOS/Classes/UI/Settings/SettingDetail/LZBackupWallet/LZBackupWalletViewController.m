//
//  LZBackupWalletViewController.m
//  LZEasemob3
//
//  Created by chunzheng wang on 2017/11/14.
//  Copyright © 2017年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "LZBackupWalletViewController.h"
#import <SVProgressHUD.h>
#import "LZTabBarController.h"
#import "LZVerifyWordViewController.h"



#ifdef def_eos_support


#endif

//scrollview 的高
#define ScrollViewHeight 850

@interface LZBackupWalletViewController ()
@property (nonatomic,strong)UILabel *miyuLabel;
@property (nonatomic,strong)UIScrollView *scrollView;

@end

@implementation LZBackupWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //title_activity_backup_seed 备份恢复钱包密码
    self.title = NSLocalizedString(@"title_activity_backup_seed", nil);
    //    self.view.backgroundColor = [UIColor whiteColor];
    if (_needVerifyWord) {
        
        self.navigationItem.rightBarButtonItem = nil;
    }
    if (_hideBlack) {
        self.navigationItem.leftBarButtonItem = nil;
        //        self.navigationItem.leftBarButtonItem.tintColor = [UIColor clearColor];
        self.navigationItem.hidesBackButton = YES;
    } else {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClick)];
        
    }
    
//    self.view.backgroundColor = [UIColor colorWithHex:BACKGROUND_COLOR];
    self.view.backgroundColor = THMColor(@"bg_white_color");
    [self setupUI];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userDidTakeScreenshot:)
                                                 name:UIApplicationUserDidTakeScreenshotNotification object:nil];
    
}
- (void)userDidTakeScreenshot:(NSNotification *)notification
{
    [[UIAlertController shareAlertController] showAlertcWithString:NSLocalizedString(@"no_screen_shoot", @"") controller:self];
    
    ///// 这个地方 更换助记词
}

- (void)setupUI {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenW, self.view.bounds.size.height)];
    
    self.scrollView = scrollView;
//    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.backgroundColor = THMColor(@"bg_white_color");
    //    scrollView.center = self.view.center;
    //    scrollView.contentInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    scrollView.contentSize = CGSizeMake(KScreenW, ScrollViewHeight);
    [self.view addSubview: scrollView];
    self.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    //提示 私钥不能告诉任何人,请妥善保管好以下密语,一旦丢失,将不可恢复!
    //save_key_tip
    UILabel *tipsLabel = [UILabel makeLabelWithTextColor:[UIColor colorWithHex:GAY_COLOR] andTextFont:LABEL_FRONT andContentText:NSLocalizedString(@"save_key_tip", nil)];
    tipsLabel.themeMap = @{
                           TextColorName:@"back_up_text_color"
                           };
    tipsLabel.numberOfLines = 0;
    [self.scrollView addSubview:tipsLabel];
    [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(LEFT_SPACE);
        make.left.offset(LEFT_SPACE);
        //        make.right.offset(-RIGHT_SPACE);
        make.width.offset(KScreenW-LEFT_SPACE-RIGHT_SPACE);
        
    }];
    [tipsLabel sizeToFit];
    //    tipsLabel.textAlignment = UITextAlignmentCenter;
    //长按复制 long_click_copy
    UILabel *tipLabel = [UILabel makeLabelWithTextColor:[UIColor blackColor] andTextFont:LITTLE_LABEL_FRONT andContentText:@""];
    tipLabel.themeMap = @{
                          TextColorName:@"back_up_text_color"
                          };

    [self.scrollView addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipsLabel.mas_bottom).offset(LARGE_SPACE);
        //        make.left.equalTo(tipsLabel.mas_left).offset(0);
        make.left.offset(LEFT_SPACE);
        make.width.offset(KScreenW);
    }];
    tipLabel.textAlignment = NSTextAlignmentLeft;
    
    //    //密语label
    UILabel *miyuLabel = [UILabel makeLabelWithTextColor:[UIColor colorWithHex:BTN_BACKGROUNDCOLOR] andTextFont:SEED_LABEL_FRONT andContentText:@""];
    miyuLabel.themeMap = @{
                           TextColorName:@"theme_color"
                           };
    
    miyuLabel.text = self.seed;
    
    self.miyuLabel = miyuLabel;
    
    miyuLabel.numberOfLines = 0;
    [self.scrollView addSubview:miyuLabel];
    [miyuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipLabel.mas_bottom).offset(MID_SPACE);
        //        make.right.offset(-RIGHT_SPACE);
        make.left.equalTo(tipLabel.mas_left).offset(SPEACE_ZERO);
        make.width.offset(KScreenW-LEFT_SPACE-RIGHT_SPACE);
    }];
    //添加长按手势
    self.miyuLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *longPress = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(longPre:)];
    [self.miyuLabel addGestureRecognizer:longPress];

    
    
    UIButton *savaBtn  = [UIButton new];
    savaBtn.themeMap = @{
                         BGColorName:@"theme_color",
                         TextColorName:@"theme_title_color"
                         };

    [savaBtn setTitle:NSLocalizedString(@"action_have_saved", nil) forState:UIControlStateNormal];
    [self.scrollView addSubview:savaBtn];
    [savaBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tipLabel.mas_left).offset(SPEACE_ZERO);
        //        make.right.offset(-RIGHT_SPACE);
        make.width.offset(KScreenW-LEFT_SPACE-RIGHT_SPACE); make.top.equalTo(miyuLabel.mas_bottom).offset(LARGE_SPACE);
        make.height.offset(BTN_HEIGHT);
        
    }];
    [savaBtn addTarget:self action:@selector(savaBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)savaBtnClick {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:NSLocalizedString(@"make_sure_save_seed", nil) preferredStyle:UIAlertControllerStyleAlert];
    ///取消 button_cancel
    UIAlertAction *cancelAction =[UIAlertAction actionWithTitle:NSLocalizedString(@"button_cancel", nil) style:UIAlertActionStyleCancel handler:nil];
    [cancelAction setValue:[UIColor lightGrayColor] forKeyPath:@"titleTextColor"];
    //确认 button_confirm
    UIAlertAction *confirmAction =[UIAlertAction actionWithTitle:NSLocalizedString(@"button_confirm", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if( self.fromWhere == LZBackupWalletViewControllerSource_Reg ) {
            
            ///存在才验证
            if (self.needVerifyWord) {
                LZVerifyWordViewController *verityVC = [LZVerifyWordViewController new];
                verityVC.seed = self.seed;
                [self.navigationController pushViewController:verityVC animated:YES];
            } else{
                // 我们要把系统windown的rootViewController替换掉
                LZTabBarController *tab = [[LZTabBarController alloc] init];
                [UIApplication sharedApplication].keyWindow.rootViewController = tab;
            }
            
            
            
            
            
            //            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SWITCH_ROOT_VIEWCONTROLLER object:nil];
        }
        
    }];
    
    [confirmAction setValue:[UIColor orangeColor] forKeyPath:@"titleTextColor"];
    
    [alertVC addAction:confirmAction];
    
    [alertVC addAction:cancelAction];
    
    [self presentViewController:alertVC animated:YES completion:nil];
    
    
    
    //    [self.navigationController popViewControllerAnimated:YES];
    //[self.navigationController popToRootViewControllerAnimated:YES];
    
    
    
}
- (void)longPre:(UILongPressGestureRecognizer *)recognizer{
//    [self becomeFirstResponder]; // 用于UIMenuController显示，缺一不
//
    
#if as_is_dev_mode
    
    BOOL state = [[CoinTools sharedCoinTools] copyToPasteboardWithString:self.miyuLabel.text];
    if (state) {
        //copied_to_clipboard 复制到剪贴板
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"copied_to_clipboard", nil)];
        [SVProgressHUD dismissWithDelay:1.0f];
    } else {
        //copy_fail
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"copy_fail", nil)];
        [SVProgressHUD dismissWithDelay:1.0f];
    }
    
#else

#endif
    
    
}
- (void)backBtnClick {
    
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
