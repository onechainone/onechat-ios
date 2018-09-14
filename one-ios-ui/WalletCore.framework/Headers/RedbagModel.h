//
//  RedbagModel.h
//  LZEasemob3
//
//  Created by lifei on 2017/12/22.
//  Copyright © 2017年 帶頭二哥 QQ:648959. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RedbagModel : NSObject

@property (nonatomic, copy) NSString *asset_code;
@property (nonatomic, copy) NSString *red_content;
@property (nonatomic, copy) NSString *red_type;
@property (nonatomic, copy) NSString *total_amount;
@property (nonatomic, copy) NSString *single_amount;
@property (nonatomic, assign) int red_total_num;

@end
