//
//  HLKLine.m
//  StockLineDemo
//
//  Created by wyh on 2019/4/18.
//  Copyright © 2019 wyh. All rights reserved.
//

#import "HLKLine.h"

@interface HLKLine ()

// context
@property (nonatomic, assign) CGContextRef context;
// 最后一个绘制日期点
@property (nonatomic, assign) CGPoint lastDrawDatePoint;

@end

@implementation HLKLine

- (instancetype)initWithContext:(CGContextRef)context {
    if (self = [super init]) {
        _context = context;
        _lastDrawDatePoint = CGPointZero;
    }
    return self;
}

- (UIColor *)draw {
    if (!self.kLineModel || !self.context) {
        return nil;
    }
    
    CGContextRef context = self.context;
    
    UIColor *strokeColor = self.kLineModel.open.floatValue < self.kLineModel.close.floatValue ? [UIColor greenColor] : [UIColor redColor];
}

@end
