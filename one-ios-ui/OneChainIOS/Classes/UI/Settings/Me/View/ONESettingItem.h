//
//  ONESettingItem.h
//  OneChainIOS
//
//  Created by 李飞 on 2018/7/23.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ItemClicked)(NSString *title);

@interface ONESettingItem : UIView

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *imageName;

@property (nonatomic, copy) ItemClicked itemClicked;

- (instancetype)initWithFrame:(CGRect)frame
                        image:(NSString *)imageName
                        title:(NSString *)title;

@end
