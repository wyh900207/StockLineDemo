//
//  OTJKLineView.m
//  StockLineDemo
//
//  Created by wyh on 2019/4/22.
//  Copyright © 2019 wyh. All rights reserved.
//

#import "OTJKLineView.h"
#import "HLKLineMainView.h"
#import <Masonry/Masonry.h>

@interface OTJKLineView () <UIScrollViewDelegate, HLKLineMainViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
// 主视图
@property (nonatomic, strong) HLKLineMainView *kLineMainView;
// 旧的scrollview准确位移
@property (nonatomic, assign) CGFloat *oldExactOffset;

@end

@implementation OTJKLineView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.mainViewRatio = 1.f;
    }
    return self;
}

#pragma mark - Getter & Setter

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.minimumZoomScale = 1.f;
        _scrollView.maximumZoomScale = 1.f;
        _scrollView.delegate = self;
        _scrollView.bounces = NO;
        
        // 缩放
        UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pichMethod:)];
        [_scrollView addGestureRecognizer:pinchGesture];
        
        // 长按
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressMethod:)];
        [_scrollView addGestureRecognizer:longPressGesture];
        
//        _scrollView.frame = self.bounds;
        
        [self addSubview:_scrollView];
        
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        [self layoutIfNeeded];
    }
    return _scrollView;
}

- (HLKLineMainView *)kLineMainView {
    if (!_kLineMainView) {
        _kLineMainView = [HLKLineMainView new];
        _kLineMainView.delegate = self;
//        _kLineMainView.frame = self.scrollView.bounds;
        [self.scrollView addSubview:_kLineMainView];
        [_kLineMainView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self.scrollView);
            make.height.equalTo(self.scrollView).multipliedBy(self.mainViewRatio);
            make.width.equalTo(@0);
        }];
    }
    return _kLineMainView;
}

- (void)setKLineModels:(NSArray<HLKLineModel *> *)kLineModels {
    _kLineModels = kLineModels;
    
    if (!kLineModels) return;
    
    [self drawKLineMainView];
    // 设置contentOffset
    CGFloat kLineViewWidth = self.kLineModels.count * 20 + self.kLineModels.count + 1 + 10;
    CGFloat offset = kLineViewWidth - self.scrollView.frame.size.width;
    
    if (offset > 0) {
        self.scrollView.contentOffset = CGPointMake(offset, 0);
    }
    else {
        self.scrollView.contentOffset = CGPointMake(0, 0);
    }
    
//    HLKLineModel *model = [kLineModels lastObject];
//    // 设置均线等
}

#pragma mark Event

- (void)pichMethod:(UIPinchGestureRecognizer *)pinch {
    static CGFloat oldScale = 1.f;
    CGFloat difValue = pinch.scale - oldScale;
    if (ABS(difValue) > CHART_VIEW_SCALE_BOUNDS) {
        CGFloat oldKLineWidth = lineWidth();
        if (oldKLineWidth == LINE_MIN_WIDTH && difValue <= 0) return;
        
        NSInteger oldNeedDrawStartIndex = [self.kLineMainView getNeedDrawStartIndexWithScroll:NO];
        
        CGFloat new_line_width = oldKLineWidth * (difValue > 0 ? (1 + CHART_VIEW_SCALE_FACTOR) : (1 - CHART_VIEW_SCALE_FACTOR));
        setkLineWidth(new_line_width);
        
        oldScale = pinch.scale;
        
        if (pinch.numberOfTouches == 2) {
            CGPoint p1 = [pinch locationOfTouch:0 inView:self.scrollView];
            CGPoint p2 = [pinch locationOfTouch:1 inView:self.scrollView];
            CGPoint center_point = CGPointMake((p1.x + p2.x) * 0.5, (p1.y + p2.y) * 0.5);
            NSUInteger oldLeftArrCount = ABS((center_point.x - self.scrollView.contentOffset.x) - 1) / (1 + oldKLineWidth);
            NSUInteger newLeftArrCount = ABS((center_point.x - self.scrollView.contentOffset.x) - 1) / (1 + lineWidth());
            
            self.kLineMainView.pinchStartIndex = oldNeedDrawStartIndex + oldLeftArrCount - newLeftArrCount;
        }
        
        [self.kLineMainView updateMainViewWidth];
        [self.kLineMainView drawMainView];
    }
}

- (void)longPressMethod:(UILongPressGestureRecognizer *)longPress {
    
}

#pragma mark - 画KLineMainView

- (void)drawKLineMainView {
    self.kLineMainView.kLineModels = self.kLineModels;
    [self.kLineMainView drawMainView];
}

#pragma mark - 重绘

- (void)reDraw {
    self.kLineMainView.type = self.mainViewType;
    
    [self.kLineMainView drawMainView];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"这是  %f-----%f=====%f",scrollView.contentSize.width,scrollView.contentOffset.x,self.kLineMainView.frame.size.width);
}

#pragma mark - HLKLineMainViewDelegate

- (void)kLineMainViewCurrentNeedDrawKLineModels:(NSArray *)needDrawKLineModels {
    // 更新 辅助视图和 成交量视图的 models
}

- (void)kLineMainViewCurrentNeedDrawKLinePositionModels:(NSArray *)needDrawKLinePositionModels {
    // 更新 辅助视图和 成交量视图的 models
}

- (void)kLineMainViewCurrentNeedDrawKLineColors:(NSArray *)kLineColors {
    // 成交量视图颜色更新
}

- (void)kLineMainViewLongPressKLinePositionModel:(HLKLinePositionModel *)kLinePositionModel kLineModel:(HLKLineModel *)kLineModel {
    //更新ma信息
}

// MARK: - Life Cycle

- (void)dealloc {
    [_kLineMainView removeAllObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
