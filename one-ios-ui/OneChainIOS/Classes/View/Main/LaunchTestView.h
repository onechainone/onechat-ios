//
//  LaunchTestView.h
//  OneChainIOS
//
//  Created by lifei on 2018/1/10.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PassBlock)();
typedef void(^RefreshBlock)();
@interface LaunchTestView : UIView

@property (nonatomic, copy) PassBlock passBlock;

@property (nonatomic, copy) RefreshBlock refreshBlock;
- (void)showNodeInfo:(NSMutableArray *)nodes;
@end
