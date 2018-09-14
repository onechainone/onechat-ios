//
//  ChooseSeedController.h
//  OneChainIOS
//
//  Created by lifei on 2018/1/11.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectedSeed)(NSString *seedString);
@interface ChooseSeedController : UIViewController

@property (nonatomic, copy) SelectedSeed selectedSeed;
//改变按钮的颜色
@property (nonatomic, copy) NSString *type;

@property (nonatomic, strong) NSString *existSeedString;

@end
