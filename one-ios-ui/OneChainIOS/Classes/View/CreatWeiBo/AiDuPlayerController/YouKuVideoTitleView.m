//
//  YouKuVideoTitleView.m
//  CancerDo
//
//  Created by hugaowei on 16/11/2.
//  Copyright © 2016年 lianji. All rights reserved.
//

#import "YouKuVideoTitleView.h"
#define VIDEO_QULITY_BUTTON_WIDTH  45
#define VIDEO_QULITY_BUTTON_HEIGHT 24

@implementation YouKuVideoTitleView

@synthesize videoQulityButton;

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [self createSubViews];
    }
    
    return self;
}

- (void)createSubViews{
    
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    
    backButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 22, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"videoTopBackImage"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(onClickBack:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setExclusiveTouch:YES];
    [self addSubview:backButton];
    
    videoQulityButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - VIDEO_QULITY_BUTTON_WIDTH - 10, 20+(44-VIDEO_QULITY_BUTTON_HEIGHT)/2, VIDEO_QULITY_BUTTON_WIDTH, VIDEO_QULITY_BUTTON_HEIGHT)];
    // 流畅、高清、超清、原画
    [videoQulityButton setTitle:@"流畅" forState:UIControlStateNormal];
    [videoQulityButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [videoQulityButton setTitleColor:ColorWithRGB(0, 137, 255, 1) forState:UIControlStateSelected];
    videoQulityButton.layer.cornerRadius = 2;
    videoQulityButton.layer.masksToBounds = YES;
    videoQulityButton.layer.borderColor = [UIColor whiteColor].CGColor;
    videoQulityButton.layer.borderWidth = 1;
    videoQulityButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [videoQulityButton addTarget:self action:@selector(changeVideoQulity:) forControlEvents:UIControlEventTouchUpInside];
    videoQulityButton.selected = NO;
    videoQulityButton.hidden = YES;
    [videoQulityButton setExclusiveTouch:YES];
    [self addSubview:videoQulityButton];
    
    CGFloat originX = CGRectGetMaxX(backButton.frame);
    CGFloat width = videoQulityButton.frame.origin.x - originX;
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 30, width, 24)];
    titleLabel.textAlignment = NSTextAlignmentLeft; //文字居中
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.adjustsFontSizeToFitWidth = YES;
    titleLabel.font = [UIFont fontWithName:titleLabel.font.fontName size:15.0];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [self addSubview:titleLabel];
}

- (void)changeVideoQulity:(UIButton*)btn{
    if (self.delegate && [self.delegate respondsToSelector:@selector(videoQulityChanged:)]) {
        [self.delegate videoQulityChanged:btn];
    }
}

#pragma mark
- (void)onClickBack:(UIButton*)button{
    if (self.delegate && [self.delegate respondsToSelector:@selector(gotoBack)]) {
        [self.delegate gotoBack];
    }
}

- (void)setTitle:(NSString *)t{
    if (![_title isEqualToString:t]) {
        _title = nil;
        _title = [t copy];
    }
    
    titleLabel.text = _title;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    videoQulityButton.frame = CGRectMake(self.frame.size.width - VIDEO_QULITY_BUTTON_WIDTH - 10, 20+(44-VIDEO_QULITY_BUTTON_HEIGHT)/2, VIDEO_QULITY_BUTTON_WIDTH, VIDEO_QULITY_BUTTON_HEIGHT);
    
    CGFloat originX = CGRectGetMaxX(backButton.frame);
    CGFloat width = videoQulityButton.frame.origin.x - originX;
    titleLabel.frame = CGRectMake(originX, 30, width, 24);
}

@end
