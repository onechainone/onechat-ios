//
//  RedpacketView.h
//  LZEasemob3
//
//  Created by lifei on 2017/12/20.
//  Copyright © 2017年 帶頭二哥 QQ:648959. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickRedbag)(id<IMessageModel>model);
typedef void(^ClickRedbagCancel)();
@interface RedpacketView : UIView

@property (nonatomic, copy) ClickRedbag clickRedbag;
@property (nonatomic, copy) ClickRedbagCancel clickCancel;
-(instancetype)initWithModel:(id<IMessageModel>)model;

@end
