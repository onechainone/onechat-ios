//
//  CreateWeiBoViewController.h
//  CancerDo
//
//  Created by hugaowei on 16/8/10.
//  Copyright © 2016年 lianji. All rights reserved.
//

#import "SBaseViewController.h"
#import "WeiBoImagesView.h"
#import "MediaButtonView.h"
//#import "UploadEntity.h"
//#import "Uploader.h"
//#import "NSObject+YYModel.h"
#import "VideoUploadAlertView.h"
#import "KImagePickerController.h"
#import "kUITextView.h"
#import "AiDuPlayerViewController.h"
#import "YKPlayNaviController.h"

typedef enum : NSInteger {
    MEDIA_TYPE_IMAGE = 1,
    MEDIA_TYPE_VIDEO = 2,
} MEDIA_TYPE;

typedef void(^NeedRefreshBlock)();

@protocol CreateWeiBoViewControllerDelegate <NSObject>

@optional
- (void)createWeiBoSuccess;

@end

@interface CreateWeiBoViewController : SBaseViewController<WeiBoImagesViewDelegate,kUITextViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,KImagePickerControllerDelegate,MediaButtonViewDelegate,UIScrollViewDelegate,UIAlertViewDelegate>
{
    UIScrollView *kScrollView;
    
    WeiBoImagesView *weiBoImagesView;
    kUITextView     *kTextView;
    
    BOOL isFristAppear;
    
    
    MEDIA_TYPE mediaType;
    
    MediaButtonView *mediaButtonView;
    
    VideoUploadAlertView *videoUploadAlertView;
    UIView *guanjianZiView;
}

@property (nonatomic,assign) id<CreateWeiBoViewControllerDelegate>delegate;

@property (nonatomic, copy) NeedRefreshBlock needRefreshBlock;
@end
