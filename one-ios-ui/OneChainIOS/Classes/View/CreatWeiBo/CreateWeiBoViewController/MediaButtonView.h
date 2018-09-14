//
//  MediaButtonView.h
//  CancerDo
//
//  Created by hugaowei on 16/10/27.
//  Copyright © 2016年 lianji. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MediaButtonViewDelegate <NSObject>

@optional
- (void)weiBoGetPictureFromPhotoList;
- (void)weiBoGetPictureFromCamera;
- (void)weiboGetVideoFromVideoList;
- (void)weiboFaBuClick;

@end

@interface MediaButtonView : UIView
{
    UIButton *takePicButton;// 照相机按钮
    
    UIButton *photoListViewButton;// 相册按钮
    UIButton *videoButton;// 选择视频
    UIButton *faceButton;//  选择表情
    UIButton *fabuBtn;///发布按钮
}

@property (nonatomic,assign) id<MediaButtonViewDelegate>delegate;

@end
