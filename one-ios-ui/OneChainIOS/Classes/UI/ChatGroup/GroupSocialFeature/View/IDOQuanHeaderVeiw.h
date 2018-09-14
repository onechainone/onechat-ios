//
//  IDOQuanHeaderVeiw.h
//  CancerDo
//
//  Created by hugaowei on 16/12/1.
//  Copyright © 2016年 lianji. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  IDOQuanHeaderVeiw;

@protocol IDOQuanHeaderVeiwDelegate <NSObject>

@optional
- (void)tableHeaderViewDidClicked;

@end

@interface IDOQuanHeaderVeiw : UIView
{
    UIView *backgroundView;
    UIImageView *backgroundImageView;
    UIImageView *headerImageView;
    
    UILabel *numberLabel;
    
    UIButton *rowButton;
    UIButton *clearButton;
}

@property (nonatomic,copy  ) NSString *number;
@property (nonatomic,copy  ) NSString *image_url;

@property (nonatomic,assign) id<IDOQuanHeaderVeiwDelegate>delegate;

@end
