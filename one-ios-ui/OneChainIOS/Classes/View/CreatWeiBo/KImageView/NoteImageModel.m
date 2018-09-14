//
//  NoteImageModel.m
//  CancerDo
//
//  Created by hugaowei on 16/7/21.
//  Copyright © 2016年 lianji. All rights reserved.
//

#import "NoteImageModel.h"

@implementation NoteImageModel

- (void)reloadImageModelWithDictionary:(NSDictionary*)dict{
    self.imagePath  = [self getSafeStringFromDict:dict withKey:NOTEIMAGE_IMAGE_URL];
    self.groupId    = [self getSafeStringFromDict:dict withKey:NOTEIMAGE_GROUP_ID];
    self.imageId    = [self getSafeStringFromDict:dict withKey:NOTEIMAGE_IMAGE_ID];
    self.parentId   = [self getSafeStringFromDict:dict withKey:NOTEIMAGE_PARENT_ID];
}

- (NSString*)getSafeStringFromDict:(NSDictionary*)dict withKey:(NSString*)key{
    NSString *string = @"";
    if ([dict objectForKey:key]) {
        string = [NSString stringWithFormat:@"%@",[dict objectForKey:key]];
    }
    
    if ([string isBlankString]) {
        string = @"";
    }
    
    return string;
}

@end
