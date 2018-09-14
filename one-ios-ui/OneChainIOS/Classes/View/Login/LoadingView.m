//
//  LoadingView.m
//  OneChainIOS
//
//  Created by lifei on 2018/1/23.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "LoadingView.h"
#import "UIView+Extension.h"
#define KANO_CIRCLE 120
#define KANO_SINGLE_W 10
static const CGFloat BANNER_HEIGHT = 30;
static const CGFloat BANNER_FONT_SIZE = 14.f;
static const CGFloat BANNER_NUM_OF_LINES = 0;
@interface LoadingView()

@property (nonatomic, strong) UILabel *loadingBanner;
@property (nonatomic, strong) UIView *anotationV;
@property (nonatomic, strong) UIView *round1;
@property (nonatomic, strong) UIView *round2;
@property (nonatomic, strong) UIView *round3;

@end

@implementation LoadingView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupAnotation];
    }
    return self;
}


- (UILabel *)loadingBanner
{
    if (!_loadingBanner) {
        
        _loadingBanner = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame) - BANNER_HEIGHT, CGRectGetWidth(self.frame), BANNER_HEIGHT)];
        _loadingBanner.textColor = [UIColor colorWithHex:THEME_COLOR];
        _loadingBanner.font = [UIFont fontWithName:@"PingFangSC-Regular" size:BANNER_FONT_SIZE];
        _loadingBanner.numberOfLines = BANNER_NUM_OF_LINES;
        _loadingBanner.adjustsFontSizeToFitWidth = YES;
        _loadingBanner.textAlignment = NSTextAlignmentCenter;
        _loadingBanner.text = NSLocalizedString(@"sync_data", @"");
    }
    return _loadingBanner;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self addSubview:self.loadingBanner];
    
    _round2.centerX = self.width / 2;
    _round2.centerY = self.height / 2;
    
    _round1.centerX = _round2.centerX - 20;
    _round1.centerY = _round2.centerY - 20;
    
    _round3.centerX = _round2.centerX + 20;
    _round3.centerY = _round2.centerY;
}

- (void)setupAnotation
{
    UIColor *color = [UIColor colorWithHex:THEME_COLOR];
    UIView *round1 = [[UIView alloc] init];
    round1.width = KANO_SINGLE_W;
    round1.height = KANO_SINGLE_W;
    round1.backgroundColor = color;
    round1.layer.cornerRadius = KANO_SINGLE_W / 2;
    
    UIView *round2 = [[UIView alloc] init];
    round2.width = KANO_SINGLE_W;
    round2.height = KANO_SINGLE_W;
    round2.backgroundColor = color;
    round2.layer.cornerRadius = KANO_SINGLE_W / 2;
    
    UIView *round3 = [[UIView alloc] init];
    round3.width = KANO_SINGLE_W;
    round3.height = KANO_SINGLE_W;
    round3.backgroundColor = color;
    round3.layer.cornerRadius = KANO_SINGLE_W / 2;
    
    [self addSubview:round1];
    [self addSubview:round2];
    [self addSubview:round3];
    

    round2.centerX = self.width / 2;
    round2.centerY = self.height / 2;
    
    round1.centerX = round2.centerX - 20;
    round1.centerY = round2.centerY - 20;
    
    round3.centerX = round2.centerX + 20;
    round3.centerY = round2.centerY;
    
    _round1 = round1;
    _round2 = round2;
    _round3 = round3;
    
    [self startAno];
}

- (void)startAno {
    
    CGPoint otherRoundCenter1 = CGPointMake(_round1.centerX+10, _round2.centerY);
    CGPoint otherRoundCenter2 = CGPointMake(_round2.centerX+10, _round2.centerY);
    //圆1的路径
    UIBezierPath *path1 = [[UIBezierPath alloc] init];
    [path1 addArcWithCenter:otherRoundCenter1 radius:10 startAngle:-M_PI endAngle:0 clockwise:true];
    UIBezierPath *path1_1 = [[UIBezierPath alloc] init];
    [path1_1 addArcWithCenter:otherRoundCenter2 radius:10 startAngle:-M_PI endAngle:0 clockwise:false];
    [path1 appendPath:path1_1];
    
    [self viewMovePathAnimWith:_round1 path:path1];
    
    UIBezierPath *path2 = [[UIBezierPath alloc] init];
    [path2 addArcWithCenter:otherRoundCenter1 radius:10 startAngle:0 endAngle:-M_PI clockwise:true];
    [self viewMovePathAnimWith:_round2 path:path2];
    
    UIBezierPath *path3 = [[UIBezierPath alloc] init];
    [path3 addArcWithCenter:otherRoundCenter2 radius:10 startAngle:0 endAngle:-M_PI clockwise:false];
    [self viewMovePathAnimWith:_round3 path:path3];

}

- (void)viewMovePathAnimWith:(UIView *)view path:(UIBezierPath *)path
{
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    anim.path = [path CGPath];
    anim.removedOnCompletion = false;
    anim.fillMode = kCAFillModeForwards;
    anim.calculationMode = kCAAnimationCubic;
    anim.repeatCount = MAXFLOAT;
    anim.duration = 1.f;
    anim.autoreverses = NO;
    anim.delegate = self;
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [view.layer addAnimation:anim forKey:@"animation"];
}

- (void)stopAno
{
    [_round1.layer removeAllAnimations];
    [_round2.layer removeAllAnimations];
    [_round3.layer removeAllAnimations];
    [self removeFromSuperview];
}

- (void)updateBannerText:(NSString *)text
{
    if (text.length == 0) {
        return;
    }
    self.loadingBanner.text = text;
    [UIView animateWithDuration:0.5 animations:^{
        
        self.height += BANNER_HEIGHT;
        self.loadingBanner.height += BANNER_HEIGHT;
        
    }];
}




@end
