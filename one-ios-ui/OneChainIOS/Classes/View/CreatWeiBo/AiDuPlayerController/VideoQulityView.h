//
//  VideoQulityView.h
//  CancerDo
//
//  Created by hugaowei on 16/11/3.
//  Copyright © 2016年 lianji. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VideoQulityViewDelegate <NSObject>

@optional
- (void)playVideoWithQulityDict:(NSDictionary*)dict;

@end

@interface VideoQulityView : UIView
{
    NSMutableArray *buttonArray;
}

@property (nonatomic,strong) NSMutableArray *qulityArray;

@property (nonatomic,assign) id<VideoQulityViewDelegate>delegate;

//- (NSString *)reloadWithQulity:(YKPlayerVideoQuality)qulity;

@end
