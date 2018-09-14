//
//  SettingInfoTableViewCell.m
//  LZEasemob3
//
//  Created by hanshaoqing on 2017/11/8.
//  Copyright © 2017年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "SettingInfoTableViewCell.h"
#import "NSString+Addition.h"

#define Spece 10
@interface  SettingInfoTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *IconImg;
@property (weak, nonatomic) IBOutlet UILabel *NameLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
@property (weak, nonatomic) IBOutlet UILabel *welcomeLabel;
@property (weak, nonatomic) UIImageView *sexImg;

@property (weak, nonatomic) IBOutlet UILabel *introLabel;
@property (weak, nonatomic) IBOutlet UIButton *erWeimaBtn;
@property (weak, nonatomic) IBOutlet UILabel *yaoQingMaLabel;

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

@end
@implementation SettingInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
//    self.bgImageView.image = [UIImage imageFromColor:THMImage(@"bg_white_color") withCGRect:];
    self.bgImageView.image = nil;
    self.bgImageView.themeMap = @{
                                  BGColorName:@"bg_white_color"
                                  };
    self.NameLabel.themeMap = @{
                                TextColorName:@"common_text_color"
                                };
    self.yaoQingMaLabel.themeMap = @{
                                     TextColorName:@"common_text_color"
                                     };
    self.introLabel.themeMap = @{
                                 TextColorName:@"common_text_color"
                                 };
    
    self.themeMap = @{
                      BGColorName:@"bg_white_color"
                      };
    
//    self.welcomeLabel.text = NSLocalizedString(@"default_user_intro", nil);
    self.IconImg.layer.cornerRadius = self.IconImg.width/2;
    self.IconImg.layer.masksToBounds = YES;
    self.separatorInset = UIEdgeInsetsMake(0, 600, 0, 0);
    UIImageView *sexImg = [[UIImageView alloc] init];
    [self.contentView addSubview:sexImg];
    [sexImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.NameLabel.mas_right).offset(Spece);
        make.centerY.equalTo(self.NameLabel).offset(0);
        make.width.offset(Spece);
        make.height.offset(Spece);
    }];
    self.sexImg = sexImg;
    ///从联系人进来的
//    if (self.type) {
//        
//    } else{
//        NSString *accountID = WSHomeAccount.accountId;
//        //    NSString *a = [[NSString alloc] initWithString : @"冬瓜，西瓜，火龙果，大头，小狗" ];
//        NSArray *b = [accountID componentsSeparatedByString:@"."];
//        NSString *a3 = [b objectAtIndex:2];
//        self.yaoQingMaLabel.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"invitation_code", @""),a3];
//        
//    }

    
}
-(void)setInvitationCode:(NSString *)invitationCode{
    NSString *accountID = invitationCode;
    //    NSString *a = [[NSString alloc] initWithString : @"冬瓜，西瓜，火龙果，大头，小狗" ];
    if (accountID) {
        
        NSArray *b = [accountID componentsSeparatedByString:@"."];
        if (b.count == 3) {
            NSString *a3 = [b objectAtIndex:2];
            self.yaoQingMaLabel.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"invitation_code", @""),a3];
        }
    }
}
-(void)setName:(NSString *)name {
    if (self.type) {
        self.erWeimaBtn.hidden = YES;
    }
    self.NameLabel.text = name;
    [self.NameLabel sizeToFit];
    
}
-(void)setIntro:(NSString *)intro {
    if (!intro || intro.length == 0) {
        self.introLabel.text = NSLocalizedString(@"default_user_intro", nil);
    } else {
        self.introLabel.text = intro;
    }
    
}
-(void)setSex:(NSInteger)sex {
    [self.NameLabel sizeToFit];
    _sex = sex;
//    self.sexImg = nil;
//    UIImageView *sexImg = [[UIImageView alloc] init];
//    [self.contentView addSubview:sexImg];
//    [sexImg mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.NameLabel.mas_right).offset(Spece);
//        make.centerY.equalTo(self.NameLabel).offset(0);
//        make.width.offset(Spece);
//        make.height.offset(Spece);
//    }];
//    self.sexImg = sexImg;
    if (sex == AccountMan) {
//       sexImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sex_man_icon"]];
        self.sexImg.image = [UIImage imageNamed:@"sex_man_icon"];
//        self.sexImg = sexImg;
//        [self.contentView addSubview:sexImg];
//        [sexImg mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.NameLabel.mas_right).offset(Spece);
//            make.centerY.equalTo(self.NameLabel).offset(0);
//            make.width.offset(Spece);
//            make.height.offset(Spece);
//        }];
    }else if (sex == AccountWoman) {
//        UIImageView *sexImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sex_women_icon"]];
//        self.sexImg = sexImg;
        self.sexImg.image = [UIImage imageNamed:@"sex_women_icon"];
//        [self.contentView addSubview:sexImg];
//        [sexImg mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.NameLabel.mas_right).offset(0);
//            make.centerY.equalTo(self.NameLabel).offset(0);
//            make.width.offset(Spece);
//            make.height.offset(Spece);
//
//        }];
    } else {
        // 什么都没有
    }

    
}
-(void)setAccount:(NSString *)account {
    NSString *realAccount = [NSString stringWithFormat:@"ID: %@",account];
    self.accountLabel.text = realAccount;
}
-(void)setIcon:(NSString *)icon {
    

    if (self.sex == AccountMan) {
        [self.IconImg sd_setImageWithURL:[NSURL URLWithString:[NSString addURLStr:icon]] placeholderImage:[UIImage imageNamed:@"maniconplaceholder"] completed:nil];
        
    } else if (self.sex == AccountWoman) {
        [self.IconImg sd_setImageWithURL:[NSURL URLWithString:[NSString addURLStr:icon]] placeholderImage:[UIImage imageNamed:@"womaniconpalceholder"] completed:nil];
    } else {
        [self.IconImg sd_setImageWithURL:[NSURL URLWithString:[NSString addURLStr:icon]] placeholderImage:[UIImage imageNamed:@"peopleicon"] completed:nil];
    }

    
}
- (IBAction)showMyQRCode:(UIButton *)sender {
    
    !_qrCodeBlock ?: _qrCodeBlock();
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
