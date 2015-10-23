//
//  ZJStatusPhotosView.h
//  ZJWeibo
//
//  Created by dibadalu on 15/10/23.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//  配图相册，存放1-9张配图

#import <UIKit/UIKit.h>

@interface ZJStatusPhotosView : UIView

/** 配图模型数组，一个模型代表一张配图 */
@property(nonatomic,strong) NSArray *photos;
/** 计算图片的位置和尺寸 */
+ (CGSize)sizeWithPhotosCount:(NSUInteger)count;

@end
