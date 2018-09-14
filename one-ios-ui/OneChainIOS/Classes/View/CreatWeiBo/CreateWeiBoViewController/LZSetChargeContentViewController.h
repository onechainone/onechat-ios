//
//  LZSetChargeContentViewController.h
//  OneChainIOS
//
//  Created by chunzheng wang on 2018/5/11.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "LFSendRedController.h"
typedef void(^SendChargeMsg)(NSString *chargeAsset_code, NSString *chargeCount,BOOL isOpen);

@interface LZSetChargeContentViewController : LFSendRedController
@property (nonatomic, copy) SendChargeMsg sendchargeMsg;

///收费币的asset_code
@property(nonatomic,copy)NSString *chargeAsset_code;
////个数
@property(nonatomic,copy)NSString *chargeCount;
///是不是开启收费
@property(nonatomic)BOOL isOpen;
@property(nonatomic)UISwitch *openSwich;

@end
