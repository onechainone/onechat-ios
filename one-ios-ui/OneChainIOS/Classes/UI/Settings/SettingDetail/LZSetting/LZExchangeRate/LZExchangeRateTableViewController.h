//
//  LZExchangeRateTableViewController.h
//  LZEasemob3
//
//  Created by chunzheng wang on 2017/11/14.
//  Copyright © 2017年 帶頭二哥 QQ:648959. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LZExchangeRateTableViewController : UITableViewController
@property(nonatomic,copy)NSString *type;
///传递的值
@property(nonatomic,copy)NSString *passValue;
///是不是首页
@property(nonatomic,copy)NSString *shouYe;

@end
