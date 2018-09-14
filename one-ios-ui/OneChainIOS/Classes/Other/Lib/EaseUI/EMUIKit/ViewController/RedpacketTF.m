//
//  RedpacketTF.m
//  LZEasemob3
//
//  Created by lifei on 2017/12/21.
//  Copyright © 2017年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "RedpacketTF.h"


#define kDefault_placeholder_color  [UIColor colorWithRed:131/255.0 green:131/255.0 blue:131/255.0 alpha:1/1.0]
#define kDefault_title_color [UIColor colorWithRed:48/255.0 green:48/255.0 blue:48/255.0 alpha:1/1.0]
static const CGFloat kPlaceholder_font_size = 10.f;
static const CGFloat kTitle_font_size = 14.f;
static const CGFloat kRight_lbl_width = 15;
static const CGFloat kRight_view_height = 20;


@implementation RedpacketTF

- (instancetype)initWithRightView:(BOOL)includeRightView placeholder:(NSString *)placeholder
{
    self = [super init];
    if (self) {
        
        self.textAlignment = NSTextAlignmentRight;
        self.textColor = kDefault_title_color;
        self.font = [UIFont fontWithName:@"PingFangSC-Regular" size:kTitle_font_size];
        self.placeholder = placeholder;
        self.keyboardType = UIKeyboardTypeNumberPad;
        [self setValue:[UIFont systemFontOfSize:kPlaceholder_font_size] forKeyPath:@"_placeholderLabel.font"];
        [self setValue:kDefault_placeholder_color forKeyPath:@"_placeholderLabel.textColor"];
        if (includeRightView) {
            
            [self addRightView];
        }
    }
    return self;
}

- (void)addRightView
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kRight_lbl_width, kRight_view_height)];
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:kTitle_font_size];
//    label.textColor = kDefault_title_color;
    label.themeMap = @{
                       TextColorName:@"common_text_color"
                       };
    label.text = NSLocalizedString(@"item", @"");
    self.rightViewMode = UITextFieldViewModeAlways;
    self.rightView = label;
}

- (CGRect)textRectForBounds:(CGRect)bounds
{
    if (self.rightView) {
        
        return CGRectMake(self.bounds.size.width - bounds.size.width - self.rightView.bounds.size.width, bounds.origin.y, bounds.size.width, bounds.size.height);
    } else {
        return bounds;
    }
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds
{
    if (self.rightView) {
        
        return CGRectMake(self.bounds.size.width - bounds.size.width - self.rightView.bounds.size.width, bounds.origin.y, bounds.size.width, bounds.size.height);
    } else {
        return bounds;
    }
}

@end
