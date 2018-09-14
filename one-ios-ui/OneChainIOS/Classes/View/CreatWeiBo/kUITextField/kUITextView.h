//
//  kUITextView.h
//  CancerDo
//
//  Created by hugaowei on 16/7/7.
//  Copyright © 2016年 lianji. All rights reserved.
//

#import <UIKit/UIKit.h>

@class kUITextView;
@protocol kUITextViewDelegate <NSObject>

@optional
- (void)kTextViewDidEndInput:(NSString*)inputString;
- (void)kTextViewDidBeginInput:(kUITextView*)textView;
- (void)kTextViewDidChange:(NSString*)inputString;

@end

@interface kUITextView : UIView<UITextViewDelegate>
{
    UILabel *alertLabel;
}

@property (nonatomic,strong) UIImageView *backgroundImageView;
@property (nonatomic,strong) UITextView *kTextView;
@property (nonatomic,strong) UIImage *backgroundImage;
@property (nonatomic,copy  ) NSString *placeHolderString;
@property (nonatomic,assign) id<kUITextViewDelegate>delegate;

- (void)kResignFirstResponder;

@end
