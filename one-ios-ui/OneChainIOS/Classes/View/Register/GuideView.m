//
//  GuideView.m
//  OneChainIOS
//
//  Created by lifei on 2018/1/26.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "GuideView.h"


@interface GuideView()

@property (nonatomic, assign) GuideStyle style;

@property (nonatomic, strong) UIImageView *tipImageView;
@end

@implementation GuideView

- (instancetype)initWithGuideStyle:(GuideStyle)style
{
    self = [super init];
    if (self) {
        _style = style;
        [self _layoutSubviews];
    }
    return self;
}

- (void)_layoutSubviews
{
    _tipImageView = [[UIImageView alloc] init];
    UIImage *image = nil;
    if (_style == GuideStyleFirst) {
        
        image = [UIImage imageNamed:@"Tip_first"];
    } else if (_style == GuideStyleSecond) {
        
        image = [UIImage imageNamed:@"Tip_second"];
    }
    _tipImageView.image = image;
    if (KScreenW == IPHONEFIVESCREENH) {
        _tipImageView.contentMode = UIViewContentModeScaleToFill;
    } else {
        
        _tipImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    [self addSubview:_tipImageView];
    
    [_tipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).offset(WidthScale(18));
        make.right.equalTo(self.mas_right).offset(-WidthScale(18));
        make.top.equalTo(self);
    }];
    
    [self createLbl];
}

- (void)createLbl
{
    NSArray *array = @[NSLocalizedString(@"get_seed", @""),NSLocalizedString(@"make_sure_seed", @""),NSLocalizedString(@"input_infomation", @""), NSLocalizedString(@"register_completed", @"")];
    

    for (NSInteger i = 0; i < array.count; i ++ ) {
        
        UILabel *lbl = [[UILabel alloc] init];
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.numberOfLines = 0;
        lbl.font = [UIFont fontWithName:FONT_NAME_REGULAR size:11.f];
        lbl.text = array[i];

        [self addSubview:lbl];
        [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(_tipImageView.mas_bottom).offset(5);

            NSInteger padding = i < 2 ? WidthScale(37) : WidthScale(48);
            make.centerX.equalTo(@((i - 2) * WidthScale(85) + padding));
            make.width.mas_equalTo(@(WidthScale(85)));
            make.bottom.equalTo(self.mas_bottom).offset(-5);
        }];
    }
}

@end
