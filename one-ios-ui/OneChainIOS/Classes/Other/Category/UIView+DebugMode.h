//
//  UIView+DebugMode.h
//  OneChainIOS
//
//  Created by lifei on 2018/2/2.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (DebugMode)
- (void)switchToDebugModeWithTapRect:(CGRect)rect;

- (void)removeDebugModeGesture;
@end
