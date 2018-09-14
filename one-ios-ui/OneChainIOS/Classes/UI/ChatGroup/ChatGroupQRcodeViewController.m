//
//  ChatGroupQRcodeViewController.m
//  OneChainIOS
//
//  Created by chunzheng wang on 2018/5/14.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "ChatGroupQRcodeViewController.h"
#import "RedPacketMngr.h"
@interface ChatGroupQRcodeViewController ()
@property(nonatomic,strong)UIView *BGview;
@property(nonatomic,strong)UILabel *desLabel;

@end

@implementation ChatGroupQRcodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = NSLocalizedString(@"group_qr_code", @"群二维码");

    [self loadInfo];
    
    [self setupUI];

}
-(void)loadInfo {
    
    [[ONEChatClient sharedClient] getGroupIndexInformation:self.group_id completion:^(ONEError *error, ONEChatGroup *group) {
       
        dispatch_async(dispatch_get_main_queue(), ^{
           
            if (!error) {
                self.group_affiche = group.indexInformation.groupDesc;
                self.desLabel.text = group.indexInformation.groupDesc;
            }
        });
    }];
}


-(void)setupUI{
    self.view.themeMap = @{
                           BGColorName:@"bg_white_color"
                           };
    UIView *BGview = [[UIView alloc] init];
    [self.view addSubview:BGview];
    
    self.BGview = BGview;
    [BGview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(HeightScale(30));
//        make.left.offset(WidthScale(39));
//        make.right.offset(-WidthScale(39));
        make.height.offset(HeightScale(472));
        make.width.offset(WidthScale(297));
        make.centerX.offset(0);
        
    }];
//    BGview.backgroundColor = [UIColor greenColor];
    UIImageView *BGimg = [[UIImageView alloc] init/**WithImage:[UIImage imageNamed:@"group_qr_code_bg"]*/];
    BGimg.themeMap = @{
                       ImageName:@"offset_bg_image"
                       };
    [BGview addSubview:BGimg];
    [BGimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    UIImageView *iconImg = [[UIImageView alloc] init];
    [iconImg sd_setImageWithURL:[NSURL URLWithString:self.group_avatar_url] placeholderImage:[UIImage imageNamed:@"group_default_avatar"]];
    [BGview addSubview:iconImg];
    [iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(WidthScale(20));
        make.top.offset(HeightScale(20));
        make.width.offset((60));
        make.height.offset((60));
    }];
    iconImg.layer.cornerRadius  = 30;
    iconImg.layer.masksToBounds = YES;
    ///群名字
    UILabel *nameLabel = [UILabel makeLabelWithTextColor:[UIColor colorWithHex:BLACK_COLOER_ONE] andTextFont:LABEL_MID_FRONT andContentText:self.group_name];
    nameLabel.themeMap = @{
                           TextColorName:@"conversation_title_color"
                           };
    [BGview addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconImg.mas_right).offset(WidthScale(15));
        make.top.offset(HeightScale(26));
//        BGview.mas_width
        make.width.offset(WidthScale(297)-WidthScale(20)-WidthScale(15)-WidthScale(60));
    }];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    
    ///群ID
    NSString *IDstr = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"group_id", nil),self.show_group_id];
    
    UILabel *IDLabel = [UILabel makeLabelWithTextColor:[UIColor colorWithHex:BLACK_COLOER_ONE] andTextFont:LITTLE_LABEL_FRONT andContentText:IDstr];
    IDLabel.themeMap = @{
                         TextColorName:@"golden_text_color"
                         };
    [BGview addSubview:IDLabel];
    [IDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel.mas_left).offset(0);
        make.top.equalTo(nameLabel.mas_bottom).offset(WidthScale(3));
        make.width.offset(WidthScale(297)-WidthScale(20)-WidthScale(15)-WidthScale(60));
        
    }];
    [IDLabel sizeToFit];
    ///二维码
    
    UIImageView *QRimg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"modal_bg"]];
    [BGview addSubview:QRimg];
    [QRimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(WidthScale(111));
        //        make.width.offset((144));
        //        make.height.offset((144));
        make.left.equalTo(BGview.mas_left).offset(30);
        make.right.equalTo(BGview.mas_right).offset(-30);
        make.height.equalTo(QRimg.mas_width);
        
    }];
    NSString *groupUrl = [ONEUrlHelper groupShareUrlWithGroupId:self.group_id];
    NSString *qrCodeString = groupUrl;
    
    CGSize size = CGSizeMake(WidthScale(237), HeightScale(237));
    UIImage *qrImage = [ONEChatClient qrCodeImageWithString:qrCodeString size:size scale:1.f];
    QRimg.image = qrImage;
    
    ///群介绍
    
    UILabel *desLabel = [UILabel makeLabelWithTextColor:[UIColor colorWithHex:THEME_BLACK_COLOR] andTextFont:TWELFTH_FRONT andContentText:self.group_affiche];
    desLabel.themeMap = @{
                          TextColorName:@"conversation_detail_color"
                          };
    self.desLabel = desLabel;
    desLabel.numberOfLines = 0;
    [BGview addSubview:desLabel];
    [desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(QRimg.mas_bottom).offset(HeightScale(20));
        make.width.offset(WidthScale(257));
        make.centerX.offset(0);
        
    }];

    UIButton *saveInPhoneBtn = [UIButton new];
    saveInPhoneBtn.themeMap = @{
                                BGColorName:@"theme_color",
                                TextColorName:@"theme_title_color"
                                };
//    [saveInPhoneBtn setBackgroundColor:[UIColor colorWithHex:BTN_BACKGROUNDCOLOR]];
    [saveInPhoneBtn setTitle:NSLocalizedString(@"save_to_phone", nil) forState:UIControlStateNormal];
    [self.view addSubview:saveInPhoneBtn];
    [saveInPhoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(WidthScale(18));
        make.height.offset(HeightScale(44));
        make.width.offset(WidthScale(164));
        make.top.equalTo(BGview.mas_bottom).offset(HeightScale(26));
        
    }];
    saveInPhoneBtn.layer.cornerRadius = BTN_CIRCULAR;
    saveInPhoneBtn.layer.masksToBounds = YES;
    [saveInPhoneBtn addTarget:self action:@selector(saveBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    ////分享按钮
    UIButton *shareBtn = [UIButton new];
    shareBtn.themeMap = @{
                                BGColorName:@"theme_color",
                                TextColorName:@"theme_title_color"
                                };
//    [shareBtn setBackgroundColor:[UIColor colorWithHex:BTN_BACKGROUNDCOLOR]];
    [shareBtn setTitle:NSLocalizedString(@"action_share", nil) forState:UIControlStateNormal];
    [self.view addSubview:shareBtn];
    [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-WidthScale(18));
        make.height.offset(HeightScale(44));
        make.width.offset(WidthScale(164));
        make.top.equalTo(BGview.mas_bottom).offset(HeightScale(26));
        
    }];
    [shareBtn addTarget:self action:@selector(shareBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    shareBtn.layer.cornerRadius = BTN_CIRCULAR;
    shareBtn.layer.masksToBounds = YES;
    
    
}
- (NSString *)localLaungage
{
    NSString *language = @"";
    if ([[NSUserDefaults standardUserDefaults] objectForKey:MY_LANGUAGE] && ![[[NSUserDefaults standardUserDefaults] objectForKey:MY_LANGUAGE] isEqualToString:@""])
    {
        language = [[NSUserDefaults standardUserDefaults] objectForKey:MY_LANGUAGE];
    } else {
        
        language = [[CoinTools sharedCoinTools] getPreferredLanguage];
    }
    return language;
}

-(void)saveBtnClick{
   UIImage *image = [UIImage imageFromView:self.BGview];
    ///保存到手机
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);

}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    [self showHint:NSLocalizedString(@"save_to_phone_success", @"Saved")];
}
-(void)shareBtnClick {
    ///分享
    UIImage *image = [UIImage imageFromView:self.BGview];
    [RedPacketMngr shareMiningImage:image];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
