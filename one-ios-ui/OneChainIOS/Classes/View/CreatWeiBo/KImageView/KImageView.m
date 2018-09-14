//
//  KImageView.m
//  CancerDo
//
//  Created by hugaowei on 16/6/14.
//  Copyright © 2016年 lianji. All rights reserved.
//

#import "KImageView.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
#import "UIImageView+GetImage.h"

@implementation KImageView

@synthesize kImageView;

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubViews];
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

- (void)createSubViews{
    imageButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [imageButton setBackgroundColor:[UIColor clearColor]];
    imageButton.hidden = YES;
    [imageButton setExclusiveTouch:YES];
    
    [self addSubview:imageButton];
    
    kImageView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [kImageView setBackgroundColor:[UIColor clearColor]];
    kImageView.userInteractionEnabled = YES;
    [kImageView setExclusiveTouch:YES];
    [kImageView addTarget:self action:@selector(imageViewDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:kImageView];
    
    deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-20, 0, 20, 20)];
    [deleteButton setImage:[UIImage imageNamed:@"imageDeleteButton"] forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(deleteImage:) forControlEvents:UIControlEventTouchUpInside];
    [deleteButton setExclusiveTouch:YES];
    [self addSubview:deleteButton];
}

- (void)imageViewDidClicked:(UIGestureRecognizer*)ges{
    if (self.delegate && [self.delegate respondsToSelector:@selector(scanImageView:)]) {
        [self.delegate scanImageView:self];
    }
}

- (void)deleteImage:(UIButton*)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(deleteImageFromImageView:)]) {
        [self.delegate deleteImageFromImageView:self];
    }
}

- (void)setKImage:(NoteImageModel *)image{
    if (_kImage != image) {
        _kImage = image;
    }
    
    CGSize size = imageButton.frame.size;
    
    UIImage *newImage =[[ImageManager sharedImageManager] getThumbnailImage:_kImage.image withSize:size];
    if (_kImage.imagePath.length > 0) {
        NSURL *url = [NSURL URLWithString:_kImage.imagePath];
        UIImage *defaultImage = [UIImage imageNamed:@"defaultHeader"];
        //        [imageButton sd_setImageWithURL:url forState:UIControlStateNormal placeholderImage:defaultImage completed:^(UIImage *image, NSError *error, EMSDImageCacheType cacheType, NSURL *imageURL) {
        //        }];
        [imageButton sd_setImageWithURL:url forState:UIControlStateNormal placeholderImage:defaultImage completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            
        }];
//        [kImageView sd_setBackgroundImageWithURL:url forState:UIControlStateNormal placeholderImage:defaultImage completed:^(UIImage *image, NSError *error, EMSDImageCacheType cacheType, NSURL *imageURL) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                UIImage *secImage = [kImageView.imageView getImageFromImage:image fromRect:kImageView.frame];
//                if (secImage) {
//                    [kImageView setBackgroundImage:secImage forState:UIControlStateNormal];
//                }
//            });
//        }];
//
        
//        [kImageView setBackgroundImageWithURL:url forState:UIControlStateNormal placeholderImage:defaultImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
       [kImageView sd_setBackgroundImageWithURL:url forState:UIControlStateNormal placeholderImage:defaultImage completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImage *secImage = [kImageView.imageView getImageFromImage:image fromRect:kImageView.frame];
                if (secImage) {
                    [kImageView setBackgroundImage:secImage forState:UIControlStateNormal];
                }
            });
        }];
    }else{
        [imageButton setImage:newImage forState:UIControlStateNormal];
        [kImageView setBackgroundImage:newImage forState:UIControlStateNormal];
    }
}

- (void)setShowDeleteButton:(BOOL)showDelete{
    if (_showDeleteButton != showDelete) {
        _showDeleteButton = showDelete;
    }
    
    deleteButton.hidden = !_showDeleteButton;
}

@end
