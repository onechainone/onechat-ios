//
//  LFSendRedController.h
//  LZEasemob3
//
//  Created by lifei on 2017/12/21.
//  Copyright © 2017年 帶頭二哥 QQ:648959. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RedpacketButton.h"
#import "UIColor+Addition.h"
#import "UIButton+EMWebCache.h"
#import "CoinInfoMngr.h"
#import "RedpacketTF.h"
#import "RedPacketMngr.h"
#import "ZYKeyboardUtil.h"

typedef void(^SendRedMsg)(NSString *redID, NSString *redMsg);
@interface LFSendRedController : UIViewController

@property (nonatomic, copy) SendRedMsg sendRedMsg;
@property (nonatomic, copy) NSString *groupId;
@property (nonatomic, strong)UILabel *groupMCLbl;

@property (nonatomic, strong) UIImageView *imgV1;
/////
@property (nonatomic, strong) RedpacketButton *selectCoinBtn;
@property (nonatomic, strong) RedpacketTF *singleAmountTF;
@property (nonatomic, strong) RedpacketTF *totalAmountTF;
@property (nonatomic, strong) RedpacketTF *redCountTF;
@property (nonatomic, strong) RedpacketTF *redMsgTF;
@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) NSDictionary *coinIcon;
@property (nonatomic, strong) RpAssetModel *selectedModel;
@property (nonatomic, strong) NSArray *assetsList;
@property (nonatomic, strong) UILabel *changeLabel1;
@property (nonatomic, strong) UIButton *no2Btn;
@property (nonatomic) BOOL isEquailRed;
@property (nonatomic, strong) UILabel *singleALbl;
@property (nonatomic, strong) ZYKeyboardUtil *keyboardUtil;
@property (nonatomic, strong) ONEChatGroup *grInfo;
/////////// imgV4 red_countLbl imgV5 msgLbl
@property (nonatomic, strong) UILabel *red_countLbl;
@property (nonatomic, strong) UILabel *msgLbl;
@property (nonatomic, strong) UIImageView *imgV4;
@property (nonatomic, strong) UIImageView *imgV5;
@property (nonatomic, strong) UILabel *select_type_lbl;

- (void)sendRedpacket;
- (RedbagModel *)getModel;
-(void)updateLeftSubviewConstraints:(UIView *)subView from:(UIView *)fromView;
- (void)updateRedType:(BOOL)isEquail;
- (void)gotoCoinSelectionVC:(NSArray *)datasource;
- (void)updateCoinWithCode:(NSString *)code button:(RedpacketButton *)button;
- (void)loadAssetsList;
- (void)sendButtonCanClick:(BOOL)status;

@end
