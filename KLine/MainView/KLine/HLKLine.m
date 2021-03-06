//
//  HLKLine.m
//  StockLineDemo
//
//  Created by wyh on 2019/4/18.
//  Copyright © 2019 wyh. All rights reserved.
//

#import "HLKLine.h"
#import "HLKLineConfig.h"

#import "OTJDateUtils.h"

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
    if (!self.line_model || !self.context) {
        return nil;
    }
    
    CGContextRef context = self.context;
    
    UIColor *strokeColor = self.line_model.open.floatValue < self.line_model.close.floatValue ? HexColor(@"0ADC71") : HexColor(@"FF315C");
    
    CGContextSetStrokeColorWithColor(context, strokeColor.CGColor);
    
    CGContextSetLineWidth(context, lineWidth());
    const CGPoint solidPoints[] = {self.position_model.open_point, self.position_model.close_point};
    CGContextStrokeLineSegments(context, solidPoints, 2);
    
    CGContextSetLineWidth(context, LINE_SHADOW_WIDTH);
    const CGPoint shadowPoints[] = {self.position_model.high_point, self.position_model.low_point};
    CGContextStrokeLineSegments(context, shadowPoints, 2);
    
//    NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.line_model.date.doubleValue * 0.001];
//    NSDateFormatter *format = [NSDateFormatter new];
//    format.dateFormat = @"HH:mm";
//    NSString *dateStr = [format stringFromDate:date];
    
    NSString *dateStr = [OTJDateUtils dateStringWith:self.line_model.date];
    
    CGPoint draw_date_point = CGPointMake(self.position_model.low_point.x + 1, self.maxY + 6);
    if (CGPointEqualToPoint(self.lastDrawDatePoint, CGPointZero) || draw_date_point.x - self.lastDrawDatePoint.x > 60) {
        [dateStr drawAtPoint:draw_date_point withAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:11],
                                                              NSForegroundColorAttributeName: ASSIST_TEXT_COLOR
                                                              }];
        self.lastDrawDatePoint = draw_date_point;
    }
    
    return strokeColor;
}

@end
