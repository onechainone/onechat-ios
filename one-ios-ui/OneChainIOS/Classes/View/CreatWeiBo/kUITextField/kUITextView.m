//
//  kUITextView.m
//  CancerDo
//
//  Created by hugaowei on 16/7/7.
//  Copyright © 2016年 lianji. All rights reserved.
//

#import "kUITextView.h"

@implementation kUITextView

@synthesize backgroundImage;
@synthesize placeHolderString;
@synthesize kTextView;
@synthesize backgroundImageView;

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self createViews];
    }
    
    return self;
}

- (void)createViews{
    UIImage *image = [[UIImage imageNamed:@"textFieldImageView2"] stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    UIImage *tintImage = [[UIImage imageNamed:@"systemColorImage"] stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [backgroundImageView setBackgroundColor:[UIColor clearColor]];
    [backgroundImageView setImage:image];
    [self addSubview:backgroundImageView];
    
    kTextView = [[UITextView alloc] initWithFrame:CGRectMake(2, 2, self.frame.size.width-4, self.frame.size.height-4)];
    kTextView.returnKeyType = UIReturnKeyDone;
    [kTextView setFont:[UIFont systemFontOfSize:18.0f]];
    [kTextView setTextColor:ColorWithRGB(120, 120, 120, 1)];
    [kTextView setDelegate:self];
    [kTextView setTintColor:[UIColor colorWithPatternImage:tintImage]];
    [self addSubview:kTextView];
    
    alertLabel = [[UILabel alloc] initWithFrame:CGRectMake(kTextView.frame.origin.x+5, kTextView.frame.origin.y+7, kTextView.frame.size.width - 10, 24)];
    alertLabel.font      = [UIFont systemFontOfSize:17.0];
    alertLabel.textColor = ColorWithRGB(160.0f, 160.0f, 160.0f, 1);
    alertLabel.text      = @"请输入内容";
    [self addSubview:alertLabel];
}

- (void)setBackgroundImage:(UIImage *)image{
    
    if (image == nil) {
        image = [[UIImage imageNamed:@"textFieldImageView2"] stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    }
    
    if (backgroundImage != image) {
        backgroundImage = image;
    }
    
    backgroundImageView.image = backgroundImage;
}

- (void)setPlaceHolderString:(NSString *)string{
    if (![placeHolderString isEqualToString:string]) {
        placeHolderString = nil;
        placeHolderString = [string copy];
    }
    
    alertLabel.text = placeHolderString;
    if (kTextView.text.length < 1) {
        if ([placeHolderString isBlankString]) {
            alertLabel.hidden = YES;
        }else{
            alertLabel.hidden = NO;
        }
    }else{
        alertLabel.hidden = YES;
    }
    
    CGRect frame = [MTool getFrameWithString:alertLabel.text
                                        size:CGSizeMake(alertLabel.frame.size.width, kTextView.frame.size.height - 14)
                                        font:alertLabel.font];
    alertLabel.frame = CGRectMake(alertLabel.frame.origin.x, alertLabel.frame.origin.y, alertLabel.frame.size.width, frame.size.height);
}

- (void)kResignFirstResponder{
    if ([kTextView isFirstResponder]) {
        [kTextView resignFirstResponder];
    }
    
    if (kTextView.text.length > 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(kTextViewDidEndInput:)]) {
            [self.delegate kTextViewDidEndInput:kTextView.text];
        }
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [textView resignFirstResponder];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    if (textView == kTextView) {
        if (textView.text.length > 0) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(kTextViewDidEndInput:)]) {
                [self.delegate kTextViewDidEndInput:kTextView.text];
            }
        }
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    if (textView == kTextView) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(kTextViewDidBeginInput:)]) {
            [self.delegate kTextViewDidBeginInput:self];
        }
    }
}

- (void)textViewDidChange:(UITextView *)textView{
    if (textView == kTextView) {
        if (textView.text.length < 1) {
            alertLabel.hidden = NO;
        }else{
            alertLabel.hidden = YES;
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(kTextViewDidChange:)]) {
            [self.delegate kTextViewDidChange:kTextView.text];
        }
    }
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    backgroundImageView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    
    kTextView.frame = CGRectMake(2, 2, frame.size.width-4, frame.size.height-4);
    
    ;
    
    CGRect rect = [MTool getFrameWithString:alertLabel.text
                                        size:CGSizeMake(kTextView.frame.size.width-10, kTextView.frame.size.height - 10)
                                        font:alertLabel.font];
    alertLabel.frame = CGRectMake(kTextView.frame.origin.x+5, kTextView.frame.origin.y+7, kTextView.frame.size.width - 10, rect.size.height);
}

@end
