//
//  ZJProfileHeaderBottomView.h
//  ZJWeibo
//
//  Created by dibadalu on 15/11/9.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

typedef enum {
    ZJProfileHeaderBottomViewButtonStatusesType,
    ZJProfileHeaderBottomViewButtonFriendsType,
    ZJProfileHeaderBottomViewButtonFollowersType
}ZJProfileHeaderBottomViewButtonType;


#import <UIKit/UIKit.h>
@class ZJInfoCount;

@interface ZJProfileHeaderBottomView : UIView

/** 类方法 */
+ (instancetype)headerBottomView;

/** ZJInfoCount模型 */
@property(nonatomic,strong) ZJInfoCount *infoCount;

@end
