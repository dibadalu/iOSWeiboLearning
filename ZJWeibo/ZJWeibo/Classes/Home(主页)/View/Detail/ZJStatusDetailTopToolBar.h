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

@class ZJStatusDetailTopToolBar;
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

@end
