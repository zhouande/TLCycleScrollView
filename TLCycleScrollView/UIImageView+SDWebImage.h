//
//  UIImageView+SDWebImage.h
//  TLCycleScrollView
//
//  Created by andezhou on 15/8/4.
//  Copyright (c) 2015年 andezhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"

typedef void (^TLDownloadSuccessBlock) (BOOL success, UIImage *image);
typedef void (^TLDownloadFailureBlock) (NSError *error);

@interface UIImageView (SDWebImage)

#pragma mark SDWebImage图片下载
- (void)downloadImage:(NSString *)url
                place:(UIImage *)place
              success:(TLDownloadSuccessBlock)success
              failure:(TLDownloadFailureBlock)failure;
- (void)downloadImage:(NSString *)url
                place:(UIImage *)place;

@end
