//
//  ViewController.m
//  StockLineDemo
//
//  Created by wyh on 2019/4/18.
//  Copyright © 2019 wyh. All rights reserved.
//

#import "ViewController.h"
#import "HLKLineMainView.h"

@interface ViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) HLKLineMainView *mainview;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.mainview];
    
    [self.mainview drawMainView];
}

#pragma mark - Getter

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
        _scrollView.frame = CGRectMake(0, 100, self.view.bounds.size.width, 200);
        _scrollView.minimumZoomScale = 1.0;
        _scrollView.maximumZoomScale = 1.0f;
        _scrollView.bounces = NO;
    }
    return _scrollView;
}

- (HLKLineMainView *)mainview {
    if (!_mainview) {
        _mainview = [HLKLineMainView new];
        _mainview.frame = self.scrollView.bounds;
        _mainview.type = HLKLineMainViewTypeKLine;
    }
    return _mainview;
}

@end
