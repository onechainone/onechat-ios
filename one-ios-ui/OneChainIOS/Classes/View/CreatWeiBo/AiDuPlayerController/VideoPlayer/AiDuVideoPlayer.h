//
//  AiDuVideoPlayer.h
//  BaiDuVideoDemo
//
//  Created by hugaowei on 2017/2/13.
//  Copyright © 2017年 lianji. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AiDuVideoPlayer;

typedef void (^VideoCompletedPlayingBlock) (AiDuVideoPlayer *videoPlayer);
typedef void (^ShowOrHiddenBottomBolck) (AiDuVideoPlayer *videoPlayer);

@interface AiDuVideoPlayer : UIView

@property (nonatomic, copy) VideoCompletedPlayingBlock completedPlayingBlock;
@property (nonatomic, copy) ShowOrHiddenBottomBolck showBottomBlock;

/**
 *  video url 视频路径
 */
@property (nonatomic, strong) NSString *videoUrl;

@property (nonatomic, assign) BOOL barHiden;

/**
 *  play or pause
 */
- (void)playPause;

/**
 *  dealloc 销毁
 */
- (void)destroyPlayer;

/**
 *  在cell上播放必须绑定TableView、当前播放cell的IndexPath
 */
- (void)playerBindTableView:(UITableView *)bindTableView currentIndexPath:(NSIndexPath *)currentIndexPath;

/**
 *  在scrollview的scrollViewDidScroll代理中调用
 *
 *  @param support        是否支持右下角小窗悬停播放
 */
- (void)playerScrollIsSupportSmallWindowPlay:(BOOL)support;


- (void)show;
@end
