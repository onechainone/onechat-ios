//
//  UILabel+Addition.m
//  BeeQuick
//
//  Created by 韩绍卿 on 17/06/2017.
//  Copyright © 2017 Weipeng Qi. All rights reserved.
//

#import "UILabel+Addition.h"

@implementation UILabel (Addition)

+ (UILabel *)makeLabelWithTextColor:(UIColor *)textColor andTextFont:(CGFloat)fontSize andContentText:(NSString *)text {
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.textColor = textColor;
    label.font = [UIFont systemFontOfSize:fontSize];
    
    return label;
}
+ (UILabel *)makeLabelWithTextColor:(UIColor *)textColor andTextFont:(CGFloat)fontSize andTextSystom:(NSString *)sysm andContentText:(NSString *)text {
    
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.textColor = textColor;
    label.font = [UIFont fontWithName:sysm size:fontSize];
    return label;
    
}
@end
