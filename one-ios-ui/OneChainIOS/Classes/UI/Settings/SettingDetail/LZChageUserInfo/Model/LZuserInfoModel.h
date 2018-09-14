//
//  LZuserInfoModel.h
//  LZEasemob3
//
//  Created by chunzheng wang on 2017/11/22.
//  Copyright © 2017年 帶頭二哥 QQ:648959. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LZuserInfoModel : NSObject
///用户名
@property (copy, nonatomic) NSString *account_name;
//性别
@property (copy, nonatomic) NSString *sex;
//手机号
@property (copy, nonatomic) NSString *mobile;
//account_id 用户id
@property (copy, nonatomic) NSString *account_id;
//简介
@property (copy, nonatomic) NSString *intro;
//邮箱 email
@property (copy, nonatomic) NSString *email;
//昵称
@property (copy, nonatomic) NSString *nickname;

@end
