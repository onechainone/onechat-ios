//
//  LZVerifyWordViewController.h
//  LZEasemob3
//
//  Created by chunzheng wang on 2017/12/25.
//  Copyright © 2017年 帶頭二哥 QQ:648959. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LZVerifyWordViewController : UIViewController

@property(nonatomic,copy)NSString *seed;
@property (nonatomic, copy) NSString *type;
//跳过后验证助记词
@property (nonatomic, copy) NSString *VerifySeed;

@end
