//
//  RpAssetModel.h
//  LZEasemob3
//
//  Created by lifei on 2017/12/21.
//  Copyright © 2017年 帶頭二哥 QQ:648959. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RpAssetModel : NSObject

@property (nonatomic, copy) NSString *account_id;
@property (nonatomic, copy) NSString *account_name;
@property (nonatomic, copy) NSString *account_status;
@property (nonatomic, assign) long amount_availabel;
@property (nonatomic, assign) long amount_frozen;
@property (nonatomic, copy) NSString *asset_code;
@property (nonatomic, assign) long create_time;
@property (nonatomic, assign) int some_id;
@property (nonatomic, copy) NSString *uni_uuid;
@property (nonatomic, assign) long update_time;
//字符串类型的
@property (nonatomic, copy) NSString *amount_avalible_string;
@property (nonatomic, copy) NSString *amount_frozen_string;


@property (nonatomic, copy) NSString *iconUrl;

@property (nonatomic, copy) NSString *showName;


@end
