//
//  ZJStatusCell.h
//  ZJWeibo
//
//  Created by dibadalu on 15/10/22.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//  自定义cell




#import <UIKit/UIKit.h>
@class ZJStatusFrame;

@interface ZJStatusCell : UITableViewCell

/** 微博Frame模型 */
@property(nonatomic,strong) ZJStatusFrame *statusFrame;

/** 工厂方法--类方法 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;


@end
