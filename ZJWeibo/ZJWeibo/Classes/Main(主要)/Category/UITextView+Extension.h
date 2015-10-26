//
//  UITextView+Extension.h
//  HM微博01
//
//  Created by dibadalu on 15/9/23.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
// UITextView 插入普通文字和图片

#import <UIKit/UIKit.h>

@interface UITextView (Extension)

- (void)insertAttributedText:(NSAttributedString *)text;
- (void)insertAttributedText:(NSAttributedString *)text settingBlock:(void (^)(NSMutableAttributedString *attributedText))settingBlock;

@end
