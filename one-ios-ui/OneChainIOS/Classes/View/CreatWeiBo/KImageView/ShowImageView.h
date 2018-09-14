//
//  ShowImageView.h
//  CancerDo
//
//  Created by hugaowei on 16/8/11.
//  Copyright © 2016年 lianji. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShowImageViewDelegate <NSObject>

@optional

- (void)superViewReload;

- (void)scanImageView:(KImageView*)imageView withCurrentIndex:(NSInteger)index withTotalImageCount:(NSInteger)total;

@end

@interface ShowImageView : UIView<KImageViewDelegate>
{
}

@property (nonatomic,assign) BOOL showDeleteButton;
@property (nonatomic,retain) NSMutableArray *imagesArray;
@property (nonatomic,retain) NSMutableArray *imageViewsArray;
@property (nonatomic,assign) id<ShowImageViewDelegate>delegate;

- (void)reloadImages;

+(CGFloat)getImagesHeightWithCount:(NSInteger)count;

@end
