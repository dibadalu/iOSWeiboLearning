//
//  ZJDetailTopToolBar.h
//  ZJWeibo
//
//  Created by dibadalu on 15/11/2.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    ZJStatusDetailTopToolbarButtonRetweetedType,
    ZJStatusDetailTopToolbarButtonCommentType
}ZJStatusDetailTopToolbarButtonType;

@class ZJStatusDetailTopToolBar,ZJStatus;
//声明代理协议
@protocol ZJStatusDetailTopToolBarDelegate <NSObject>

@optional
- (void)statusDetailTopToolBar:(ZJStatusDetailTopToolBar *)topToolBar didSelectedButton:(ZJStatusDetailTopToolbarButtonType)buttonType;

@end

@interface ZJStatusDetailTopToolBar : UIView

/** 类方法 */
+ (instancetype)toolBar;

/** 设置代理属性 */
@property(nonatomic,weak) id<ZJStatusDetailTopToolBarDelegate> delegate;

/** 微博模型数据 */
@property(nonatomic,strong) ZJStatus *status;

/** 选中按钮类型 */
@property(nonatomic,assign) ZJStatusDetailTopToolbarButtonType selectedButtonType;


@end
