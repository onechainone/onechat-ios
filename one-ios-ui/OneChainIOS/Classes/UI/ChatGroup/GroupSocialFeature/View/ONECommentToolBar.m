//
//  ONECommentToolBar.m
//  OneChainIOS
//
//  Created by lifei on 2018/5/11.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "ONECommentToolBar.h"

@implementation ONECommentToolBar


- (void)_setupSubviews
{
    [super _setupSubviews];
    self.inputViewLeftItems = nil;
    EaseChatToolbarItem *item = [[EaseChatToolbarItem alloc] initWithButton:[UIButton new] withView:nil];
    self.inputViewRightItems = @[item];
    
//    self.backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
//    self.backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//    self.backgroundImageView.backgroundColor = [UIColor clearColor];
//    self.backgroundImageView.image = [[UIImage imageNamed:@"EaseUIResource.bundle/messageToolbarBg"] stretchableImageWithLeftCapWidth:0.5 topCapHeight:10];
//    [self addSubview:self.backgroundImageView];
//
//    //toolbar
//    self.toolbarView = [[UIView alloc] initWithFrame:self.bounds];
//    self.toolbarView.backgroundColor = [UIColor clearColor];
//    [self addSubview:self.toolbarView];
//
//    self.toolbarBackgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.toolbarView.frame.size.width, self.toolbarView.frame.size.height)];
//    self.toolbarBackgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//    self.toolbarBackgroundImageView.backgroundColor = [UIColor clearColor];
//    [self.toolbarView addSubview:self.toolbarBackgroundImageView];
//
//    //input textview
//    self.inputTextView = [[EaseTextView alloc] initWithFrame:CGRectMake(self.horizontalPadding, self.verticalPadding, self.frame.size.width - self.verticalPadding * 2, self.frame.size.height - self.verticalPadding * 2)];
//    self.inputTextView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
//    self.inputTextView.scrollEnabled = YES;
//    self.inputTextView.returnKeyType = UIReturnKeySend;
//    self.inputTextView.enablesReturnKeyAutomatically = YES; // UITextView内部判断send按钮是否可以用
//    self.inputTextView.placeHolder = NSEaseLocalizedString(@"message.toolBar.inputPlaceHolder", @"input a new message");
//    self.inputTextView.delegate = self;
//    self.inputTextView.backgroundColor = [UIColor clearColor];
//    self.inputTextView.layer.borderColor = [UIColor colorWithWhite:0.8f alpha:1.0f].CGColor;
//    self.inputTextView.layer.borderWidth = 0.65f;
//    self.inputTextView.layer.cornerRadius = 6.0f;
//    self.previousTextViewContentHeight = [self self.getTextViewContentH:self.inputTextView];
//    [self.toolbarView addSubview:self.inputTextView];
    
}

@end
