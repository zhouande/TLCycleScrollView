//
//  ViewController.m
//  TLCycleScrollView
//
//  Created by andezhou on 15/8/3.
//  Copyright (c) 2015年 andezhou. All rights reserved.
//

#import "TLMainViewController.h"
#import "TLClickImageView.h"
#import "UIImageView+SDWebImage.h"

static CGFloat const kMargin = 10;

@interface TLMainViewController ()

@property (strong, nonatomic) NSMutableArray *views;

@end

@implementation TLMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"图片浏览";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSData *reply = [[NSData alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"]];
    NSError *error = nil;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:reply options:NSJSONReadingMutableLeaves error:&error];
    NSArray *data = [dict objectForKey:@"images"];
    
    self.views = [NSMutableArray array];
    CGFloat width = ([UIScreen mainScreen].bounds.size.width - 4*kMargin)/3.0;
    for (NSUInteger idx = 0; idx < 9; idx ++) {
        NSDictionary *imageDict = [data objectAtIndex:idx];
        
        NSUInteger X = idx % 3;
        NSUInteger Y = idx / 3;
        
        TLClickImageView *imageView = [[TLClickImageView alloc] initWithFrame:CGRectMake(kMargin + (width + kMargin) * X, 100 + (width + kMargin) * Y, width, width)];
        [imageView downloadImage:imageDict[@"image"] place:nil];
        [self.view addSubview:imageView];
        [_views addObject:imageView];
        [imageView setViews:_views];
    }
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
