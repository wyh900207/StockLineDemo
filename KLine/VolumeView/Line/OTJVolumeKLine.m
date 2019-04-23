//
//  OTJVolumeKLine.m
//  StockLineDemo
//
//  Created by wyh on 2019/4/23.
//  Copyright © 2019 wyh. All rights reserved.
//

#import "OTJVolumeKLine.h"

@interface OTJVolumeKLine ()

@property (nonatomic, assign) CGContextRef context;

@end

@implementation OTJVolumeKLine

- (instancetype)initWithContext:(CGContextRef)context {
    self = [super init];
    if (self) {
        _context = context;
    }
    return self;
}

- (void)draw {
    if (!self.kLineModel || !self.positionModel || !self.context || !self.lineColor) return;
    
    CGContextRef ctx = self.context;
    CGContextSetStrokeColorWithColor(ctx, self.lineColor.CGColor);
    CGContextSetLineWidth(ctx, lineWidth());
    
    const CGPoint solidPoints[] = {self.positionModel.StartPoint, self.positionModel.EndPoint};
    CGContextStrokeLineSegments(ctx, solidPoints, 2);
}

@end
