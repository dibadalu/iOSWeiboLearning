//
//  NSString+Extension.h
//  ZJWeibo
//
//  Created by dibadalu on 15/9/14.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//  计算文字的size

#import <Foundation/Foundation.h>

@interface NSString (Extension)
- (CGSize)sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW;

- (CGSize)sizeWithFont:(UIFont *)font;

- (NSString *)urlencode;
@end
