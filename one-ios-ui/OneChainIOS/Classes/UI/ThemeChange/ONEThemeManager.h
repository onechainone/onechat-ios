//
//  ONEThemeManager.h
//  OneChainIOS
//
//  Created by 李飞 on 2018/6/28.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ONETheme.h"

@interface ONEThemeManager : NSObject

@property (nonatomic, strong) ONETheme *theme;

+ (instancetype)sharedInstance;

- (void)switchTheme:(NSString *)themeId;

+ (void)start;

+ (void)resetTheme;

+ (void)resetStatusBarStyle;


@end
