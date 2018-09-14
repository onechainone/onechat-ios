//
//  LZChageUserInfoViewController.h
//  LZEasemob3
//
//  Created by chunzheng wang on 2017/11/15.
//  Copyright © 2017年 帶頭二哥 QQ:648959. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^backBlock)();
@interface LZChageUserInfoViewController : UIViewController
@property (nonatomic, copy) backBlock backBlock;

@end
