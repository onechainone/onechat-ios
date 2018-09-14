//
//  ONEMiningShareView.m
//  OneChainIOS
//
//  Created by lifei on 2018/3/12.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "ONEMiningShareView.h"

#define kINVATION_CODE_X 72
#define kINVATION_CODE_Y 285
#define kINVATION_CODE_WIDTH 221
#define kINVATION_CODE_HEIGHT 84
static const CGFloat kINVATION_CODE_FONT_SIZE = 60.f;

@interface ONEMiningShareView()

@property (nonatomic, copy) NSString *invationCode;
@end

@implementation ONEMiningShareView

- (instancetype)initWithFrame:(CGRect)frame invationCode:(NSString *)invationCode
{
    self = [super initWithFrame:CGRectMake(0, 0, 375, 667)];
    if (self) {
        
        _invationCode = invationCode;
        [self _initSubviews];
    }
    return self;
}

- (void)_initSubviews
{
    
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:self.frame];
    UIImage *image = [UIImage imageNamed:@"Mining_share_BG"];
    bgView.image = image;
    
    [self addSubview:bgView];
    
    UILabel *codeLbl = [[UILabel alloc] initWithFrame:CGRectMake(kINVATION_CODE_X, kINVATION_CODE_Y, kINVATION_CODE_WIDTH, kINVATION_CODE_HEIGHT)];
    codeLbl.centerX = self.centerX;
    codeLbl.font = [UIFont fontWithName:FONT_NAME_MEDIUM size:kINVATION_CODE_FONT_SIZE];
    codeLbl.textColor = [UIColor colorWithHex:THEME_COLOR];
    codeLbl.textAlignment = NSTextAlignmentCenter;
    codeLbl.text = _invationCode;
    [self addSubview:codeLbl];

}
@end
