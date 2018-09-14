//
//  ONECommentCell.h
//  OneChainIOS
//
//  Created by lifei on 2018/5/10.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ONEComment;

typedef void(^CommentBeLikedBlock)(ONEComment *comment);
@interface ONECommentCell : UITableViewCell

@property (nonatomic, strong) ONEComment *comment;
@property (nonatomic, strong) UILabel *timeLbl;
@property (nonatomic, strong) UILabel *contentLbl;
@property (nonatomic, strong) UIImageView *avatarView;
@property (nonatomic, strong) UILabel *nickNameLbl;
@property (nonatomic, strong) UILabel *quoteContentLbl;
@property (nonatomic, strong) UIButton *likeButton;
@property (nonatomic, strong) UILabel *subTimeLbl;

@property (nonatomic, copy) CommentBeLikedBlock commentBeLiked;

+ (CGFloat)commentCellHeightWithComment:(ONEComment *)comment;

- (void)setupSubviews;

@end
