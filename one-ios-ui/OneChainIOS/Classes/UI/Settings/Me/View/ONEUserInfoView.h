//
//  ONEUserInfoView.h
//  OneChainIOS
//
//  Created by 李飞 on 2018/7/23.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WSAccountInfo;
@class ONEUserAssetView;
@class ONEUserInfoView;
@protocol ONEUserInfoViewDelegate<NSObject>

- (void)userInfoViewDidTapped:(ONEUserInfoView *)view;

- (void)userInfoView:(ONEUserInfoView *)view didQRCodeClicked:(WSAccountInfo *)accountInfo;

- (void)userInfoViewSettingClicked:(ONEUserInfoView *)view;
@end

@interface ONEUserInfoView : UIView

@property (nonatomic, strong) WSAccountInfo *accountInfo;

@property (nonatomic, weak) id<ONEUserInfoViewDelegate>delegate;

- (void)updateAccountInfo:(WSAccountInfo *)info;
@end


@interface ONEUserAssetView: UIView

@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UILabel *subLbl;
@property (nonatomic, copy) NSString *assetCount;
@property (nonatomic, copy) NSString *assetType;

- (instancetype)initWithTitle:(NSString *)title subTitle:(NSString *)subTitle;
- (void)updateAssetView:(NSString *)title;
@end
