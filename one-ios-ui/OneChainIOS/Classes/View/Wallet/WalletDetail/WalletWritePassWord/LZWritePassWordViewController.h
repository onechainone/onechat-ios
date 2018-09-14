//
//  LZWritePassWordViewController.h
//  LZEasemob3
//
//  Created by chunzheng wang on 2017/11/13.
//  Copyright © 2017年 帶頭二哥 QQ:648959. All rights reserved.
//

#import <UIKit/UIKit.h>




@interface LZWritePassWordViewController : UIViewController
//对方地址
@property(nonatomic,copy)NSString *peopleAddress;
//金额
@property(nonatomic,copy)NSString *jinE;
//附加消息
@property(nonatomic,copy)NSString *fuJiaMesage;
//1是支付的时候 2是备份钱包的时候
@property(nonatomic,copy)NSString *type;
typedef void(^Click)(NSString *passwrd);

@property (nonatomic, copy) Click block;



@end
