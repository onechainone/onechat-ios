//
//  VideoQulityView.m
//  CancerDo
//
//  Created by hugaowei on 16/11/3.
//  Copyright © 2016年 lianji. All rights reserved.
//

#import "VideoQulityView.h"

#define VIDEO_BUTTON_WIDTH  50
#define VIDEO_BUTTON_HEIGHT 30

@implementation VideoQulityView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        _qulityArray = [[NSMutableArray alloc] init];
        buttonArray  = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)setQulityArray:(NSMutableArray *)qulityArr{
    if (_qulityArray == nil) {
        _qulityArray = [[NSMutableArray alloc] init];
    }
    
    if (_qulityArray.count > 0) {
        [_qulityArray removeAllObjects];
    }
    
    NSArray *titleArr = @[@"流畅",@"标清",@"高清",@"超清",@"原画"];
    
    for (int i = 0;i < qulityArr.count;i++) {
        id sender = [qulityArr objectAtIndex:i];
        
        if ([sender isKindOfClass:[NSString class]]) {
            NSString *numberStr = (NSString*)sender;
            NSInteger index = [numberStr integerValue];
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setObject:numberStr forKey:@"number"];
            [dict setObject:[titleArr objectAtIndex:index] forKey:@"title"];
            [_qulityArray addObject:dict];
        }
    }
    
    
    [self createQulityButtons];
}

- (void)createQulityButtons{
    
    if (buttonArray == nil) {
        buttonArray = [[NSMutableArray alloc] init];
    }
    
    for (UIButton *button in buttonArray) {
        if (button && button.superview) {
            [button removeFromSuperview];
        }
    }
    
    [buttonArray removeAllObjects];
    
    CGFloat height = 0;
    for (int i = 0; i < _qulityArray.count; i++) {
        NSDictionary *dict = [_qulityArray objectAtIndex:i];
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 5+i*(VIDEO_BUTTON_HEIGHT+5), VIDEO_BUTTON_WIDTH, VIDEO_BUTTON_HEIGHT)];
        [self addSubview:button];
        button.tag = i+1111;
        [button setTitle:[dict objectForKey:@"title"] forState:UIControlStateNormal];
        [button setTitleColor:ColorWithRGB(0, 137, 255, 1) forState:UIControlStateSelected];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        [button setExclusiveTouch:YES];
        [buttonArray addObject:button];
        if (i == 0) {
            button.selected = YES;
        }
        
        if (i == (_qulityArray.count - 1)) {
            height = CGRectGetMaxY(button.frame)+5;
        }
    }
    
    self.frame = CGRectMake(self.frame.origin.x, -height, self.frame.size.width, height);
}

- (void)buttonAction:(UIButton*)button{
    for (UIButton *btn in buttonArray) {
        if (button.tag != btn.tag) {
            btn.selected = NO;
        }else{
            button.selected = YES;
        }
    }
    
    NSDictionary *dict = [_qulityArray objectAtIndex:button.tag - 1111];
    if (dict && self.delegate && [self.delegate respondsToSelector:@selector(playVideoWithQulityDict:)]) {
        [self.delegate playVideoWithQulityDict:dict];
    }
    
}

//- (NSString *)reloadWithQulity:(YKPlayerVideoQuality)qulity{
//    
//    NSString *titleStr = @"";
//    NSString *str = [NSString stringWithFormat:@"%d",qulity];
//    for (int i = 0; i < _qulityArray.count; i++) {
//        NSMutableDictionary *dict = [_qulityArray objectAtIndex:i];
//        UIButton *button = [buttonArray objectAtIndex:i];
//        NSString *qulityStr = [NSString stringWithFormat:@"%@",[dict objectForKey:@"number"]];
//        if ([str isEqualToString:qulityStr]) {
//            button.selected = YES;
//            titleStr = [NSString stringWithFormat:@"%@",[dict objectForKey:@"title"]];
//        }else{
//            button.selected = NO;
//        }
//    }
//    
//    return titleStr;
//}

- (void)layoutSubviews{
    [super layoutSubviews];
    if (buttonArray.count > 0) {
        for (int i = 0; i < buttonArray.count; i++) {
            UIButton *button = [buttonArray objectAtIndex:i];
            button.frame = CGRectMake(0, 5+i*(VIDEO_BUTTON_HEIGHT+5), VIDEO_BUTTON_WIDTH, VIDEO_BUTTON_HEIGHT);
        }
    }
}

@end
