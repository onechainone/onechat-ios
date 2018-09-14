//
//  SettingInfoTableViewCell.h
//  LZEasemob3
//
//  Created by hanshaoqing on 2017/11/8.
//  Copyright © 2017年 帶頭二哥 QQ:648959. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MyQRCodeBlock)();
@interface SettingInfoTableViewCell : UITableViewCell
@property(nonatomic,copy)NSString *icon;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *account;

@property(nonatomic,assign)NSInteger sex;

@property (nonatomic, copy) MyQRCodeBlock qrCodeBlock;
@property(nonatomic,copy)NSString *intro;
@property(nonatomic,copy)NSString *type;
///从联系人进来的时候的邀请码
@property(nonatomic,copy)NSString *invitationCode;

@end
