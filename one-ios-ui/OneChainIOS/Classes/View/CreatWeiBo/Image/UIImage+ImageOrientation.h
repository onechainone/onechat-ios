
#import <UIKit/UIKit.h>

@interface UIImage (ImageOrientation)

+ (UIImage *)fixOrientation:(UIImage *)aImage;
+ (UIImage *)fixOrientation:(UIImage *)aImage imageOrientation:(UIImageOrientation)imageOrientation1;

@end
