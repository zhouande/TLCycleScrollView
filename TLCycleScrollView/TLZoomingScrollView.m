//
//  TLZoomingScrollView.m
//  TLCycleScrollView
//
//  Created by andezhou on 15/8/3.
//  Copyright (c) 2015年 andezhou. All rights reserved.
//

#import "TLZoomingScrollView.h"

static CGFloat const kMaxZoom = 2.0f;
static CGFloat const kMinZoom = 1.0f;

@interface TLZoomingScrollView () <UIScrollViewDelegate>

@property (assign, nonatomic) CGFloat currentScale;
@property (assign, nonatomic) CGRect oldFrame;
@property (assign, nonatomic) CGSize imgSize;

@end

@implementation TLZoomingScrollView

#pragma mark -
#pragma mark lifecycle
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self){
        self.delegate = self;
        self.bounces = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.bouncesZoom = YES;
        self.scrollEnabled = YES;
        self.minimumZoomScale = 1;
        self.maximumZoomScale = kMaxZoom;
        
        [self addSubview:self.imageView];
        
        [self addGestures];
    }
    return self;
}

- (void)addGestures {
    // 添加双击手势，用于方法图片
    UITapGestureRecognizer *doubleGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleGesture:)];
    doubleGesture.numberOfTapsRequired = 2;
    doubleGesture.numberOfTouchesRequired = 1;
    [self.imageView addGestureRecognizer:doubleGesture];
    
    // 添加单击手势，取消浏览
    UITapGestureRecognizer *singleGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleGestureAction:)];
    singleGesture.numberOfTapsRequired = 1;
    singleGesture.numberOfTouchesRequired = 1;
    [singleGesture requireGestureRecognizerToFail:doubleGesture];
    [self addGestureRecognizer:singleGesture];
}

#pragma mark -
#pragma mark init methods
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.clipsToBounds = YES;
        _imageView.userInteractionEnabled = YES;
    }
    return _imageView;
}

#pragma mark -
#pragma mark 图片浏览动画
// 设置初始化frame，为动画做准备
- (void)setSmallFrame:(CGRect)frame {
    _imageView.frame = frame;
    _oldFrame = frame;
}

// 开始浏览
- (void)showAnimation {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = width * _imgSize.height/_imgSize.width;
    
    _imageView.frame = CGRectMake(0, 0, width, height);
    _imageView.center = self.superview.center;
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
}

// 取消浏览
- (void)dismissAnimation {
    self.zoomScale = 1.0;
    _imageView.frame = _oldFrame;
}

// 给_imageView设置图片
- (void)setImage:(UIImage *)image {
    if (image) {
        _imageView.image = image;
        _imgSize = image.size;
    }
}

#pragma mark -
#pragma mark 点击手势
// 单击推出浏览模式
- (void)singleGestureAction:(UITapGestureRecognizer *)tapGesture
{
    [self setZoomScale:kMinZoom animated:YES];

    if ([self.zoomingDelegate respondsToSelector:@selector(zoomingScrollView:clickCancel:)]) {
        [self.zoomingDelegate zoomingScrollView:self clickCancel:tapGesture];
    }
}

// 双击放大图片
- (void)doubleGesture:(UITapGestureRecognizer *)tapGesture {
    if (_currentScale > kMinZoom) {
        [self setZoomScale:kMinZoom animated:YES];
    }
    else{
        CGRect zoomRect = [self zoomRectForScale:kMaxZoom withCenter:[tapGesture locationInView:self]];
        [self zoomToRect:zoomRect animated:YES];
    }
}

- (CGRect)zoomRectForScale:(CGFloat)scale withCenter:(CGPoint)touch {
    CGRect zoomRect = CGRectZero;
    zoomRect.size.height = self.frame.size.height / scale;
    zoomRect.size.width  = self.frame.size.width / scale;
    zoomRect.origin.x = touch.x - (zoomRect.size.width / 2.0);
    zoomRect.origin.y = touch.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
}

#pragma mark -
#pragma mark UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    _currentScale = scale;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGSize boundsSize = scrollView.bounds.size;
    CGRect imgFrame = _imageView.frame;
    CGSize contentSize = scrollView.contentSize;
    
    CGPoint centerPoint = CGPointMake(contentSize.width/2.0f, contentSize.height/2.0f);
    
    if (imgFrame.size.width <= boundsSize.width){
        centerPoint.x = boundsSize.width/2.0f;
    }
    
    if (imgFrame.size.height <= boundsSize.height){
        centerPoint.y = boundsSize.height/2.0f;
    }
    
    _imageView.center = centerPoint;
}
@end
