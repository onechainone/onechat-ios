//
//  LZLoginModalPasswordViewController.m
//  LZEasemob3
//
//  Created by chunzheng wang on 2017/12/5.
//  Copyright © 2017年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "LZLoginModalPasswordViewController.h"
#import "LZCannotDecryptPasswordViewController.h"
#import "ZYKeyboardUtil.h"
#define MARGIN_KEYBOARD 80
#define LOCAL_IHPHONEFIVEFRONT 14
@interface LZLoginModalPasswordViewController ()
@property (weak, nonatomic) IBOutlet UILabel *changeWriteAccountAndPasswordLabel;
@property (weak, nonatomic) IBOutlet UIButton *changeForgetPasswordBtn;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *changeCancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *changeConfirmBtn;
@property (weak, nonatomic) IBOutlet UIView *passView;
@property (weak, nonatomic) IBOutlet UIImageView *underLineView;
@property (weak, nonatomic) IBOutlet UIImageView *modalBGView;
//键盘
@property (strong, nonatomic) ZYKeyboardUtil *keyboardUtil;

@end

@implementation LZLoginModalPasswordViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.passwordTextField.text = @"";

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor = [UIColor colorWithWhite:0.f alpha:MODAL_ALPHA];

    if ([[ONEThemeManager sharedInstance].theme.theme_id isEqualToString:@"2"]) {
        self.modalBGView.hidden = YES;
    }

    self.passView.themeMap = @{
                               BGColorName:@"bg_white_color"
                               };
    self.changeWriteAccountAndPasswordLabel.themeMap = @{
                                                         TextColorName:@"conversation_title_color"
                                                         };
    self.passwordTextField.backgroundColor = [UIColor clearColor];
    self.passwordTextField.themeMap = @{
                                        TextColorName:@"conversation_title_color"
                                        };
    self.underLineView.image = nil;
    self.underLineView.themeMap = @{
                                    BGColorName:@"conversation_line_color"
                                    };
    self.changeCancelBtn.themeMap = @{
                                      TextColorName:@"conversation_detail_color"
                                      };
    self.changeConfirmBtn.themeMap = @{
                                       TextColorName:@"theme_color"
                                       };
    
//    [self.passwordTextField becomeFirstResponder];
    self.passwordTextField.delegate = self;
    self.passwordTextField.secureTextEntry = YES;

    //输入账户和密码
    self.changeWriteAccountAndPasswordLabel.text = NSLocalizedString(@"enter_password", nil);
    self.changeWriteAccountAndPasswordLabel.adjustsFontSizeToFitWidth = YES;
    ///忘记密码 forget_password
    [self.changeForgetPasswordBtn setTitle:NSLocalizedString(@"forget_password", nil) forState:UIControlStateNormal];
    self.changeForgetPasswordBtn.titleLabel.adjustsFontSizeToFitWidth = YES;

    //取消 button_cancel
    [self.changeCancelBtn setTitle:NSLocalizedString(@"button_cancel", nil) forState:UIControlStateNormal];
    //确认 button_confirm
    [self.changeConfirmBtn setTitle:NSLocalizedString(@"button_confirm", nil) forState:UIControlStateNormal];
    [self configKeyBoardRespond];
    _passView.layer.cornerRadius = MODAL_CIRCULAR;
    [_passView.layer setMasksToBounds:YES];

    if(KScreenW == IPHONEFIVESCREENH) {
        self.changeWriteAccountAndPasswordLabel.font = [UIFont systemFontOfSize:LOCAL_IHPHONEFIVEFRONT];

        self.changeForgetPasswordBtn.font = [UIFont systemFontOfSize:LOCAL_IHPHONEFIVEFRONT];

    }
    [self.passwordTextField becomeFirstResponder];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)cancelBtnClick:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
    
}
- (IBAction)confirmBtnClick:(id)sender {
    ///登录的类型
    [self.view endEditing:YES];
    if ([self.type isEqualToString:CONFIRMLOGIN_TYPE]) {
        
        BOOL state = [ONEChatClient verifyAccountWithPassword:self.passwordTextField.text];
        
        if(state) {
            self.block(self.passwordTextField.text);
            [self dismissViewControllerAnimated:NO completion:nil];
        }else {
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"LZCannotDecryptPasswordViewController" bundle:nil];
            LZCannotDecryptPasswordViewController *CannotShowWindowVC = [sb instantiateViewControllerWithIdentifier:@"LZCannotDecryptPasswordViewController"];
            CannotShowWindowVC.type = LOGINMODALERROR_TYPE;
            
            [self presentViewController:CannotShowWindowVC animated:NO completion:nil];
        }
        
    }
    
}
- (IBAction)forgetPasswordBtnClick:(id)sender {
    [self showWarning];
    
}

- (void)showWarning
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"override_new_wallet_warning_message", @"") preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ensureAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"action_ok", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[ONEChatClient sharedClient] clearContext];
        [ONEThemeManager resetTheme];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:KUSERDEFAULT_KEY_EXPORT_ENCRYPT_SEED];
        [[NSUserDefaults standardUserDefaults] synchronize];
        self.forgetPasswordblock();
        [self dismissViewControllerAnimated:NO completion:^{
        }];
        
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"button_cancel", @"") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:ensureAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

//解决键盘遮挡
- (void)configKeyBoardRespond {
    self.keyboardUtil = [[ZYKeyboardUtil alloc] initWithKeyboardTopMargin:MARGIN_KEYBOARD];
    __weak LZLoginModalPasswordViewController *weakSelf = self;
#pragma explain - 全自动键盘弹出/收起处理 (需调用keyboardUtil 的 adaptiveViewHandleWithController:adaptiveView:)
#pragma explain - use animateWhenKeyboardAppearBlock, animateWhenKeyboardAppearAutomaticAnimBlock will be invalid.
    [_keyboardUtil setAnimateWhenKeyboardAppearAutomaticAnimBlock:^(ZYKeyboardUtil *keyboardUtil) {
        [keyboardUtil adaptiveViewHandleWithController:weakSelf adaptiveView:weakSelf.passView,weakSelf.passwordTextField, nil];
    }];
    
}
#pragma mark delegate
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.passwordTextField resignFirstResponder];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.passwordTextField resignFirstResponder];
    return YES;
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    
}
- (void)dealloc
{
    
}

@end
