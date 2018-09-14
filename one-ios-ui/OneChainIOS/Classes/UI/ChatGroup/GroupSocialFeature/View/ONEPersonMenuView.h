//
//  ONEPersonMenuView.h
//  OneChainIOS
//
//  Created by lifei on 2018/5/12.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ONEPersonMenuViewDelegate<NSObject>
 /** 个人中心 */
- (void)personalCenterAction;
/** 禁言 */
- (void)userBeingMuted;
/** AT */
- (void)userBeingAted;
/** 设置为管理员 */
- (void)userBeingSetAdmin;
/** 移除 */
- (void)userBeingRemoved;
/** 加入黑名单 */
- (void)userBeingAddToBlackList;
/** 取消 */
- (void)cancelAction;

@end


typedef NS_ENUM(NSInteger, PersonMenuType) {
    
    PersonMenuType_Member = 1,  /** 群成员 */
    PersonMenuType_Admin,       /** 群管理 */
    PersonMenuType_Owner,       /** 群主 */
};

@interface ONEPersonMenuView : UIVisualEffectView

@property (nonatomic, weak) id <ONEPersonMenuViewDelegate>delegate;
- (instancetype)initWithEffect:(UIVisualEffect *)effect type:(PersonMenuType)type;
- (CGFloat)heightFromPersonMenuType:(PersonMenuType)type;
@end
