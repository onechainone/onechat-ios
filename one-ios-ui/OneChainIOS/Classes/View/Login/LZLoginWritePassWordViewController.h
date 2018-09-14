//
//  LZLoginWritePassWordViewController.h
//  LZEasemob3
//
//  Created by chunzheng wang on 2017/12/5.
//  Copyright © 2017年 帶頭二哥 QQ:648959. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^LoginClick)(NSString *str);

@interface LZLoginWritePassWordViewController : UIViewController
@property (nonatomic, copy) LoginClick succBlock;

@end
