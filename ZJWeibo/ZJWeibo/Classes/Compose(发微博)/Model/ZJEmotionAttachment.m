//
//  ZJEmotionAttachment.m
//  ZJWeibo
//
//  Created by dibadalu on 15/10/26.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import "ZJEmotionAttachment.h"
#import "ZJEmotion.h"

@implementation ZJEmotionAttachment

- (void)setEmotion:(ZJEmotion *)emotion
{
    _emotion = emotion;
    
    //设置图片
    self.image = [UIImage imageNamed:emotion.png];
}


@end
