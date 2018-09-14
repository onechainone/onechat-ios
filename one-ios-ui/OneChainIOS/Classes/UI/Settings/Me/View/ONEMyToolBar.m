//
//  ONEMyToolBar.m
//  OneChainIOS
//
//  Created by 李飞 on 2018/7/23.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "ONEMyToolBar.h"
#import "ONESettingItem.h"
@interface ONEMyToolBar()

@property (nonatomic, strong) UILabel *titleLbl;

@property (nonatomic, strong) UIView *seperateLine;
@end

@implementation ONEMyToolBar

- (UILabel *)titleLbl
{
    if (!_titleLbl) {
        
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(11, 9, self.width - 22, 20)];
        _titleLbl.themeMap = @{
                               TextColorName:@"setting_toolbar_title_color"
                               };
        _titleLbl.font = [UIFont fontWithName:FONT_NAME_SEMIBOLD size:14.f];
//        _titleLbl.text = NSLocalizedString(@"my_tools", @"");
        _titleLbl.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLbl;
}

- (UIView *)seperateLine
{
    if (!_seperateLine) {
        
        _seperateLine = [[UIView alloc] initWithFrame:CGRectMake(0, 38, self.width, 1)];
        _seperateLine.themeMap = @{
                                   BGColorName:@"bg_normal_color"
                                   };
//        _seperateLine.layer.opacity = 0.05;
    }
    return _seperateLine;
}

- (void)setBarTitle:(NSString *)barTitle
{
    _barTitle = barTitle;
    self.titleLbl.text = _barTitle;
}


- (void)_layoutSubviews
{
    [self addSubview:self.titleLbl];
    [self addSubview:self.seperateLine];

    if ([self.items count] == 0) {
        return;
    }
    int tmp = ([self.items count]) % 4;
    int row = (int)([self.items count]) / 4;
    row += tmp == 0 ? 0 : 1;
    
    CGFloat defaultY = CGRectGetMaxY(self.seperateLine.frame);
    CGFloat defaultWidth = self.width / 4;
    CGFloat defaultHeight = 67;
    
    for (NSInteger i = 0; i < row; i ++) {
        
        for (NSInteger j = 0; j < 4; j++) {
            NSInteger index = i * 4 + j;

            if (index < [self.items count]) {
                NSDictionary *dic = self.items[index];
                ONESettingItem *item = [[ONESettingItem alloc] initWithFrame:CGRectMake(j * defaultWidth, i * defaultHeight + defaultY, defaultWidth, defaultHeight) image:dic[@"image"] title:dic[@"title"]];
                kWeakSelf
                item.itemClicked = ^(NSString *title) {
                    
                    if ([weakself.delegate respondsToSelector:@selector(toolBar:didItemClick:)]) {
                        
                        [weakself.delegate toolBar:self didItemClick:title];
                    }
                };
                [self addSubview:item];
            }

        }
    }
}

@end
