//
//  WCInputView.m
//  WeChatDemo
//
//  Created by 陈泽嘉 on 15/12/8.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import "ZJInputView.h"

@implementation ZJInputView

+ (instancetype)inputView{
    
    return [[[NSBundle mainBundle] loadNibNamed:@"ZJInputView" owner:nil options:nil] lastObject];
}



@end
