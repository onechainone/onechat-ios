//
//  EncryptSeedAlertView.m
//  OneChainIOS
//
//  Created by lifei on 2018/3/7.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "EncryptSeedAlertView.h"

static const CGFloat kMSG_LBL_FONT_SIZE = 16.f;
static const CGFloat kMSG_LBL_PADDING = 34;
static const CGFloat kBUTTON_FONT_SIZE = 14.f;
static const CGFloat kBUTTON_TOP = 27;
static const CGFloat kBUTTON_HEIGHT = 60;
static const CGFloat kCOVER_OPATICY = 0.35;
static const CGFloat kALERT_PADDING = 18.f;

@interface EncryptSeedAlertView()

@property (nonatomic, strong) NSArray *btnTitles;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, strong) UIButton *tempBtn;

@property (nonatomic, strong) UIView *coverView;
@end

@implementation EncryptSeedAlertView

- (instancetype)initWithTitles:(NSArray *)titles message:(NSString *)message
{
    self = [super init];
    if (self) {
        
        _btnTitles = titles;
        _message = [message copy];
        [self _layoutSubviews];
    }
    return self;
}

- (void)_layoutSubviews
{
    self.backgroundColor = [UIColor whiteColor];
    
    UILabel *msgLbl = [[UILabel alloc] init];
    msgLbl.font = [UIFont fontWithName:FONT_NAME_REGULAR size:kMSG_LBL_FONT_SIZE];
    msgLbl.textColor = DEFAULT_BLACK_COLOR;
    msgLbl.text = _message;
    msgLbl.numberOfLines = 0;
    msgLbl.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:msgLbl];
    
    [msgLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.mas_top).offset(kMSG_LBL_PADDING);
        make.left.equalTo(self.mas_left).offset(kMSG_LBL_PADDING);
        make.right.equalTo(self.mas_right).offset(-kMSG_LBL_PADDING);
    }];
    for (NSInteger i = 0; i < _btnTitles.count; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:_btnTitles[i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont fontWithName:FONT_NAME_MEDIUM size:kBUTTON_FONT_SIZE];
        button.titleLabel.numberOfLines = 0;
        button.tag = 1000 + i;
        if (i == _btnTitles.count - 1) {
            
            [button setTitleColor:[UIColor colorWithHex:THEME_COLOR] forState:UIControlStateNormal];
        } else {
            
            [button setTitleColor:DEFAULT_GRAY_COLOR forState:UIControlStateNormal];
        }
        [button addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:button];

        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(msgLbl.mas_bottom).offset(kBUTTON_TOP);
            if (_tempBtn == nil) {
                
                make.left.equalTo(self.mas_left);
            } else {
                
                make.left.equalTo(_tempBtn.mas_right);
            }
            make.width.equalTo(self.mas_width).dividedBy(_btnTitles.count);
            make.height.mas_equalTo(@(kBUTTON_HEIGHT));
            make.bottom.equalTo(self);
            _tempBtn = button;
        }];
    }
    self.layer.cornerRadius = 3.f;
    self.layer.masksToBounds = YES;
}

- (void)btnClicked:(UIButton *)sender
{
    NSInteger index = sender.tag - 1000;
    !_alertBtnClick ?: _alertBtnClick(index);
}

- (void)show
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    _coverView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _coverView.backgroundColor = [UIColor blackColor];
    _coverView.layer.opacity = kCOVER_OPATICY;
    [keyWindow addSubview:_coverView];
    
    [keyWindow addSubview:self];
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(keyWindow.mas_left).offset(kALERT_PADDING);
        make.right.equalTo(keyWindow.mas_right).offset(-kALERT_PADDING);
        make.center.equalTo(keyWindow);
    }];

}

- (void)hide
{
    [self removeFromSuperview];
    [_coverView removeFromSuperview];
    _coverView = nil;
}


@end
