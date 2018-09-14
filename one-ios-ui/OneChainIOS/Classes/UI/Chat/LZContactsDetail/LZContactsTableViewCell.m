//
//  LZContactsTableViewCell.m
//  LZEasemob3
//
//  Created by chunzheng wang on 2017/11/30.
//  Copyright © 2017年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "LZContactsTableViewCell.h"

@implementation LZContactsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.nameLabel.themeMap = @{
                                 TextColorName:@"conversation_title_color"
                                 };
    self.titleLabel.themeMap = @{
                                 TextColorName:@"conversation_detail_color"
                                 };
    self.themeMap = @{
                      BGColorName:@"bg_white_color"
                      };
}

-(void)setName:(NSString *)name {
    self.nameLabel.text = name;
}

-(void)setSubtitles:(NSString *)subtitles {
    self.titleLabel.text = subtitles;
    
    if ([_model.name isEqualToString:@"clear_chat_msg"]) {
        self.titleLabel.hidden = YES;
    }
}

-(void)setModel:(LZContactsThingsModel *)model {
    _model = model;
    
    self.nameLabel.text = NSLocalizedString(model.name, nil)
    ;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

@end
