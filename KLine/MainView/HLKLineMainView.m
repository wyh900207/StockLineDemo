//
//  HLKLineMainView.m
//  StockLineDemo
//
//  Created by wyh on 2019/4/18.
//  Copyright © 2019 wyh. All rights reserved.
//

#import "HLKLineMainView.h"
#import "HLKLineModel.h"
#import "HLKLinePositionModel.h"
#import "HLKLine.h"

@interface HLKLineMainView ()

// 需要绘制的model数组
@property (nonatomic, strong) NSMutableArray<HLKLineModel *> *lineModels;
// 需要绘制的model位置数组
@property (nonatomic, strong) NSMutableArray<HLKLinePositionModel *> *positionModels;
// Index开始X的值
@property (nonatomic, assign) NSInteger startXPosition;
// 旧的contentoffset值
@property (nonatomic, assign) CGFloat oldContentOffsetX;
// 旧的缩放值
@property (nonatomic, assign) CGFloat oldScale;

@end

@implementation HLKLineMainView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.lineModels = @[].mutableCopy;
        self.positionModels = @[].mutableCopy;
        
        self.needDrawStartIndex = 0;
        self.oldContentOffsetX = 0;
        self.oldScale = 0;
    }
    return self;
}

- (void)didMoveToSuperview {
    _parentScrollView = (UIScrollView *)self.superview;
    [_parentScrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:NULL];
    [super didMoveToSuperview];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentOffset"]) {
        CGFloat difValue = ABS(self.parentScrollView.contentOffset.x - self.oldContentOffsetX);
        if (difValue >= 21) {
            self.oldContentOffsetX = self.parentScrollView.contentOffset.x;
            [self drawMainView];
            CGRect rect = self.frame;
            self.frame = CGRectMake(self.parentScrollView.contentOffset.x, rect.origin.y, rect.size.width, rect.size.height);
        }
    }
}

#pragma mark - 画

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];

    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextFillRect(context, rect);
    CGContextFillRect(context, rect);

    if (!self.lineModels) return;

    NSMutableArray *kLineColors = @[].mutableCopy;
    
    // 指标
    CGContextSetFillColorWithColor(context, ASSIST_BACKGROUND_COLOR.CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, rect.size.width, 15));

    // 日期区域背景色
    CGContextSetFillColorWithColor(context, ASSIST_BACKGROUND_COLOR.CGColor);
    CGContextFillRect(context, CGRectMake(0, rect.size.height - 15, rect.size.width, 15));

    if (self.type == HLKLineMainViewTypeKLine) {
        HLKLine *line = [[HLKLine alloc] initWithContext:context];
        line.maxY = rect.size.height - 15;

        [self.positionModels enumerateObjectsUsingBlock:^(HLKLinePositionModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            line.position_model = obj;
            line.line_model = self.lineModels[idx];
            UIColor *color = [line draw];
            [kLineColors addObject:color];
        }];
    }

}

#pragma mark - Public

- (void)drawMainView {
    // 获取需要展示的 K线 模型
    [self extractNeedDrawModels];
    // 将 Model 转换为 坐标
    [self modelsConvertToPostionsModels];
    // 调用drawRect方法
    [self setNeedsDisplay];
}

- (void)updateMainViewWidth {
    CGFloat kLineViewWidth = self.kLineModels.count * 20 + (self.kLineModels.count + 1) + 10;
    
    if (kLineViewWidth < self.parentScrollView.bounds.size.width) {
        kLineViewWidth = self.parentScrollView.bounds.size.width;
    }
    
    CGRect rect = self.frame;
    
    self.frame = CGRectMake(rect.origin.x, self.parentScrollView.contentOffset.x, rect.size.width, rect.size.height);
    
    [self layoutIfNeeded];
    
    self.parentScrollView.contentSize = CGSizeMake(kLineViewWidth, self.parentScrollView.contentSize.height);
}

-(void)removeAllObserver {
    [_parentScrollView removeObserver:self forKeyPath:@"contentOffset" context:NULL];
}

#pragma mark - Private

- (NSArray *)extractNeedDrawModels {
    CGFloat lineGap = 1;
    CGFloat lineWidth = 20;

    // 数组个数
    CGFloat scrollViewWidth = self.parentScrollView.frame.size.width;
    NSInteger needDrawKLineCount = (scrollViewWidth - lineGap) / (lineGap + lineWidth);

    // 起始位置
    NSInteger needDrawKLineStartIndex;

//    if (self.pinchStartIndex > 0) {
//        needDrawKLineStartIndex = self.pinchStartIndex;
//        _needDrawStartIndex = self.pinchStartIndex;
//        self.pinchStartIndex = -1;
//    } else {
//        needDrawKLineStartIndex = [self getNeedDrawStartIndexWithScroll:YES];
//    }
    
    needDrawKLineStartIndex = [self getNeedDrawStartIndexWithScroll:YES];

    // 重新计算需要显示的 数据源
    [self.lineModels removeAllObjects];

    if (needDrawKLineStartIndex < self.kLineModels.count) {
        if (needDrawKLineStartIndex + needDrawKLineCount < self.kLineModels.count) {
            [self.lineModels addObjectsFromArray:[self.kLineModels subarrayWithRange:NSMakeRange(needDrawKLineStartIndex, needDrawKLineCount)]];
        } else {
            [self.lineModels addObjectsFromArray:[self.kLineModels subarrayWithRange:NSMakeRange(needDrawKLineStartIndex, self.kLineModels.count - needDrawKLineStartIndex)]];
        }
    }

    return self.lineModels;
}

- (NSArray<HLKLinePositionModel *> *)modelsConvertToPostionsModels {
    if (!self.lineModels) return nil;

    NSArray<HLKLineModel *> *kLineModels = [self lineModels];

    HLKLineModel *firstModel = kLineModels.firstObject;
    __block CGFloat minAssert = firstModel.low.floatValue;
    __block CGFloat maxAssert = firstModel.high.floatValue;

    [kLineModels enumerateObjectsUsingBlock:^(HLKLineModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.high.floatValue > maxAssert) {
            maxAssert = obj.high.floatValue;
        }
        if (obj.low.floatValue < minAssert) {
            minAssert = obj.low.floatValue;
        }
        
        minAssert = obj.low.floatValue > minAssert ? minAssert : obj.low.floatValue;
        maxAssert = obj.high.floatValue < maxAssert ? maxAssert : obj.high.floatValue;
    }];

//    maxAssert = 1.0001;
//    minAssert = 0.9991;

    CGFloat minY = 20;
    CGFloat maxY = self.bounds.size.height - 15;
    CGFloat unitValue = (maxAssert - minAssert) / (maxY - minY);  // 没个物理像素对应多少大盘点
    
    /*
     Y坐标: 最大值 - (实际值 - 最小值) / unitValue
     
        如: View.bounds = (0, 0, 100, 100)
        0 - 3000点            -----
     
        最高 2800点              |
        收盘 2600点             ---
                               | |
                               | |
        开盘 2500点             ---
                                |
        最低 2200点
     
        100 - 2000点          -----
     
     unitValue = (3000 - 2000) / (100 - 0) = 10
     
     high  = 100 - (2800 - 2000) / 10 = 20
     close = 100 - (2600 - 2000) / 10 = 40
     open  = 100 - (2500 - 2000) / 10 = 50
     low   = 100 - (2200 - 2000) / 10 = 80
    */

    [self.positionModels removeAllObjects];

    for (NSUInteger idx = 0; idx < kLineModels.count; idx++) {
        HLKLineModel *klineModel = kLineModels[idx];
        
        CGFloat x_position = self.startXPosition + idx * (20 + 1);
        
        CGFloat open_point_y = ABS(maxY - (klineModel.open.floatValue - minAssert) / unitValue);
        CGFloat close_point_y = ABS(maxY - (klineModel.close.floatValue - minAssert) / unitValue);
        CGFloat high_point_y = ABS(maxY - (klineModel.high.floatValue - minAssert) / unitValue);
        CGFloat low_point_y = ABS(maxY - (klineModel.low.floatValue - minAssert) / unitValue);
        
        CGPoint open_point = CGPointMake(x_position, open_point_y);
        
        if (ABS(close_point_y - open_point_y) < 2) {
            if (open_point_y > close_point_y) {
                open_point_y = close_point_y + 2;
            }
            else if (open_point_y < close_point_y) {
                close_point_y = open_point_y + 2;
            }
            else {
                if (idx > 0) {
                    HLKLineModel *pre_line_model = kLineModels[idx - 1];
                    if (klineModel.open.floatValue > pre_line_model.close.floatValue) {
                        open_point_y = close_point_y + 2;
                    } else {
                        close_point_y = open_point_y + 2;
                    }
                } else if (idx + 1 < kLineModels.count) {
                    HLKLineModel *sub_line_model = kLineModels[idx + 1];
                    if (klineModel.close.floatValue < sub_line_model.open.floatValue) {
                        open_point_y = close_point_y + 2;
                    }
                    else {
                        close_point_y = open_point_y + 2;
                    }
                }
            }
        }
        
        CGPoint close_point = CGPointMake(x_position, close_point_y);
        CGPoint high_point = CGPointMake(x_position, high_point_y);
        CGPoint low_point = CGPointMake(x_position, low_point_y);
        
        HLKLinePositionModel *line_position_model = [HLKLinePositionModel modelWithOpen:open_point close:close_point high:high_point low:low_point];
        [self.positionModels addObject:line_position_model];
    }
    
    return self.positionModels;
}

#pragma mark - Public

- (NSInteger)getNeedDrawStartIndexWithScroll:(BOOL)scorll {
    if (scorll) {
        CGFloat scrollViewOffsetX = self.parentScrollView.contentOffset.x < 0 ? 0 : self.parentScrollView.contentOffset.x;
        NSUInteger leftArrCount = ABS(scrollViewOffsetX - 1) / (1 + 20);
        _needDrawStartIndex = leftArrCount;
    }

    return _needDrawStartIndex;
}

- (NSArray<HLKLineModel *> *)allKLineModels {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    
    NSArray<NSArray<NSString *> *> *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    __block NSMutableArray<HLKLineModel *> *entries = @[].mutableCopy;
    
    [array enumerateObjectsUsingBlock:^(NSArray<NSString *> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        HLKLineModel *model = [HLKLineModel new];
        model.date = obj[0];
        model.open = @(obj[1].doubleValue);
        model.close = @(obj[2].doubleValue);
        model.high = @(obj[3].doubleValue);
        model.low = @(obj[4].doubleValue);
        
        [entries addObject:model];
    }];
    
    return entries;
}

- (NSArray<HLKLineModel *> *)kLineModels {
    if (!_kLineModels) {
        _kLineModels = [self allKLineModels];
    }
    return _kLineModels;
}

#pragma mark - Getter

- (NSMutableArray<HLKLineModel *> *)lineModels {
    return [self.kLineModels subarrayWithRange:NSMakeRange(0, 20)].mutableCopy;
}

@end
