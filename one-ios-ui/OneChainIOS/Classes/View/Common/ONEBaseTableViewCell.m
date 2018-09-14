//
//  ONEBaseTableViewCell.m
//  OneChainIOS
//
//  Created by 李飞 on 2018/7/30.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "ONEBaseTableViewCell.h"

@implementation ONEBaseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.themeMap = @{
                          BGColorName:@"bg_white_color"
                          };
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        self.themeMap = @{
                          BGColorName:@"bg_color"
                          };
    } else {
        self.themeMap = @{
                          BGColorName:@"bg_white_color"
                          };
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        self.themeMap = @{
                          BGColorName:@"bg_color"
                          };
    } else {
        self.themeMap = @{
                          BGColorName:@"bg_white_color"
                          };
    }
}

@end
