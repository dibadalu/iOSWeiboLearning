//
//  ZJStatusPhotosView.m
//  ZJWeibo
//
//  Created by dibadalu on 15/10/23.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

/** 配图相册的最大列数 特殊情况是4张配图 */
#define ZJStatusPhotoMaxCol(count) ((count==4)?2:3)
/** 单张配图的宽高 */
#define ZJStatusPhotoWH 80
/** 配图间的间隙 */
#define ZJStatusPhotoMargin 5

#import "ZJStatusPhotosView.h"
#import "ZJPhoto.h"
#import "ZJStatusPhotoView.h"
#import <UIImageView+WebCache.h>

@implementation ZJStatusPhotosView
#pragma mark - 系统方法
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor redColor];
    }
    return self;
}


#pragma mark - 传值
/**
 *  设置配图相册里的配图
 *
 *  @param photos 配图模型数组
 */
- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    
    //配图的数量
    NSUInteger photosCount = photos.count;
    
    //注意：创建足够多的imageView（图片控件） 要考虑到cell的循环利用
    while (self.subviews.count < photosCount) {
        UIImageView *photoView = [[UIImageView alloc] init];
        [self addSubview:photoView];
    }
    
    //遍历所有的iamgeView（图片控件），设置图片
    for (int i = 0; i< self.subviews.count; i++) {
        UIImageView *photoView = self.subviews[i];
        
        //注意：判断是否显示或隐藏几个图片控件
        if (i < photosCount) {//显示图片控件
            photoView.hidden = NO;
            
            //设置配图
            //取出配图模型
            ZJPhoto *photo = photos[i] ;
            [photoView sd_setImageWithURL:[NSURL URLWithString:photo.thumbnail_pic] placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]];

        }else{//隐藏没用到的imageView
            photoView.hidden = YES;
        }
        
    }
    
}
/**
 *  计算图片的位置和尺寸
 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //图片的数量(考虑到有4张配图的特殊情况)
    NSUInteger photosCount = self.photos.count;
    
    //设置图片的位置和尺寸
    int maxCols = ZJStatusPhotoMaxCol(photosCount);
    for (int i = 0; i< self.photos.count; i++) {
        UIImageView *photoView = self.subviews[i];
        
        //列
        int col = i % maxCols;
        photoView.x = col * (ZJStatusPhotoWH + ZJStatusPhotoMargin);
        
        //行
        int row = i / maxCols ;
        photoView.y = row * (ZJStatusPhotoWH + ZJStatusPhotoMargin);

        photoView.width = ZJStatusPhotoWH;
        photoView.height = ZJStatusPhotoWH;
        
        
    }
}
/**
 *  根据图片个数计算整个相册的尺寸
 */
+ (CGSize)sizeWithPhotosCount:(NSUInteger)count
{

    //最大列数(一行最多有多少列)
    /* 思路
     count   maxCols
     4        2
     1        3
     5        3
     7        3
     */
    int maxCols = ZJStatusPhotoMaxCol(count);
    // 列数
    NSUInteger cols = (count >= maxCols) ? maxCols : count;
    CGFloat photosW = cols * ZJStatusPhotoWH + (cols - 1) * ZJStatusPhotoMargin;
    // 行数
    // 计算rows的通用公式： rows = ( count + maxCols - 1 ) / maxCols;
    NSUInteger rows = ( count + maxCols - 1 ) / maxCols;
    CGFloat photosH = rows * ZJStatusPhotoWH + (rows - 1) * ZJStatusPhotoMargin;
    
    return CGSizeMake(photosW, photosH);

}

@end


/*
 //行数思路
 int rows = 0;
 if (count % 3 == 0) {//count = 3\6\9
 rows = count / 3;
 }else{ //count = 1\2 4\5 7\8
 rows = count / 3 + 1;
 }
 
 int rows = count / 3;
 if (count % 3 != 0) {
 rows += 1;
 }
 */