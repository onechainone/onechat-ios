//
//  LZContactsTableViewCell.h
//  LZEasemob3
//
//  Created by chunzheng wang on 2017/11/30.
//  Copyright © 2017年 帶頭二哥 QQ:648959. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LZContactsThingsModel.h"

@interface LZContactsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property(nonatomic,copy) NSString *name;
@property(nonatomic,copy) NSString *subtitles;
@property(nonatomic,strong) LZContactsThingsModel *model;

@end
