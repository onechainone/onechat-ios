//
//  VideoView.h
//  CancerDo
//
//  Created by hugaowei on 16/10/27.
//  Copyright © 2016年 lianji. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VideoViewDelegate <NSObject>

@optional
- (void)playVideo;
- (void)deleteVideo;

@end

@interface VideoView : UIView
{
    UIImageView *thumbImageView;
    UIButton *playButton;
    UIButton *deleteButton;
    UILabel *timeLabel;
    UILabel *sizeLabel;
}

@property (nonatomic,assign) id<VideoViewDelegate>delegate;

@property (nonatomic,strong) UIImage *kImage;

@property (nonatomic,copy  ) NSString *durationString;
@property (nonatomic,copy  ) NSString *sizeString;

@end
