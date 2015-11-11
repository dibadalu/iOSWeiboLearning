//
//  ZJPhoto.h
//  ZJWeibo
//
//  Created by dibadalu on 15/10/22.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZJPhoto : NSObject

/**  thumbnail_pic	string	缩略图片地址，没有时不返回此字段 */
@property(nonatomic,copy) NSString *thumbnail_pic;
@property (nonatomic, copy) NSString *bmiddle_pic;

@end
