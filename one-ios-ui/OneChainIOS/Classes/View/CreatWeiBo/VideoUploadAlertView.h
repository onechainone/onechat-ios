//
//  VideoUploadAlertView.h
//  CancerDo
//
//  Created by hugaowei on 16/11/8.
//  Copyright © 2016年 lianji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoUploadProgressView.h"

@interface VideoUploadAlertView : UIView
{
    UIView *backgroundView;
    UIImageView *roundImageView;
    
    VideoUploadProgressView *progressView;
    
    UIView  *jinDuView;
    UILabel *jinDuLabel;
    UILabel *titleLabel;
    
    UILabel *completeLabel;
}

@property (nonatomic,assign) CGFloat progressValue;

@end
