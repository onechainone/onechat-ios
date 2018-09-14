//
//  GuideView.h
//  OneChainIOS
//
//  Created by lifei on 2018/1/26.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, GuideStyle) {
    
    GuideStyleFirst = 0,
    GuideStyleSecond,
};

@interface GuideView : UIView

- (instancetype)initWithGuideStyle:(GuideStyle)style;
@end
