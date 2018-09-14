//
//  VideoUploadProgressView.m
//  CancerDo
//
//  Created by hugaowei on 16/11/8.
//  Copyright © 2016年 lianji. All rights reserved.
//

#import "VideoUploadProgressView.h"

@implementation VideoUploadProgressView
@synthesize progressValue;

- (void)drawRect:(CGRect)rect
{
    CGPoint point = CGPointMake(self.frame.size.width*0.5, self.frame.size.width*0.5);
    CGFloat radius = self.frame.size.width*0.5 - 2;
    UIBezierPath* path = [UIBezierPath bezierPathWithArcCenter:point
                                                        radius:radius
                                                    startAngle:3*M_PI_2
                                                      endAngle:((progressValue*M_PI*2)+(3*M_PI_2))
                                                     clockwise:YES];
    [SystemDefaultColor set];
    [path setLineCapStyle:kCGLineCapRound];
    path.lineWidth = 2;
    
    [path stroke];
}
@end
