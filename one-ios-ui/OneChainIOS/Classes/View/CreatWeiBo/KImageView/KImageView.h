//
//  KImageView.h
//  CancerDo
//
//  Created by hugaowei on 16/6/14.
//  Copyright © 2016年 lianji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteImageModel.h"

@class KImageView;
@protocol KImageViewDelegate <NSObject>

- (void)deleteImageFromImageView:(KImageView*)imageView;

- (void)scanImageView:(KImageView*)imageView;

@end

@interface KImageView : UIView
{
    UIButton *imageButton;
    UIButton *deleteButton;
}

@property (nonatomic,retain) UIButton *kImageView;

@property (nonatomic,assign) BOOL showDeleteButton;
@property (nonatomic,retain) NoteImageModel *kImage;
@property (nonatomic,assign) id<KImageViewDelegate>delegate;

- (id)initWithFrame:(CGRect)frame;

@end
