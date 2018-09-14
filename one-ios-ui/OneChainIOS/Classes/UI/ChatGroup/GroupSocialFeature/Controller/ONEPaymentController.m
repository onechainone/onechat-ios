//
//  ONEPaymentController.m
//  OneChainIOS
//
//  Created by lifei on 2018/5/15.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "ONEPaymentController.h"
#import "ONEArticleDetailController.h"
@interface ONEPaymentController ()

@property (nonatomic, copy) NSString *assetCode;
@property (nonatomic, copy) NSString *amount;
@property (nonatomic) BOOL isPayArticle; // YES 支付微博  NO 打赏微博

@property (nonatomic, copy) NSString *navTitle;

@property (nonatomic, strong) id<IMessageModel>msgModel;
@end

@implementation ONEPaymentController


- (instancetype)initWithAssetCode:(NSString *)assetCode amount:(NSString *)amount
{
    self = [super init];
    if (self) {
        _assetCode = assetCode;
        _amount = amount;
        _isPayArticle = YES;
        _navTitle = NSLocalizedString(@"pay", @"");
        _msgModel = nil;
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _isPayArticle = NO;
        _navTitle = NSLocalizedString(@"zanshang", @"");
        _msgModel = nil;

    }
    return self;
}

- (instancetype)initWithMessage:(id<IMessageModel>)msgModel
{
    self = [super init];
    if (self) {
        _msgModel = msgModel;
        _navTitle = NSLocalizedString(@"zanshang", @"");

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _navTitle;
    self.imgV4.hidden = YES;
    self.imgV5.hidden = YES;
    self.red_countLbl.hidden = YES;
    self.msgLbl.hidden = YES;
    self.changeLabel1.hidden = YES;
    [self updateRedType:YES];
    self.redCountTF.hidden = YES;
    self.groupMCLbl.hidden = YES;
    self.redMsgTF.hidden = YES;
    if (_isPayArticle) {
        
        self.imgV1.userInteractionEnabled = NO;
        [self updateCoinWithCode:_assetCode button:self.selectCoinBtn];
        [self.select_type_lbl setHidden:YES];
        self.singleALbl.text = NSLocalizedString(@"charge_amount", nil);
        self.singleAmountTF.text = _amount;
        self.singleAmountTF.userInteractionEnabled = NO;
        [self.sendButton setTitle:NSLocalizedString(@"pay", @"") forState:UIControlStateNormal];
        [self sendButtonCanClick:YES];
    } else {
        [self sendButtonCanClick:YES];
        self.singleALbl.text = NSLocalizedString(@"reward_amount", @"");
                [self.sendButton setTitle:_navTitle forState:UIControlStateNormal];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    }
    
}


- (void)sendRedpacket
{
    if (_msgModel) {
        
        [self likeGroupMessageAction];
        return;
    }
    if (_isPayArticle) {
        [self showHudInView:self.view hint:nil];
        __weak typeof(self) weakself = self;
        
        [[ONEChatClient sharedClient] payForArticle:self.articleId assetCode:_assetCode amount:_amount groupId:self.groupId withCompletion:^(ONEError *error) {
           
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakself hideHud];
                if (!error) {
                    [weakself showHudInView:weakself.view hint:nil];
                    [[ONEChatClient sharedClient] getArticleDetail:self.articleId completion:^(ONEError *error, ONEArticle *article) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [weakself hideHud];
                            if (!error && article) {
                                
                                !weakself.articlePayed ?:weakself.articlePayed(article);
                                ONEArticleDetailController *detail = [[ONEArticleDetailController alloc] initWithArticle:article];
                                [self.navigationController pushViewController:detail animated:YES];
                                [self removePaymentController];
                            }
                        });
                    }];
                } else {
                    if (error.errorCode == ONEErrorCommunityOpeNeedAssetButNotEnough) {
                        [self showHint:NSLocalizedString(@"amount_error_not_enough_money_plain", @"")];
                    } else {
                        [self showHint:NSLocalizedString(@"error", @"")];
                    }
                }
            });
        }];
        
    } else {
        
        NSString *assetCode = self.selectedModel.asset_code;
        NSString *amount = self.singleAmountTF.text;
        if (assetCode == nil || amount == nil) {
            return;
        }
        [self showHudInView:self.view hint:nil];
        __weak typeof(self) weakself = self;
        
        [[ONEChatClient sharedClient] rewardArticle:self.articleId assetCode:assetCode amount:amount groupId:self.groupId withCompletion:^(ONEError *error) {
           
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakself hideHud];
                if (!error) {
                    
                    !weakself.articleHasRewarded ?: weakself.articleHasRewarded(weakself.articleId);
                    [weakself.navigationController popViewControllerAnimated:YES];
                } else {
                    [weakself showHint:NSLocalizedString(@"failed_to_reward", @"")];
                }

            });
        }];
    }
}

- (void)likeGroupMessageAction
{
    if (!_msgModel) {
        return;
    }
    NSString *assetCode = self.selectedModel.asset_code;
    NSString *amount = self.singleAmountTF.text;
    if (assetCode == nil || amount == nil) {
        return;
    }
    NSString *msgId = _msgModel.message.messageId;
    NSString *userId = _msgModel.message.from;
    if (![userId isAccountId]) {
        userId = [ONEChatClient accountIdWithName:userId];
    }
    __weak typeof(self)weakself = self;
    [self showHudInView:self.view hint:nil];
    
    [[ONEChatClient sharedClient] rewardGroupMessage:msgId likedUserId:userId assetCode:assetCode amount:amount completion:^(ONEError *error) {
       
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakself hideHud];
            if (!error) {
                [weakself.navigationController popViewControllerAnimated:YES];
                !weakself.groupMsgRewarded ?: weakself.groupMsgRewarded();
                
            } else {
                
                if (error.errorCode == ONEErrorBalanceNotEnough) {
                    [weakself showHint:NSLocalizedString(@"amount_error_not_enough_money_plain", @"")];
                } else {
                    [weakself showHint:NSLocalizedString(@"failed_to_reward", @"")];
                }
            }
        });
    }];
}


- (void)removePaymentController
{
    NSMutableArray *vcs = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    [vcs enumerateObjectsUsingBlock:^(UIViewController *vc, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([vc isKindOfClass:[ONEPaymentController class]]) {
            
            [vcs removeObject:vc];
            *stop = YES;
        }
    }];
    self.navigationController.viewControllers = [NSArray arrayWithArray:vcs];
}

- (void)dealloc
{
    
}

@end
