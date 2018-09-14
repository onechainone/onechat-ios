
//  LFSendRedController.m
//  LZEasemob3
//
//  Created by lifei on 2017/12/21.
//  Copyright © 2017年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "LFSendRedController.h"
#import "SelectCoinController.h"
#define kDefault_placeholder_color  [UIColor colorWithRed:131/255.0 green:131/255.0 blue:131/255.0 alpha:1/1.0]
#define kDefault_title_color [UIColor colorWithRed:48/255.0 green:48/255.0 blue:48/255.0 alpha:1/1.0]
#define kButton_color 0xDB5942
#define MARGIN_KEYBOARD 80

static const CGFloat kPlaceholder_font_size = 10.f;
static const CGFloat kTitle_font_size = 14.f;
static const CGFloat kRight_lbl_width = 25;
static const CGFloat kRight_btn_width = 14;
static const CGFloat kRight_view_height = 20;
static const CGFloat kBack_top = 20;
static const CGFloat kBack_left = 20;
static const CGFloat kBack_right = 20;
static const CGFloat kBack_height = 40;
static const CGFloat kTip_left = 12;
static const CGFloat kTip_top = 4;
static const CGFloat kTitle_Height = 30;
static const CGFloat kRight_tf_right = 12;
static const CGFloat kRight_tf_left = 20;
static const CGFloat kTitle_left_new = 3;
static const CGFloat kSend_btn_height = 44;
static const CGFloat kSend_btn_bottom = 100;
static const CGFloat kBasic_width = 150;
#define kDefaultPlaceholder @"0.0000"
@interface LFSendRedController ()
{
    NSString *_contentData;
}

@end

@implementation LFSendRedController

- (NSDictionary *)coinIcon
{
    if (!_coinIcon) {
        
        _coinIcon = [NSDictionary dictionary];
    }
    return _coinIcon;
}

- (NSArray *)assetsList
{
    if (!_assetsList) {
        
        _assetsList = [NSArray array];
    }
    return _assetsList;
}

- (RedpacketButton *)selectCoinBtn
{
    if (!_selectCoinBtn) {
        
        _selectCoinBtn = [RedpacketButton buttonWithType:UIButtonTypeCustom];
        _selectCoinBtn.themeMap = @{
                                    TextColorName:@"golden_text_color"
                                    };
//        [_selectCoinBtn setTitle:kDefault_title_color forState:UIControlStateNormal];
        _selectCoinBtn.userInteractionEnabled = NO;
    }
    return _selectCoinBtn;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = NSLocalizedString(@"send_red_packet", @"Send Packet");
//    self.view.backgroundColor = [UIColor colorWithHex:BACKGROUND_COLOR];
    self.view.themeMap = @{
                           BGColorName:@"bg_normal_color"
                           };
    _grInfo = [[ONEChatClient sharedClient] groupChatWithGroupId:_groupId];
    [self setupForDismissKeyboard];
    _isEquailRed = NO;
    [self setupSubviews];
    [self sendButtonCanClick:NO];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextChanged) name:UITextFieldTextDidChangeNotification object:nil];
    
}

- (void)configKeyBoardRespond {
    self.keyboardUtil = [[ZYKeyboardUtil alloc] initWithKeyboardTopMargin:MARGIN_KEYBOARD];
    __weak typeof(self) weakSelf = self;
#pragma explain - 全自动键盘弹出/收起处理 (需调用keyboardUtil 的 adaptiveViewHandleWithController:adaptiveView:)
#pragma explain - use animateWhenKeyboardAppearBlock, animateWhenKeyboardAppearAutomaticAnimBlock will be invalid.
    [_keyboardUtil setAnimateWhenKeyboardAppearAutomaticAnimBlock:^(ZYKeyboardUtil *keyboardUtil) {
        [keyboardUtil adaptiveViewHandleWithController:weakSelf adaptiveView:weakSelf.singleAmountTF,weakSelf.redCountTF, weakSelf.redMsgTF,weakSelf.sendButton, nil];
    }];
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)sendButtonCanClick:(BOOL)status
{
    if (status) {
        
        [_sendButton setAlpha:1.0];
        [_sendButton setEnabled:YES];
    } else {
        
        [_sendButton setAlpha:0.6];
        [_sendButton setEnabled:NO];
    }
}

- (void)setupSubviews
{
    UIScrollView *scroll = [[UIScrollView alloc] init];
//    scroll.backgroundColor = [UIColor colorWithHex:BACKGROUND_COLOR];
    scroll.themeMap = @{
                        BGColorName:@"bg_normal_color"
                        };
    [self.view addSubview:scroll];
    
    [scroll mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.view);
    }];
    _container = [[UIView alloc] init];
//    _container.backgroundColor = [UIColor colorWithHex:BACKGROUND_COLOR];
    _container.themeMap = @{
                            BGColorName:@"bg_normal_color"
                            };
    [scroll addSubview:_container];
    [_container mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(scroll);
        make.width.equalTo(scroll);
    }];
    
    
    UIImageView *imgV1 = [self getBackImageViewWithTrailingView:nil];
    imgV1.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadAssetsList)];
    [imgV1 addGestureRecognizer:tap];
    self.imgV1 = imgV1;
    [self updateCoinWithCode:nil button:self.selectCoinBtn];
    
    [_container addSubview:self.selectCoinBtn];
    [self updateLeftSubviewConstraints:self.selectCoinBtn from:imgV1];
    
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:kTitle_font_size];
//    label.textColor = kDefault_title_color;
    label.themeMap = @{
                       TextColorName:@"common_text_color"
                       };
    label.text = NSLocalizedString(@"select_coin_type", @"Select Coin");
    self.select_type_lbl = label;
    [_container addSubview:label];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"Combined Shape"] forState:UIControlStateNormal];
    [button setFrame:CGRectMake(0, 0,kRight_btn_width, kRight_view_height)];
    [button setUserInteractionEnabled:NO];
    [_container addSubview:button];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(imgV1);
        make.right.equalTo(imgV1.mas_right).offset(-kRight_tf_right);
    }];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(button.mas_left);
        make.centerY.equalTo(button);
    }];
    
    UIImageView *imgV2 = [self getBackImageViewWithTrailingView:imgV1];
    
    _singleALbl = [self labelWithText:NSLocalizedString(@"red_packet_item_amount", @"Amount Each")];
    [_container addSubview:_singleALbl];
    [self updateLeftSubviewConstraints:_singleALbl from:imgV2];
    
    _no2Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    _no2Btn.themeMap = @{
                         TextColorName:@"common_text_color"
                         };
//    [_no2Btn setTitleColor:kDefault_title_color forState:UIControlStateNormal];
    _no2Btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:kTitle_font_size];
    [_no2Btn setTitle:NSLocalizedString(@"red_packet_total_amount", @"Total") forState:UIControlStateNormal];
    [_no2Btn setImage:[UIImage imageNamed:@"Redpacket_type_1"] forState:UIControlStateNormal];
    [_no2Btn setUserInteractionEnabled:NO];
    [_container addSubview:_no2Btn];
    [self updateLeftSubviewConstraints:_no2Btn from:imgV2];
    
    _singleAmountTF = [[RedpacketTF alloc] initWithRightView:YES placeholder:kDefaultPlaceholder];
    _singleAmountTF.keyboardType = UIKeyboardTypeDecimalPad;
    _singleAmountTF.tag = 1001;
    [_container addSubview:_singleAmountTF];
    [self updateRightSubviewConstraints:_singleAmountTF from:imgV2];
    
    _changeLabel1 = [[UILabel alloc] init];
    [_container addSubview:_changeLabel1];

    [_changeLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(imgV2.mas_left).offset(kTip_left);
        make.top.equalTo(imgV2.mas_bottom).offset(kTip_top);
    }];
    
    _changeLabel1.userInteractionEnabled = YES;
    UITapGestureRecognizer *lblTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeRedType)];
    [_changeLabel1 addGestureRecognizer:lblTap];
    [self updateRedType:_isEquailRed];

    UIImageView *imgV4 = [self getBackImageViewWithTrailingView:_changeLabel1];
    self.imgV4 = imgV4;
    UILabel *red_countLbl = [self labelWithText:NSLocalizedString(@"red_packet_num", @"Quantity")];
    self.red_countLbl = red_countLbl;
    [_container addSubview:red_countLbl];
    [self updateLeftSubviewConstraints:red_countLbl from:imgV4];
    
    _redCountTF = [[RedpacketTF alloc] initWithRightView:YES placeholder:NSLocalizedString(@"red_packet_num", @"Quantity")];
    _redCountTF.tag = 1003;
    [_container addSubview:_redCountTF];
    [self updateRightSubviewConstraints:_redCountTF from:imgV4];
    
    UILabel *groupMCLbl = [[UILabel alloc] init];
    self.groupMCLbl = groupMCLbl;
    groupMCLbl.textColor = kDefault_placeholder_color;
    groupMCLbl.font = [UIFont fontWithName:@"PingFangSC-Regular" size:kPlaceholder_font_size];
    
    groupMCLbl.text = [NSString stringWithFormat:NSLocalizedString(@"group_member_num", @"%dmembers"),_grInfo.memberSize];
    self.groupMCLbl = groupMCLbl;
    
    [_container addSubview:groupMCLbl];
    [groupMCLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(imgV4.mas_left).offset(kTip_left);
        make.top.equalTo(imgV4.mas_bottom).offset(kTip_top);
    }];
    
    UIImageView *imgV5 = [self getBackImageViewWithTrailingView:groupMCLbl];
    self.imgV5 = imgV5;
    UILabel *msgLbl = [self labelWithText:NSLocalizedString(@"red_packet_message", @"Notes")];
    self.msgLbl = msgLbl;
    [_container addSubview:msgLbl];
    [self updateLeftSubviewConstraints:msgLbl from:imgV5];
    
    _redMsgTF = [[RedpacketTF alloc] initWithRightView:NO placeholder:NSLocalizedString(@"red_packet_default_msg", @"Best wishes")];
    _redMsgTF.tag = 1004;
    _redMsgTF.keyboardType = UIKeyboardTypeDefault;
    [_container addSubview:_redMsgTF];
    [self updateRightSubviewConstraints:_redMsgTF from:imgV5];
    
    _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_sendButton setTitle:NSLocalizedString(@"send_red_packet_text", @"Prepare Red Packet") forState:UIControlStateNormal];
    [_sendButton setBackgroundColor:[UIColor colorWithHex:kButton_color]];
    [_sendButton addTarget:self action:@selector(pleaseEnterPwd) forControlEvents:UIControlEventTouchUpInside];
    
    [_container addSubview:_sendButton];
    [_sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(imgV5.mas_bottom).offset(kBack_height);
        make.left.equalTo(_container.mas_left).offset(kBack_height/2);
        make.right.equalTo(_container.mas_right).offset(-kBack_height/2);
        make.height.mas_equalTo(@(kSend_btn_height));
        make.bottom.equalTo(_container.mas_bottom).offset(-kSend_btn_bottom);
    }];
}


- (void)updateRedType:(BOOL)isEquail
{
    if (isEquail) {
        
        [_no2Btn setHidden:YES];
        [_singleALbl setHidden:NO];
        [_changeLabel1 setAttributedText:[self attrStringFromString:NSLocalizedString(@"simple_red_packet_tip", @"Identical Amount.") string2:NSLocalizedString(@"set_lucky_red_packet", @"Change to Random Amount")]];
    } else {
        
        [_no2Btn setHidden:NO];
        [_singleALbl setHidden:YES];
        [_changeLabel1 setAttributedText:[self attrStringFromString:NSLocalizedString(@"lucky_red_packet_tip", @"Random Amount.") string2:NSLocalizedString(@"set_simple_red_packet", @"Chage to Identical Amount")]];
    }
}

- (UILabel *)labelWithText:(NSString *)text
{
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:kTitle_font_size];
//    label.textColor = kDefault_title_color;
    label.themeMap = @{
                       TextColorName:@"common_text_color"
                       };
    label.text = text;
    return label;
}

- (UIImageView *)getBackImageViewWithTrailingView:(UIView *)view
{
//    UIImage *backImage = [UIImage imageNamed:@"Redpacket_back_view"];
    UIImageView *imgV = [[UIImageView alloc] init];
    imgV.layer.cornerRadius = HeightScale(20);
    imgV.layer.masksToBounds = YES;
    imgV.themeMap = @{
                      BGColorName:@"bg_white_color"
                      };
    [_container addSubview:imgV];
    if (!view) {
        
        [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(_container.mas_top).offset(kBack_top);
            make.left.equalTo(_container.mas_left).offset(kBack_left);
            make.right.equalTo(_container.mas_right).offset(-kBack_right);
            make.height.mas_equalTo(@(HeightScale(kBack_height)));
        }];
    } else {
        
        [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(view.mas_bottom).offset(kBack_top);
            make.left.equalTo(_container.mas_left).offset(kBack_left);
            make.right.equalTo(_container.mas_right).offset(-kBack_right);
            make.height.mas_equalTo(@(HeightScale(kBack_height)));
        }];
    }
    return imgV;
}

- (void)updateLeftSubviewConstraints:(UIView *)subView from:(UIView *)fromView
{
    CGFloat leftPadding = 0;
    if ([subView isKindOfClass:[UIButton class]]) {
        
        leftPadding = kTitle_left_new;
    } else if ([subView isKindOfClass:[UILabel class]]) {
        
        leftPadding = kTip_left;
    }
    [subView mas_makeConstraints:^(MASConstraintMaker *make) {

        make.left.equalTo(fromView.mas_left).offset(leftPadding);
        make.centerY.equalTo(fromView);
        make.height.mas_equalTo(@(kTitle_Height));
    }];
}

- (void)updateRightSubviewConstraints:(UIView *)subView from:(UIView *)fromView
{
    [subView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(fromView.mas_right).offset(-kRight_tf_right);
        make.centerY.equalTo(fromView);
        make.width.mas_equalTo(@(WidthScale(kBasic_width)));
    }];
}

#pragma mark - 更新头像

- (void)updateCoinWithCode:(NSString *)code button:(RedpacketButton *)button
{
    if (code == nil) {
        
        [button setHidden:YES];
    } else {
        
        [button setHidden:NO];
    }
    NSDictionary *info = [[ONEChatClient sharedClient] assetShowInfoFromAssetCode:code];
    
    [button setTitle:info[@"name"] forState:UIControlStateNormal];
    
    [button sd_setImageWithURL:[NSURL URLWithString:info[@"icon"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"noicon"]];
}

- (NSAttributedString *)attrStringFromString:(NSString *)str1 string2:(NSString *)str2
{
    if (str1.length == 0 || str2.length == 0) return nil;
    
    NSDictionary *dic1 = @{
                           NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:kPlaceholder_font_size],
                           NSForegroundColorAttributeName: kDefault_placeholder_color
                           };
    NSMutableAttributedString *attString1 = [[NSMutableAttributedString alloc] initWithString:str1 attributes:dic1];
    
    NSDictionary *dic2 = @{
                           NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:kPlaceholder_font_size],
                           NSForegroundColorAttributeName: [UIColor colorWithHex:THEME_COLOR]
                           };
    NSAttributedString *attString2 = [[NSAttributedString alloc] initWithString:str2 attributes:dic2];
    
    [attString1 appendAttributedString:attString2];
    
    return [attString1 copy];
}

- (void)gotoCoinSelectionVC:(NSArray *)datasource
{
    SelectCoinController *vc = [[SelectCoinController alloc] initWithDatasources:datasource];
    vc.view.backgroundColor=[UIColor colorWithWhite:0 alpha:0];
    vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
    vc.selectCoin = ^(RpAssetModel *model) {
      
        _selectedModel = model;
        [self updateCoinWithCode:model.asset_code button:_selectCoinBtn];
        _singleAmountTF.text = @"";
        _redCountTF.text = @"";
    };
    [self presentViewController:vc animated:YES completion:nil];
    
}

- (void)loadAssetsList
{
    __weak typeof(self)weakSelf = self;
    [self showHudInView:self.view hint:nil];
    
    [[ONEChatClient sharedClient] getRedPacketAssetListWithCompletion:^(ONEError *error, NSArray *list) {
       
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf hideHud];
            if (!error) {
                if ([list count] > 0) {
                    [weakSelf gotoCoinSelectionVC:list];
                } else {
                    [weakSelf showHint:NSLocalizedString(@"assets_nodata", @"No assets")];
                }
            } else {
                [weakSelf showHint:NSLocalizedString(@"get_asset_list_error", @"Failed to get asset list")];
            }
        });
    }];
}

- (void)textFieldTextChanged
{
    if (_selectedModel) {
        
        if (_singleAmountTF.text.length > 0 && (_redCountTF.text.length > 0 && [_redCountTF.text intValue] > 0)) {
            
            [self sendButtonCanClick:YES];
        } else {
            
            [self sendButtonCanClick:NO];
        }
    }
}


- (RedbagModel *)getModel
{
    RedbagModel *model = [[RedbagModel alloc] init];
    model.red_content = _redMsgTF.text.length > 0 ? _redMsgTF.text : _redMsgTF.placeholder;
    model.red_type = _isEquailRed ? @"EQUAL" : @"NOTEQAUL";
    model.asset_code = _selectedModel.asset_code.length > 0 ? _selectedModel.asset_code : @"";
    
    NSDecimalNumber *totalAmount = nil;
    NSDecimalNumber *red_single = nil;
    if (_isEquailRed) {
        
        NSDecimalNumber *num = [NSDecimalNumber decimalNumberWithString:_redCountTF.text];
        NSDecimalNumber *singleAmount = [NSDecimalNumber decimalNumberWithString:_singleAmountTF.text];

        red_single = singleAmount;
        totalAmount = [num decimalNumberByMultiplyingBy:singleAmount];
        
    } else {
        
        totalAmount = [NSDecimalNumber decimalNumberWithString:_singleAmountTF.text];
        NSDecimalNumber *num = [NSDecimalNumber decimalNumberWithString:_redCountTF.text];
        
        if ([totalAmount compare:[NSDecimalNumber zero]] == NSOrderedSame || [[NSDecimalNumber notANumber] isEqualToNumber:totalAmount]) {
            
            red_single = [NSDecimalNumber zero];
        } else {
            red_single = [totalAmount decimalNumberByDividingBy:num];
        }
    }
    NSDecimalNumber *avalibaleAmount = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%ld",_selectedModel.amount_availabel]];
    if ([[totalAmount decimalNumberBySubtracting:avalibaleAmount] longValue] < 0) {
        
        [self showHint:NSLocalizedString(@"amount_error_not_enough_money_plain", @"")];
        return nil;
    }
    model.total_amount = [totalAmount stringValue];
    model.red_total_num = [_redCountTF.text intValue];
    model.single_amount = [red_single stringValue];
    
    return model;
}

- (void)pleaseEnterPwd
{
    [self.view endEditing:YES];

    //输入密码
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"enter_password", nil) message:@"" preferredStyle:UIAlertControllerStyleAlert];
    ///取消 button_cancel
    UIAlertAction *cancelAction =[UIAlertAction actionWithTitle:NSLocalizedString(@"button_cancel", nil) style:UIAlertActionStyleCancel handler:nil];
    [cancelAction setValue:[UIColor lightGrayColor] forKeyPath:@"titleTextColor"];
    
    //确认 button_confirm
    UIAlertAction *confirmAction =[UIAlertAction actionWithTitle:NSLocalizedString(@"button_confirm", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        BOOL check = [ONEChatClient checkPassword:_contentData];
        
        if (check) {
            
            [self sendRedpacket];
        } else {
            
            [[UIAlertController shareAlertController] showTitleAlertcWithString:NSLocalizedString(@"unlocking_wallet_error_detail", nil) andTitle:NSLocalizedString(@"unlocking_wallet_error_title", nil) controller:self];
        }
    }];
    
    [confirmAction setValue:[UIColor orangeColor] forKeyPath:@"titleTextColor"];
    
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        
        textField.secureTextEntry = YES;
        
        [textField addTarget:self action:@selector(buyTextFieldChange:) forControlEvents:(UIControlEventEditingChanged)];
    }];
    
    
    [alertVC addAction:confirmAction];
    [alertVC addAction:cancelAction];
    
    [self presentViewController:alertVC animated:YES completion:nil];
}
- (void)buyTextFieldChange:(UITextField *)textfiled {
    
    _contentData = textfiled.text;
}

- (void)sendRedpacket
{
    if (_selectedModel == nil) return;
    
    RedbagModel *model = [self getModel];
    
    if (model == nil) return;
    kWeakSelf
    [[ONEChatClient sharedClient] sendRedpacket:model withCompletion:^(ONEError *error, NSString *redpacketID, NSString *redpacketMsg) {
       
        dispatch_async(dispatch_get_main_queue(), ^{
           
            if (!error) {
                [weakself.navigationController popViewControllerAnimated:YES];
                !_sendRedMsg ?: _sendRedMsg(redpacketID, redpacketMsg);
            } else {
                if (error.errorCode == ONEErrorRedpacketBalanceNotEnough) {
                    [weakself showHint:NSLocalizedString(@"amount_error_not_enough_money_plain", @"")];
                } else {
                    [weakself showHint:NSLocalizedString(@"redpacket_send_failed", @"")];
                }
            }
        });
    }];
}

- (void)changeRedType
{
    _isEquailRed = !_isEquailRed;
    [self updateRedType:_isEquailRed];
}

@end
