//
//  ONEGroupListCell.h
//  OneChainIOS
//
//  Created by 李飞 on 2018/6/8.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ONEGroupListCell : UITableViewCell

@property (nonatomic, strong) UIImageView *avatarView;

@property (nonatomic, strong) UILabel *nameLbl;

@property (nonatomic, strong) ONEChatGroup *info;
@end
