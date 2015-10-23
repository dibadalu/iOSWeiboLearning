//
//  ZJTextView.m
//  ZJWeibo
//
//  Created by dibadalu on 15/10/23.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import "ZJTextView.h"

@implementation ZJTextView

#pragma mark - 系统方法
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //通过通知来监听textView
        //当UITextView的文字发生改变时，UITextView自己会发出一个UITextViewTextDidChangeNotificationt通知
        //添加通知的监听者 object:self  自己监听自己
        [ZJNotificationCenter addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
        
    }
    return self;
}

/**
 *  重绘
 */
- (void)drawRect:(CGRect)rect
{
    //    HMLog(@"drawRect");
    
    //如果有输入文字就直接返回，不画占位文字
    if (self.hasText) return;
    
    /* 画占位文字 */
    
    //文字属性
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = self.font;
    attrs[NSForegroundColorAttributeName] = self.placedholderColor;
    //画占位文字
    //    [self.placedholder drawAtPoint:CGPointMake(5, 8) withAttributes:attrs];
    CGFloat x = 5;
    CGFloat w = rect.size.width - 2 * x;
    CGFloat y = 8;
    CGFloat h = rect.size.height - 2 * y;
    CGRect placeholderRect = CGRectMake(x, y, w, h);
    [self.placedholder drawInRect:placeholderRect withAttributes:attrs];
    
}

#pragma mark - 点击事件
- (void)textDidChange
{
    //    HMLog(@"textDidChange");
    //重绘（重新调用）
    [self setNeedsDisplay];
}


@end
