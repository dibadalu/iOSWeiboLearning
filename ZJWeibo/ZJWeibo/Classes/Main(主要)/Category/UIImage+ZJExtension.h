//
//  UIImage+ZJExtension.h
//  ZJWeibo
//
//  Created by dibadalu on 15/11/3.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//  处理图片

#import <UIKit/UIKit.h>

@interface UIImage (ZJExtension)

/** 根据图片名返回一张能够自由拉伸的图片 */
+ (UIImage *)resizedImageName:(NSString *)name;



@end
