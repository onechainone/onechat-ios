//
//  LZLoginModalPasswordViewController.h
//  LZEasemob3
//
//  Created by chunzheng wang on 2017/12/5.
//  Copyright © 2017年 帶頭二哥 QQ:648959. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^LoginClick1)();
typedef void(^LoginWithSeedClick)(NSString *seed);

@interface LZLoginModalPasswordViewController : UIViewController
@property (nonatomic, copy) LoginWithSeedClick block;
@property (nonatomic, copy) LoginClick1 forgetPasswordblock;
@property (nonatomic, copy) NSString *type;
@end
