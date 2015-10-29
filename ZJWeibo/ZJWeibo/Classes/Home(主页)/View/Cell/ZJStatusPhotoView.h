//
//  ZJStatusPhotoView.h
//  ZJWeibo
//
//  Created by dibadalu on 15/10/23.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//  单独一张配图,用来设置显示gif标识

#import <UIKit/UIKit.h>
@class ZJPhoto;

@interface ZJStatusPhotoView : UIImageView

/** 配图模型 */
@property(nonatomic,strong) ZJPhoto *photo;

@end
