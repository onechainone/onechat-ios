//
//  UIView+Theme.h
//  OneChainIOS
//
//  Created by 李飞 on 2018/6/29.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import <UIKit/UIKit.h>

FOUNDATION_EXTERN NSString *const ColorName;
// 背景色
FOUNDATION_EXTERN NSString *const BGColorName;
// table 分割线color
FOUNDATION_EXTERN NSString *const TableSepColorName;
// 文本颜色
FOUNDATION_EXTERN NSString *const TextColorName;

FOUNDATION_EXTERN NSString *const BorderColorName;
// placeholder color
FOUNDATION_EXTERN NSString *const PlaceHolderColorName;
FOUNDATION_EXTERN NSString *const ActivityViewStyle;

FOUNDATION_EXTERN NSString *const MainThemeColor;
FOUNDATION_EXTERN NSString *const ButtonSelectedTextColor;

// image
// 背景图片
FOUNDATION_EXTERN NSString *const BackgroudImageName;
// 图片
FOUNDATION_EXTERN NSString *const ImageName;

// button 的image
FOUNDATION_EXTERN NSString *const NormalImageName;
FOUNDATION_EXTERN NSString *const HighLightedImageName;
FOUNDATION_EXTERN NSString *const SelectedImageName;
FOUNDATION_EXTERN NSString *const DisabledImageName;


@interface UIView (Theme)

@property (nonatomic, strong) NSDictionary *themeMap;
@end
