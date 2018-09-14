//
//  ONEUnreadCell.h
//  OneChainIOS
//
//  Created by lifei on 2018/5/12.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "ONECommentCell.h"
@class ONEUnreadModel;
@interface ONEUnreadCell : ONECommentCell

@property (nonatomic, strong) ONEUnreadModel *model;
+ (CGFloat)heightWithModel:(ONEUnreadModel *)unreadModel;
@end
