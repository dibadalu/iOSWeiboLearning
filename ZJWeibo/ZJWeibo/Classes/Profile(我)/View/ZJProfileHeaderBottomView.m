//
//  ZJProfileHeaderBottomView.m
//  ZJWeibo
//
//  Created by dibadalu on 15/11/9.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import "ZJProfileHeaderBottomView.h"
#import "ZJInfoCount.h"

@interface ZJProfileHeaderBottomView ()

@property (weak, nonatomic) IBOutlet UIButton *statusesBtn;
@property (weak, nonatomic) IBOutlet UIButton *friendsBtn;
@property (weak, nonatomic) IBOutlet UIButton *followersBtn;
- (IBAction)btnClick:(UIButton *)button;

@end

@implementation ZJProfileHeaderBottomView
#pragma mark - class method
+ (instancetype)headerBottomView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"ZJProfileHeaderBottomView" owner:nil options:nil] lastObject];
}

#pragma mark - system method
/**
 * 加载完nib或storyboard之后调用
 */
- (void)awakeFromNib
{
    //设置三个按钮的tag
    self.statusesBtn.tag = ZJProfileHeaderBottomViewButtonStatusesType;
    self.friendsBtn.tag = ZJProfileHeaderBottomViewButtonFriendsType;
    self.followersBtn.tag = ZJProfileHeaderBottomViewButtonFollowersType;
}

#pragma mark - setter method
- (void)setInfoCount:(ZJInfoCount *)infoCount
{
    _infoCount = infoCount;
    
//    ZJLog(@"%d",self.infoCount.friends_count);
    
    //微博
    [self setupBtnCount:infoCount.statuses_count btn:self.statusesBtn];
    //关注
    [self setupBtnCount:infoCount.friends_count btn:self.friendsBtn];
    //粉丝
    [self setupBtnCount:infoCount.followers_count btn:self.followersBtn];

}

- (void)setupBtnCount:(int)count  btn:(UIButton *)btn
{
    NSString *title = nil;
    if (count) {//数字不为0
        if (count < 10000) {// 不足10000：直接显示数字，比如786、7986
            title = [NSString stringWithFormat:@"%d",count];
        }else{// 达到10000：显示xx.x万，不要有.0的情况
            double wan = count/10000.0;
            title = [NSString stringWithFormat:@"%.1f万",wan];
            // 将字符串里面的.0去掉
            title = [title stringByReplacingOccurrencesOfString:@".0" withString:@""];
        }
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitle:title forState:UIControlStateSelected];
    }
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateSelected];
}

#pragma mark - action method 
- (IBAction)btnClick:(UIButton *)button {
//    ZJLog(@"btnClick-%d",button.tag);
    
    //发出通知（携带被点击按钮的类型）
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[ZJSelectProfileHeaderBottomViewBtnType] = button;
    [ZJNotificationCenter postNotificationName:ZJProfileHeaderBottomViewBtnDidSelectNotification object:nil userInfo:userInfo];
    
}

@end
