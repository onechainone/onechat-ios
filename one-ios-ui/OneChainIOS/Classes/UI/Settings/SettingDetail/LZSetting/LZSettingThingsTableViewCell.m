//
//  LZSettingThingsTableViewCell.m
//  LZEasemob3
//
//  Created by chunzheng wang on 2017/11/14.
//  Copyright © 2017年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "LZSettingThingsTableViewCell.h"
#define LOCAL_HANWEN @"한국어"

@interface LZSettingThingsTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *rightImg;
@property(nonatomic,strong)UISwitch *swith;


@end
@implementation LZSettingThingsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    
    self.nameLabel.themeMap = @{
                                TextColorName:@"conversation_title_color"
                                };
    self.titleLabel.themeMap = @{
                                 TextColorName:@"conversation_detail_color"
                                 };
}
-(void)setModel:(LZSettingThingsModel *)model {
    self.nameLabel.text = NSLocalizedString(model.name, nil);
    self.titleLabel.text = NSLocalizedString(model.title, nil);
    
    //英语en-US zh-Hans-US
    if ([model.name isEqualToString:@"select_langurafe"]) {
        [self setLanguge];
        
  
    }
    
    
    
}
-(void)setLanguge {
    if (![[NSUserDefaults standardUserDefaults] objectForKey:MY_LANGUAGE] || [[[NSUserDefaults standardUserDefaults] objectForKey:MY_LANGUAGE] isEqualToString:@""]) {
        
        //判断语言
        NSString *languageType = [[CoinTools sharedCoinTools] getPreferredLanguage];
        
        if([languageType rangeOfString:LANGUAGE_ZH_HANS].location !=NSNotFound)
        {
            NSLog(@"包含");
            self.titleLabel.text = JIANTIZHONGWEN;
        }
        else
        {
            // NSLog(@"不包含");
            self.titleLabel.text = ENGLISH;
        }
        
    }
    else {
        ///中文
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:MY_LANGUAGE] isEqualToString:LANGUAGE_ZH_HANS]) {
            self.titleLabel.text = JIANTIZHONGWEN;
        }/// 韩语
        else if([[[NSUserDefaults standardUserDefaults] objectForKey:MY_LANGUAGE] isEqualToString:LANGUAGE_KO]) {
            self.titleLabel.text = LOCAL_HANWEN;
        }
        ///意大利语
        else if([[[NSUserDefaults standardUserDefaults] objectForKey:MY_LANGUAGE] isEqualToString:LANGUAGE_IT]) {
            self.titleLabel.text = YIDALIYU;
            
        }
        ///德语
        else if([[[NSUserDefaults standardUserDefaults] objectForKey:MY_LANGUAGE] isEqualToString:LANGUAGE_DE]) {
            self.titleLabel.text = DEYU;
            
        }
        ///法语
        else if([[[NSUserDefaults standardUserDefaults] objectForKey:MY_LANGUAGE] isEqualToString:LANGUAGE_FR]){
            self.titleLabel.text = FAYU;
            
        }
        ///菲律宾语
        else if([[[NSUserDefaults standardUserDefaults] objectForKey:MY_LANGUAGE] isEqualToString:LANGUAGE_FIL]){
            self.titleLabel.text = FEILVBINYU;
            
        }
        ///葡萄牙
        else if([[[NSUserDefaults standardUserDefaults] objectForKey:MY_LANGUAGE] isEqualToString:LANGUAGE_PT]){
            self.titleLabel.text = PUTAOYAYU;
            
        }
        //荷兰
        else if([[[NSUserDefaults standardUserDefaults] objectForKey:MY_LANGUAGE] isEqualToString:LANGUAGE_NL]){
            self.titleLabel.text = HELANYU;
            
        }
        ///印度尼西亚
        else if([[[NSUserDefaults standardUserDefaults] objectForKey:MY_LANGUAGE] isEqualToString:LANGUAGE_ID]){
            self.titleLabel.text = YINDUNIXIYAYU;
            
        }
        //西班牙语
        else if([[[NSUserDefaults standardUserDefaults] objectForKey:MY_LANGUAGE] isEqualToString:LANGUAGE_ES]){
            self.titleLabel.text = XIBANYAYU;
            
        }
        //阿拉伯语
        else if([[[NSUserDefaults standardUserDefaults] objectForKey:MY_LANGUAGE] isEqualToString:LANGUAGE_AR]){
            self.titleLabel.text = ALABOYU;
            
        }
        //印度
        else if([[[NSUserDefaults standardUserDefaults] objectForKey:MY_LANGUAGE] isEqualToString:LANGUAGE_HI]){
            self.titleLabel.text = YINDUYU;
            
        }
        //日语
        else if([[[NSUserDefaults standardUserDefaults] objectForKey:MY_LANGUAGE] isEqualToString:LANGUAGE_JA]){
            self.titleLabel.text = RIYU;
            
        }
        else {
            self.titleLabel.text = ENGLISH;
            
        }
        
    }
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    if (selected) {
        self.themeMap = @{
                          BGColorName:@"bg_color"
                          };
    } else {
        self.themeMap = @{
                          BGColorName:@"bg_white_color"
                          };
    }
    // Configure the view for the selected state
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        self.themeMap = @{
                          BGColorName:@"bg_color"
                          };
    } else {
        self.themeMap = @{
                          BGColorName:@"bg_white_color"
                          };
    }

}

@end
