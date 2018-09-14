//
//  CoinTools.h
//  LZEasemob3
//
//  Created by chunzheng wang on 2017/12/13.
//  Copyright © 2017年 帶頭二哥 QQ:648959. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LZNavigationController.h"
#import "LZTabBarController.h"

@interface CoinTools : NSObject
@property (nonatomic,assign) int timeCount;
///上传通讯录成功还是失败
typedef void (^sysBlock)(BOOL state);


//单例
+ (instancetype)sharedCoinTools;

//获取系统语言
- (NSString*)getPreferredLanguage;

//让第一个字母变大写
//-(NSString *)letFirstAlphabetBig:(NSString *)string;
- (void)saveuserArrInfo:(id)userArrInfo name:(NSString *)name;
-(void)deleteUserInfo:(NSString *)name;
-(NSString *)jugmentIphoneLanguage;
-(void)startTimerWithSecond:(double)time;
-(void)stopTimer;
-(BOOL)copyToPasteboardWithString:(NSString *)str;
-(BOOL)copyToPasteboardWithImg:(UIImage *)img;
-(NSAttributedString *)setTextColor:(UILabel *)label FontNumber:(id)font AndRange:(NSRange)range AndColor:(UIColor *)vaColor;

-(NSString *)accordingGeLinShiJiangetJingQueStr:(NSString *)time;
-(NSString *)accordingGeLinShiJianGetQuanBuJingQueStr:(NSString *)time;

/////根据分割 设置颜色不同
-(void)labelSetTextColor:(UILabel *)label FontNumber:(id)font AndRange:(NSRange)range AndColor:(UIColor *)vaColor;
///字典转json
///json 转字典

- (NSString *)judgeNetWork;

+(NSString*) creditAssetWithDict:(NSMutableDictionary*) dict;

@end
