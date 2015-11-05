//
//  ZJCommonCell.m
//  ZJWeibo
//
//  Created by dibadalu on 15/11/5.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import "ZJCommonCell.h"
#import "ZJCommonItem.h"

@implementation ZJCommonCell

#pragma mark - init method
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

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //设置子标题的x
    self.detailTextLabel.x = CGRectGetMaxX(self.textLabel.frame) + ZJCellMargin * 0.5;
}

#pragma mark - setter
- (void)setItem:(ZJCommonItem *)item
{
    _item = item;
    
    //1.设置cell的基本数据
    self.imageView.image = [UIImage imageNamed:item.icon];
    self.textLabel.text = item.title;
    self.detailTextLabel.text = item.subTitle;
    
}

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
