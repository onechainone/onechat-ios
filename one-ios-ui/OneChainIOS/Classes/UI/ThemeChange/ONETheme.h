//
//  ONETheme.h
//  OneChainIOS
//
//  Created by 李飞 on 2018/6/29.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ONETheme : NSObject

@property (nonatomic, copy) NSString *theme_id;
@property (nonatomic, copy) NSString *theme_name;

- (instancetype)initWithThemeConfig:(NSDictionary *)config;

- (void)mergeTheme:(ONETheme *)newTheme;

- (UIColor *)colorWithName:(NSString *)colorName;

- (UIImage *)imageWithName:(NSString *)imgName;

- (UIActivityIndicatorViewStyle)activityViewStyle:(NSString *)act;

@end
