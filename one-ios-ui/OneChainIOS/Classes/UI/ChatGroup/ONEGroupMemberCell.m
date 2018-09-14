//
//  ONEGroupMemberCell.m
//  OneChainIOS
//
//  Created by lifei on 2018/5/30.
//  Copyright © 2018 帶頭二哥 QQ:648959. All rights reserved.
//

#import "ONEGroupMemberCell.h"
#import "ContactView.h"
@interface ONEGroupMemberCell()

@property (nonatomic, strong) ContactView *imageV;
@property (nonatomic, strong) UIImageView *addView;
@end

@implementation ONEGroupMemberCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.themeMap = @{
                          BGColorName:@"bg_white_color"
                          };
        [self _layoutSubviews];
    }
    return self;
}

- (void)_layoutSubviews
{
    _imageV = [[ContactView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    _imageV.themeMap = @{
                         BGColorName:@"bg_white_color"
                         };
    _imageV.frame = self.bounds;
    _imageV.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    [_imageV addGestureRecognizer:longPress];
    [self.contentView addSubview:_imageV];
    _addView = [[UIImageView alloc] init];
    _addView.image = [UIImage imageNamed:@"group_participant_add"];
    _addView.contentMode = UIViewContentModeScaleToFill;
    _addView.frame = CGRectMake(self.width / 12, self.height / 6, self.width * 5 / 6, self.height * 5 / 6);

    [self.contentView addSubview:_addView];
    _addView.hidden = YES;
   
}

- (void)setRemark:(NSString *)remark
{
    _remark = remark;
    if ([_remark isEqualToString:@"group_add"]) {
        
        _imageV.hidden = YES;
        _addView.hidden = NO;
    } else {
        _imageV.hidden = NO;
        _addView.hidden = YES;
        _imageV.remark = _remark;
    }
}

- (void)setRoleType:(NSInteger)roleType
{
    _imageV.roleTyle = roleType;
}

- (void)longPressAction:(UILongPressGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        
        if (_delegate && [_delegate respondsToSelector:@selector(didLongPressItem:)]) {
            
            [_delegate didLongPressItem:_remark];
        }
    }
}
@end
