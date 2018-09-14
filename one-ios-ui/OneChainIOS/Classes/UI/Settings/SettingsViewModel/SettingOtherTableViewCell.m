//
//  SettingOtherTableViewCell.m
//  LZEasemob3
//
//  Created by hanshaoqing on 2017/11/8.
//  Copyright © 2017年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "SettingOtherTableViewCell.h"
@interface SettingOtherTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImg;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;

@property (weak, nonatomic) IBOutlet UILabel *verifyLbl;
@property (weak, nonatomic) IBOutlet UIImageView *rightArrow;

@end
@implementation SettingOtherTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(LZSettingOtherCellModel *)model {
    self.iconImg.image = [UIImage imageNamed:model.icon];
    
    self.desLabel.text = NSLocalizedString(model.name, nil);
    
}

- (void)setIsVerified:(BOOL)isVerified
{
    _isVerified = isVerified;
    if (_isVerified) {
        [self.rightArrow setHidden:YES];
        [self.verifyLbl setHidden:NO];
        self.verifyLbl.text = NSLocalizedString(@"face_verified", @"");
    } else {
        [self.verifyLbl setHidden:YES];
        [self.rightArrow setHidden:NO];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
