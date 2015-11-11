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
#import "ZJStatusPhotoView.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

@implementation ZJStatusPhotosView
#pragma mark - system method
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor redColor];
    }
    return self;
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
        ZJStatusPhotoView *photoView = self.subviews[i];
        
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

#pragma mark - setter
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
        ZJStatusPhotoView *photoView = [[ZJStatusPhotoView alloc] init];
        [self addSubview:photoView];
    }
    
    //遍历所有的iamgeView（图片控件），设置图片
    for (int i = 0; i< self.subviews.count; i++) {
        ZJStatusPhotoView *photoView = self.subviews[i];
        
        //注意：判断是否显示或隐藏几个图片控件
        if (i < photosCount) {//显示图片控件
            photoView.hidden = NO;
            //设置配图
            photoView.photo = photos[i];
        }else{//隐藏没用到的imageView
            photoView.hidden = YES;
        }
        
        //给图片控件添加手势监听器（一个手势监听器只能监听对应的一个图片控件）
        photoView.tag = i;
        UITapGestureRecognizer *recgnizer = [[UITapGestureRecognizer alloc] init];
        [recgnizer addTarget:self action:@selector(tapPhoto:)];
        [photoView addGestureRecognizer:recgnizer];
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

#pragma mark - action method
/**
 *  监听图片的点击
 */
- (void)tapPhoto:(UITapGestureRecognizer *)recgnizer
{
    
    //1.创建图片浏览器
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    
    //2.设置图片浏览器显示的所有图片
    NSMutableArray *photos = [NSMutableArray array];
    int count = self.photos.count;
    for (int i = 0; i< count; i++) {
        ZJPhoto *pic = self.photos[i];
        
        MJPhoto *photo = [[MJPhoto alloc] init];
        //设置图片的路径
        photo.url = [NSURL URLWithString:pic.bmiddle_pic];
        //设置来源于哪一个图片控件
        photo.srcImageView = self.subviews[i];
        [photos addObject:photo];
    }
    browser.photos = photos;
    
    //3.设置默认显示的图片索引
    browser.currentPhotoIndex = recgnizer.view.tag;
    
    //4.显示浏览器
    [browser show];
}



@end

