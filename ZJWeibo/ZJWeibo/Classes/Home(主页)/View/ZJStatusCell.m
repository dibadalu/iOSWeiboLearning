//
//  ZJStatusCell.m
//  ZJWeibo
//
//  Created by dibadalu on 15/10/22.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import "ZJStatusCell.h"
#import "ZJStatusFrame.h"
#import "ZJStatusToolBar.h"
#import "ZJStatusDetailView.h"

@interface ZJStatusCell ()


@property(nonatomic,weak) ZJStatusDetailView *detailView;
/** 工具条 */
@property(nonatomic,weak) ZJStatusToolBar *toolBar;

@end

@implementation ZJStatusCell

#pragma mark - 创建方法
/**
 *  创建cell
 *
 *  @param tableView 外界的tableView
 *
 *  @return 创建好的cell
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"status";
    ZJStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[ZJStatusCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    return cell;
}

#pragma mark - 系统方法
/**
 *  只调用一次，进行cell子控件的初始化
 *  1.添加有可能显示的所有cell子控件到contentView中
 *  2.设置子控件的一次性设置(label要显示必须有font)
 */
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;//选中cell不要变色
       
        //1.微博整体
        ZJStatusDetailView *detailView = [[ZJStatusDetailView alloc] init];
        [self.contentView addSubview:detailView];
        self.detailView = detailView;
       
        //2.工具条
        ZJStatusToolBar *toolBar = [ZJStatusToolBar tooBar];
        [self.contentView addSubview:toolBar];
        self.toolBar = toolBar;
    }
    
    return self;
    
}

#pragma mark - 传值
/**
 *  设置frame和数据
 *  cell根据StatusFrame模型给子控件设置frame，根据Status模型给子控件设置数据
 *  @param statusFrame 微博Frame模型 从控制器传进来的
 */
- (void)setStatusFrame:(ZJStatusFrame *)statusFrame
{
    _statusFrame = statusFrame;
    
    //1.微博整体
    self.detailView.detailFrame = statusFrame.detailFrame;
    
    //2.工具条
    self.toolBar.frame = statusFrame.toolBarF;
    self.toolBar.status =statusFrame.status;
    
    
}

@end
