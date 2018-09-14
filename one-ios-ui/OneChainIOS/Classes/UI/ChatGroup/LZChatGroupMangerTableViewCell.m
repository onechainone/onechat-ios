//
//  LZChatGroupMangerTableViewCell.m
//  OneChainIOS
//
//  Created by chunzheng wang on 2018/5/7.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "LZChatGroupMangerTableViewCell.h"
#define LOCAL_LEFT_MERGE 12

@implementation LZChatGroupMangerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];

}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}
-(void)setupUI {
    UILabel *nameLabel = [UILabel makeLabelWithTextColor:[UIColor blackColor] andTextFont:LITTLE_LABEL_FRONT andContentText:@"群头像"];
    self.nameLabel = nameLabel;
    
    [self addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(LOCAL_LEFT_MERGE);
        make.centerY.offset(0);
        
    }];
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rightenter"]];
    self.img = img;
    
    [self addSubview:img];
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-12);
        make.centerY.offset(0);
    }];
    [img sizeToFit];
    UILabel *desLabel = [UILabel makeLabelWithTextColor:[UIColor colorWithHex:THEME_BLACK_COLOR] andTextFont:TWELFTH_FRONT andContentText:@"123"];
    self.desLabel = desLabel;
    [self addSubview:desLabel];
    [desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-12);
        make.centerY.offset(0);
    }];
    
}
-(void)setName:(NSString *)name {
    self.nameLabel.text = name;
    //加群方式
    if ([name isEqualToString:NSLocalizedString(@"group_join_type", nil)]) {
        self.desLabel.hidden = NO;
        self.img.hidden = YES;
    } else {
        self.desLabel.hidden = YES;
        self.img.hidden = NO;
    }
}
-(void)setAdd_group_type:(NSString *)add_group_type {
    self.desLabel.text = add_group_type;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

@end
