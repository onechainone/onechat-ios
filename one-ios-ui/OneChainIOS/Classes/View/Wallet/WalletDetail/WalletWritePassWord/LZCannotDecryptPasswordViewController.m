//
//  LZCannotDecryptPasswordViewController.m
//  LZEasemob3
//
//  Created by chunzheng wang on 2017/12/5.
//  Copyright © 2017年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "LZCannotDecryptPasswordViewController.h"
#import "LZWritePassWordViewController.h"
#import "LZLoginModalPasswordViewController.h"

@interface LZCannotDecryptPasswordViewController ()
@property (weak, nonatomic) IBOutlet UILabel *changeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *changedesLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *againBtn;
@property (weak, nonatomic) IBOutlet UIView *PassView;

@end

@implementation LZCannotDecryptPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0.f alpha:MODAL_ALPHA];
    //    [self.presentingViewController dismissViewControllerAnimated:NO completion:nil];
    
    //无法解密钱包
    self.changeTitleLabel.text = NSLocalizedString(@"unlocking_wallet_error_title", nil);
    self.changeTitleLabel.adjustsFontSizeToFitWidth = YES;
    //密码是否正确unlocking_wallet_error_detail
    self.changedesLabel.text = NSLocalizedString(@"unlocking_wallet_error_detail", nil);
    self.changedesLabel.adjustsFontSizeToFitWidth = YES;
    //取消
    [self.cancelBtn setTitle:NSLocalizedString(@"cancel", nil) forState:UIControlStateNormal];
    
    [self.againBtn setTitle:NSLocalizedString(@"button_retry", nil) forState:UIControlStateNormal];
    _PassView.layer.cornerRadius = MODAL_CIRCULAR;
    [_PassView.layer setMasksToBounds:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)againBtnClick:(id)sender {
    if ([self.type isEqualToString:BACKUPMODALERROR_TYPE]) {
        //备份钱包错误
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"LZWritePassWordViewController" bundle:nil];
        
        LZWritePassWordViewController *HSQShowWindowVC = [sb instantiateViewControllerWithIdentifier:@"LZWritePassWordViewController"];
        
        HSQShowWindowVC.modalPresentationStyle = UIModalPresentationCustom;
        
        //        HSQShowWindowVC.type = VERIFICATION_WRITEPASSWORDTYPE;
        
        [self presentViewController:HSQShowWindowVC animated:NO completion:nil];
        [self.presentingViewController dismissViewControllerAnimated:NO completion:nil];
    }
    if ([self.type isEqualToString:LOGINMODALERROR_TYPE]) {
        ///登录错误
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"LZLoginModalPasswordViewController" bundle:nil];
        
        LZLoginModalPasswordViewController *writepassVC = [sb instantiateViewControllerWithIdentifier:@"LZLoginModalPasswordViewController"];
        
        writepassVC.modalPresentationStyle = UIModalPresentationCustom;
        
        writepassVC.type = CONFIRMTRADE_TYPE;
        
        [self presentViewController:writepassVC animated:NO completion:nil];
        
        [self.presentingViewController dismissViewControllerAnimated:NO completion:nil];
    }
    if ([self.type isEqualToString:TRADEMODALERROR_TYPE]) {
        ///交易错误
        NSLog(@"交易错误");
    } if ([self.type isEqualToString:ADDMONEYMODALERROR_TYPE]) {
        //        //添加币密码错误
        //        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"WalletDetailAddMoneyViewController" bundle:nil];
        //
        //        WalletDetailAddMoneyViewController *HSQShowWindowVC = [sb instantiateViewControllerWithIdentifier:@"DetailAddMoney"];
        //        HSQShowWindowVC.modalPresentationStyle = UIModalPresentationCustom;
        //        //    self.datas[indexPath.row]
        //        HSQShowWindowVC.name = self.results[indexPath.row];
        //
        //        [self presentViewController:HSQShowWindowVC animated:NO completion:nil];
    }
    
    
    
}
- (IBAction)cancelBtnClick:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
    [self.presentingViewController.presentingViewController dismissViewControllerAnimated:NO completion:nil];
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
