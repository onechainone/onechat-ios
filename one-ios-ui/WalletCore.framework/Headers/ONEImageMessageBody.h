//
//  ONEImageMessageBody.h
//  OneChainIOS
//
//  Created by 李飞 on 2018/8/27.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "ONEMessageBody.h"

@interface ONEImageMessageBody : ONEMessageBody

@property (nonatomic, copy) NSString *localPath;

@property (nonatomic, copy) NSString *remotePath;

@property (nonatomic, assign) CGFloat compressionRato;

@property (nonatomic) CGSize imageSize;

@property (nonatomic, copy) NSString *encryptKey;

@property (nonatomic, readonly) BOOL isDownloaded;

- (instancetype)initWithData:(NSData *)imageData;

- (instancetype)initWithPath:(NSString *)path;

- (instancetype)initWithLocalPath:(NSString *)localPath;
@end
