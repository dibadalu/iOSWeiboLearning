//
//  ZJComposeToolBar.h
//  ZJWeibo
//
//  Created by dibadalu on 15/10/24.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//  键盘上的工具条

typedef enum
{
    ZJComposeToolbarButtonTypeCamera,//拍照
    ZJComposeToolbarButtonTypePicture,//相册
    ZJComposeToolbarButtonTypeMention,//@
    ZJComposeToolbarButtonTypeTrend,//#
    ZJComposeToolbarButtonTypeEmotion//表情
}ZJComposeToolbarButtonType;

#import <UIKit/UIKit.h>
@class ZJComposeToolBar;
//声明代理协议
@protocol ZJComposeToolBarDelegate <NSObject>
//代理方法
@optional
- (void)composeToolBar:(ZJComposeToolBar *)toolBar didClickbuttonType:(ZJComposeToolbarButtonType)buttonType;

@end

@interface ZJComposeToolBar : UIView

/** 代理属性 */
@property(nonatomic,weak) id<ZJComposeToolBarDelegate> delegate;
/** 是否显示键盘按钮 */
@property(nonatomic,assign) BOOL showKeyboardButton;

@end











