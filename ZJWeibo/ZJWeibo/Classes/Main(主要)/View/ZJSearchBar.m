//
//  ZJSearchBar.m
//  ZJWeibo
//
//  Created by dibadalu on 15/11/3.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import "ZJSearchBar.h"


@implementation ZJSearchBar
#pragma mark - class method
+ (instancetype)searchBar
{
    return [[self alloc] init];
}

#pragma mark - system method
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //设置背景
        self.background = [UIImage resizedImageName:@"searchbar_textfield_background"];
        
        //设置内容--垂直居中（在iOS7.0可以不用设置）
//        self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        
        //设置左边显示 -- 一个放大镜
        UIImageView *leftView = [[UIImageView alloc] init];
        leftView.image = [UIImage imageNamed:@"searchbar_textfield_search_icon"];
        leftView.width = leftView.image.size.width + 10;
        leftView.height = leftView.image.size.height;
        //设置leftView的内容居中
        leftView.contentMode = UIViewContentModeCenter;
        self.leftView = leftView;
        
        //设置左边的view永远显示
        self.leftViewMode = UITextFieldViewModeAlways;
        
        //设置右边永远显示清除按钮
        self.clearButtonMode = UITextFieldViewModeAlways;
        
    }
    return self;
}



@end
