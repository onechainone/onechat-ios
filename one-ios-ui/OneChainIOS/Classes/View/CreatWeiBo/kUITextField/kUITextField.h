//
//  kUITextField.h
//  CancerDo
//
//  Created by hugaowei on 16/5/26.
//  Copyright © 2016年 lianji. All rights reserved.
//

#import <UIKit/UIKit.h>

@class kUITextField;
@protocol kUITextFieldDelegate <NSObject>

@optional
- (void)kTextFieldShouldReturn:(kUITextField*)textField;
- (void)kTextFieldShouldBeginEditing:(kUITextField*)textField;
- (void)kTextFieldChangeCharacters:(kUITextField *)textField Text:(NSString*)string;
- (void)kTextFieldDidBeginEdit:(kUITextField*)textField;
- (void)kTextFieldEndEdit:(kUITextField *)textField;

@end

@interface kUITextField : UIView<UITextFieldDelegate>

@property (nonatomic,strong) UITextField *kTextField;
@property (nonatomic,strong) UIImageView *kImageView;

@property (nonatomic,assign) BOOL isSecureTextEntry;

@property (nonatomic,assign) id<kUITextFieldDelegate>delegate;

- (id)initWithFrame:(CGRect)frame placeholder:(NSString*)placeholder;

@end
