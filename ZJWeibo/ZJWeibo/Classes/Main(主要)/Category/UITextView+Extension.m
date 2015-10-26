//
//  UITextView+Extension.m
//  HM微博01
//
//  Created by dibadalu on 15/9/23.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import "UITextView+Extension.h"

@implementation UITextView (Extension)

- (void)insertAttributedText:(NSAttributedString *)text
{
    [self insertAttributedText:text settingBlock:nil];
}

- (void)insertAttributedText:(NSAttributedString *)text settingBlock:(void (^)(NSMutableAttributedString *attributedText))settingBlock
{
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] init];
    //拼接之前的文字（图片和普通文字）
    [attributedText appendAttributedString:self.attributedText];
    
    //拼接其他文字
    NSUInteger loc = self.selectedRange.location;
//    [attributedText insertAttributedString:text atIndex:loc];
    //改进
    [attributedText replaceCharactersInRange:self.selectedRange withAttributedString:text];
    
    //调用从外面传进来的代码（block回调）
    if (settingBlock) {
        settingBlock(attributedText);
    }
    
    //存储起来
    self.attributedText = attributedText;
    
    //移动光标到表情的后面
    self.selectedRange = NSMakeRange(loc + 1, 0);
}



@end
