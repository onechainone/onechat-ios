//
//  ONEThemeHeader.h
//  OneChainIOS
//
//  Created by 李飞 on 2018/6/29.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#ifndef ONEThemeHeader_h
#define ONEThemeHeader_h


#define THMColor(name) [[ONEThemeManager sharedInstance].theme colorWithName:name]
#define THMImage(name) [[ONEThemeManager sharedInstance].theme imageWithName:name]
#define THMACStyle(name) [[ONEThemeManager sharedInstance].theme activityViewStyle:name]

#define kThemeDidChangeNotification @"kThemeDidChangeNotification"

#import "ONEThemeManager.h"
#import "UIView+Theme.h"

#endif /* ONEThemeHeader_h */

