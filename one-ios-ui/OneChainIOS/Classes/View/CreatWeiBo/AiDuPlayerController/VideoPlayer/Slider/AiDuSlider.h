//
//  AiDuSlider.h
//  BaiDuVideoDemo
//
//  Created by hugaowei on 2017/2/13.
//  Copyright © 2017年 lianji. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AiDuSlider;

typedef void (^SliderValueChangeBlock) (AiDuSlider *slider);
typedef void (^SliderFinishChangeBlock) (AiDuSlider *slider);
typedef void (^DraggingSliderBlock) (AiDuSlider *slider);

@interface AiDuSlider : UIView

@property (nonatomic, assign) CGFloat value;        /* From 0 to 1 */
@property (nonatomic, assign) CGFloat middleValue;  /* From 0 to 1 */

@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, assign) CGFloat sliderDiameter;
@property (nonatomic, strong) UIColor *sliderColor;
@property (nonatomic, strong) UIColor *maxColor;
@property (nonatomic, strong) UIColor *middleColor;
@property (nonatomic, strong) UIColor *minColor;

@property (nonatomic, copy) SliderValueChangeBlock valueChangeBlock;
@property (nonatomic, copy) SliderFinishChangeBlock finishChangeBlock;
@property (nonatomic, strong) DraggingSliderBlock draggingSliderBlock;


@end
