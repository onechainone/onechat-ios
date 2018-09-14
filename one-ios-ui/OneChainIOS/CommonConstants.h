//
//  CommonConstants_h
//  LZEasemob3
//
//  Created by chunzheng wang on 2017/11/17.
//  Copyright © 2017年 帶頭二哥 QQ:648959. All rights reserved.
//

#ifndef CommonConstants_h
#define CommonConstants_h

#define G_ZERO                      @"0"
#define G_ONENAME                   @"ONE"

#define QRCODE_PATH_ADDFRIEND @"oneapp://onechain.one?a=addfriend&n="
#define QRCODE_PATH_JOINGROUP @"oneapp://onechain.one?a=joingroup&n="


typedef NS_ENUM(NSInteger, RootControllerType) {
    
    RootControllerTypeRegister = 0,        /** 注册 */
    RootControllerTypeEnterPwd,            /** 输入密码 */
    RootControllerTypeShowRoot             /** 主页Tab */
};

/** 切换根控制器的通知 */
#define KNOTIFICATION_SWITCHROOT @"rootControllerShouldChange"
// 获取token成功
#define KNOTIFICATION_GOTTOKEN @"GOTTOKENNOTIFICATION"
// 消息附件下载成功
#define KNOTIFICATION_MESSAGEATTCHMENT_DOWNLOADED @"NOTIFICATION_MESSAGEATTCHMENT_DOWNLOADED"
// 导出加密助记词提示
#define KUSERDEFAULT_KEY_EXPORT_ENCRYPT_SEED @"NEED_EXPORT_ENCRYPT_SEED"
// 上次升级检测时间
#define KUSERDEFAULT_KEY_LATEST_UPGRADE_HINT @"LAST_SHOW_UPGRADE_ALERT_TIME"
// 检测升级间隔时间
#define KCHECK_UPGRADE_INTERVAL (60 * 60 * 24)
// 发消息最大字节数
#define KMAX_INPUT_COUNT 1024

// weakself
#define kWeakSelf __weak typeof(self)weakself = self;



#import "ONEThemeHeader.h"
#endif /* CommonConstants_h */




