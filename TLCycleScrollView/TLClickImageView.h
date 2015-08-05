//
//  TLTapImageView.h
//  TLCycleScrollView
//
//  Created by andezhou on 15/8/4.
//  Copyright (c) 2015年 andezhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TLClickImageView : UIImageView

@property (nonatomic, strong) UIColor *pageIndicatorTintColor;
@property (nonatomic, strong) UIColor *currentPageIndicatorTintColor;

- (void)setViews:(NSArray *)views;

@end
