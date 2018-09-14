//
//  VideoView.m
//  CancerDo
//
//  Created by hugaowei on 16/10/27.
//  Copyright © 2016年 lianji. All rights reserved.
//

#import "VideoView.h"

@implementation VideoView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubViews];
    }
    
    return self;
}

- (void)createSubViews{

    CGFloat width = ScreenWidth*(356.0/750.0);
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, width);
    thumbImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, width)];
    [thumbImageView setImage:[UIImage imageNamed:@"headerImage"]];
    [self addSubview:thumbImageView];
    
    playButton = [[UIButton alloc] initWithFrame:CGRectMake((width-57.0)/2.0, (width-57.0)/2.0, 57, 57)];
    [playButton setImage:[UIImage imageNamed:@"weiBoPlayButton"] forState:UIControlStateNormal];
    [playButton addTarget:self action:@selector(playAction:) forControlEvents:UIControlEventTouchUpInside];
    [playButton setBackgroundColor:[UIColor clearColor]];
    [playButton setExclusiveTouch:YES];
    [self addSubview:playButton];
    
    deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(width - 20, 0, 20, 20)];
    [deleteButton setImage:[UIImage imageNamed:@"weiBoVideoDeleteButton"] forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
    [deleteButton setExclusiveTouch:YES];
    [self addSubview:deleteButton];
    
    NSString *timeStr = @"12:20:30";
    CGRect frame = [MTool getFrameWithString:timeStr size:CGSizeMake(width, 20) font:[UIFont systemFontOfSize:12.0]];
    
    timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(width - frame.size.width - 5, width - 22, frame.size.width, 20)];
    [timeLabel setTextColor:[UIColor whiteColor]];
    [timeLabel setFont:[UIFont systemFontOfSize:12]];
    [timeLabel setTextAlignment:NSTextAlignmentRight];
    [timeLabel setText:@"00:00"];
    timeLabel.hidden = NO;
    [self addSubview:timeLabel];
    
    sizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(2, width - 22, width - frame.size.width - 7, 20)];
    [sizeLabel setTextColor:[UIColor whiteColor]];
    [sizeLabel setFont:[UIFont systemFontOfSize:12]];
    [sizeLabel setTextAlignment:NSTextAlignmentLeft];
    [sizeLabel setText:@"12:20:30"];
    [self addSubview:sizeLabel];
}

- (void)playAction:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(playVideo)]) {
        [self.delegate playVideo];
    }
}

- (void)delete:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(deleteVideo)]) {
        [self.delegate deleteVideo];
    }
}

- (void)setKImage:(UIImage *)image{
    if (_kImage != image) {
        _kImage = image;
    }
    
    thumbImageView.image = image;
    if (image == nil) {
        return;
    }
    
    CGFloat width = ScreenWidth*(356.0/750.0);
    CGFloat scale = image.size.height/image.size.width;
    CGFloat height = width *scale;
    
    if (height < width) {
        scale = image.size.width/image.size.height;
        height = width;
        width = height * scale;
    }
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, height);
    thumbImageView.frame = CGRectMake(0, 0, width, height);
    playButton.center = thumbImageView.center;
    deleteButton.frame = CGRectMake(width - deleteButton.frame.size.width, 0, deleteButton.frame.size.width, deleteButton.frame.size.height);
    NSString *timeStr = @"12:20:30";
    CGRect frame = [MTool getFrameWithString:timeStr size:CGSizeMake(width, 20) font:[UIFont systemFontOfSize:12.0]];
    timeLabel.frame = CGRectMake(width - frame.size.width - 5, height - 22, frame.size.width, 20);
    sizeLabel.frame = CGRectMake(2, height - 22, width - frame.size.width - 7, 20);
}

- (void)setDurationString:(NSString *)durationStr{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (![durationStr isEqualToString:_durationString]) {
            _durationString = nil;
            _durationString = [durationStr copy];
        }
        timeLabel.text = _durationString;
    });
}

- (void)setSizeString:(NSString *)sizeStr{
    if (![sizeStr isEqualToString:_sizeString]) {
        _sizeString = nil;
        _sizeString = [sizeStr copy];
    }
    
    sizeLabel.text = _sizeString;
}

@end
