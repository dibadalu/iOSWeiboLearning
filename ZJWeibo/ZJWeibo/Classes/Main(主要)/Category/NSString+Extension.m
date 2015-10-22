//
//  NSString+Extension.m
//  HM微博01
//
//  Created by dibadalu on 15/9/14.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

/**
 *  计算文字的size
 * 
 *  @param font 字体大小
 *  @param maxW 文字范围宽度
 *
 *  @return 文字的size
 */
- (CGSize)sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW
{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

- (CGSize)sizeWithFont:(UIFont *)font
{
    return [self sizeWithFont:font maxW:MAXFLOAT];
}

@end
