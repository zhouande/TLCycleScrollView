//
//  TLZoomingScrollView.h
//  TLCycleScrollView
//
//  Created by andezhou on 15/8/3.
//  Copyright (c) 2015年 andezhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TLZoomingScrollView;
@protocol TLZoomingScrollViewDelegate <NSObject>

// 取消浏览代理
- (void)zoomingScrollView:(TLZoomingScrollView *)scrollView clickCancel:(UITapGestureRecognizer *)tapGesture;

@end

@interface TLZoomingScrollView : UIScrollView

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, weak) id<TLZoomingScrollViewDelegate> zoomingDelegate;

// 设置初始化frame，为动画做准备
- (void)setSmallFrame:(CGRect)frame;
// 设置图片
- (void)setImage:(UIImage *)image;
// 开始浏览
- (void)showAnimation;
// 取消浏览
- (void)dismissAnimation;


@end
