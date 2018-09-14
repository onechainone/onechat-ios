//
//  lhScanQCodeViewController.h
//  lhScanQCodeTest
//
//  Created by GZWei on 15/10/20.
//  Copyright © 2015年 GZWei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QRCodeReaderView.h"

#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#define DeviceMaxHeight ([UIScreen mainScreen].bounds.size.height)
#define DeviceMaxWidth ([UIScreen mainScreen].bounds.size.width)
#define widthRate DeviceMaxWidth/320
#define IOS8 ([[UIDevice currentDevice].systemVersion intValue] >= 7 ? YES : NO)

typedef void(^ErWeiMaBlock)(NSString *str);

@interface lhScanQCodeViewController : UIViewController<QRCodeReaderViewDelegate,AVCaptureMetadataOutputObjectsDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate>{
//    QRCodeReaderView * readview;//二维码扫描对象
    
    BOOL isFirst;//第一次进入该页面
    BOOL isPush;//跳转到下一级页面
}
@property (nonatomic, copy) ErWeiMaBlock succ;

@property (strong, nonatomic) CIDetector *detector;
@property(nonatomic,strong)QRCodeReaderView *readview;
- (void)accordingQcode:(NSString *)str;

@end
