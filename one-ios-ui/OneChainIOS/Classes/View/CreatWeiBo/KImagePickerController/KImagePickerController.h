//
//  KImagePickerController.h
//  CancerDo
//
//  Created by hugaowei on 16/6/13.
//  Copyright © 2016年 lianji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "NSDate+TimeInterval.h"

@class KImagePickerController;

@protocol KImagePickerControllerDelegate <NSObject>

- (void)imagePickerController:(KImagePickerController*)pickerController didFinishPickingAssets:(NSArray*)assetsArray;

@optional

- (void)kImagePickerControllerDidCancel:(KImagePickerController*)pickerController;

@end

@interface KImagePickerController : UINavigationController

@property (nonatomic,weak) id<UINavigationControllerDelegate,KImagePickerControllerDelegate>kDelegate;

@property (nonatomic,strong) ALAssetsFilter *assetsFilter;

@property (nonatomic,assign) BOOL showsCancleButton;

@property (nonatomic,assign) BOOL selectPhotoAndVideo;

@property (nonatomic,assign) NSInteger maximumNumberOfSelection;


@end
