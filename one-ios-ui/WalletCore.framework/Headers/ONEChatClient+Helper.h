//
//  ONEChatClient+Helper.h
//  OneChainIOS
//
//  Created by 李飞 on 2018/8/30.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "ONEChatClient.h"
@class ServerInfo;
@interface ONEChatClient (Helper)


/**
 节点检测

 @param node node
 @param cb 回调
 */
- (void)initNode:(void(^)(ServerInfo *si, BOOL state))node
              cb:(void(^)(BOOL state, id data))cb;

/**
 更新节点
 */
- (void)updateNodeUrl;
/**
 获取原子资产列表

 @param completion List<RpAssetModel>
 */
- (void)getAtomicAssetList:(void(^)(ONEError *error, NSArray *list))completion;


/**
 根据asset_code获取资产的显示信息

 @param asset_code asset_code
 @return Map {@"icon":图标url, @"name":显示名称}
 */
- (NSDictionary *)assetShowInfoFromAssetCode:(NSString *)asset_code;


- (NSDictionary *)myAssetBalanceDic;

- (NSDictionary *)informationFromAssetCode:(NSString *)asset_code;


/*********************************** Seed ***********************************/


/**
 生成助记词

 @return 助记词
 */
+ (NSString *)buildSeed;


/**
 检测助记单词是否合法

 @param seed 助记词
 @param words 不合法的助记词列表
 @return 错误信息
 */
+ (ONEError *)seedIsValid:(NSString *)seed invalidWords:(NSArray **)words;


/**
 助记词库列表

 @return list
 */
+ (NSArray *)englishWordList;


/**
 根据链接生成二维码图片

 @param string 链接
 @param size 大小
 @param scale 缩放比例
 @return 图片
 */
+ (UIImage*)qrCodeImageWithString:(NSString*) string
                                size:(CGSize)size
                               scale:(CGFloat)scale;


/**
 设置时间
 如果不设置默认取到的是本地时间

 @param block block
 */
+ (void)setNetworkDate:(NSDate *(^)())block;


/**
 获取设置的时间

 @return NSDate
 */
+ (NSDate *)date;


/**
 解密

 @param pass 密码
 @param str 加密字符串
 @return 解密后的结果
 */
+ (NSString*)aesCommonDecryptWithPass:(NSString*) pass string:(NSString*) str;

/**
 加密

 @param pass 密码
 @param str 原始字符串
 @return 加密后的字符串
 */
+ (NSString*)aesCommonEncryptWithPass:(NSString*) pass string:(NSString*) str;


/**
 获取本地缓存的节点列表

 @return 节点列表
 */
+ (NSArray *)cachedServerInfoList;


/**
 获取当前加密助记词

 @return 加密后的助记词
 */
+ (NSString *)getEncryptedSeed;

/**
 验证密码是否正确

 @param password 密码
 @return BOOL
 */
+ (BOOL)checkPassword:(NSString *)password;

/*********************************** Attchment ***********************************/


/**
 根据消息附件的远程路径获取本地路径

 @param remotePath 消息附件的远程url
 @return 本地路径
 */
+ (NSString *)localPathFromRemotePath:(NSString *)remotePath;


/**
 语音消息是否播放过

 @param messageId 消息ID
 @return 是否播放过
 */
+ (BOOL)voiceMessageHasPlayed:(NSString *)messageId;

/**
 标识语音消息为已经播放

 @param messageId 消息ID
 */
+ (void)markVoiceMessageAsPlayed:(NSString *)messageId;

/**
 添加节点

 @param ip ip地址
 @param port 端口号
 @param completion 错误回调
 */
- (void)applyConfigWithIp:(NSString*) ip port:(NSString*) port completion:(void(^)(ONEError *error))completion;

/**
 清除节点
 */
- (void)clearIPConfig;
@end
