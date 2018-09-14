//
//  CoinInfoMngr.m
//  LZEasemob3
//
//  Created by summer0610 on 2017/11/23.
//  Copyright © 2017年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "CoinInfoMngr.h"



#define NatureYES @"YES"


@interface CoinInfoMngr ()
//资产id
@property (nonatomic,copy)NSString *asset_id;
//名字
@property (nonatomic,copy)NSString *short_name;
//精度
@property (nonatomic,copy)NSString *min_precision;
//虚拟名字
@property (nonatomic,copy)NSString *asset_code;
//goodAmount onegood的数量
@property (nonatomic,copy)NSString *goodAmount;
// onebad的数量
@property (nonatomic,copy)NSString *badAmount;
/////钱币的头像
//@property (nonatomic,strong)NSMutableArray *moneyIcon;
@property (nonatomic,assign)BOOL isBalanceLoding;
//正在加载配置isBalanceLoding
@property (nonatomic,assign)BOOL isConfigLoding;
//isBalanceLoding 原子列表
@property (nonatomic,assign)BOOL isAtomListLoding;
//isRechargeListLoding 充值列表
@property (nonatomic,assign)BOOL isRechargeListLoding;
///交易交易对
@property (nonatomic,assign)BOOL isTradeTeamLoding;

@end

@implementation CoinInfoMngr
//单例
+ (instancetype)sharedCoinInfoMngr{
    
    static CoinInfoMngr *client;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //        self.inCount = 1;
        client = [[self alloc]init];
    });
    
    return client;
}


@end
