//
//  TLCycleScrollView.h
//  TLCycleScrollView
//
//  Created by andezhou on 15/8/3.
//  Copyright (c) 2015年 andezhou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TLCycleScrollView;
@class TLZoomingScrollView;

@protocol TLCycleScrollViewDelegate <NSObject>

@optional
- (void)cycleScrollView:(TLCycleScrollView *)csView didSelectPage:(NSUInteger)page;
- (void)dismissFromZoomingView:(TLZoomingScrollView *)zoomingView;

@end

@interface TLCycleScrollView : UIScrollView <UIScrollViewDelegate>

// 代理方法
@property (nonatomic, weak) id<TLCycleScrollViewDelegate> cycleDelegate;

// 当前显示的view
@property (nonatomic, strong) TLZoomingScrollView *imgCenter;

// 当前显示的位置
@property (nonatomic, assign) NSInteger curPage;

// 
@property (nonatomic, strong) NSArray *superViews;

// 刷新
- (void)cycleReloadData;

@end
