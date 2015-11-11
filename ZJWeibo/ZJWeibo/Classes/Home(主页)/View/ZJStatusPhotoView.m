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
#pragma mark - lazy method
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

#pragma mark - system method
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //注意：开启交互
        self.userInteractionEnabled = YES;
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

#pragma mark - setter method 
- (void)setPhoto:(ZJPhoto *)photo
{
    _photo = photo;
    
    //取出配图模型
    [self sd_setImageWithURL:[NSURL URLWithString:photo.thumbnail_pic] placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]];
    
    //判断是否是gif、GIF结尾以显示gif图片控件
    self.gifView.hidden = ![photo.thumbnail_pic.lowercaseString hasSuffix:@"gif"];
    
}



@end


