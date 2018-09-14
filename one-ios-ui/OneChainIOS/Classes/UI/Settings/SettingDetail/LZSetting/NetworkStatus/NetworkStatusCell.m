//
//  NetworkStatusCell.m
//  OneChainIOS
//
//  Created by lifei on 2018/1/10.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "NetworkStatusCell.h"

#define KTITLE_COLOR RGBACOLOR(48, 48, 48, 1)
#define KTITLE_FONT [UIFont fontWithName:@"PingFangSC-Regular" size:14.f]
#define KHOR_PADDING WidthScale(18)

@interface NetworkStatusCell()

@property (nonatomic, strong) UILabel *nodeLbl;
@property (nonatomic, strong) UIImageView *statusV;
@end

@implementation NetworkStatusCell

- (UILabel *)nodeLbl
{
    if (!_nodeLbl) {
        
        _nodeLbl = [[UILabel alloc] init];
//        _nodeLbl.textColor = KTITLE_COLOR;
        _nodeLbl.themeMap = @{
                              TextColorName:@"conversation_title_color"
                              };
        _nodeLbl.font = KTITLE_FONT;
    }
    return _nodeLbl;
}

- (UIImageView *)statusV
{
    if (!_statusV) {
        
        _statusV = [[UIImageView alloc] init];
    }
    return _statusV;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.themeMap = @{
                          BGColorName:@"bg_white_color"
                          };
        [self _layoutSubviews];
    }
    return self;
}

- (void)_layoutSubviews
{
    [self.contentView addSubview:self.nodeLbl];
    [self.contentView addSubview:self.statusV];
    
    [self.nodeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView.mas_left).offset(KHOR_PADDING);
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.statusV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.contentView.mas_right).offset(-KHOR_PADDING);
        make.centerY.equalTo(self.contentView);
    }];
}

- (void)setNodeName:(NSString *)nodeName
{
    _nodeName = nodeName;
    self.nodeLbl.text = _nodeName;
}

- (void)setStatus:(BOOL)status
{
    _status = status;
    if (_status) {
        
        self.statusV.image = [UIImage imageNamed:@"NetworkGood"];
    } else {
        
        self.statusV.image = [UIImage imageNamed:@"NetworkFail"];
    }
}

@end
