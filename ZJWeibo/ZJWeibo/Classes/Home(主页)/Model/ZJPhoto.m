//
//  ZJPhoto.m
//  ZJWeibo
//
//  Created by dibadalu on 15/10/22.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import "ZJPhoto.h"


@implementation ZJPhoto

#pragma setter
- (void)setThumbnail_pic:(NSString *)thumbnail_pic
{
    _thumbnail_pic = thumbnail_pic;
    
    self.bmiddle_pic = [thumbnail_pic stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
}



@end
