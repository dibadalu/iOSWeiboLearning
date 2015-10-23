//
//  ZJStatusPhotosView.m
//  ZJWeibo
//
//  Created by dibadalu on 15/10/23.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import "ZJStatusPhotosView.h"
#import "ZJPhoto.h"

@implementation ZJStatusPhotosView
#pragma mark - 系统方法
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor redColor];
    }
    return self;
}


#pragma mark - 传值
- (void)setPhotos:(NSArray *)photos
{
    
}

+ (CGSize)sizeWithPhotosCount:(NSUInteger)count
{
    
    return CGSizeMake(250, 250);
}

@end
