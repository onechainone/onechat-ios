//
//  ONERewardCell.m
//  OneChainIOS
//
//  Created by lifei on 2018/5/10.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "ONERewardCell.h"
#import "CoinInfoMngr.h"
@implementation ONERewardCell

- (void)setupSubviews
{
    self.timeLbl = [[UILabel alloc] init];
    self.timeLbl.font = [UIFont fontWithName:FONT_NAME_LIGHT size:12.f];
//    self.timeLbl.textColor = DEFAULT_GRAY_COLOR;
    self.timeLbl.themeMap = @{
                              TextColorName:@"conversation_time_color"
                              };
    [self.contentView addSubview:self.timeLbl];
    
    [self.timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.nickNameLbl.mas_right).offset(10);
        make.centerY.equalTo(self.nickNameLbl);
    }];
    self.contentLbl = [[UILabel alloc] init];
    self.contentLbl.font = [UIFont fontWithName:FONT_NAME_MEDIUM size:15.f];
//    self.contentLbl.textColor = DEFAULT_BLACK_COLOR;
    self.contentLbl.themeMap = @{
                                 TextColorName:@"conversation_detail_color"
                                 };
    [self.contentView addSubview:self.contentLbl];
    [self.contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.nickNameLbl);
        make.top.equalTo(self.avatarView.mas_centerY).offset(2);
    }];
}

- (void)setReward:(ONEReward *)reward
{
    _reward = reward;
    [self.avatarView sd_setImageWithURL:[NSURL URLWithString:_reward.avatar_url] placeholderImage:[UIImage defaultAvaterImage]];
    self.nickNameLbl.text = _reward.nickname;
    NSString *asset_code = _reward.asset_code;
    if ([asset_code length] > 0) {
        NSDictionary *moneyInfoDic = [[ONEChatClient sharedClient] assetShowInfoFromAssetCode:asset_code];
        asset_code = [moneyInfoDic objectForKey:@"name"];
    }

    NSString *str = [NSString stringWithFormat:@"%@ %@ %@", NSLocalizedString(@"zanshang", @""),_reward.reward_amount, asset_code];
     NSMutableAttributedString *mAttr = [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName: [UIFont fontWithName:FONT_NAME_LIGHT size:14], NSForegroundColorAttributeName:THMColor(@"conversation_detail_color")}];
    if ([_reward.reward_amount rangeOfString:str].location != NSNotFound) {
        
        NSRange range = [_reward.reward_amount rangeOfString:str];
        
        [mAttr addAttributes:@{NSForegroundColorAttributeName: THMColor(@"theme_color")} range:range];
    }
    [self.contentLbl setAttributedText:mAttr];
}


@end
