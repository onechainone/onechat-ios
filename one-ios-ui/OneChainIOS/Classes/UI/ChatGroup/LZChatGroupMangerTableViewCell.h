//
//  LZChatGroupMangerTableViewCell.h
//  OneChainIOS
//
//  Created by chunzheng wang on 2018/5/7.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LZChatGroupMangerTableViewCell : UITableViewCell
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UIImageView *img;
@property(nonatomic,strong)UILabel *desLabel;
///名字
@property(nonatomic,strong)NSString *name;
///加群方式
@property(nonatomic,strong)NSString *add_group_type;

@end
