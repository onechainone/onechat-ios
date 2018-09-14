//
//  ONENormalApplyCell.h
//  OneChainIOS
//
//  Created by lifei on 2018/6/1.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "GroupApplyCell.h"
typedef void(^AcceptBlock)(id model);

typedef void(^RejectBlock)(id model);

@interface ONENormalApplyCell : GroupApplyCell

@property (nonatomic, strong) id applyModel;

@property (nonatomic, strong) UILabel *agreedLabel;

@property (nonatomic, copy) AcceptBlock acceptBlock;

@property (nonatomic, copy) RejectBlock rejectBlock;

@end
