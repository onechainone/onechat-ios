//
//  LZRecoverViewController.h
//  LZEasemob3
//
//  Created by hanshaoqing on 2017/11/9.
//  Copyright © 2017年 帶頭二哥 QQ:648959. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LZRecoverViewController : UIViewController<UITextFieldDelegate>
//有值的话 从忘记密码进来
@property(nonatomic, copy)NSString *type;

@end
