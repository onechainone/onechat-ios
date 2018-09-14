//
//  ONEMainToolBar.h
//  OneChainIOS
//
//  Created by 李飞 on 2018/7/23.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ONEMainToolBar;
@protocol ONEMainToolBarDelegate<NSObject>

- (void)toolBar:(ONEMainToolBar *)toolBar didItemClick:(NSString *)itemTitle;

@end

@interface ONEMainToolBar : UIView

@property (nonatomic, strong) NSArray *items;


@property (nonatomic, weak) id<ONEMainToolBarDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame items:(NSArray *)items;

- (void)_layoutSubviews;
@end
