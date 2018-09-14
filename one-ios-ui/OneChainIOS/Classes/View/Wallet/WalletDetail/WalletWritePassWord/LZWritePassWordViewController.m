//
//  LZWritePassWordViewController.m
//  LZEasemob3
//
//  Created by chunzheng wang on 2017/11/13.
//  Copyright © 2017年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "LZWritePassWordViewController.h"
#import "LZBackupWalletViewController.h"
#import "ZYKeyboardUtil.h"
#import "LZCannotDecryptPasswordViewController.h"





#define MARGIN_KEYBOARD 10
@interface LZWritePassWordViewController ()
@property (weak, nonatomic) IBOutlet UIView *PassView;
@property (weak, nonatomic) IBOutlet UITextField *passWordText;
@property (weak, nonatomic) IBOutlet UIImageView *backgoundImg;
@property (weak, nonatomic) IBOutlet UILabel *jieMiLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UILabel *changeAccountAndPassword;
@property (weak, nonatomic) IBOutlet UIImageView *underLineView;
@property (weak, nonatomic) IBOutlet UIImageView *modalBGView;

//键盘
@property (strong, nonatomic) ZYKeyboardUtil *keyboardUtil;


@end

@implementation LZWritePassWordViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.passWordText.text = @"";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //解密钱包 unlock_wallet_title accountname_create_password_tips
    //    self.passWordText.placeholder = NSLocalizedString(@"enter_password", nil);
    //    self.passWordText.becomeFirstResponder = YES;
    self.view.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.3];

    if ([[ONEThemeManager sharedInstance].theme.theme_id isEqualToString:@"2"]) {
        self.modalBGView.hidden = YES;
    }
    
    self.PassView.themeMap = @{
                               BGColorName:@"bg_white_color"
                               };
    self.jieMiLabel.themeMap = @{
                                 TextColorName:@"conversation_title_color"
                                 };
    self.changeAccountAndPassword.themeMap = @{
                                               TextColorName:@"conversation_title_color"
                                               };
    self.passWordText.backgroundColor = [UIColor clearColor];
    self.passWordText.themeMap = @{
                                   TextColorName:@"conversation_title_color"
                                   };
    self.underLineView.image = nil;
    self.underLineView.themeMap = @{
                                    BGColorName:@"conversation_line_color"
                                    };
    
    [self.passWordText becomeFirstResponder];
    self.jieMiLabel.text = NSLocalizedString(@"unlock_wallet_title", nil);
    self.changeAccountAndPassword.text =NSLocalizedString(@"enter_password", nil);
    //取消 button_cancel button_ok
    [self.cancelBtn setTitle:NSLocalizedString(@"button_cancel", nil) forState:UIControlStateNormal];
    [self.confirmBtn setTitle:NSLocalizedString(@"button_ok", nil) forState:UIControlStateNormal];
    self.passWordText.secureTextEntry = YES;
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tap1.cancelsTouchesInView = NO;
    [self.backgoundImg addGestureRecognizer:tap1];
    self.backgoundImg.userInteractionEnabled = YES;
    //解决键盘遮挡
    self.passWordText.delegate = self;
    
    _PassView.layer.cornerRadius = MODAL_CIRCULAR;
    [_PassView.layer setMasksToBounds:YES];
    
    [self configKeyBoardRespond];
    
}
-(void)viewTapped:(UITapGestureRecognizer*)tap1
{
    [self dismissViewControllerAnimated:NO completion:nil];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
}
- (IBAction)confrimBtnClick:(id)sender {
    
    
    //    if ([self.type isEqualToString:SEND_WRITEPASSWORDTYPE]) {
    //
    //        // [self buildTransWithBitCoin];
    //
    //        [self buildTranscation];
    //
    //    }
    
    //    if ([self.type isEqualToString:VERIFICATION_WRITEPASSWORDTYPE]) {
    NSLog(@"备份账号");
    NSString *seed = [ONEChatClient seedWithPassword:self.passWordText.text];
    if (seed) {
        self.block(seed);
        [self dismissViewControllerAnimated:NO completion:nil];
        
    } else{
//        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"LZCannotDecryptPasswordViewController" bundle:nil];
//        //LZCannotDecryptPasswordViewController
//        LZCannotDecryptPasswordViewController *CannotShowWindowVC = [sb instantiateViewControllerWithIdentifier:@"LZCannotDecryptPasswordViewController"];
//        CannotShowWindowVC.type = BACKUPMODALERROR_TYPE;
//
//        [self presentViewController:CannotShowWindowVC animated:NO completion:nil];
        
//        [[UIAlertController shareAlertController] showTitleAlertcWithString:NSLocalizedString(@"unlocking_wallet_error_detail", nil) andTitle:NSLocalizedString(@"unlocking_wallet_error_title", nil) controller:self];
        
        //button_retry button_cancel
        [[UIAlertController shareAlertController] showTwoChoiceAlertcWithTitleString:NSLocalizedString(@"unlocking_wallet_error_title", nil) andMsg:NSLocalizedString(@"unlocking_wallet_error_detail", nil) andLeftBtnStr:NSLocalizedString(@"button_cancel", nil) andRightBtnStr:NSLocalizedString(@"button_retry", nil) andRightBlock:^{
            self.passWordText.text = @"";
        } controller:self];
        
        
    }
    
}


- (IBAction)cancelBtn:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}




- (void)configKeyBoardRespond {
    self.keyboardUtil = [[ZYKeyboardUtil alloc] initWithKeyboardTopMargin:MARGIN_KEYBOARD];
    __weak LZWritePassWordViewController *weakSelf = self;
#pragma explain - 全自动键盘弹出/收起处理 (需调用keyboardUtil 的 adaptiveViewHandleWithController:adaptiveView:)
#pragma explain - use animateWhenKeyboardAppearBlock, animateWhenKeyboardAppearAutomaticAnimBlock will be invalid.
    [_keyboardUtil setAnimateWhenKeyboardAppearAutomaticAnimBlock:^(ZYKeyboardUtil *keyboardUtil) {
        [keyboardUtil adaptiveViewHandleWithController:weakSelf adaptiveView:weakSelf.passWordText, nil];
    }];
    /*  or
     [_keyboardUtil setAnimateWhenKeyboardAppearAutomaticAnimBlock:^(ZYKeyboardUtil *keyboardUtil) {
     [keyboardUtil adaptiveViewHandleWithAdaptiveView:weakSelf.inputViewBorderView, weakSelf.secondTextField, weakSelf.thirdTextField, nil];
     }];
     */
    
#pragma explain - 自定义键盘弹出处理(如配置，全自动键盘处理则失效)
#pragma explain - use animateWhenKeyboardAppearAutomaticAnimBlock, animateWhenKeyboardAppearBlock must be nil.
    /*
     [_keyboardUtil setAnimateWhenKeyboardAppearBlock:^(int appearPostIndex, CGRect keyboardRect, CGFloat keyboardHeight, CGFloat keyboardHeightIncrement) {
     NSLog(@"\n\n键盘弹出来第 %d 次了~  高度比上一次增加了%0.f  当前高度是:%0.f"  , appearPostIndex, keyboardHeightIncrement, keyboardHeight);
     //do something
     }];
     */
    
#pragma explain - 自定义键盘收起处理(如不配置，则默认启动自动收起处理)
#pragma explain - if not configure this Block, automatically itself.
    /*
     [_keyboardUtil setAnimateWhenKeyboardDisappearBlock:^(CGFloat keyboardHeight) {
     NSLog(@"\n\n键盘在收起来~  上次高度为:+%f", keyboardHeight);
     //do something
     }];
     */
    
#pragma explain - 获取键盘信息
    [_keyboardUtil setPrintKeyboardInfoBlock:^(ZYKeyboardUtil *keyboardUtil, KeyboardInfo *keyboardInfo) {
        // NSLog(@"\n\n拿到键盘信息 和 ZYKeyboardUtil对象");
    }];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.passWordText resignFirstResponder];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.passWordText resignFirstResponder];
    
    return YES;
}

@end
