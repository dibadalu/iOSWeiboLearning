//
//  ZJTextPart.m
//  ZJWeibo
//
//  Created by 陈泽嘉 on 15/10/26.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//  

#import "ZJTextPart.h"


@implementation ZJTextPart

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@---%@",self.text,NSStringFromRange(self.range)];
    
}



@end
