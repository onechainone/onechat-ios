//
//  NoteImageModel.h
//  CancerDo
//
//  Created by hugaowei on 16/7/21.
//  Copyright © 2016年 lianji. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NOTEIMAGE_GROUP_ID  @"group_id"
#define NOTEIMAGE_IMAGE_ID  @"image_id"
#define NOTEIMAGE_IMAGE_URL @"image_url"
#define NOTEIMAGE_PARENT_ID @"parent_id"

@interface NoteImageModel : NSObject

@property (nonatomic,retain) UIImage   *image;
@property (nonatomic,assign) NSInteger index;

@property (nonatomic,copy  ) NSString *imagePath;
@property (nonatomic,copy  ) NSString *groupId;
@property (nonatomic,copy  ) NSString *imageId;
@property (nonatomic,copy  ) NSString *parentId;

- (void)reloadImageModelWithDictionary:(NSDictionary*)dict;

@end
