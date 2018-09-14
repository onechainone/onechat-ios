//
//  WeiBoImagesView.m
//  CancerDo
//
//  Created by hugaowei on 16/8/10.
//  Copyright © 2016年 lianji. All rights reserved.
//

#import "WeiBoImagesView.h"

#define KButtonAbsY 18.0f// 行间隔
#define KButton_Height 26
#define KKOriginX 22
#define KRowsOfImage   3 // 行数
#define KColumnOfImage 3 // 列数
#define KBlackSpace    4

#define MaxNumberOfImages 9

@implementation WeiBoImagesView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _imagesArray = [[NSMutableArray alloc] init];
        _videoArray  = [[NSMutableArray alloc] init];

        self.backgroundColor = [UIColor whiteColor];
        [self createSubViews];
    }
    
    return self;
}

#pragma mark 创建子视图
- (void)createSubViews{
    
    [self createImageViews];
    
    videoView = [[VideoView alloc] initWithFrame:CGRectMake(12, 5, 0, 0)];
    videoView.hidden = YES;
    videoView.delegate = self;
    [videoView setBackgroundColor:[UIColor clearColor]];
    [self addSubview:videoView];
    self.backgroundColor = [UIColor clearColor];
    
}

#pragma mark 创建图片
- (void)createImageViews{
    imageViewsArray = [[NSMutableArray alloc] init];
    CGFloat width = ((ScreenWidth-40) - (KColumnOfImage - 1)*KBlackSpace)/KColumnOfImage;
    
    CGFloat originX = 20;
    CGFloat originY = 13;
    
    for (int i = 0; i < MaxNumberOfImages; i++) {
        
        NSInteger k = i % KRowsOfImage;
        NSInteger m = i / KRowsOfImage;
        if (k == 0) {
            originX = 20;
        }else{
            originX = 20 + k*(width+KBlackSpace);
        }
        
        if (m == 0) {
            originY = 13;
        }else{
            originY = 13 + m*(width+KBlackSpace);
        }
        
        KImageView *imageView = [[KImageView alloc] initWithFrame:CGRectMake(originX, originY, width, width)];
        imageView.delegate = self;
        imageView.hidden = YES;
        imageView.showDeleteButton = YES;
        [imageView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:imageView];
        [imageViewsArray addObject:imageView];
        
        if (i == MaxNumberOfImages-1) {
            self.frame = CGRectMake(self.frame.origin.x,self.frame.origin.y , self.frame.size.width, CGRectGetMaxY(imageView.frame)+13);
        }
    }
}

- (void)reloadImages{
    
    for (int i = 0; i < imageViewsArray.count; i++) {
        KImageView *imageView = [imageViewsArray objectAtIndex:i];
        if (i < self.imagesArray.count) {
            NoteImageModel *image = [self.imagesArray objectAtIndex:i];
            imageView.kImage = image;
            imageView.hidden = NO;
        }else{
            imageView.hidden = YES;
        }
    }
    
//    [UIView animateWithDuration:0.25
//                     animations:^{
//                         CGFloat height = 50;
//                         if (self.imagesArray.count > 0) {
//                             KImageView *imageView = [imageViewsArray objectAtIndex:(self.imagesArray.count - 1)];
//                             height = CGRectGetMaxY(imageView.frame)+13;
//                         }
////                         self.frame = CGRectMake(0, self.frame.origin.y, ScreenWidth, height);
//                     }
//                     completion:^(BOOL finished) {
////                         if (self.delegate && [self.delegate respondsToSelector:@selector(superViewReload)]) {
////                             [self.delegate superViewReload];
////                         }
//                     }];
    
}

- (void)setVideoPathString:(NSString *)videoPathStr{
    if (videoPathStr == nil) {
        videoPathStr = @"";
    }
    if (![_videoPathString isEqualToString:videoPathStr]) {
        _videoPathString = nil;
        _videoPathString = [videoPathStr copy];
    }
    
    self.thumbImage = [MTool thumbnailImageForVideo:_videoPathString atTime:0];
    
    NSString *sizeStr = @"0b";
    
    NSData *data = [NSData dataWithContentsOfFile:_videoPathString];
    NSUInteger size = [data length];
    if (size < 1000) {
        sizeStr = [NSString stringWithFormat:@"%dB", (int)size];
    }else if (size < 1000 * 1024) {
        sizeStr = [NSString stringWithFormat:@"%.2fK", size / 1024.0];
    }else if (size < 1000 * 1024 * 1024) {
        sizeStr =  [NSString stringWithFormat:@"%.2fM", size / 1024.0 / 1024.0];
    }else{
        sizeStr = [NSString stringWithFormat:@"%.2fG", size / 1024.0 / 1024.0 / 1024.0];
    }
    
    videoView.sizeString = sizeStr;
}

- (void)setDuration:(CGFloat)dur{
    if (_duration != dur) {
        _duration = dur;
    }
    
    videoView.durationString = [MTool getVideoDurationFromDuration:_duration];
}

- (void)setThumbImage:(UIImage *)image{
    if (_thumbImage != image) {
        _thumbImage = image;
    }
    
    if (image == nil) {
        videoView.kImage = nil;
        videoView.hidden = YES;
    }else{
        videoView.hidden = NO;
        videoView.kImage = _thumbImage;
    }
}

#pragma mark KImageViewDelegate 删除图片
- (void)deleteImageFromImageView:(KImageView*)imageView{
    
    if ([self.imagesArray containsObject:imageView.kImage]) {
        [self.imagesArray removeObject:imageView.kImage];
    }
    
    [self reloadImages];
    if (self.delegate && [self.delegate respondsToSelector:@selector(deleteImage)]) {
        [self.delegate deleteImage];
    }
}

#pragma mark 播放视频
- (void)playVideo{
    if (self.videoPathString.length > 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(playVideoWithURL:)]) {
            [self.delegate playVideoWithURL:self.videoPathString];
        }
    }
}

#pragma mark 删除视频
- (void)deleteVideo{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (self.videoPathString.length > 0) {
        if ([fileManager fileExistsAtPath:self.videoPathString]) {
            [fileManager removeItemAtPath:self.videoPathString error:nil];
            self.videoPathString = @"";
        }
    }
    
    videoView.hidden = YES;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(deleteVideo)]) {
        [self.delegate deleteVideo];
    }
}

- (void)removeVideoCache{
    if (self.videoPathString.length > 0) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:self.videoPathString]) {
            [fileManager removeItemAtPath:self.videoPathString error:nil];
        }
    }
}

@end
