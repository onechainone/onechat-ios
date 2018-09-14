//
//  SettingOtherTableViewCell.h
//  LZEasemob3
//
//  Created by hanshaoqing on 2017/11/8.
//  Copyright © 2017年 帶頭二哥 QQ:648959. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LZSettingOtherCellModel.h"

@interface SettingOtherTableViewCell : UITableViewCell
@property(nonatomic, strong)LZSettingOtherCellModel *model;
@property (nonatomic) BOOL isVerified;
@end
