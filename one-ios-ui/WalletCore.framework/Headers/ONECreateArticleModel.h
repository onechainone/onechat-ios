//
//  ONECreateArticleModel.h
//  OneChainIOS
//
//  Created by 李飞 on 2018/8/29.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ArticleType) {
    ArticleTypeFeed = 1,    // 文本
    ArticleTypeImage,       // 图片/文本+图片
    ArticleTypeVideo,       // 视频
};

@interface ONECreateArticleModel : NSObject

/**
 帖子类型
 */
@property (nonatomic) ArticleType type;

/**
 帖子内容
 */
@property (nonatomic, copy) NSString *content;

/**
 群组ID
 */
@property (nonatomic, copy) NSString *groupId;

/**
 是否免费
 */
@property (nonatomic) BOOL isFree;

/**
 收费资产类型
 */
@property (nonatomic, copy) NSString *asset_code;

/**
 收费价格
 */
@property (nonatomic, copy) NSString *price;

/**
 图片列表List<UIImage*>
 */
@property (nonatomic, strong) NSArray *imageList;

/**
 视频本地路径
 */
@property (nonatomic, copy) NSString *videoPath;

/**
 关键词列表List<NSString*>
 */
@property (nonatomic, strong) NSArray *keywords;

/**
 视频缩略图
 */
@property (nonatomic, strong) UIImage *videoThumbImage;


@end
