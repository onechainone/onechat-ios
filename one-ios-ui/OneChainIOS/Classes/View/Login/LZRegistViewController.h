//
//  LZRegistViewController.h
//  LZEasemob3
//
//  Created by hanshaoqing on 2017/11/9.
//  Copyright © 2017年 帶頭二哥 QQ:648959. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^registBlock)(BOOL isUseisPullUserInfor);

@interface LZRegistViewController : UIViewController<UITextFieldDelegate>

@property(nonatomic, copy)NSString *type;

@property (nonatomic, copy) NSString *seed;

@end
