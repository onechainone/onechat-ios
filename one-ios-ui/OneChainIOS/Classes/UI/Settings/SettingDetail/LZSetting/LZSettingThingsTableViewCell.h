//
//  LZSettingThingsTableViewCell.h
//  LZEasemob3
//
//  Created by chunzheng wang on 2017/11/14.
//  Copyright © 2017年 帶頭二哥 QQ:648959. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LZSettingThingsModel.h"
@interface LZSettingThingsTableViewCell : UITableViewCell
@property(nonatomic,strong)LZSettingThingsModel *model;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
