//
//  IDOQuanHeaderVeiw.m
//  CancerDo
//
//  Created by hugaowei on 16/12/1.
//  Copyright © 2016年 lianji. All rights reserved.
//

#import "IDOQuanHeaderVeiw.h"

#define K_NUMBER_FONT ([UIFont systemFontOfSize:14.0f])
#define K_SELF_HEIGHT 36.0f

@implementation IDOQuanHeaderVeiw

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubViews];
    }
    
    return self;
}

- (void)createSubViews{
/*
 UIImageView *backgroundImageView;
 UIImageView *headerImageView;
 
 UILabel *numberLabel;
 
 UIButton *rowButton;
 UIButton *clearButton;
 */
    
//    self.backgroundColor = [UIColor whiteColor];
    self.themeMap = @{
                      BGColorName:@"bg_white_color"
                      };
    
    CGFloat minWidth = 3 + 30 + 10 + 10 + 15 + 8;
    CGFloat width = KScreenW - minWidth;
    
    
    CGRect frame = [self getFrameWithString:@"0条新消息" size:CGSizeMake(width, 24) font:K_NUMBER_FONT];
    minWidth += frame.size.width;
    
    backgroundView = [[UIView alloc] initWithFrame:CGRectMake((KScreenW - minWidth)*0.5, (self.frame.size.height - K_SELF_HEIGHT)*0.5, minWidth, K_SELF_HEIGHT)];
    [backgroundView setBackgroundColor:RGBACOLOR(79.0, 79.0, 79.0, 1)];
    backgroundView.layer.masksToBounds = YES;
    backgroundView.layer.cornerRadius = backgroundView.frame.size.height*0.5;
    [self addSubview:backgroundView];
    
    headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(3, 3, 30, 30)];
    [headerImageView setImage:[UIImage imageNamed:@"touxiangyuannan"]];
    headerImageView.layer.masksToBounds = YES;
    headerImageView.layer.cornerRadius = headerImageView.frame.size.width*0.5;
    [backgroundView addSubview:headerImageView];
    
    numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(headerImageView.frame)+10, (K_SELF_HEIGHT - 24)*0.5, frame.size.width, 24)];
    [numberLabel setBackgroundColor:[UIColor clearColor]];
    [numberLabel setFont:K_NUMBER_FONT];
    [numberLabel setTextColor:RGBACOLOR(244.0, 244.0, 244.0, 1)];
    [numberLabel setText:@"0条新消息"];
    [backgroundView addSubview:numberLabel];
    
    // 15 27
    rowButton = [[UIButton alloc] initWithFrame:CGRectMake(minWidth-8-15, (K_SELF_HEIGHT-27)*0.5, 15, 27)];
    [rowButton setImage:[UIImage imageNamed:@"rightRow"] forState:UIControlStateNormal];
    [rowButton addTarget:self action:@selector(clearButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [rowButton setExclusiveTouch:YES];
    
    UIImage *image = [[UIImage imageNamed:@"selectedColor"] stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    clearButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, backgroundView.frame.size.width, backgroundView.frame.size.height)];
    [clearButton setBackgroundColor:[UIColor clearColor]];
    [clearButton setExclusiveTouch:YES];
    [clearButton setBackgroundImage:nil   forState:UIControlStateNormal];
    [clearButton setBackgroundImage:image forState:UIControlStateHighlighted];
    [clearButton addTarget:self action:@selector(clearButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    clearButton.layer.masksToBounds = YES;
    clearButton.layer.cornerRadius = clearButton.frame.size.height*0.5;
    [backgroundView addSubview:clearButton];
    [backgroundView addSubview:rowButton];
}

- (void)setImage_url:(NSString *)imageUrl{
    if (_image_url == nil || ![_image_url isEqualToString:imageUrl]) {
        _image_url = imageUrl;
    }
    
    [headerImageView sd_setImageWithURL:[NSURL URLWithString:_image_url] placeholderImage:[UIImage defaultAvaterImage]];
}

- (void)setNumber:(NSString *)number{
    if (_number == nil || ![_number isEqualToString:number]) {
        _number = number;
    }
    
    NSString *numberStr = [NSString stringWithFormat:@"%@ %@",_number,NSLocalizedString(@"new_chat_message_num", @"")];
    
    CGFloat minWidth = 3 + 30 + 10 + 10 + 15 + 8;
    CGFloat width = KScreenW - minWidth;
    CGRect frame = [self getFrameWithString:numberStr size:CGSizeMake(width, 24) font:K_NUMBER_FONT];
    minWidth += frame.size.width;
    
    backgroundView.frame = CGRectMake((KScreenW-minWidth)*0.5, backgroundView.frame.origin.y, minWidth, backgroundView.frame.size.height);
    
    numberLabel.frame = CGRectMake(CGRectGetMaxX(headerImageView.frame)+10, (K_SELF_HEIGHT - 24)*0.5, frame.size.width, 24);
    
    rowButton.frame = CGRectMake(minWidth-8-15, (K_SELF_HEIGHT-27)*0.5, 15, 27);
    
    [numberLabel setText:numberStr];
}

- (void)clearButtonAction:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableHeaderViewDidClicked)]) {
        [self.delegate tableHeaderViewDidClicked];
    }
}

- (CGRect)getFrameWithString:(NSString*)str size:(CGSize)size font:(UIFont*)font{
    
    if ([str length] == 0) {
        return CGRectZero;
    }
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,paraStyle,NSParagraphStyleAttributeName, nil];
    
    CGRect frame = [str boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    
    return frame;
}

@end
