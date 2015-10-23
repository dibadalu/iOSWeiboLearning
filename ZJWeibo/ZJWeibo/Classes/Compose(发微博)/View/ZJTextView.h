//
//  ZJTextView.h
//  ZJWeibo
//
//  Created by dibadalu on 15/10/23.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//  自定义textView，实现占位文字功能

#import <UIKit/UIKit.h>

@interface ZJTextView : UITextView

/** 占位文字 */
@property(nonatomic,copy) NSString *placedholder;
/** 占位文字颜色 */
@property(nonatomic,strong) UIColor *placedholderColor;

@end
