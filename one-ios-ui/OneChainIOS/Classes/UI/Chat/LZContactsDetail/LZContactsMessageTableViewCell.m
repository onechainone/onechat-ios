//
//  LZContactsMessageTableViewCell.m
//  LZEasemob3
//
//  Created by chunzheng wang on 2017/11/30.
//  Copyright © 2017年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "LZContactsMessageTableViewCell.h"

@interface LZContactsMessageTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *goodMoneyCount;
@property (weak, nonatomic) IBOutlet UILabel *badMoneyCount;

@property (weak, nonatomic) IBOutlet UIView *badView;

@property (weak, nonatomic) IBOutlet UIView *goodView;

@end

@implementation LZContactsMessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.themeMap = @{
                      BGColorName:@"bg_white_color"
                      };
    self.goodView.themeMap = @{
                                     BGColorName:@"bg_white_color"
                                     };
    self.badView.themeMap = @{
                                     BGColorName:@"bg_white_color"
                                     };
}

-(void)setGoodCount:(NSString *)goodCount {
    self.goodMoneyCount.text = goodCount;
}
-(void)setBadCount:(NSString *)badCount {
    self.badMoneyCount.text = badCount;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

@end
