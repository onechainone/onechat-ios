//
//  ONEAddMemberViewController.h
//  LZEasemob3
//
//  Created by lifei on 2017/12/17.
//  Copyright © 2017年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "ONECreatGroupViewController.h"
typedef void(^AddContact)(NSArray *sources);
@interface ONEAddMemberViewController : ONECreatGroupViewController

@property (nonatomic, copy) AddContact addContact;
@end
