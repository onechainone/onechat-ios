//
//  ONESelectViewCell.m
//  OneChainIOS
//
//  Created by lifei on 2018/5/11.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "ONESelectViewCell.h"

@implementation ONESelectViewCell


- (void)layoutSubviews
{
    [super layoutSubviews];
    self.textLabel.font = [UIFont fontWithName:FONT_NAME_REGULAR size:14];
    self.textLabel.themeMap = @{
                                TextColorName:@"conversation_title_color"
                                };
    self.textLabel.textAlignment = NSTextAlignmentCenter;

    [self.textLabel setFrame:CGRectMake(0, 0, KScreenW / 2, 45)];
}
@end
