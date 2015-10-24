//
//  ZJComposePhotosView.h
//  ZJWeibo
//
//  Created by dibadalu on 15/10/24.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJComposePhotosView : UIView

- (void)addPhoto:(UIImage *)image;

@property(nonatomic,strong,readonly) NSMutableArray *photos;
//默认会自动生成getter的声明和实现，_开头的成员变量
//如果手动实现了getter，那么就不会再生成getter的“实现”，_开头的成员变量

@end
