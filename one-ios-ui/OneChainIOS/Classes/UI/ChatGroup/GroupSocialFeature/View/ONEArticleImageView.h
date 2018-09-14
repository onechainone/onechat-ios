//
//  ONEArticleImageView.h
//  OneChainIOS
//
//  Created by lifei on 2018/5/9.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ImageSelectBlock)(NSInteger index);

@interface ONEArticleImageView : UIView

- (instancetype)initWithFrame:(CGRect)frame images:(NSArray *)images;
- (void)reloadImages:(NSArray *)images;

@property (nonatomic, copy) ImageSelectBlock imageSelectBlock;
@end
