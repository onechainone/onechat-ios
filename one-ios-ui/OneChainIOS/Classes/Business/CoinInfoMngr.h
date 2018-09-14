//
//  CoinInfoMngr.h
//  LZEasemob3
//
//  Created by summer0610 on 2017/11/23.
//  Copyright © 2017年 帶頭二哥 QQ:648959. All rights reserved.
//

#import <Foundation/Foundation.h>

// #import <WalletCore/WSCoinAccount.h>

@interface CoinInfoMngr : NSObject
typedef void(^Load) (NSString *amount,NSString *precision);

//单例
+ (instancetype)sharedCoinInfoMngr;
//存储网络状态
@property (nonatomic, strong) NSArray *nodeSources;
//siArray
@property (nonatomic, strong) NSArray *siArray;


///收费币的asset_code
@property(nonatomic,copy)NSString *chargeAsset_code;
////个数
@property(nonatomic,copy)NSString *chargeCount;
///是不是开启收费
@property(nonatomic)BOOL isOpen;

///密码
@property (nonatomic, strong) NSString *mima;
///是不是开关声音
@property (nonatomic) NSString *isOpenSound;
///输入密码
@property (nonatomic) NSString *shuRuStr;



@end
