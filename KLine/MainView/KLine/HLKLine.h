//
//  HLKLine.h
//  StockLineDemo
//
//  Created by wyh on 2019/4/18.
//  Copyright © 2019 wyh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HLKLineModel.h"
#import "HLKLinePositionModel.h"

@interface HLKLine : NSObject

/**
 *  K线的位置model
 */
@property (nonatomic, strong) HLKLinePositionModel *position_model;

/**
 *  k线的model
 */
@property (nonatomic, strong) HLKLineModel *line_model;

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
