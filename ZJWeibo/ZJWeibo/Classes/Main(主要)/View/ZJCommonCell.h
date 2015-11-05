//
//  ZJCommonCell.h
//  ZJWeibo
//
//  Created by dibadalu on 15/11/5.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZJCommonItem;

@interface ZJCommonCell : UITableViewCell
/** ZJCommonItem模型数据 */
@property(nonatomic,strong) ZJCommonItem *item;

/** 类方法：创建cell */
+ (instancetype)cellWithTableView:(UITableView *)tableview;
- (void)setIndexPath:(NSIndexPath *)indexPath rowsInSection:(NSUInteger)rows;

@end
