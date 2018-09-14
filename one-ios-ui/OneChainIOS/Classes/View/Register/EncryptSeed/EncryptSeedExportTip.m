//
//  EncryptSeedExportTip.m
//  OneChainIOS
//
//  Created by lifei on 2018/3/7.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "EncryptSeedExportTip.h"

static const CGFloat kTITLE_LBL_FONT_SIZE = 12.f;
static const CGFloat kCONTENT_LBL_TOP = 4.f;

@interface EncryptSeedExportTip()

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *content;
@end

@implementation EncryptSeedExportTip

- (instancetype)initWithTitle:(NSString *)title content:(NSString *)content
{
    self = [super init];
    if (self) {
        
        _title = title;
        _content = content;
        [self _layoutSubviews];
    }
    return self;
}
- (void)_layoutSubviews
{
    UILabel *titleLbl = [[UILabel alloc] init];
    titleLbl.font = [UIFont fontWithName:FONT_NAME_REGULAR size:kTITLE_LBL_FONT_SIZE];
//    titleLbl.textColor = [UIColor colorWithHex:THEME_COLOR];
    titleLbl.themeMap = @{
                          TextColorName:@"theme_color"
                          };
    titleLbl.numberOfLines = 0;
    titleLbl.textAlignment = NSTextAlignmentLeft;
    titleLbl.text = _title;
    
    [self addSubview:titleLbl];
    
    [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.right.equalTo(self);
    }];
    
    UILabel *contentLbl = [[UILabel alloc] init];
    contentLbl.font = [UIFont fontWithName:FONT_NAME_REGULAR size:kTITLE_LBL_FONT_SIZE];
//    contentLbl.textColor = DEFAULT_BLACK_COLOR;
    contentLbl.themeMap = @{
                            TextColorName:@"common_text_color"
                            };
    contentLbl.numberOfLines = 0;
    contentLbl.textAlignment = NSTextAlignmentLeft;
    contentLbl.text = _content;
    
    [self addSubview:contentLbl];
    [contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(titleLbl.mas_bottom).offset(kCONTENT_LBL_TOP);
        make.left.right.bottom.equalTo(self);
    }];
}

@end
