//
//  ZJCommonCell.m
//  ZJWeibo
//
//  Created by dibadalu on 15/11/5.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import "ZJCommonCell.h"
#import "ZJCommonItem.h"
#import "ZJCommonArrowItem.h"
#import "ZJCommonSwitchItem.h"
#import "ZJCommonLabelItem.h"
#import "ZJBadgeView.h"

@interface ZJCommonCell ()

@property(nonatomic,strong) UIView *rightArrow;
@property(nonatomic,strong) UIView *rightSwitch;
@property(nonatomic,strong) UILabel *rightLabel;
@property(nonatomic,strong) ZJBadgeView *badgeView;

@end


@implementation ZJCommonCell
#pragma mark - lazy method 
- (UIView *)rightArrow
{
    if (!_rightArrow) {
        self.rightArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_icon_arrow"]];
    }
    return _rightArrow;
}

- (UIView *)rightSwitch
{
    if (!_rightSwitch) {
        self.rightSwitch = [[UISwitch alloc] init];
    }
    return _rightSwitch;
}

- (UILabel *)rightLabel
{
    if (!_rightLabel) {
        self.rightLabel = [[UILabel alloc] init];
        self.rightLabel.textColor = [UIColor lightGrayColor];
        self.rightLabel.font = [UIFont systemFontOfSize:14];
    }
    return _rightLabel;
}

- (ZJBadgeView *)badgeView
{
    if (!_badgeView) {
        self.badgeView = [[ZJBadgeView alloc] init];
    }
    return _badgeView;
}

#pragma mark - init method
/**
 *  类方法：创建cell
 */
+ (instancetype)cellWithTableView:(UITableView *)tableview
{
    static NSString *ID = @"common";
    ZJCommonCell *cell = [tableview dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[ZJCommonCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    return cell;
}

#pragma mark - system method
/**
 *  初始化设置：只调用一次
 */
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //设置字体
        self.textLabel.font = [UIFont boldSystemFontOfSize:16];
        self.detailTextLabel.font = [UIFont systemFontOfSize:13];
        
        //设置背景view
        self.backgroundView = [[UIImageView alloc] init];
        self.selectedBackgroundView = [[UIImageView alloc] init];
        
        //去除背景色
        self.backgroundColor = [UIColor clearColor];
   
    }
    return self;
}
/**
 *  设置子控件的位置
 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //设置子标题的x
    self.detailTextLabel.x = CGRectGetMaxX(self.textLabel.frame) + ZJCellMargin * 0.5;
}

#pragma mark - setter
/**
 *  设置item数据
 *
 *  @param item 从控制器传进来的ZJCommonItem模型数据
 */
- (void)setItem:(ZJCommonItem *)item
{
    _item = item;
    
    //1.设置cell的基本数据
    if (item.icon) {
        self.imageView.image = [UIImage imageNamed:item.icon];
    }
    self.textLabel.text = item.title;
    self.detailTextLabel.text = item.subTitle;
    
    //2.设置cell的右边样式
    if (item.badgeValue) {//特殊情况：右边样式为数字标识
        //设置数字
        self.badgeView.badgeValue = item.badgeValue;
        self.accessoryView = self.badgeView;
    }else if ([item isKindOfClass:[ZJCommonArrowItem class]]) {
        self.accessoryView = self.rightArrow;
    }else if ([item isKindOfClass:[ZJCommonSwitchItem class]]){
        self.accessoryView = self.rightSwitch;
    }else if ([item isKindOfClass:[ZJCommonLabelItem class]]){
        ZJCommonLabelItem *lableItem = (ZJCommonLabelItem *)item;//取出模型
        //设置右边label上的文字
        self.rightLabel.text = lableItem.text;
        //设置文字尺寸（只有设置尺寸才会显示）
        self.rightLabel.size = [lableItem.text sizeWithFont:self.rightLabel.font];
        self.accessoryView = self.rightLabel;
    }else{
        self.accessoryView = nil;
    }
    
}

/**
 *  设置背景图片
 */
- (void)setIndexPath:(NSIndexPath *)indexPath rowsInSection:(NSUInteger)rows
{
    //1.取出背景view
    UIImageView *bgView =(UIImageView *) self.backgroundView;
    UIImageView *selectedBgView = (UIImageView *) self.selectedBackgroundView;
    
    //2.设置背景图片
    if (rows == 1) {//组只有一行数据
        bgView.image = [UIImage resizedImageName:@"common_card_background"];
        selectedBgView.image = [UIImage resizedImageName:@"common_card_background_highlighted"];
    }else if (indexPath.row == 0){//组的第一行
        bgView.image = [UIImage resizedImageName:@"common_card_top_background"];
        selectedBgView.image = [UIImage resizedImageName:@"common_card_top_background_highlighted"];
    }else if (indexPath.row == rows - 1){//组的未行
        bgView.image = [UIImage resizedImageName:@"common_card_bottom_background"];
        selectedBgView.image = [UIImage resizedImageName:@"common_card_bottom_background_highlighted"];
    }else{//中间
        bgView.image = [UIImage resizedImageName:@"common_card_middle_background"];
        selectedBgView.image = [UIImage resizedImageName:@"common_card_middle_background"];
    }
    
    
}

//- (void)setFrame:(CGRect)frame
//{
////    frame.origin.y -= (35 - ZJCellSectionMargin);
//    [super setFrame:frame];
//}

/*  
 //    ZJLog(@"%f",self.y);
 各个cell的y值：第一个cell的y值是35
 2015-11-05 14:55:14.806 ZJWeibo[1649:34004] 35.000000
 2015-11-05 14:55:14.806 ZJWeibo[1649:34004] 79.000000
 2015-11-05 14:55:14.806 ZJWeibo[1649:34004] 133.000000
 2015-11-05 14:55:14.806 ZJWeibo[1649:34004] 177.000000
 2015-11-05 14:55:14.806 ZJWeibo[1649:34004] 221.000000
 2015-11-05 14:55:14.806 ZJWeibo[1649:34004] 275.000000
 2015-11-05 14:55:14.807 ZJWeibo[1649:34004] 319.000000
 2015-11-05 14:55:14.807 ZJWeibo[1649:34004] 363.000000
 2015-11-05 14:55:14.807 ZJWeibo[1649:34004] 407.000000
 2015-11-05 14:55:14.807 ZJWeibo[1649:34004] 451.000000
 */

@end
