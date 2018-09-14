//
//  GetTokenController.m
//  LZEasemob3
//
//  Created by lifei on 2017/12/23.
//  Copyright © 2017年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "GetTokenController.h"
#import "RedPacketMngr.h"


#define kButton_color 0xDB5942
static const CGFloat kPadding = 20;
static const CGFloat kDefault_height = 44;
static const CGFloat kLine_height = 1;

@interface GetTokenController ()
@property (nonatomic, strong) UITextField *textField;
@end

@implementation GetTokenController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"check_sign", @"Verify Signature");
    self.view.themeMap = @{
                           BGColorName:@"bg_white_color"
                           };
    [self setupSubviews];
}

- (void)setupSubviews
{
    _textField = [[UITextField alloc] init];
    _textField.placeholder = NSLocalizedString(@"enter_password", @"Enter your password");
    _textField.secureTextEntry = YES;
    [self.view addSubview:_textField];
    _textField.themeMap = @{
                            PlaceHolderColorName:@"conversation_detail_color",
                            TextColorName:@"common_text_color"
                            };
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.themeMap = @{
                           BGColorName:@"theme_color"
                           };
//    UIImage *image = [UIImage imageNamed:@"underline"];
    [self.view addSubview:imageView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:NSLocalizedString(@"action_ok", @"") forState:UIControlStateNormal];
//    [button setBackgroundColor:[UIColor colorWithHex:kButton_color]];
    button.themeMap = @{
                        BGColorName:@"theme_color",
                        TextColorName:@"theme_title_color"
                        };
    [button addTarget:self action:@selector(ensureAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.view.mas_top).offset(kPadding);
        make.left.equalTo(self.view.mas_left).offset(kPadding);
        make.right.equalTo(self.view.mas_right).offset(-kPadding);
        make.height.mas_equalTo(kDefault_height);
    }];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_textField.mas_bottom);
        make.centerX.width.equalTo(_textField);
        make.height.mas_equalTo(kLine_height);
    }];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(imageView.mas_bottom).offset(kPadding);
        make.centerX.width.equalTo(imageView);
        make.height.mas_equalTo(kDefault_height);
    }];
}

- (void)ensureAction
{
    [self.view endEditing:YES];
    [self showHudInView:self.view hint:nil];
    BOOL state = [ONEChatClient verifyAccountWithPassword:_textField.text];
    if (state) {
        NSString *eralyToken = [RedPacketMngr getToken];
        KLog(@"登录之前的token=%@",eralyToken);
        [RedPacketMngr loginWithCompletetion:^(GetTokenStatus status) {
            
            [self hideHud];
            if (status == GetTokenStatusSuccess) {
                KLog(@"登录之后的token=%@",[RedPacketMngr getToken]);
                [self.navigationController popViewControllerAnimated:YES];
            } else if (status == GetTokenStatusLoading) {
                
                
            } else{
                [self showHint:NSLocalizedString(@"signed_failed", @"Sign failed")];
            }
        }];
    } else {
        [self hideHud];
        [self showHint:NSLocalizedString(@"signed_failed", @"Sign failed")];
    }

}

@end
