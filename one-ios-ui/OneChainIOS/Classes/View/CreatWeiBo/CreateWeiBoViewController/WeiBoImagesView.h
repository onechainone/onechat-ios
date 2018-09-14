//
//  WeiBoImagesView.h
//  CancerDo
//
//  Created by hugaowei on 16/8/10.
//  Copyright © 2016年 lianji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoView.h"

@protocol WeiBoImagesViewDelegate <NSObject>

@optional

- (void)superViewReload;

- (void)playVideoWithURL:(NSString*)urlStr;

- (void)deleteVideo;

- (void)deleteImage;

@end

@interface WeiBoImagesView : UIView<KImageViewDelegate,VideoViewDelegate>
{
    NSMutableArray *imageViewsArray;
    VideoView *videoView;
}
@property (nonatomic,assign) id<WeiBoImagesViewDelegate>delegate;
@property (nonatomic,retain) NSMutableArray *imagesArray;
@property (nonatomic,retain) NSMutableArray *videoArray;

@property (nonatomic,copy  ) NSString *videoPathString;
@property (nonatomic,strong) UIImage *thumbImage;

@property (nonatomic,assign) CGFloat duration;

- (void)reloadImages;

@end
