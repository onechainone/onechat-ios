//
//  ChatGroupQRcodeViewController.h
//  OneChainIOS
//
//  Created by chunzheng wang on 2018/5/14.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatGroupQRcodeViewController : UIViewController
//群id
@property(nonatomic,copy)NSString *group_id;
///群名字
@property(nonatomic,copy)NSString *group_name;
///群公告
@property(nonatomic,copy)NSString *group_affiche;
///群显示id
@property(nonatomic,copy)NSString *show_group_id;
// 群头像url
@property (nonatomic, copy) NSString *group_avatar_url;

@end
