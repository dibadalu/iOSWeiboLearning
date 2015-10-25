//
//  ZJEmotion.h
//  ZJWeibo
//
//  Created by dibadalu on 15/10/25.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//  表情内容模型

#import <Foundation/Foundation.h>

@interface ZJEmotion : NSObject

/** 表情的文字描述 */
@property(nonatomic,copy) NSString *chs;
/** 表情的png图片名 */
@property(nonatomic,copy) NSString *png;
/** emoji表情的16进制编码 */
@property(nonatomic,copy) NSString *code;

@end
