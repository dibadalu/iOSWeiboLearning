//
//  ZJStatusPhotoView.m
//  ZJWeibo
//
//  Created by dibadalu on 15/10/23.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import "ZJStatusPhotoView.h"
#import "ZJPhoto.h"
#import <UIImageView+WebCache.h>

@interface ZJStatusPhotoView ()

/** gif图片控件 */
@property(nonatomic,weak) UIImageView *gifView;

@end

@implementation ZJStatusPhotoView
#pragma mark - 懒加载
- (UIImageView *)gifView
{
    if (!_gifView) {
        UIImage *gifImage = [UIImage imageNamed:@"timeline_image_gif"];
        UIImageView *gifView = [[UIImageView alloc] initWithImage:gifImage];
        [self addSubview:gifView];
        self.gifView = gifView;
    }
    return _gifView;
}

#pragma mark - 系统方法
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //设置内容模式  Scale不会变形
        self.contentMode = UIViewContentModeScaleAspectFill;
        //超出边框的内容都剪掉
        self.clipsToBounds = YES;
    }
    
    return self;
}
/**
 *  设置gif图片控件的位置
 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.gifView.x = self.width - self.gifView.width;
    self.gifView.y = self.height - self.gifView.height;
}

#pragma mark - 传值
- (void)setPhoto:(ZJPhoto *)photo
{
    _photo = photo;
    
    //取出配图模型
    [self sd_setImageWithURL:[NSURL URLWithString:photo.thumbnail_pic] placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]];
    
    //判断是否是gif、GIF结尾以显示gif图片控件
    self.gifView.hidden = ![photo.thumbnail_pic.lowercaseString hasSuffix:@"gif"];
    
}



@end

/**
 UIViewContentModeScaleToFill : 图片拉伸至填充整个UIImageView（图片可能会变形）
 
 UIViewContentModeScaleAspectFit : 图片拉伸至完全显示在UIImageView里面为止（图片不会变形）
 
 UIViewContentModeScaleAspectFill :
 图片拉伸至 图片的宽度等于UIImageView的宽度 或者 图片的高度等于UIImageView的高度 为止
 
 UIViewContentModeRedraw : 调用了setNeedsDisplay方法时，就会将图片重新渲染
 
 UIViewContentModeCenter : 居中显示
 UIViewContentModeTop,
 UIViewContentModeBottom,
 UIViewContentModeLeft,
 UIViewContentModeRight,
 UIViewContentModeTopLeft,
 UIViewContentModeTopRight,
 UIViewContentModeBottomLeft,
 UIViewContentModeBottomRight,
 
 经验规律：
 1.凡是带有Scale单词的，图片都会拉伸
 2.凡是带有Aspect单词的，图片都会保持原来的宽高比，图片不会变形
 */
