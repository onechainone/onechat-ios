//
//  MediaButtonView.m
//  CancerDo
//
//  Created by hugaowei on 16/10/27.
//  Copyright © 2016年 lianji. All rights reserved.
//

#import "MediaButtonView.h"

@implementation MediaButtonView
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = ColorWithRGB(249.0, 249.0, 249.0, 1);
        [self createSubViews];
    }
    return self;
}

#pragma mark 创建子视图
- (void)createSubViews{
    
    CGFloat width = 34;
    CGFloat height = 30;
    
//    CGFloat originX = ScreenWidth - 20 - width;
    CGFloat originX = 20 + width+20;
    
    CGFloat originY = (self.frame.size.height - height)/2.0;
    //    takePicButton = [[UIButton alloc] initWithFrame:CGRectMake(originX, originY, 25.5, 21)];
    //    [takePicButton setBackgroundColor:[UIColor clearColor]];
    //    [takePicButton setImage:[UIImage imageNamed:@"WBTakePicButton"] forState:UIControlStateNormal];
    //    [takePicButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    //    [pictureView addSubview:takePicButton];
    
    videoButton = [[UIButton alloc] initWithFrame:CGRectMake(originX, originY, width, height)];
    [videoButton setBackgroundColor:[UIColor clearColor]];
    [videoButton setImage:[UIImage imageNamed:@"createWeiBoVideo"] forState:UIControlStateNormal];
    [videoButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [videoButton setExclusiveTouch:YES];
    [self addSubview:videoButton];
    
    originX = CGRectGetMinX(videoButton.frame) - width - 30;
    photoListViewButton = [[UIButton alloc] initWithFrame:CGRectMake(originX, originY, width, height)];
    [photoListViewButton setBackgroundColor:[UIColor clearColor]];
    [photoListViewButton setImage:[UIImage imageNamed:@"createWeiBoPhoto"] forState:UIControlStateNormal];
    [photoListViewButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [photoListViewButton setExclusiveTouch:YES];
    [self addSubview:photoListViewButton];
    
    originX = CGRectGetMinX(photoListViewButton.frame) - width - 30;
    faceButton = [[UIButton alloc] initWithFrame:CGRectMake(originX, originY, width, height)];
    [faceButton setBackgroundColor:[UIColor clearColor]];
    [faceButton setImage:[UIImage imageNamed:@"createWeiBoFace"] forState:UIControlStateNormal];
    [faceButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    faceButton.hidden = YES;
    [faceButton setExclusiveTouch:YES];
    [self addSubview:faceButton];
    ///发布btn
    CGFloat fabuoriginX = ScreenWidth - 20 - width;
    fabuBtn = [[UIButton alloc] initWithFrame:CGRectMake(fabuoriginX, originY, 35, height)];
    [fabuBtn setBackgroundColor:[UIColor colorWithHex:BTN_BACKGROUNDCOLOR]];
    [fabuBtn setTitle:NSLocalizedString(@"publish", nil) forState:UIControlStateNormal];
//    fabuBtn.layer.contentsRect = BTN_CIRCULAR;
    fabuBtn.layer.cornerRadius = BTN_CIRCULAR;
    fabuBtn.clipsToBounds = YES;
    
    fabuBtn.titleLabel.font = [UIFont systemFontOfSize:LITTLE_LABEL_FRONT];
//    [fabuBtn sizeToFit];
    [self addSubview:fabuBtn];
    [fabuBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    fabuBtn.hidden = YES;
    
    
}

- (void)buttonAction:(UIButton*)sender{
    if (sender == takePicButton) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(weiBoGetPictureFromCamera)]) {
            [self.delegate weiBoGetPictureFromCamera];
        }
    }
    
    if (sender == photoListViewButton) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(weiBoGetPictureFromPhotoList)]) {
            [self.delegate weiBoGetPictureFromPhotoList];
        }
    }
    
    if (sender == videoButton) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(weiboGetVideoFromVideoList)]) {
            [self.delegate weiboGetVideoFromVideoList];
        }
    }
    if(sender == fabuBtn) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(weiboFaBuClick)]) {
            [self.delegate weiboFaBuClick];
        }
    }
}

@end
