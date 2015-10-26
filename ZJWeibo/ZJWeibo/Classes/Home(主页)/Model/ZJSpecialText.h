//
//  ZJSpecialText.h
//  ZJWeibo
//
//  Created by 陈泽嘉 on 15/10/26.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//  正文中的某一段特殊文字

#import <Foundation/Foundation.h>

@interface ZJSpecialText : NSObject

/** 这段特殊文字的内容 */
@property(nonatomic,copy) NSString *text;
/** 这段特殊文字的范围 */
@property(nonatomic,assign) NSRange range;
/** 这段特殊文字的矩形框(要求数组里面存放CGRect) */
@property(nonatomic,strong) NSArray *rects;

@end
