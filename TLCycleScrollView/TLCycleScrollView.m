//
//  TLCycleScrollView.m
//  TLCycleScrollView
//
//  Created by andezhou on 15/8/3.
//  Copyright (c) 2015年 andezhou. All rights reserved.
//

#import "TLCycleScrollView.h"
#import "TLZoomingScrollView.h"
#import "TLClickImageView.h"

@interface TLCycleScrollView () <TLZoomingScrollViewDelegate>

@property (nonatomic, assign) NSInteger totalPages;
@property (nonatomic, strong) TLZoomingScrollView *imgLeft, *imgRight;

@end

@implementation TLCycleScrollView

#pragma mark -
#pragma mark lifecycle
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self configSetting];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configSetting];
    }
    return self;
}

// 初始化参数
- (void)configSetting {
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.pagingEnabled = YES;
    self.bounces = NO;
    self.delegate = self;
    
    [self addSubview:self.imgLeft];
    [self addSubview:self.imgCenter];
    [self addSubview:self.imgRight];

    self.superViews = [NSArray array];
    self.curPage = 0;
}

- (void)setTotalPages:(NSInteger)totalPages {
    _totalPages = totalPages;
    if (totalPages == 1) {
        self.contentSize = CGSizeZero;
    }
    else {
        self.contentSize = CGSizeMake(self.frame.size.width * 3, 0);
    }
}

#pragma mark -
#pragma mark init methods
- (TLZoomingScrollView *)imgLeft {
    if (!_imgLeft) {
        _imgLeft = [[TLZoomingScrollView alloc] initWithFrame:self.bounds];
        _imgLeft.zoomingDelegate = self;
        _imgLeft.backgroundColor = [UIColor clearColor];
    }
    return _imgLeft;
}

- (TLZoomingScrollView *)imgRight {
    if (!_imgRight) {
        _imgRight = [[TLZoomingScrollView alloc] initWithFrame:CGRectOffset(self.bounds, self.bounds.size.width * 2, 0)];
        _imgRight.zoomingDelegate = self;
        _imgRight.backgroundColor = [UIColor clearColor];
    }
    return _imgRight;
}

- (TLZoomingScrollView *)imgCenter {
    if (!_imgCenter) {
        _imgCenter = [[TLZoomingScrollView alloc] initWithFrame:CGRectOffset(self.bounds, self.bounds.size.width, 0)];
        _imgCenter.zoomingDelegate = self;
        _imgCenter.backgroundColor = [UIColor clearColor];
    }
    return _imgCenter;
}

#pragma mark -
#pragma mark 刷新视图
- (void)cycleReloadData {
    // 1.获取总的页数
    self.totalPages = self.superViews.count;
    if (_totalPages == 0) return;

    // 2.加载视图
    [self setInfoByBeginPage:_curPage];
    // 3.设置偏移
    [self setContentOffset:CGPointMake(self.frame.size.width, 0)];
}

- (void)loadData {
    CGFloat viewWidth = self.bounds.size.width;
    
    // 1.判断滑动方向，得到当前_curPage
    if (self.contentOffset.x > viewWidth) { //向左滑动
        _curPage = (_curPage + 1) % _totalPages;
    }
    else if (self.contentOffset.x < viewWidth) { //向右滑动
        _curPage = (_curPage - 1 + _totalPages) % _totalPages;
    }

    // 2.跟新imggeView对应的图片
    [self setInfoByBeginPage:-1];
    [self setContentOffset:CGPointMake(self.frame.size.width, 0)];
}

- (void)setInfoByBeginPage:(NSInteger)beginPage {
    NSInteger pre = ((_curPage - 1 + _totalPages) % _totalPages);
    NSInteger last = ((_curPage + 1) % _totalPages);
    
    // 更新图片
    [self setZoomingView:_imgLeft currentPage:pre beginPage:beginPage];
    [self setZoomingView:_imgCenter currentPage:_curPage beginPage:beginPage];
    [self setZoomingView:_imgRight currentPage:last beginPage:beginPage];
}

// 更新图片
- (void)setZoomingView:(TLZoomingScrollView *)zoomingView
           currentPage:(NSUInteger)currentPage
          beginPage:(NSInteger)beginPage {
    UIViewController *mainVC = [[[UIApplication sharedApplication] keyWindow] rootViewController];

    // 1.获取将要展示的视图
    TLClickImageView *imageView = (TLClickImageView *)_superViews[currentPage];
    // 2.获取仕途对应父视图的frame
    CGRect leftRect = [[imageView superview] convertRect:imageView.frame toView:mainVC.view];
    // 3.设置初始化的frame，为动画做准备
    [zoomingView setSmallFrame:leftRect];
    
    // 4.设置图片
    [zoomingView setImage:imageView.image];
    
    // 5.把已放大的图片调整为正常状态
    [zoomingView setZoomScale:1.0f];
    
    if (beginPage != currentPage) {
        [zoomingView showAnimation];
    }
}

#pragma mark -
#pragma mark UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // 跟新图片
    [self loadData];

    // 设置偏移
    [self setContentOffset:CGPointMake(self.frame.size.width, 0) animated:YES];
    
    // 代理
    if ([self.cycleDelegate respondsToSelector:@selector(cycleScrollView:didSelectPage:)]) {
        [_cycleDelegate cycleScrollView:self didSelectPage:_curPage];
    }
}

#pragma mark -
#pragma mark TLZoomingScrollViewDelegate
- (void)zoomingScrollView:(TLZoomingScrollView *)scrollView clickCancel:(UITapGestureRecognizer *)tapGesture {
    if ([self.cycleDelegate respondsToSelector:@selector(dismissFromZoomingView:)]) {
        [self.cycleDelegate dismissFromZoomingView:scrollView];
    }
}

@end
