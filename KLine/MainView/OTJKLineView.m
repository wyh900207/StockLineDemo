//
//  OTJKLineView.m
//  StockLineDemo
//
//  Created by wyh on 2019/4/22.
//  Copyright © 2019 wyh. All rights reserved.
//

#import "OTJKLineView.h"
#import "HLKLineMainView.h"
#import "OTJSegmentView.h"
#import "OTJMainViewIndicationSegmentView.h"
#import "OTJAssistView.h"

@interface OTJKLineView () <UIScrollViewDelegate, HLKLineMainViewDelegate, OTJSegmentViewDelegate, OTJMainViewIndicationSegmentViewDelegate, OTJAssistViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
// 分时选择器
@property (nonatomic, strong) OTJSegmentView *segmentView;
// 主视图指标选择器
@property (nonatomic, strong) OTJMainViewIndicationSegmentView *mainSegmentView;
// 主视图
@property (nonatomic, strong) HLKLineMainView *kLineMainView;
// 旧的scrollview准确位移
@property (nonatomic, assign) CGFloat *oldExactOffset;
// 辅视图指标选择器
@property (nonatomic, strong) OTJMainViewIndicationSegmentView *assistSegmentView;
// 副图
@property (nonatomic, strong) OTJAssistView *kLineAccessoryView;


@end

@implementation OTJKLineView

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.mainViewRatio = 1.f;
        [self bringSubviewToFront:self.assistSegmentView];
    }
    return self;
}

- (void)dealloc {
    [_kLineMainView removeAllObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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

- (OTJSegmentView *)segmentView {
    if (!_segmentView) {
        _segmentView = [OTJSegmentView new];
        _segmentView.delegate = self;
        _segmentView.titles = @[@"分时", @"1分", @"5分", @"15分", @"30分", @"60分"];
        [self addSubview:_segmentView];
        [_segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.left.right.equalTo(self);
            make.height.equalTo(@40);
        }];
        
        [self layoutIfNeeded];
    }
    return _segmentView;
}

- (OTJMainViewIndicationSegmentView *)mainSegmentView {
    if (!_mainSegmentView) {
        _mainSegmentView = [OTJMainViewIndicationSegmentView new];
        _mainSegmentView.delegate = self;
        _mainSegmentView.titles = @[@"SMA", @"EMA", @"BOLL"];
        [self addSubview:_mainSegmentView];
        [_mainSegmentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.segmentView.mas_bottom);
            make.left.right.equalTo(self);
            make.height.equalTo(@30);
        }];
        
        [self layoutIfNeeded];
    }
    return _mainSegmentView;
}

- (HLKLineMainView *)kLineMainView {
    if (!_kLineMainView) {
        _kLineMainView = [HLKLineMainView new];
        _kLineMainView.delegate = self;
        [self.scrollView addSubview:_kLineMainView];
        [_kLineMainView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.scrollView);
            make.top.equalTo(self.mainSegmentView.mas_bottom);
            //make.height.equalTo(self.scrollView).multipliedBy(self.mainViewRatio);
            make.height.equalTo(@300);
            make.width.equalTo(@0);
        }];
        
        [self layoutIfNeeded];
    }
    return _kLineMainView;
}

- (OTJMainViewIndicationSegmentView *)assistSegmentView {
    if (!_assistSegmentView) {
        _assistSegmentView = [OTJMainViewIndicationSegmentView new];
        _assistSegmentView.delegate = self;
        _assistSegmentView.titles = @[@"MACD", @"KDJ", @"RSI"];
        [self addSubview:_assistSegmentView];
        [_assistSegmentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.kLineMainView.mas_bottom);
            make.left.right.equalTo(self);
            make.height.equalTo(@30);
        }];
        
        [self layoutIfNeeded];
    }
    return _assistSegmentView;
}

- (OTJAssistView *)kLineAccessoryView {
    if(!_kLineAccessoryView && self)
    {
        _kLineAccessoryView = [OTJAssistView new];
        _kLineAccessoryView.delegate = self;
        [self.scrollView addSubview:_kLineAccessoryView];
        [_kLineAccessoryView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.width.equalTo(self.kLineMainView);
            make.top.equalTo(self.assistSegmentView.mas_bottom);
            make.bottom.equalTo(self);
        }];
        [self layoutIfNeeded];
    }
    return _kLineAccessoryView;
}

- (void)setKLineModels:(NSArray<HLKLineModel *> *)kLineModels {
    _kLineModels = kLineModels;
    
    if (!kLineModels) return;
    
    [self drawKLineMainView];
    // 设置contentOffset
    CGFloat k_line_width = lineWidth();
    CGFloat kLineViewWidth = self.kLineModels.count * k_line_width + self.kLineModels.count + 1 + 10;
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
//    NSLog(@"这是  %f-----%f=====%f",scrollView.contentSize.width,scrollView.contentOffset.x,self.kLineMainView.frame.size.width);
}

#pragma mark - HLKLineMainViewDelegate

- (void)kLineMainViewCurrentNeedDrawKLineModels:(NSArray *)needDrawKLineModels {
    // 更新 辅助视图和 成交量视图的 models
    self.kLineAccessoryView.needDrawKLineModels = needDrawKLineModels;
}

- (void)kLineMainViewCurrentNeedDrawKLinePositionModels:(NSArray *)needDrawKLinePositionModels {
    // 更新 辅助视图和 成交量视图的 models
    self.kLineAccessoryView.needDrawKLinePositionModels = needDrawKLinePositionModels;
}

- (void)kLineMainViewCurrentNeedDrawKLineColors:(NSArray *)kLineColors {
    // 成交量视图颜色更新
    self.kLineAccessoryView.kLineColors = kLineColors;
    self.kLineAccessoryView.targetLineStatus = HLKLineTypeMACD;
    [self private_drawKLineAccessoryView];
}

- (void)kLineMainViewLongPressKLinePositionModel:(HLKLinePositionModel *)kLinePositionModel kLineModel:(HLKLineModel *)kLineModel {
    //更新ma信息
}



#pragma mark - OTJSegmentViewDelegate

// 分时更新
- (void)segmentView:(OTJSegmentView *)segmentView didSelectIndex:(NSInteger)index {
    NSLog(@"%lu", index);
    // TODO: 更新K线展示形式
}

#pragma mark - OTJMainViewIndicationSegmentViewDelegate

// 辅助线更新
- (void)mainIndicationView:(OTJMainViewIndicationSegmentView *)indicationView didSelectIndex:(NSInteger)index {
    NSLog(@"%lu", index);
    // TODO: 更新K线辅助线
    
    if (indicationView == self.mainSegmentView) {
        // 主视图
    }
    else {
        // 成交量视图
    }
}

#pragma mark - OTJAssistViewDelegate

- (void)kLineAccessoryViewCurrentMaxValue:(CGFloat)maxValue minValue:(CGFloat)minValue {
    
}

#pragma mark - Private

- (void)private_drawKLineAccessoryView {
    [self.kLineAccessoryView layoutIfNeeded];
    [self.kLineAccessoryView draw];
}

@end
