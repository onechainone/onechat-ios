//
//  ONEVoiceMessageBody.h
//  OneChainIOS
//
//  Created by 李飞 on 2018/8/27.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "ONEMessageBody.h"

@interface ONEVoiceMessageBody : ONEMessageBody

@property (nonatomic, assign) NSInteger duration;

@property (nonatomic, copy) NSString *remotePath;

@property (nonatomic, copy) NSString *localPath;

@property (nonatomic, copy) NSString *encryptKey;

- (instancetype)initWithLocalPath:(NSString *)path;

- (instancetype)initWithRemotePath:(NSString *)remotePath;
@end
