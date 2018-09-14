//
//  YouKuVideoTitleView.h
//  CancerDo
//
//  Created by hugaowei on 16/11/2.
//  Copyright © 2016年 lianji. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YouKuVideoTitleViewDelegate <NSObject>

- (void)gotoBack;
- (void)videoQulityChanged:(UIButton*)btn;

@end

@interface YouKuVideoTitleView : UIView
{
    UIButton *backButton;
    UILabel *titleLabel;
    
}

@property (nonatomic,strong) UIButton *videoQulityButton;
@property (nonatomic,copy  ) NSString *title;
@property (nonatomic,assign) id<YouKuVideoTitleViewDelegate>delegate;

@end
