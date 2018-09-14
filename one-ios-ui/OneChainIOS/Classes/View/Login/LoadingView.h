//
//  LoadingView.h
//  OneChainIOS
//
//  Created by lifei on 2018/1/23.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingView : UIView
- (void)startAno;
- (void)stopAno;

- (void)updateBannerText:(NSString *)text;

@end
