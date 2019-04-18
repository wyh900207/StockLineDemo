//
//  HLKLine.h
//  StockLineDemo
//
//  Created by wyh on 2019/4/18.
//  Copyright © 2019 wyh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import "HLKLineModel.h"

@interface HLKLine : NSObject

@property (nonatomic, strong) HLKLineModel *kLineModel;

/**
 *  最大的Y
 */
@property (nonatomic, assign) CGFloat maxY;

/**
 *  根据context初始化
 */
- (instancetype)initWithContext:(CGContextRef)context;

/**
 *  绘制K线
 */
- (UIColor *)draw;

@end
