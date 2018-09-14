//
//  LZBackupWalletViewController.h
//  LZEasemob3
//
//  Created by chunzheng wang on 2017/11/14.
//  Copyright © 2017年 帶頭二哥 QQ:648959. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, LZBackupWalletViewControllerSource) {
    LZBackupWalletViewControllerSource_Reg = 0
    
};

@interface LZBackupWalletViewController : UIViewController

@property(nonatomic) LZBackupWalletViewControllerSource fromWhere;

@property(nonatomic,strong) NSString* seed;
///是不是需要验证
@property(nonatomic,copy)NSString *needVerifyWord;
//隐藏返回键
@property(nonatomic,copy)NSString *hideBlack;

@end
