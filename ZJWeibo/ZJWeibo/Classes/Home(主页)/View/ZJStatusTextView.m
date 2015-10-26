//
//  ZJStatusTextView.m
//  ZJWeibo
//
//  Created by 陈泽嘉 on 15/10/26.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#define ZJSpecialTextTag 999

#import "ZJStatusTextView.h"
#import "ZJSpecialText.h"

@implementation ZJStatusTextView
#pragma mark - 系统方法
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.editable = NO;//禁止编辑
        self.scrollEnabled = NO;//禁止滚动
        self.textContainerInset = UIEdgeInsetsMake(0, -5, 0, -5);//设置文本距离父容器的边距
    }
    return self;
}

#pragma mark - 其他方法
/**
 *  计算特殊文字的矩形框，并将其存储在模型ZJSpecialText中
 */
- (void)setupSpecialTextRects
{
    //通过key"specials"获得HMStatus模型所存储的特殊文字
    NSArray *specials = [self.attributedText attribute:@"specials" atIndex:0 effectiveRange:NULL];
    
    //遍历specials数组里的ZJSpecialText模型
    for (ZJSpecialText *special in specials) {
        //获得选中范围(特殊文字)的矩形框
        //     self.selectedRange 影响 self.selectedTextRange(readonly)
        self.selectedRange = special.range;
        NSArray *selectionRects = [self selectionRectsForRange:self.selectedTextRange];
        self.selectedRange = NSMakeRange(0, 0);//清空选中范围
        
        NSMutableArray *rects = [NSMutableArray array];
        for (UITextSelectionRect *selectionRect in selectionRects) {
            CGRect rect = selectionRect.rect;
            if (rect.size.width == 0 || rect.size.height == 0) continue;
            
            //添加rect
            [rects addObject:[NSValue valueWithCGRect:rect]];
            
        }
        special.rects = rects;
        
    }
}

/**
 *  根据被触摸点找出被触摸的特殊字符串
 *
 *  @param point <#point description#>
 *
 *  @return <#return value description#>
 */
- (ZJSpecialText *)touchingSpecialTextWith:(CGPoint)point
{
    NSArray *specials = [self.attributedText attribute:@"specials" atIndex:0 effectiveRange:NULL];
    
    for (ZJSpecialText *special in specials) {
        for (NSValue *rectValue in special.rects) {
            if (CGRectContainsPoint(rectValue.CGRectValue, point)) {//点击了特殊字符串
                return special;
            }
        }
    }
    return nil;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //触摸对象
    UITouch *touch = [touches anyObject];
    
    //触摸点
    CGPoint point = [touch locationInView:self];
    
    //初始化矩形框
    [self setupSpecialTextRects];
    
    //根据被触摸点找出被触摸的特殊字符串
    ZJSpecialText *special = [self touchingSpecialTextWith:point];
    
    // 在被触摸的特殊字符串后面显示一段高亮的背景
    for (NSValue *rectValue in special.rects ) {
        UIView *cover = [[UIView alloc] init];
        cover.backgroundColor = [UIColor greenColor];
        cover.frame = rectValue.CGRectValue;
        cover.tag = ZJSpecialTextTag;
        cover.layer.cornerRadius = 5;
        [self insertSubview:cover atIndex:0];
    }
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self touchesCancelled:touches withEvent:event];
    });
    //    HMLog(@"touchesEnded");
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    //去掉被触摸的特殊字符串后面的一段高亮的背景
    for (UIView *chird in self.subviews) {
        if (chird.tag == ZJSpecialTextTag)  [chird removeFromSuperview];
    }
    //    HMLog(@"touchesCancelled");
}




@end
