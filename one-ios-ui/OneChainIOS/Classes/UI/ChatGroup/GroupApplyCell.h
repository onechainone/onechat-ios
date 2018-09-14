//
//  GroupApplyCell.h
//  OneChainIOS
//
//  Created by lifei on 2018/3/6.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ONENotification;

@protocol GroupApplyCellDelegate<NSObject>

- (void)didAgreedJoinGroup:(ONENotification *)model;

- (void)didRejectJoinGroup:(ONENotification *)model;
@end

@interface GroupApplyCell : UITableViewCell

@property (nonatomic, strong) ONENotification *model;

@property (nonatomic, weak) id <GroupApplyCellDelegate>delegate;

// 头像
@property (nonatomic, strong) UIImageView *avatarView;
// 昵称
@property (nonatomic, strong) UILabel *nickLbl;
// username
@property (nonatomic, strong) UILabel *usernameLbl;

@property (nonatomic, strong) UIButton *rejectBtn;

@property (nonatomic, strong) UIButton *agreeBtn;

@property (nonatomic, strong) UILabel *timeLbl;

- (void)_initUI;

- (void)agreeAction;

- (void)rejectAction;

@end
