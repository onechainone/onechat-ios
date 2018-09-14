//
//  AiDuPlayerViewController.h
//  CancerDo
//
//  Created by hugaowei on 2017/2/14.
//  Copyright © 2017年 hepingtianxia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AiDuVideoPlayer.h"
#import "YouKuVideoTitleView.h"

@interface AiDuPlayerViewController : UIViewController<YouKuVideoTitleViewDelegate>
{
    
}

@property (nonatomic,strong)YouKuVideoTitleView  *titleView;

@property (nonatomic,copy  ) NSString *videoURL;
@property (nonatomic,copy  ) NSString *nickName;

@end
