//
//  VideoUploadAlertView.m
//  CancerDo
//
//  Created by hugaowei on 16/11/8.
//  Copyright © 2016年 lianji. All rights reserved.
//

#import "VideoUploadAlertView.h"

@implementation VideoUploadAlertView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubViews];
    }
    
    return self;
}

- (void)createSubViews{
//    self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    self.backgroundColor = [UIColor whiteColor];
    
    CGFloat width = self.width - 20;
    backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, width)];
    [backgroundView setBackgroundColor:[UIColor clearColor]];
    [backgroundView setCenter:self.center];
    [self addSubview:backgroundView];
    
    roundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, width)];
    [roundImageView setImage:[UIImage imageNamed:@"videoUploadBackground"]];
    [backgroundView addSubview:roundImageView];
    
    jinDuView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, width)];
    [jinDuView setBackgroundColor:[UIColor clearColor]];
    [backgroundView addSubview:jinDuView];
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, width - 35, width, 20)];
    [titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTextColor:ColorWithRGB(150.0, 150.0, 150.0, 1)];
    [titleLabel setText:@"视频处理中 ..."];
    [jinDuView addSubview:titleLabel];
    
    progressView = [[VideoUploadProgressView alloc] initWithFrame:CGRectMake(27, titleLabel.frame.origin.y - 10 - (width - 54), width-54, width-54)];
    [progressView setBackgroundColor:[UIColor clearColor]];
    [jinDuView addSubview:progressView];
    
    jinDuLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 20)];
    [jinDuLabel setFont:[UIFont systemFontOfSize:16.0]];
    [jinDuLabel setTextAlignment:NSTextAlignmentCenter];
    [jinDuLabel setTextColor:SystemDefaultColor];
    [jinDuLabel setText:@"0%"];
    [jinDuLabel setCenter:CGPointMake(width/2, width/2-10)];
    [jinDuLabel setBackgroundColor:[UIColor clearColor]];
    [jinDuView addSubview:jinDuLabel];
    jinDuLabel.center = CGPointMake(jinDuLabel.center.x, progressView.center.y);
    
    completeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 20)];
    [completeLabel setFont:[UIFont systemFontOfSize:16.0]];
    [completeLabel setTextAlignment:NSTextAlignmentCenter];
    [completeLabel setTextColor:SystemDefaultColor];
    [completeLabel setText:@"视频已上传"];
    [completeLabel setCenter:CGPointMake(width/2, width/2)];
    [completeLabel setHidden:YES];
    [backgroundView addSubview:completeLabel];
}

- (void)setProgressValue:(CGFloat)value{
    if (_progressValue != value) {
        _progressValue = value;
    }
    
    progressView.progressValue = _progressValue;
    
    int progress = _progressValue *100;
    
    NSString *progressStr = [NSString stringWithFormat:@"%d",progress];
    progressStr = [progressStr stringByAppendingString:@"%"];
    
    jinDuLabel.text = progressStr;
    
    NSLog(@"progressStr ====  %@",progressStr);
    
    if (_progressValue < 1) {
        [progressView setNeedsDisplay];
        jinDuView.hidden = NO;
        completeLabel.hidden = YES;
    }else{
        jinDuView.hidden = YES;
        completeLabel.hidden = NO;
    }
}

@end
