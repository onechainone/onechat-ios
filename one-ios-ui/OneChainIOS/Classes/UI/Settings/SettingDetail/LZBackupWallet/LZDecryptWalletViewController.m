//
//  LZDecryptWalletViewController.m
//  LZEasemob3
//
//  Created by chunzheng wang on 2017/11/14.
//  Copyright © 2017年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "LZDecryptWalletViewController.h"
#import "LZWritePassWordViewController.h"
#import "LZBackupWalletViewController.h"
#import "LZCannotDecryptPasswordViewController.h"
#import "DecryptWalletSegmentController.h"

#define QianNaoJiamiLabelCenterY 50
#define JieSuoBtnWith 55
@interface LZDecryptWalletViewController ()

@end

@implementation LZDecryptWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor colorWithHex:BACKGROUND_COLOR];
    self.view.backgroundColor = THMColor(@"bg_white_color");
    
    //title_activity_backup_seed 备份恢复钱包密码
    self.title = NSLocalizedString(@"title_activity_backup_seed", nil);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:THMImage(@"nav_back_btn") style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClick)];
    
    [self modalPassword];
    [self setupUI];
    
}
- (void)modalPassword {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"LZWritePassWordViewController" bundle:nil];
    
    LZWritePassWordViewController *HSQShowWindowVC = [sb instantiateViewControllerWithIdentifier:@"LZWritePassWordViewController"];
    
    HSQShowWindowVC.modalPresentationStyle = UIModalPresentationCustom;
    //跳转页面的block
    //    HSQShowWindowVC.block = ^{
    //
    //        LZBackupWalletViewController *backVC = [LZBackupWalletViewController new];
    //        [self.navigationController pushViewController:backVC animated:YES];
    //
    //    };
    HSQShowWindowVC.type = VERIFICATION_WRITEPASSWORDTYPE;
    
    [self presentViewController:HSQShowWindowVC animated:NO completion:nil];
    
    HSQShowWindowVC.block = ^(NSString *passwrd) {
//        LZBackupWalletViewController *backVC = [LZBackupWalletViewController new];
//        backVC.needVerifyWord = self.needVerifyWord;
//        backVC.hideBlack = self.hideBlack;
//
//        [self.navigationController pushViewController:backVC animated:YES];
//        backVC.seed = passwrd;
        
        DecryptWalletSegmentController *decryptController = [[DecryptWalletSegmentController alloc] init];
        decryptController.seed = passwrd;
        [self.navigationController pushViewController:decryptController animated:NO];
        NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
        [viewControllers removeObjectAtIndex:1];
        self.navigationController.viewControllers = viewControllers;
        
//        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SWITCH_ROOT_VIEWCONTROLLER object:nil];
        
    };
    
    
}
- (void)setupUI {
    //wallet_locked_message 钱包已加密
    UILabel *qianbaojiamiLabel = [UILabel makeLabelWithTextColor:[UIColor blackColor] andTextFont:LABEL_FRONT andContentText:NSLocalizedString(@"wallet_locked_message", nil)];
    qianbaojiamiLabel.themeMap = @{
                                   TextColorName:@"conversation_title_color"
                                   };
    [self.view addSubview:qianbaojiamiLabel];
    [qianbaojiamiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(SPEACE_ZERO);
        make.centerY.offset(-QianNaoJiamiLabelCenterY);
        
    }];
    UIButton *jiesuoBtn = [UIButton new];
    [jiesuoBtn setImage:[UIImage imageNamed:@"lock_icon"] forState:UIControlStateNormal];
    [self.view addSubview:jiesuoBtn];
    [jiesuoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(SPEACE_ZERO);
        make.centerY.offset(SPEACE_ZERO);
        make.width.height.offset(JieSuoBtnWith);
        
    }];
    [jiesuoBtn addTarget:self action:@selector(jiesuoBtnClick) forControlEvents:UIControlEventTouchUpInside];
    //触摸解锁 touch_to_decrypt_wallet
    UILabel *chumoLabel = [UILabel makeLabelWithTextColor:[UIColor colorWithHex:GAY_COLOR] andTextFont:LITTLE_LABEL_FRONT andContentText:NSLocalizedString(@"touch_to_decrypt_wallet", nil)];
    chumoLabel.themeMap = @{
                            TextColorName:@"conversation_title_color"
                            };
    [self.view addSubview:chumoLabel];
    [chumoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(jiesuoBtn.mas_bottom).offset(LITTLE_SPACE);
        make.centerX.offset(SPEACE_ZERO);
    }];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)jiesuoBtnClick {
    
    [self modalPassword];
}
- (void)backBtnClick {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}




@end
