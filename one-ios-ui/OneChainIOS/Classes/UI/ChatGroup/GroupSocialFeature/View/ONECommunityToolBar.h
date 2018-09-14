//
//  ONECommunityToolBar.h
//  OneChainIOS
//
//  Created by lifei on 2018/5/7.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ONECommunityToolBar;

@protocol ONECommunityToolBarDelegate<NSObject>

@optional

- (void)didChangeToChatStyle:(ONECommunityToolBar *)toolBar;

- (void)didCommunityButtonClicked:(ONECommunityToolBar *)toolBar;

- (void)didSubjectButtonClicked:(ONECommunityToolBar *)toolBar;
@end


@interface ONECommunityToolBar : UIView

@property (nonatomic, weak) id <ONECommunityToolBarDelegate>delegate;
@end
