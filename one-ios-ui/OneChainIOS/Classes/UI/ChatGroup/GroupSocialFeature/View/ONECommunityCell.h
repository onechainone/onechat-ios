//
//  ONECommunityCell.h
//  OneChainIOS
//
//  Created by lifei on 2018/5/8.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ONEArticle;

@protocol ONECommunityCellDelegate<NSObject>

// 点击头像
- (void)avatarViewClicked:(ONEArticle *)model;
// 看涨
- (void)likeButtonClicked:(ONEArticle *)model;
// 看跌
- (void)dislikeButtonClicked:(ONEArticle *)model;
// 更多
- (void)moreButtonClicked:(ONEArticle *)model;
// 视频播放
- (void)videoClicked:(ONEArticle *)model;
// 图片选择
- (void)imageSelected:(ONEArticle *)model index:(NSUInteger)index;
@end

@interface ONECommunityCell : UITableViewCell

@property (nonatomic) BOOL isShowAll;
@property (nonatomic, strong) ONEArticle *model;

@property (nonatomic, weak) id <ONECommunityCellDelegate>delegate;

+ (CGFloat)cellHeightForArticleModel:(ONEArticle *)model;

+ (CGFloat)cellHeightForArticleModel:(ONEArticle *)model isShowAll:(BOOL)showAll;

@end
