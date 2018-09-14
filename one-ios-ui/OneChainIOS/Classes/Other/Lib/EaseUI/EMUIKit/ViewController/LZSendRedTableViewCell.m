//
//  LZSendRedTableViewCell.m
//  LZEasemob3
//
//  Created by chunzheng wang on 2017/12/1.
//  Copyright © 2017年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "LZSendRedTableViewCell.h"

@implementation LZSendRedTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setIcon:(NSString *)icon {
    
    [self.iconImg sd_setImageWithURL:[NSURL URLWithString:icon] placeholderImage:[UIImage imageNamed:@"noicon"]];
}

-(void)setName:(NSString *)name {
    self.nameLabel.text = name;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
-(void)setupUI {
    UIImageView *icon = [[UIImageView alloc] init];
    icon.image = [UIImage imageNamed:@"dash"];
    //    [icon sd_setImageWithURL:[NSURL URLWithString:[NSString addMoneyIconURLStr:self.showMoneyIconData[model.short_name]]] placeholderImage:[UIImage imageNamed:@"noicon"]];
    self.iconImg = icon;
    [self.contentView addSubview:icon];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(0);
        make.left.offset(LEFT_SPACE);
        make.width.offset(32);
        make.height.offset(32);
        
    }];
    UILabel *nameLabel = [UILabel makeLabelWithTextColor:[UIColor blackColor] andTextFont:LABEL_FRONT andContentText:@"123"];
    self.nameLabel = nameLabel;
    [self.contentView addSubview:nameLabel];
    [nameLabel sizeToFit];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(0);
        make.left.equalTo(icon.mas_right).offset(MID_MID_SPACE);
    }];
    
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rightenter"]];
    [self.contentView addSubview:img];
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-10);
        make.width.offset(10);
        make.height.offset(15);
        make.centerY.offset(0);
        
    }];
    
}
@end
