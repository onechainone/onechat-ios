//
//  ONESettingItem.m
//  OneChainIOS
//
//  Created by 李飞 on 2018/7/23.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "ONESettingItem.h"
#import "ONEIButton.h"

@interface ONESettingItem()

@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UILabel *titleLbl;
@end

@implementation ONESettingItem

- (instancetype)initWithFrame:(CGRect)frame
                        image:(NSString *)imageName
                        title:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self) {
        _title = title;
        _imageName = imageName;
        [self _layoutSubviews];
    }
    return self;
}

- (void)_layoutSubviews
{
    _button = [ONEIButton buttonWithType:UIButtonTypeCustom];
    _button.themeMap = @{
                         NormalImageName:_imageName
                         };
    _button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_button addTarget:self action:@selector(itemClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_button];
    
    _titleLbl = [[UILabel alloc] init];
    _titleLbl.themeMap = @{
                           TextColorName:@"setting_item_text_color"
                           };
    _titleLbl.font = [UIFont fontWithName:FONT_NAME_REGULAR size:11.f];
    _titleLbl.textAlignment = NSTextAlignmentCenter;
    _titleLbl.text = _title;
    _titleLbl.adjustsFontSizeToFitWidth = YES;
    [self addSubview:_titleLbl];
    
    [_button mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.top.right.equalTo(self);
        make.height.mas_equalTo(@(self.height * 2 / 3));
    }];
    [_titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(_button.mas_bottom).offset(-5);
        make.left.right.bottom.equalTo(self);
    }];
    
}

- (void)itemClicked:(UIButton *)button
{
    !_itemClicked ?: _itemClicked(_title);
}
@end
