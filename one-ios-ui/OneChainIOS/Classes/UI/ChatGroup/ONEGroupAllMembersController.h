//
//  ONEGroupAllMembersController.h
//  OneChainIOS
//
//  Created by lifei on 2018/5/29.
//  Copyright © 2018 帶頭二哥 QQ:648959. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AddMember)(NSArray *members);
typedef void(^DeleteMember)(NSString *memberName);

@interface ONEGroupAllMembersController : UIViewController

@property (nonatomic, copy) AddMember addMember;
@property (nonatomic, copy) DeleteMember deleteMember;

- (instancetype)initWithGroupId:(NSString *)groupId;
@end
