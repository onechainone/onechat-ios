//
//  SelectCoinController.h
//  LZEasemob3
//
//  Created by lifei on 2017/12/21.
//  Copyright © 2017年 帶頭二哥 QQ:648959. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LZSendRedTableViewCell.h"
@class RpAssetModel;
typedef void(^SelectCoin)(RpAssetModel *model);
#import "CoinInfoMngr.h"
#import "RedPacketMngr.h"

@interface SelectCoinController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, copy) SelectCoin selectCoin;
- (instancetype)initWithDatasources:(NSArray *)datasource;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datasource;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) NSArray *origindatasource;

@end
