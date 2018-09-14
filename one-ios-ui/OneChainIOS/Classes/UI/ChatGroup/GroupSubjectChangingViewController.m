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

#import "GroupSubjectChangingViewController.h"
@interface GroupSubjectChangingViewController () <UITextFieldDelegate>
{
    ONEChatGroup         *_group;
    BOOL            _isOwner;
    UITextField     *_subjectField;
}

@end

@implementation GroupSubjectChangingViewController

- (instancetype)initWithGroup:(ONEChatGroup *)group
{
    self = [self init];
    if (self) {
        _group = group;
        _isOwner = [_group.owner isEqualToString:[ONEChatClient homeAccountId]];
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.themeMap = @{
                           BGColorName:@"bg_white_color"
                           };
    self.title = NSLocalizedString(@"group_change_subject", @"Change group name");

//    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
//    backButton.accessibilityIdentifier = @"back";
//    [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
//    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
//    [self.navigationItem setLeftBarButtonItem:backItem];

    if (_isOwner)
    {
        UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"button_save", @"Save") style:UIBarButtonItemStylePlain target:self action:@selector(save:)];
//        saveItem.tintColor = [UIColor colorWithRed:32 / 255.0 green:134 / 255.0 blue:158 / 255.0 alpha:1.0];
        saveItem.tintColor = THMColor(@"buttonItem_tint_color");
        [self.navigationItem setRightBarButtonItem:saveItem];
    }

    CGRect frame = CGRectMake(20, 20, self.view.frame.size.width - 40, 40);
    _subjectField = [[UITextField alloc] initWithFrame:frame];
    _subjectField.themeMap = @{
                               TextColorName:@"msg_input_text_color"
                               };
    _subjectField.layer.cornerRadius = 5.0;
    _subjectField.layer.borderWidth = 0.5;
    _subjectField.layer.borderColor = THMColor(@"input_text_border_color").CGColor;
//    _subjectField.placeholder = NSLocalizedString(@"group.setting.subject", @"Please input group name");
    _subjectField.text = _group.name;
    if (!_isOwner)
    {
        _subjectField.enabled = NO;
    }
    frame.origin = CGPointMake(frame.size.width - 5.0, 0.0);
    frame.size = CGSizeMake(5.0, 40.0);
    UIView *holder = [[UIView alloc] initWithFrame:frame];
    _subjectField.rightView = holder;
    _subjectField.rightViewMode = UITextFieldViewModeAlways;
    frame.origin = CGPointMake(0.0, 0.0);
    holder = [[UIView alloc] initWithFrame:frame];
    _subjectField.leftView = holder;
    _subjectField.leftViewMode = UITextFieldViewModeAlways;
    _subjectField.delegate = self;
    [self.view addSubview:_subjectField];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - action
- (void)back
{
    if ([_subjectField isFirstResponder])
    {
        [_subjectField resignFirstResponder];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)save:(id)sender
{
    [self saveSubject];
    
}



- (void)saveSubject
{
    [self.view endEditing:YES];
    [self showHudInView:self.view hint:nil];
    [[ONEChatClient sharedClient] changeGroupName:_subjectField.text group:_group.groupId completion:^(ONEError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
           
            if (!error) {
                
                [[ONEChatClient sharedClient] syncGroupChatInfo:^(ONEError *error) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self hideHud];
                        ONEChatGroup *group = [[ONEChatClient sharedClient] groupChatWithGroupId:_group.groupId];
                        !_subjectChanged ?: _subjectChanged(group);
                        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_GROUPSUBJECT_UPDATED object:nil];
                        [self back];
                    });
                    
                }];
            } else {
                [self hideHud];
                [self showHint:NSLocalizedString(@"group_change_subject_failed", @"Change group name failed")];
            }
        });
    }];
}

@end
