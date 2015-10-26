//
//  ZJEmotionlistView.m
//  ZJWeibo
//
//  Created by dibadalu on 15/10/25.
//  Copyright (c) 2015年 dibadalu. All rights reserved.
//

#import "ZJEmotionListView.h"
#import "ZJPageEmotionView.h"

@interface ZJEmotionListView ()<UIScrollViewDelegate>

@property(nonatomic,weak) UIScrollView *scrollView;
@property(nonatomic,weak) UIPageControl *pageControl;

@end

@implementation ZJEmotionListView

#pragma mark - 系统方法
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        //1.scrollView
        UIScrollView *scrollView = [[UIScrollView alloc] init];
//        scrollView.backgroundColor = [UIColor yellowColor];
        scrollView.pagingEnabled = YES;//设置分页
        scrollView.showsHorizontalScrollIndicator = NO;//取消水平滚动条的显示
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.delegate = self;//设置代理
        [self addSubview:scrollView];
        self.scrollView = scrollView;
        
        //2.pageControl
        UIPageControl *pageControl = [[UIPageControl alloc] init];
        //设置圆点的图片(系统属性，通过KVC来设置)
        [pageControl setValue:[UIImage imageNamed:@"compose_keyboard_dot_normal"] forKeyPath:@"pageImage"];
        [pageControl setValue:[UIImage imageNamed:@"compose_keyboard_dot_selected"] forKeyPath:@"currentPageImage"];
        [self addSubview:pageControl];
        self.pageControl = pageControl;

    }
    
    return self;
}
/**
 *  设置子控件的frame
 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //1.pageControl
    self.pageControl.width = self.width;
    self.pageControl.height = 45;
    self.pageControl.x = 0;
    self.pageControl.y = self.height - self.pageControl.height;
    
    //2.scrollView
    self.scrollView.width = self.width;
    self.scrollView.height = self.height - self.pageControl.height;
    self.scrollView.x = self.scrollView.y = 0;
    
    //3.设置pageView的frame
    NSUInteger count = self.scrollView.subviews.count;
    for (int i = 0; i< count; i++) {
        UIView *pageView = self.scrollView.subviews[i];
        pageView.width = self.scrollView.width;
        pageView.height = self.scrollView.height;
        pageView.x = i * pageView.width;
        pageView.y = 0;
    }
    
    //4.设置scrollView的contentSize
    self.scrollView.contentSize = CGSizeMake(count * self.scrollView.width, 0);
    
}

/**
 *  通过ZJEmotion模型计算表情内容的页数
 *
 *  @param emotions ZJEmotion数组
 */
- (void)setEmotions:(NSArray *)emotions
{
    _emotions = emotions;
 
//    ZJLog(@"%d",emotions.count);
    //0.更新“最近”页面上的表情数据
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSUInteger count = (emotions.count + ZJEmotionsPageCount - 1) / ZJEmotionsPageCount;
    
    //1.设置表情内容的页数
    self.pageControl.numberOfPages = count;
    
    //2.创建用来显示每一页表情内容的控件
    for (int i = 0; i< count; i++) {
        ZJPageEmotionView *pageView = [[ZJPageEmotionView alloc] init];//设置frame
//        pageView.backgroundColor = ZJRandomColor;
        //计算这一页的表情图片范围
        NSRange range = NSMakeRange(0, 0);
        range.location = i * ZJEmotionsPageCount;//i * 20
        //剩余的表情图标个数
        //共99个 : i = 4 ，location 80，剩余19个
        NSInteger left = emotions.count -  range.location;
        if (left >= 20) {//满足一页20个
            range.length = ZJEmotionsPageCount;
        }else{
            range.length = left;
        }
        //截取表情图片数组
        pageView.emotions = [emotions subarrayWithRange:range];
        
        [self.scrollView addSubview:pageView];
    }
    
    //重置frame
    [self setNeedsLayout];
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    ZJLog(@"%f",scrollView.contentOffset.x / self.scrollView.width);
    double pageDouble = scrollView.contentOffset.x / self.scrollView.width;
    int pageInt =(int) pageDouble + 0.5;
    self.pageControl.currentPage = pageInt;
    
}

@end
