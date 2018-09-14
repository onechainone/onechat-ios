//
//  kUITextField.m
//  CancerDo
//
//  Created by hugaowei on 16/5/26.
//  Copyright © 2016年 lianji. All rights reserved.
//

#import "kUITextField.h"

@implementation kUITextField

@synthesize kTextField;
@synthesize kImageView;
@synthesize isSecureTextEntry;

- (id)initWithFrame:(CGRect)frame placeholder:(NSString*)placeholder{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self createSubViews:placeholder];
        self.isSecureTextEntry = NO;
    }
    
    return self;
}

- (void)createSubViews:(NSString*)placeholder{
    kImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    UIImage *image = [[UIImage imageNamed:@"textFieldImageView2"] stretchableImageWithLeftCapWidth:11 topCapHeight:11];
    kImageView.image = image;
    [kImageView setBackgroundColor:[UIColor clearColor]];
    [self addSubview:kImageView];
    
    kTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, (self.frame.size.height - 30)/2, self.frame.size.width - 20, 30)];
    kTextField.returnKeyType = UIReturnKeyDone;
    kTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    kTextField.placeholder = placeholder;
    kTextField.secureTextEntry = YES;
    kTextField.backgroundColor = [UIColor clearColor];
    [self addSubview:kTextField];
    
    kTextField.delegate = self;
    UIImage *tintImage = [[UIImage imageNamed:@"systemColorImage"] stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    [kTextField setTintColor:[UIColor colorWithPatternImage:tintImage]];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if ([textField isFirstResponder]) {
        [textField resignFirstResponder];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(kTextFieldShouldReturn:)]) {
        [self.delegate kTextFieldShouldReturn:self];
    }
    
    return YES;
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(kTextFieldShouldBeginEditing:)]) {
        [self.delegate kTextFieldShouldBeginEditing:self];
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(kTextFieldChangeCharacters:Text:)]) {
        [self.delegate kTextFieldChangeCharacters:self Text:string];
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (self.delegate && [self.delegate respondsToSelector:@selector(kTextFieldEndEdit:)]) {
        [self.delegate kTextFieldEndEdit:self];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (self.delegate && [self.delegate respondsToSelector:@selector(kTextFieldDidBeginEdit:)]) {
        [self.delegate kTextFieldDidBeginEdit:self];
    }
}

- (void)setIsSecureTextEntry:(BOOL)isSecure{
    if (isSecureTextEntry != isSecure) {
        isSecureTextEntry = isSecure;
    }
    
    kTextField.secureTextEntry = isSecureTextEntry;
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    kImageView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    kTextField.frame = CGRectMake(10, (frame.size.height - 30)/2, frame.size.width - 20, 30);
}

@end
