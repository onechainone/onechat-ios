//
//  EncryptSeedRecoverController.m
//  OneChainIOS
//
//  Created by lifei on 2018/3/7.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "EncryptSeedRecoverController.h"
#import "UIViewController+DismissKeyboard.h"
#import "ZYKeyboardUtil.h"
#import "EncryptSeedAlertView.h"
#import "CoinTools.h"

#define kTEXT_DEFAULT_FONT_SIZE 12.f
#define kTEXTVIEW_TOP 12
#define kTEXTVIEW_HEIGHT 131
#define kTEXTVIEW_BORDER_COLOR [UIColor colorWithHex:0xE6E6E6]
#define kPASSWORD_LBL_COLOR RGBACOLOR(78, 93, 111, 1)
#define kPWDTF_PLACEHOLDER_COLOR RGBACOLOR(173, 173, 173, 1)
#define kLINEVIEW_BACKG_COLOR [UIColor colorWithHex:0xE9E9E9]
static const CGFloat kPWDTF_PLACEHOLDER_FONT_SIZE = 12.f;
static const CGFloat kPASSWORD_LBL_FONT_SIZE = 14.f;
static const CGFloat kTEXTVIEW_BORDER_WIDTH = .5;
static const CGFloat kTEXTVIEW_CORNERRADIUS = 3.f;
static const CGFloat kPADDING = 20.f;
static const CGFloat kRECOVER_BTN_HEIGHT = 44;


@interface EncryptSeedRecoverController ()<UITextViewDelegate>

@property (nonatomic, strong) UITextView *textView;

@property (nonatomic, strong) UITextField *pwdTF;

@property (nonatomic, strong) UIButton *recoverBtn;

@property (strong, nonatomic) ZYKeyboardUtil *keyboardUtil;

@property (nonatomic, strong) EncryptSeedAlertView *encryptAlert;

@property (nonatomic, strong) UIView *coverView;
@end

@implementation EncryptSeedRecoverController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _initUI];
    [self setupForDismissKeyboard];
    [self configKeyBoardRespond];
}

- (void)_initUI
{
    UIScrollView *scroll = [[UIScrollView alloc] init];
    scroll.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:scroll];
    
    [scroll mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.view);
    }];
    
    UIView *container = [[UIView alloc] init];
    container.backgroundColor = [UIColor whiteColor];
    [scroll addSubview:container];
    
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(scroll);
        make.width.equalTo(scroll.mas_width);
    }];
    
    UILabel *bannerLbl = [[UILabel alloc] init];
    bannerLbl.numberOfLines = 0;
    bannerLbl.textColor = DEFAULT_BLACK_COLOR;
    bannerLbl.font = [UIFont fontWithName:FONT_NAME_REGULAR size:kTEXT_DEFAULT_FONT_SIZE];
    bannerLbl.text = NSLocalizedString(@"copy_encryptseed_to_inputview", @"直接粘贴加密助记词到输入框");

    [container addSubview:bannerLbl];
    [bannerLbl mas_makeConstraints:^(MASConstraintMaker *make) {

        make.top.equalTo(container.mas_top).offset(kPADDING);
        make.left.equalTo(container.mas_left).offset(kPADDING);
        make.right.equalTo(container.mas_right).offset(-kPADDING);
    }];
    _textView = [[UITextView alloc] init];
    _textView.font = [UIFont fontWithName:FONT_NAME_REGULAR size:kTEXT_DEFAULT_FONT_SIZE];
    _textView.textColor = DEFAULT_GRAY_COLOR;
    _textView.text = NSLocalizedString(@"encrypt_seed_content", @"加密助记词文本内容");
    _textView.delegate = self;
    [container addSubview:_textView];

    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {

        make.top.equalTo(bannerLbl.mas_bottom).offset(kTEXTVIEW_TOP);
        make.left.right.equalTo(bannerLbl);
        make.height.mas_equalTo(@(kTEXTVIEW_HEIGHT));

    }];

    _textView.layer.borderColor = [kTEXTVIEW_BORDER_COLOR CGColor];
    _textView.layer.borderWidth = kTEXTVIEW_BORDER_WIDTH;
    _textView.layer.cornerRadius = kTEXTVIEW_CORNERRADIUS;
    _textView.layer.masksToBounds = YES;
//
    UILabel *passwordLbl = [[UILabel alloc] init];
    passwordLbl.font = [UIFont fontWithName:FONT_NAME_REGULAR size:kPASSWORD_LBL_FONT_SIZE];
    passwordLbl.textColor = kPASSWORD_LBL_COLOR;
    passwordLbl.text = [NSString stringWithFormat:@"%@:",NSLocalizedString(@"password", @"Password")];

    [container addSubview:passwordLbl];

    [passwordLbl mas_makeConstraints:^(MASConstraintMaker *make) {

        make.top.equalTo(_textView.mas_bottom).offset(kPADDING);
        make.left.equalTo(_textView);

    }];
//

    _pwdTF = [[UITextField alloc] init];
    _pwdTF.keyboardType = UIKeyboardTypeASCIICapable;
    _pwdTF.secureTextEntry = YES;
    _pwdTF.placeholder = NSLocalizedString(@"password_while_export_seed", @"请输入导出加密助记词是使用的账户密码");
    [_pwdTF setValue:kPWDTF_PLACEHOLDER_COLOR forKeyPath:@"_placeholderLabel.textColor"];
    [_pwdTF setValue:[UIFont fontWithName:FONT_NAME_REGULAR size:kPWDTF_PLACEHOLDER_FONT_SIZE] forKeyPath:@"_placeholderLabel.font"];
    [_pwdTF addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [container addSubview:_pwdTF];
    [_pwdTF mas_makeConstraints:^(MASConstraintMaker *make) {

        make.top.equalTo(passwordLbl.mas_bottom).offset(kPADDING / 2);
        make.left.equalTo(passwordLbl.mas_left);
        make.right.equalTo(container.mas_right).offset(-kPADDING);
        make.height.mas_equalTo(@(3*kPADDING / 2));
    }];

    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = kLINEVIEW_BACKG_COLOR;
    [container addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(_pwdTF);
        make.top.equalTo(_pwdTF.mas_bottom);
        make.height.mas_equalTo(@1);
    }];

    _recoverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_recoverBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _recoverBtn.titleLabel.font = [UIFont fontWithName:FONT_NAME_REGULAR size:16.f];
    [_recoverBtn setBackgroundImage:[UIImage imageNamed:@"Button_BG_big"] forState:UIControlStateNormal];
    
    [_recoverBtn setTitle:NSLocalizedString(@"start_recover", @"开始恢复") forState:UIControlStateNormal];
    [_recoverBtn addTarget:self action:@selector(startRecover) forControlEvents:UIControlEventTouchUpInside];
    _recoverBtn.alpha = 0.9;
    _recoverBtn.enabled = NO;
    [container addSubview:_recoverBtn];
    [_recoverBtn mas_makeConstraints:^(MASConstraintMaker *make) {

        make.top.equalTo(_pwdTF.mas_bottom).offset(2 * kPADDING);
        make.left.right.equalTo(_pwdTF);
        make.height.mas_equalTo(@(kRECOVER_BTN_HEIGHT));
        make.bottom.equalTo(container.mas_bottom).offset(-(2 * kPADDING));
    }];
    
}

- (void)startRecover
{
    KLog(@"startRecover");
    
    [self.view endEditing:YES];

    _encryptAlert = [[EncryptSeedAlertView alloc] initWithTitles:@[NSLocalizedString(@"button_dismiss", @"Dismiss"),NSLocalizedString(@"action_ok", @"")] message:NSLocalizedString(@"keep_account_password_in_mind", @"")];
    
    __weak typeof(self) weakself = self;
    _encryptAlert.alertBtnClick = ^(NSInteger index) {
        
        if (index == 0) {
            
            [weakself.encryptAlert hide];
            weakself.encryptAlert = nil;
        } else if (index == 1) {
            
            [weakself.encryptAlert hide];
            weakself.encryptAlert = nil;

            NSString *seed = [ONEChatClient aesCommonDecryptWithPass:weakself.pwdTF.text string:weakself.textView.text];
            
            ONEError *error = [ONEChatClient seedIsValid:seed invalidWords:nil];
            if( error != nil ) {
                [weakself showHint:NSLocalizedString(@"make_sure_seed_error_tip", @"The order is not right, please check again.")];
                return;
            }
            NSString *password = weakself.pwdTF.text;
            [weakself showHudInView:weakself.view hint:nil];
            
            [[ONEChatClient sharedClient] recoverAccount:seed password:password completion:^(ONEError *error) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakself hideHud];
                    if (!error) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SWITCH_ROOT_VIEWCONTROLLER object:nil];
                        
                        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:KUSERDEFAULT_KEY_EXPORT_ENCRYPT_SEED];
                        [[NSUserDefaults standardUserDefaults] synchronize];

                    } else {
                        [[UIAlertController shareAlertController] showAlertcWithString:[CSUtil showRecoverErrMsg:error] controller:weakself];

                    }
                });
            }];
        }
    };
    [_encryptAlert show];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if(textView.text.length < 1){
        textView.text = NSLocalizedString(@"encrypt_seed_content", @"加密助记词文本内容");
        textView.textColor = DEFAULT_GRAY_COLOR;
        
    }
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if([textView.text isEqualToString:NSLocalizedString(@"encrypt_seed_content", @"加密助记词文本内容")]){
        textView.text = @"";
        textView.textColor = DEFAULT_BLACK_COLOR;
    }
}

- (void)textFieldChanged:(UITextField *)tf
{
    if (_pwdTF.text.length < 8 || [_textView.text isEqualToString:NSLocalizedString(@"encrypt_seed_content", @"加密助记词文本内容")] || [_textView.text isEqualToString:@""]) {
        
        _recoverBtn.alpha = 0.9;
        _recoverBtn.enabled = NO;
    } else {
        
        _recoverBtn.alpha = 1.f;
        _recoverBtn.enabled = YES;
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    [self textFieldChanged:nil];
}

- (void)configKeyBoardRespond {
    self.keyboardUtil = [[ZYKeyboardUtil alloc] initWithKeyboardTopMargin:50];
    __weak EncryptSeedRecoverController *weakSelf = self;
    [_keyboardUtil setAnimateWhenKeyboardAppearAutomaticAnimBlock:^(ZYKeyboardUtil *keyboardUtil) {
        [keyboardUtil adaptiveViewHandleWithController:weakSelf adaptiveView:weakSelf.pwdTF, weakSelf.textView, nil];
    }];
    
    [_keyboardUtil setPrintKeyboardInfoBlock:^(ZYKeyboardUtil *keyboardUtil, KeyboardInfo *keyboardInfo) {
        // NSLog(@"\n\n拿到键盘信息 和 ZYKeyboardUtil对象");
    }];
}




@end
