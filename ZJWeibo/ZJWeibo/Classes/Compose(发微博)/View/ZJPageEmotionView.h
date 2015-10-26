//
//  ZJPageEmotionView.h
//  ZJWeibo
//
//  Created by dibadalu on 15/10/26.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

// 一页中最多3行
#define ZJEmotionMaxRows 3
// 一行中最多7列
#define ZJEmotionMaxCols 7
// 每一页的表情个数
#define ZJEmotionsPageCount ((ZJEmotionMaxRows * ZJEmotionMaxCols) - 1)

#import <UIKit/UIKit.h>

@interface ZJPageEmotionView : UIView

/** scrollView每一页的表情内容---存放ZJEmotion模型 */
@property(nonatomic,strong) NSArray *emotions;

@end
