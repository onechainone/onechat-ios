//
//  EncryptSeedAlertView.h
//  OneChainIOS
//
//  Created by lifei on 2018/3/7.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AlertBtnClick)(NSInteger index);

@interface EncryptSeedAlertView : UIView

@property (nonatomic, copy) AlertBtnClick alertBtnClick;

- (instancetype)initWithTitles:(NSArray *)titles message:(NSString *)message;

- (void)show;
- (void)hide;
@end
