//
//  ZJEmotionTextView.m
//  ZJWeibo
//
//  Created by dibadalu on 15/10/26.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
// 

#import "ZJEmotionTextView.h"
#import "ZJEmotion.h"
#import "ZJEmotionAttachment.h"

@implementation ZJEmotionTextView

/**
 *  插入文字和图片
 *
 *  @param emotion 传进来的被点击按钮携带的ZJEmotion模型数据
 */
- (void)insertEmotion:(ZJEmotion *)emotion
{
    
    if (emotion.code) {//emoji
        //insert 将文字插入到光标所在的位置
        [self insertText:emotion.code.emoji];
        
    }else if (emotion.png){
        //加载图片
        ZJEmotionAttachment *attch = [[ZJEmotionAttachment alloc] init];
        
        //传递模型
        attch.emotion = emotion;
        
        //设置图片的尺寸
        CGFloat attchWH = self.font.lineHeight;//行高
        attch.bounds = CGRectMake(0, -4, attchWH, attchWH);
        
        //根据NSTextAttachment附件创建一个属性文字
        NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:attch];
        
        //插入属性文字到光标位置
        [self insertAttributedText:imageStr settingBlock:^(NSMutableAttributedString *attributedText) {//以下代码在block（block是一个函数）内执行
            // 添加字体属性
            [attributedText addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, attributedText.length)];
        }];
    }
    
}
/**
 * 包含文字和图片的属性文字
 *
 *  @return 完整的属性文字
 */
- (NSString *)fullText
{
    //    HMLog(@"%@",self.attributedText);
    NSMutableString *fullText = [NSMutableString string];
    
    //遍历attributedText里的所有主键（属性文字：普通文字、图片和emoji）
    [self.attributedText enumerateAttributesInRange:NSMakeRange(0, self.attributedText.length) options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
        
        //如果是图片表情
        ZJEmotionAttachment *attach = attrs[@"NSAttachment"];
        if (attach) {//图片
            [fullText appendString:attach.emotion.chs];
            
        }else{//emoji和普通文字
            //获得这个范围内的文字
            NSAttributedString *str = [self.attributedText attributedSubstringFromRange:range];
            [fullText appendString:str.string];
        }
    }];
    
    return fullText;
}

@end


