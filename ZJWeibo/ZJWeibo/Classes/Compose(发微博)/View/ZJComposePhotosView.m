//
//  ZJComposePhotosView.m
//  ZJWeibo
//
//  Created by dibadalu on 15/10/24.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import "ZJComposePhotosView.h"

@implementation ZJComposePhotosView
#pragma mark - 系统方法
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _photos = [NSMutableArray array];
    }
    return self;
}
/**
 *  设置相册上图片的frame
 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //设置图片的位置和尺寸
    NSUInteger count = self.subviews.count;
    int maxCol = 4;
    CGFloat imageWH = 70;
    CGFloat imageMargin = 10;
    
    for (int i = 0; i<count; i++) {
        UIImageView *photoView = self.subviews[i];
        //列
        int col = i % maxCol;
        photoView.x = col * (imageWH + imageMargin);
        //行
        int cow = i / maxCol;
        photoView.y = cow * (imageWH + imageMargin);
        
        photoView.width = imageWH;
        photoView.height = imageWH;
        
    }
}

#pragma mark - 传值
- (void)addPhoto:(UIImage *)image
{
    UIImageView *photoView = [[UIImageView alloc] init];
    photoView.image = image;
    [self addSubview:photoView];
    
    
    //存储图片
    [_photos addObject:image];
}

@end
