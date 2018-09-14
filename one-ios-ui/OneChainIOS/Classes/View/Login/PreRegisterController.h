//
//  PreRegisterController.h
//  OneChainIOS
//
//  Created by lifei on 2018/1/9.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SeedStatus) {
    SeedStatus_Default = 0,
    SeedStatus_Produce,
    SeedStatus_Input
};
@interface PreRegisterController : UIViewController

@property (nonatomic, copy) NSString *type;
//是不是跳过后验证助记词 如果有值的话 就说明跳过了
@property (nonatomic, copy) NSString *VerifySeed;
///用户输入的密码
@property (nonatomic, copy) NSString *miMa;

@end
