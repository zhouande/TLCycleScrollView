//
//  UIImageView+SDWebImage.m
//  TLCycleScrollView
//
//  Created by andezhou on 15/8/4.
//  Copyright (c) 2015年 andezhou. All rights reserved.
//

#import "UIImageView+SDWebImage.h"

@implementation UIImageView (SDWebImage)

#pragma mark SDWebImage图片下载
- (void)downloadImage:(NSString *)url
                place:(UIImage *)place
              success:(TLDownloadSuccessBlock)success
              failure:(TLDownloadFailureBlock)failure {
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    
    [manager downloadImageWithURL:[NSURL URLWithString:url] options:SDWebImageLowPriority | SDWebImageRetryFailed  progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        if (error) {
            failure(error);
        }else{
            self.image = image;
            success(finished, image);
        }
    }];
}

- (void)downloadImage:(NSString *)url
                place:(UIImage *)place {
    
    //    self.userInteractionEnabled = NO;
    [self downloadImage:url place:place success:^(BOOL success, UIImage *image) {
    } failure:^(NSError *error) {
    }];
}

@end;