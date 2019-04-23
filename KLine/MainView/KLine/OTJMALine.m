//
//  OTJMALine.m
//  StockLineDemo
//
//  Created by wyh on 2019/4/23.
//  Copyright © 2019 wyh. All rights reserved.
//

#import "OTJMALine.h"

@interface OTJMALine ()

@property (nonatomic, assign) CGContextRef context;
/**
 *  最后一个绘制日期点
 */
@property (nonatomic, assign) CGPoint lastDrawDatePoint;

@end

@implementation OTJMALine

- (instancetype)initWithContext:(CGContextRef)context
{
    self = [super init];
    if(self)
    {
        self.context = context;
    }
    return self;
}

- (void)draw {
    if (!self.context) return;
    
    if (_MAType == Y_BOLL_DN || _MAType == Y_BOLL_MB || _MAType == Y_BOLL_UP) {
        
    }
    else {
        if (!self.MAPositions) return;
        
        UIColor *lineColor = self.MAType == Y_MA7Type ? [UIColor purpleColor] : (self.MAType == Y_MA30Type ? [UIColor cyanColor] : [UIColor colorWithHexString:@"333333"]);
        
        CGContextSetStrokeColorWithColor(self.context, lineColor.CGColor);
        CGContextSetLineWidth(self.context, 0.8);
        CGPoint firstPoint = [self.MAPositions.firstObject CGPointValue];
        CGContextMoveToPoint(self.context, firstPoint.x, firstPoint.y);
        
        for (NSInteger idx = 1; idx < self.MAPositions.count ; idx++)
        {
            CGPoint point = [self.MAPositions[idx] CGPointValue];
            CGContextAddLineToPoint(self.context, point.x, point.y);
            //
            //
            //        //日期
            //        NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.kLineModel.Date.doubleValue/1000];
            //        NSDateFormatter *formatter = [NSDateFormatter new];
            //        formatter.dateFormat = @"HH:mm";
            //        NSString *dateStr = [formatter stringFromDate:date];
            //
            //        CGPoint drawDatePoint = CGPointMake(point.x + 1, self.maxY + 1.5);
            //        if(CGPointEqualToPoint(self.lastDrawDatePoint, CGPointZero) || point.x - self.lastDrawDatePoint.x > 60 )
            //        {
            //            [dateStr drawAtPoint:drawDatePoint withAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:11],NSForegroundColorAttributeName : [UIColor assistTextColor]}];
            //            self.lastDrawDatePoint = drawDatePoint;
            //        }
        }
    }
    CGContextStrokePath(self.context);
}

@end
