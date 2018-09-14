//
//  GetTokenController.h
//  LZEasemob3
//
//  Created by lifei on 2017/12/23.
//  Copyright © 2017年 帶頭二哥 QQ:648959. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GotToken)(BOOL success);
@interface GetTokenController : UIViewController

@property (nonatomic, copy) GotToken gotToken;

@end
