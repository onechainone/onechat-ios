//
//  ONELikeToolBar.h
//  OneChainIOS
//
//  Created by lifei on 2018/5/10.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ONEArticle;
@class ExtendedButton;
@protocol ONELikeToolBarDelegate<NSObject>

@optional

- (void)admireButtonSelected;
- (void)commentButtonSelected;
- (void)likeButtonClicked;
- (void)dislikeButtonClicked;

@end

@interface ONELikeToolBar : UIView

@property (nonatomic, strong) ExtendedButton *commentButton;

@property (nonatomic, weak) id<ONELikeToolBarDelegate>delegate;

- (void)reloadSubviewsWithArticle:(ONEArticle *)article;
- (void)changeToComment:(BOOL)isComment;

@end
