//
//  TLTapImageView.m
//  TLCycleScrollView
//
//  Created by andezhou on 15/8/4.
//  Copyright (c) 2015年 andezhou. All rights reserved.
//

#import "TLClickImageView.h"

@interface TLWindow : UIWindow

- (void)show;
- (void)dismiss;

@end

@implementation TLWindow

+ (instancetype)share {
    static TLWindow *window = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        window = [[TLWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    });
    
    return window;
}

- (void)show {
    [self makeKeyAndVisible];
    self.hidden = NO;
}

- (void)dismiss {
    self.hidden = YES;
    [self resignKeyWindow];
    [self removeFromSuperview];
}

@end

#import "TLCycleScrollView.h"
#import "TLZoomingScrollView.h"

static NSTimeInterval kDuration = .4f;

@interface TLClickImageView () <TLCycleScrollViewDelegate>

@property (nonatomic, strong) TLWindow *window;
@property (nonatomic, strong) UIView *showView;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) TLCycleScrollView *cycleView;
@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) NSArray *superViews;

@end

@implementation TLClickImageView

#pragma mark -
#pragma mark init methods
- (UIView *)showView {
    if (!_showView) {
        _showView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        _showView.backgroundColor = [UIColor clearColor];
        _showView.alpha = .0f;
        
        [_showView addSubview:self.backView];
        [_showView addSubview:self.cycleView];
        [_showView addSubview:self.pageControl];
    }
    return _showView;
}

- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        _backView.backgroundColor = [UIColor blackColor];
        _backView.alpha = .0f;
    }
    return _backView;
}

- (TLCycleScrollView *)cycleView {
    if (!_cycleView) {
        _cycleView = [[TLCycleScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        _cycleView.backgroundColor = [UIColor clearColor];
        _cycleView.cycleDelegate = self;
    }
    return _cycleView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.currentPageIndicatorTintColor = self.currentPageIndicatorTintColor;
        _pageControl.pageIndicatorTintColor = self.pageIndicatorTintColor;
        _pageControl.alpha = .0f;
    }
    return _pageControl;
}

#pragma mark -
#pragma mark lifecycle
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 添加单击手势，开始图片浏览模式
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
        [self addGestureRecognizer:tapGesture];
        
        // 设置scrollView属性
        self.clipsToBounds = YES;
        self.contentMode = UIViewContentModeScaleToFill;
        self.userInteractionEnabled = YES;
        
        self.currentPageIndicatorTintColor = [UIColor whiteColor];
        self.pageIndicatorTintColor = [[UIColor lightGrayColor] colorWithAlphaComponent:.5f];

        // 用来承载图片浏览的窗口
        self.window = [TLWindow share];
    }
    return self;
}

- (void)setViews:(NSArray *)views {
    for (TLClickImageView *imageView in views) {
        imageView.superViews = views;
    }
}

#pragma mark -
#pragma mark TLCycleScrollViewDelegate
- (void)dismissFromZoomingView:(TLZoomingScrollView *)zoomingView {
    // 取消图片浏览动画
    [UIView animateWithDuration:kDuration animations:^{
        _backView.alpha = .0f;
        _pageControl.alpha = .0f;
        [zoomingView dismissAnimation];
        zoomingView.imageView.contentMode = self.contentMode;
    } completion:^(BOOL finished) {
        _showView.alpha = .0f;
        
        [self.window dismiss];
    }];
}

- (void)cycleScrollView:(TLCycleScrollView *)csView didSelectPage:(NSUInteger)page {
    _pageControl.currentPage = page;
}

#pragma mark -
#pragma mark tap action
- (void)tapGestureAction:(UITapGestureRecognizer *)tapGesture {
    [self.window.subviews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];
    [self.window addSubview:self.showView];
    [self.window show];
    [self.window bringSubviewToFront:self.showView];

    self.showView.alpha = 1.0f;
    self.cycleView.curPage = [_superViews indexOfObject:self];
    self.cycleView.superViews = _superViews;
    [self.cycleView cycleReloadData];
    
    [self performSelector:@selector(setShowAnimation:) withObject:self.cycleView.imgCenter afterDelay:.1f];

    // 设置pageControl属性
    _pageControl.numberOfPages = _superViews.count;
    _pageControl.currentPage = [_superViews indexOfObject:self];
    
    // 设置pageControl坐标
    CGSize size = [_pageControl sizeForNumberOfPages:_superViews.count];
    CGFloat pointX = ([UIScreen mainScreen].bounds.size.width - size.width)/2.0f;
    CGFloat pointY = [UIScreen mainScreen].bounds.size.height - 35;
    _pageControl.frame = CGRectMake(pointX, pointY, size.width, size.height);
}

// 开始图片浏览动画
- (void)setShowAnimation:(TLZoomingScrollView *)zoomingView {
    [UIView animateWithDuration:kDuration animations:^{
        _backView.alpha = 1.0f;
        _pageControl.alpha = 1.0f;
        [zoomingView showAnimation];
    } completion:^(BOOL finished) {
        zoomingView.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }];
}


@end
