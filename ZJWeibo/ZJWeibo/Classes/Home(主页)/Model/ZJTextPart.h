//
//  ZJTextPart.h
//  ZJWeibo
//
//  Created by 陈泽嘉 on 15/10/26.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//  正文的某一段文字

#import <Foundation/Foundation.h>

@interface ZJTextPart : NSObject

/** 这段文字的内容 */
@property(nonatomic,copy) NSString *text;
/** 这段文字的范围 */
@property(nonatomic,assign) NSRange range;
/** 这段文字是否为特殊文字 */
@property(nonatomic,assign,getter=isSepcail) BOOL special;
/** 这段文字是否为表情 */
@property(nonatomic,assign,getter=isEmotion) BOOL emotion;

@end
