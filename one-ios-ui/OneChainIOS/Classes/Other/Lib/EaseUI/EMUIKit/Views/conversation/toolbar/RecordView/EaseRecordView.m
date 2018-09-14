/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */

#import "EaseRecordView.h"
#import "EMCDDeviceManager.h"
#import "EaseLocalDefine.h"

@interface EaseRecordView ()
{
    NSTimer *_timer;
    UIImageView *_recordAnimationView;
    UIImageView *_recordMicroView;
    UILabel *_textLabel;
    UIImageView *_recordCancelView;
}

@end

@implementation EaseRecordView

+ (void)initialize
{
    // UIAppearance Proxy Defaults
    EaseRecordView *recordView = [self appearance];
    
    recordView.voiceMessageAnimationImages = @[@"One_Voice_1",@"One_Voice_2",@"One_Voice_3",@"One_Voice_4",@"One_Voice_5",@"One_Voice_6"];

    recordView.upCancelText = NSEaseLocalizedString(@"message.toolBar.record.upCancel", @"Fingers up slide, cancel sending");
    recordView.loosenCancelText = NSEaseLocalizedString(@"message.toolBar.record.loosenCancel", @"loosen the fingers, to cancel sending");
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIView *bgView = [[UIView alloc] initWithFrame:self.bounds];
        bgView.backgroundColor = [UIColor grayColor];
        bgView.layer.cornerRadius = 5;
        bgView.layer.masksToBounds = YES;
        bgView.alpha = 0.6;
        [self addSubview:bgView];
        
        _recordMicroView = [[UIImageView alloc] initWithFrame:CGRectMake(26, 26, 67, 102)];
        _recordMicroView.image = [UIImage imageNamed:@"One_Record_View_Micro"];
        _recordMicroView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_recordMicroView];
        
        _recordAnimationView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_recordMicroView.frame) + 20, CGRectGetMinY(_recordMicroView.frame), 60, 102)];
        _recordAnimationView.image = [UIImage imageNamed:@"One_Voice_1"];
        _recordAnimationView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_recordAnimationView];
        
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(28,
                                                               CGRectGetMaxY(_recordMicroView.frame) + 22,
                                                               144,
                                                               self.bounds.size.height - CGRectGetMaxY(_recordMicroView.frame) - 22 - 5)];
        
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.text = NSEaseLocalizedString(@"message.toolBar.record.upCancel", @"Fingers up slide, cancel sending");
        [self addSubview:_textLabel];
        _textLabel.font = [UIFont systemFontOfSize:14];
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.numberOfLines = 0;

        _recordCancelView = [[UIImageView alloc] initWithFrame:CGRectMake(46, 27, 90, 101)];
        _recordCancelView.image = [UIImage imageNamed:@"One_Record_Cancel"];
        _recordCancelView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_recordCancelView];
        _recordCancelView.hidden = YES;

    }
    return self;
}

#pragma mark - setter
- (void)setVoiceMessageAnimationImages:(NSArray *)voiceMessageAnimationImages
{
    _voiceMessageAnimationImages = voiceMessageAnimationImages;
}

- (void)setUpCancelText:(NSString *)upCancelText
{
    _upCancelText = upCancelText;
    _textLabel.text = _upCancelText;

}

- (void)setLoosenCancelText:(NSString *)loosenCancelText
{
    _loosenCancelText = loosenCancelText;
}

-(void)recordButtonTouchDown
{
    _textLabel.text = _upCancelText;
    _textLabel.backgroundColor = [UIColor clearColor];
    [_recordMicroView setHidden:NO];
    [_recordAnimationView setHidden:NO];
    [_recordCancelView setHidden:YES];
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.05
                                              target:self
                                            selector:@selector(setVoiceImage)
                                            userInfo:nil
                                             repeats:YES];
    
}

-(void)recordButtonTouchUpInside
{
    [_timer invalidate];
}

-(void)recordButtonTouchUpOutside
{
    [_timer invalidate];
}

-(void)recordButtonDragInside
{
    _textLabel.text = _upCancelText;
    _textLabel.backgroundColor = [UIColor clearColor];
    [_recordMicroView setHidden:NO];
    [_recordAnimationView setHidden:NO];
    [_recordCancelView setHidden:YES];
}

-(void)recordButtonDragOutside
{
    _textLabel.text = _loosenCancelText;
    _textLabel.backgroundColor = RGBACOLOR(191, 0, 0, 1);
    [_recordMicroView setHidden:YES];
    [_recordAnimationView setHidden:YES];
    [_recordCancelView setHidden:NO];
}

-(void)setVoiceImage {
    _recordAnimationView.image = [UIImage imageNamed:[_voiceMessageAnimationImages objectAtIndex:0]];
    double voiceSound = 0;
    voiceSound = [[EMCDDeviceManager sharedInstance] emPeekRecorderVoiceMeter];
    int index = voiceSound*[_voiceMessageAnimationImages count];
    if (index >= [_voiceMessageAnimationImages count]) {
        _recordAnimationView.image = [UIImage imageNamed:[_voiceMessageAnimationImages lastObject]];
    } else {
        _recordAnimationView.image = [UIImage imageNamed:[_voiceMessageAnimationImages objectAtIndex:index]];
    }
    
    /*
    if (0 < voiceSound <= 0.05) {
        [_recordAnimationView setImage:[UIImage imageNamed:@"EaseUIResource.bundle/EaseUIResource.bundle/VoiceSearchFeedback001"]];
    }else if (0.05<voiceSound<=0.10) {
        [_recordAnimationView setImage:[UIImage imageNamed:@"EaseUIResource.bundle/EaseUIResource.bundle/VoiceSearchFeedback002"]];
    }else if (0.10<voiceSound<=0.15) {
        [_recordAnimationView setImage:[UIImage imageNamed:@"EaseUIResource.bundle/EaseUIResource.bundle/VoiceSearchFeedback003"]];
    }else if (0.15<voiceSound<=0.20) {
        [_recordAnimationView setImage:[UIImage imageNamed:@"EaseUIResource.bundle/EaseUIResource.bundle/VoiceSearchFeedback004"]];
    }else if (0.20<voiceSound<=0.25) {
        [_recordAnimationView setImage:[UIImage imageNamed:@"EaseUIResource.bundle/EaseUIResource.bundle/VoiceSearchFeedback005"]];
    }else if (0.25<voiceSound<=0.30) {
        [_recordAnimationView setImage:[UIImage imageNamed:@"EaseUIResource.bundle/EaseUIResource.bundle/VoiceSearchFeedback006"]];
    }else if (0.30<voiceSound<=0.35) {
        [_recordAnimationView setImage:[UIImage imageNamed:@"EaseUIResource.bundle/EaseUIResource.bundle/VoiceSearchFeedback007"]];
    }else if (0.35<voiceSound<=0.40) {
        [_recordAnimationView setImage:[UIImage imageNamed:@"EaseUIResource.bundle/EaseUIResource.bundle/VoiceSearchFeedback008"]];
    }else if (0.40<voiceSound<=0.45) {
        [_recordAnimationView setImage:[UIImage imageNamed:@"EaseUIResource.bundle/EaseUIResource.bundle/VoiceSearchFeedback009"]];
    }else if (0.45<voiceSound<=0.50) {
        [_recordAnimationView setImage:[UIImage imageNamed:@"EaseUIResource.bundle/EaseUIResource.bundle/VoiceSearchFeedback010"]];
    }else if (0.50<voiceSound<=0.55) {
        [_recordAnimationView setImage:[UIImage imageNamed:@"EaseUIResource.bundle/EaseUIResource.bundle/VoiceSearchFeedback011"]];
    }else if (0.55<voiceSound<=0.60) {
        [_recordAnimationView setImage:[UIImage imageNamed:@"EaseUIResource.bundle/EaseUIResource.bundle/VoiceSearchFeedback012"]];
    }else if (0.60<voiceSound<=0.65) {
        [_recordAnimationView setImage:[UIImage imageNamed:@"EaseUIResource.bundle/EaseUIResource.bundle/VoiceSearchFeedback013"]];
    }else if (0.65<voiceSound<=0.70) {
        [_recordAnimationView setImage:[UIImage imageNamed:@"EaseUIResource.bundle/EaseUIResource.bundle/VoiceSearchFeedback014"]];
    }else if (0.70<voiceSound<=0.75) {
        [_recordAnimationView setImage:[UIImage imageNamed:@"EaseUIResource.bundle/EaseUIResource.bundle/VoiceSearchFeedback015"]];
    }else if (0.75<voiceSound<=0.80) {
        [_recordAnimationView setImage:[UIImage imageNamed:@"EaseUIResource.bundle/EaseUIResource.bundle/VoiceSearchFeedback016"]];
    }else if (0.80<voiceSound<=0.85) {
        [_recordAnimationView setImage:[UIImage imageNamed:@"EaseUIResource.bundle/EaseUIResource.bundle/VoiceSearchFeedback017"]];
    }else if (0.85<voiceSound<=0.90) {
        [_recordAnimationView setImage:[UIImage imageNamed:@"EaseUIResource.bundle/EaseUIResource.bundle/VoiceSearchFeedback018"]];
    }else if (0.90<voiceSound<=0.95) {
        [_recordAnimationView setImage:[UIImage imageNamed:@"EaseUIResource.bundle/EaseUIResource.bundle/VoiceSearchFeedback019"]];
    }else {
        [_recordAnimationView setImage:[UIImage imageNamed:@"EaseUIResource.bundle/EaseUIResource.bundle/VoiceSearchFeedback020"]];
    }*/
}

@end
