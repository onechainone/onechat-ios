//
//  LZSendRedTableViewCell.h
//  LZEasemob3
//
//  Created by chunzheng wang on 2017/12/1.
//  Copyright © 2017年 帶頭二哥 QQ:648959. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LZSendRedTableViewCell : UITableViewCell
///设置头像
@property(nonatomic, copy) NSString *icon;
//设置名字  充值的时候用
@property(nonatomic, copy) NSString *name;
//nameLabel
@property(nonatomic, strong) UILabel *nameLabel;

@property(nonatomic, strong) UIImageView *iconImg;

@end
