//
//  OTJAssistLine.m
//  StockLineDemo
//
//  Created by wyh on 2019/4/23.
//  Copyright © 2019 wyh. All rights reserved.
//

#import "OTJAssistLine.h"

@interface OTJAssistLine ()

@property (nonatomic, assign) CGContextRef context;

@end

@implementation OTJAssistLine

- (instancetype)initWithContext:(CGContextRef)context
{
    self = [super init];
    if(self)
    {
        _context = context;
    }
    return self;
}

- (void)draw {
    if(!self.kLineModel || !self.positionModel || !self.context || !self.lineColor) return;
    
    CGContextRef context = self.context;
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    CGContextSetLineWidth(context, lineWidth());
    
    CGPoint solidPoints[] = {self.positionModel.StartPoint, self.positionModel.EndPoint};
    
    if(self.kLineModel.MACD.floatValue > 0)
    {
        CGContextSetStrokeColorWithColor(context, [UIColor greenColor].CGColor);
    }
    CGContextStrokeLineSegments(context, solidPoints, 2);
}

@end
