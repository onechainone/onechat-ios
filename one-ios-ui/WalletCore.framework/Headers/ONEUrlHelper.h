//
//  ONEUrlHelper.h
//  OneChainIOS
//
//  Created by 李飞 on 2018/8/31.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ONEUrlHelper : NSObject


/**
 用户头像url host

 @return host
 */
+ (NSString *)userAvatarPrefix;

/**
 社区图片url host
 
 @return host
 */
+ (NSString *)communityImagePrefix;

+ (NSString *)assetIconImagePrefix;


/**
 社区视频url host

 @return host
 */
+ (NSString *)communityVideoPrefix;


/**
 群组管理界面h5
 
 @param groupId 群组ID
 @return urlString
 */
+ (NSString *)groupManagementH5WithGroupId:(NSString *)groupId;

/**
 群组公告h5
 
 @param groupId 群组ID
 @return url
 */
+ (NSString *)groupAnnouncementH5WithGroupId:(NSString *)groupId;

/**
 搜索群组的h5界面
 
 @return url
 */
+ (NSString *)searchGroupH5;

/**
 获取红包详情的URL
 
 @param redpacketID 红包ID
 @return URL string
 */
+ (NSString *)redpacketDetailH5FromRedpacketId:(NSString *)redpacketID;

/**
 个人名片分享URL Host

 @return URL Host
 */
+ (NSString *)personalShareHost;

/**
 公告H5

 @return url
 */
+ (NSString *)announcementH5Url;


/**
 钱包账户H5

 @return url
 */
+ (NSString *)walletAccountH5Url;

/**
 群组分享Url

 @param groupId 群组ID
 @return url
 */
+ (NSString *)groupShareUrlWithGroupId:(NSString *)groupId;

/**
 公共参数

 @return 公共参数
 */
+ (NSString *)commonParam;

/**
 检查app更新URL

 @return url
 */
+ (NSString *)checkVersionHttpUrl;


/**
 同步通讯录URL

 @return url
 */
+ (NSString *)syncAddressbookHttpUrl;
@end
