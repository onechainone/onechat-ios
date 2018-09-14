//
//  EaseMessageCell+Link.m
//  OneChainIOS
//
//  Created by lifei on 2018/1/22.
//  Copyright © 2018年 帶頭二哥 QQ:648959. All rights reserved.
//

#import "EaseMessageCell+Link.h"
#import <objc/runtime.h>
#import <CoreText/CoreText.h>
static char matchsKey;

@interface EaseMessageCell()

@property (nonatomic, strong) NSMutableArray *matchs;

@end

@implementation EaseMessageCell (Link)

+ (void)load {
    Method oldSetMethod = class_getInstanceMethod([EaseMessageCell class], @selector(setModel:));
    Method newSetMethod = class_getInstanceMethod([EaseMessageCell class], @selector(linkSetModel:));
    method_exchangeImplementations(oldSetMethod, newSetMethod);
    
    Method oldInitMethod = class_getInstanceMethod([EaseMessageCell class], @selector(initWithStyle:reuseIdentifier:model:));
    Method newInitMethod = class_getInstanceMethod([EaseMessageCell class], @selector(linkInitWithStyle:reuseIdentifier:model:));
    method_exchangeImplementations(oldInitMethod, newInitMethod);
    
    Method oldTapMethod = class_getInstanceMethod([EaseMessageCell class], @selector(bubbleViewTapAction:));
    Method newTapMethod = class_getInstanceMethod([EaseMessageCell class], @selector(linkBubbleViewTapAction:));
    method_exchangeImplementations(oldTapMethod, newTapMethod);
}

#pragma mark - getter

- (NSMutableArray *)matchs {
    return objc_getAssociatedObject(self, &matchsKey);
}

#pragma mark - setter

- (void)setMatchs:(NSMutableArray *)matchs {
    objc_setAssociatedObject(self, &matchsKey, matchs, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (instancetype)linkInitWithStyle:(UITableViewCellStyle)style
                  reuseIdentifier:(NSString *)reuseIdentifier
                            model:(id<IMessageModel>)model
{
    EaseMessageCell *cell = [self linkInitWithStyle:style reuseIdentifier:reuseIdentifier model:model];
    if (cell && model.bodyType == ONEMessageBodyTypeText) {
        cell.messageTextColor = [UIColor blackColor];
        cell.matchs = [NSMutableArray array];
    }
    return cell;
}

- (void)linkSetModel:(id<IMessageModel>)model {
    [self linkSetModel:model];
    if (model.bodyType == ONEMessageBodyTypeText) {
        self.matchs = [NSMutableArray arrayWithArray:[self regularExpression]];
        if (self.matchs.count > 0) {
            [self highlightLinksWithMatchs];
        }
    }
}

- (NSArray *)regularExpression
{
    NSString *regular = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|((https?|ftp|file)://[-A-Za-z0-9+&@#/%?=~_|!:,.;]+[-A-Za-z0-9+&@#/%=~_|])|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|([a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    NSString *linkString = self.bubbleView.textLabel.attributedText.string;
    if (linkString.length == 0) {
        return nil;
    }
    NSRegularExpression *exp = [NSRegularExpression regularExpressionWithPattern:regular options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *match = [exp matchesInString:linkString options:NSMatchingReportProgress range:NSMakeRange(0, linkString.length)];
    
    NSMutableArray *results = [NSMutableArray array];
    
    for (NSTextCheckingResult *result in match) {
        NSString *str = [self.model.text substringWithRange:result.range];
        NSURL *url = [NSURL URLWithString:str];
        //为不包含http/https的url添加前缀http
        if ([str rangeOfString:@"http"].location == NSNotFound &&
            [str rangeOfString:@"https"].location == NSNotFound) {
            url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@",str]];
        }
        [results addObject:[NSTextCheckingResult linkCheckingResultWithRange:result.range URL:url]];
    }
    return results;
}

- (void)highlightLinksWithMatchs {
    
    NSMutableAttributedString* attributedString = [self.bubbleView.textLabel.attributedText mutableCopy];
    
    for (NSTextCheckingResult *match in self.matchs) {
        
        if ([match resultType] == NSTextCheckingTypeLink) {
            NSRange matchRange = [match range];
            
            UIColor *color = nil;
            if (self.model.isSender) {
                
                color = [UIColor whiteColor];
            } else {
                
                color = [UIColor colorWithRed:(30)/255.0 green:(167)/255.0 blue:(252)/255.0 alpha:(1)];
            }
            [attributedString addAttribute:NSForegroundColorAttributeName value:color range:matchRange];
            [attributedString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:matchRange];
        }
    }
    self.bubbleView.textLabel.attributedText = attributedString;
}

- (BOOL)isIndex:(CFIndex)index inRange:(NSRange)range
{
    return index >= range.location && index < range.location+range.length;
}

#pragma mark - action

- (void)linkBubbleViewTapAction:(UITapGestureRecognizer *)tapRecognizer {
    [self linkBubbleViewTapAction:tapRecognizer];
    if (tapRecognizer.state == UIGestureRecognizerStateEnded &&
        self.model.bodyType == ONEMessageBodyTypeText &&
        self.matchs.count > 0) {
        
        CGPoint point = [tapRecognizer locationInView:self.bubbleView.textLabel];
        CFIndex charIndex = [self characterIndexAtPoint:point];
        for (NSTextCheckingResult *match in self.matchs) {
            if ([match resultType] == NSTextCheckingTypeLink) {
                NSRange matchRange = [match range];
                if ([self isIndex:charIndex inRange:matchRange]) {
                    [[UIApplication sharedApplication] openURL:match.URL];
                    break;
                }
            }
        }
    }
}


- (CFIndex)characterIndexAtPoint:(CGPoint)point
{
    NSMutableAttributedString* optimizedAttributedText = [self.bubbleView.textLabel.attributedText mutableCopy];
    
    [self.bubbleView.textLabel.attributedText enumerateAttributesInRange:NSMakeRange(0, [self.bubbleView.textLabel.attributedText length]) options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
        
        if (!attrs[(NSString*)kCTFontAttributeName])
        {
            [optimizedAttributedText addAttribute:(NSString*)kCTFontAttributeName value:self.bubbleView.textLabel.font range:NSMakeRange(0, [self.bubbleView.textLabel.attributedText length])];
        }
    }];
    
    if (!CGRectContainsPoint(self.bubbleView.textLabel.bounds, point)) {
        return NSNotFound;
    }
    
    CGRect textRect = self.bubbleView.textLabel.frame;
    
    if (!CGRectContainsPoint(textRect, point)) {
        return NSNotFound;
    }
    
    point = CGPointMake(point.x - textRect.origin.x, point.y - textRect.origin.y);
    
    point = CGPointMake(point.x, textRect.size.height - point.y);
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)optimizedAttributedText);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, textRect);
    
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, [self.bubbleView.textLabel.attributedText length]), path, NULL);
    
    if (frame == NULL) {
        CFRelease(path);
        return NSNotFound;
    }
    
    CFArrayRef lines = CTFrameGetLines(frame);
    
    NSInteger numberOfLines = self.bubbleView.textLabel.numberOfLines > 0 ? MIN(self.bubbleView.textLabel.numberOfLines, CFArrayGetCount(lines)) : CFArrayGetCount(lines);
    
    
    if (numberOfLines == 0) {
        CFRelease(frame);
        CFRelease(path);
        return NSNotFound;
    }
    NSUInteger idx = NSNotFound;
    CGPoint lineOrigins[numberOfLines];
    CTFrameGetLineOrigins(frame, CFRangeMake(0, numberOfLines), lineOrigins);
    
    for (CFIndex lineIndex = 0; lineIndex < numberOfLines; lineIndex++) {
        
        CGPoint lineOrigin = lineOrigins[lineIndex];
        CTLineRef line = CFArrayGetValueAtIndex(lines, lineIndex);
        
        // Get bounding information of line
        CGFloat ascent, descent, leading, width;
        width = CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
        CGFloat yMin = floor(lineOrigin.y - descent);
        CGFloat yMax = ceil(lineOrigin.y + ascent);
        // Check if we've already passed the line
        if (point.y > yMax) {
            break;
        }
        // Check if the point is within this line vertically
        if (point.y >= yMin) {
            
            // Check if the point is within this line horizontally
            if (point.x >= lineOrigin.x && point.x <= lineOrigin.x + width) {
                
                // Convert CT coordinates to line-relative coordinates
                CGPoint relativePoint = CGPointMake(point.x - lineOrigin.x, point.y - lineOrigin.y);
                idx = CTLineGetStringIndexForPosition(line, relativePoint);
                
                break;
            }
        }
    }
    CFRelease(frame);
    CFRelease(path);
    
    return idx;
}
@end
