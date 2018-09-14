//
//  ChoseCell.m
//  demoDan
//
//  Created by mac on 16/8/25.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "ChoseCell.h"
#import "Masonry.h"
@implementation ChoseCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.themeMap = @{
                          BGColorName:@"bg_white_color"
                          };
        _stateV=[[UIImageView alloc]init];
        [self.contentView addSubview:_stateV];
        [_stateV mas_makeConstraints:^(MASConstraintMaker *make) {
            //            make.top.left.equalTo(self.contentView).with.offset(15);
            //            make.bottom.equalTo(self.contentView).with.offset(-15);
            //            make.width.mas_equalTo(_stateV.mas_height);
            make.right.offset(-RIGHT_SPACE);
            make.centerY.offset(0);
            make.width.height.offset(16);
            
        }];
        
        _nameLabel=[[UILabel alloc]init];
//        _nameLabel.textColor=[UIColor blackColor];
        _nameLabel.themeMap = @{
                                TextColorName:@"conversation_title_color"
                                };
        _nameLabel.textAlignment=NSTextAlignmentLeft;
        [self.contentView addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            //            make.top.equalTo(self.contentView).with.offset(5);
            //            make.bottom.equalTo(self.contentView).with.offset(-5);
            //            make.right.equalTo(self.contentView).with.offset(-10);
            //            make.left.equalTo(_stateV.mas_right).with.offset(10);
            make.left.offset(LEFT_SPACE);
            make.centerY.offset(0);
            
        }];
        
    }
    return self;
}











@end
