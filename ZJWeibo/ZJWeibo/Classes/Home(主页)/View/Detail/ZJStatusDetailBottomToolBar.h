//
//  ZJStatusDetailBottomToolBar.h
//  ZJWeibo
//
//  Created by dibadalu on 15/11/2.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

typedef enum {
    ZJStatusDetailBottomToolBarButtonRetweetType,
    ZJStatusDetailBottomToolBarButtonCommentType,
    ZJStatusDetailBottomToolBarButtonLikeType
}ZJStatusDetailBottomToolBarButtonType;

#import <UIKit/UIKit.h>
@class ZJStatusDetailBottomToolBar;

@protocol ZJStatusDetailBottomToolBarDelegate <NSObject>

@optional
- (void)statusDetailBottomToolBar:(ZJStatusDetailBottomToolBar *)bottomToolBar bottomButtonType:(ZJStatusDetailBottomToolBarButtonType)bottomBtnType;

@end


@interface ZJStatusDetailBottomToolBar : UIView

@property(nonatomic,weak) id<ZJStatusDetailBottomToolBarDelegate> delegate;

@end
