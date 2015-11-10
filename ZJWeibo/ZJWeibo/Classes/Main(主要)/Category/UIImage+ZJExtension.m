//
//  UIImage+ZJExtension.m
//  ZJWeibo
//
//  Created by dibadalu on 15/11/3.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import "UIImage+ZJExtension.h"

@implementation UIImage (ZJExtension)

/**
 *  根据图片名返回一张能够自由拉伸的图片
 */
+ (UIImage *)resizedImageName:(NSString *)name
{
    UIImage *image = [UIImage imageNamed:name];
    return [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
}



@end
