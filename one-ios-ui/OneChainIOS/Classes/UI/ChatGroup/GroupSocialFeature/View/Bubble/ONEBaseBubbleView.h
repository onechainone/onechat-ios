//
//  ONEBaseBubbleView.h
//  OneChainIOS
//
//  Created by lifei on 2018/5/8.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ONEBaseBubbleView : UIView

/*** 群申请*/
// 头像
@property (nonatomic, strong) UIImageView *avatarView;
// 昵称
@property (nonatomic, strong) UILabel *nickLbl;
// username
@property (nonatomic, strong) UILabel *usernameLbl;

@property (nonatomic, strong) UIButton *rejectBtn;

@property (nonatomic, strong) UIButton *agreeBtn;

@property (nonatomic, strong) UILabel *timestampLbl;


@end
