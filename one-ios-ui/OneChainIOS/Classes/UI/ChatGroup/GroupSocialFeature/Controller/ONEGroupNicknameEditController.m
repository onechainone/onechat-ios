//
//  ONEGroupNicknameEditController.m
//  OneChainIOS
//
//  Created by lifei on 2018/5/7.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "ONEGroupNicknameEditController.h"
#import "UIView+Extension.h"

static const CGFloat kLBLFONTSIZE = 14.f;
#define kLBLTEXTCOLOR RGBACOLOR(78, 93, 111, 1)

@interface ONEGroupNicknameEditController ()<UITextFieldDelegate>
@property (nonatomic, strong) UITextField *nickTF;
@property (nonatomic, copy) NSString *nickName;
@end

@implementation ONEGroupNicknameEditController

- (instancetype)initWithNickName:(NSString *)nickName
{
    self = [super init];
    if (self) {
        _nickName = nickName;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"my_nickname_in_group", @"");
    [self setupUI];
    if ([_nickName length] > 0) {
        
        _nickTF.text = _nickName;
    }
    [self setupForDismissKeyboard];
}

- (void)setupUI {
    
    self.view.themeMap = @{
                           BGColorName:@"bg_white_color"
                           };
    UILabel *lbl = [[UILabel alloc] init];
    lbl.font = [UIFont fontWithName:FONT_NAME_MEDIUM size:kLBLFONTSIZE];
    lbl.textColor = kLBLTEXTCOLOR;
    lbl.text = NSLocalizedString(@"input_or_change_nickname", @"");
    lbl.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:lbl];
    [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(WidthScale(18));
        make.top.equalTo(self.view.mas_top).offset(30);
    }];
    
    _nickTF = [[UITextField alloc] init];
    _nickTF.font = [UIFont fontWithName:FONT_NAME_REGULAR size:12];
    _nickTF.backgroundColor = [UIColor clearColor];
//    _nickTF.textColor = DEFAULT_BLACK_COLOR;
    _nickTF.themeMap = @{
                         TextColorName:@"msg_input_text_color"
                         };
    _nickTF.returnKeyType = UIReturnKeyDone;
    _nickTF.delegate = self;
    _nickTF.placeholder = NSLocalizedString(@"pls_input_nickname_in_group", @"");
    [_nickTF setValue:[UIFont fontWithName:FONT_NAME_REGULAR size:11] forKeyPath:@"_placeholderLabel.font"];
//    [_nickTF setValue:DEFAULT_GRAY_COLOR forKeyPath:@"_placeholderLabel.textColor"];
    _nickTF.themeMap = @{
                         PlaceHolderColorName:@"trade_detail_83_color"
                         };
    
    [self.view addSubview:_nickTF];
    [_nickTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lbl.mas_bottom).offset(8);
        make.left.equalTo(self.view.mas_left).offset(18);
        make.right.equalTo(self.view.mas_right).offset(-18);
        make.height.mas_equalTo(@40);
    }];
    [_nickTF addRectLine:1 color:THMColor(@"input_text_border_color") cornerRadius:3];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // 修改昵称
    return YES;
}

@end
