//
//  ZJInfoCountTool.h
//  ZJWeibo
//
//  Created by dibadalu on 15/11/10.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZJInfoCount;

@interface ZJInfoCountTool : NSObject

+ (void)saveInfoCount:(ZJInfoCount *)infoCount;
+ (ZJInfoCount *)infoCount;

@end


