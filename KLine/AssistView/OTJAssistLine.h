//
//  OTJAssistLine.h
//  StockLineDemo
//
//  Created by wyh on 2019/4/23.
//  Copyright © 2019 wyh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OTJVolumePositionModel.h"
#import "HLKLineModel.h"

@interface OTJAssistLine : NSObject
/**
 *  位置model
 */
@property (nonatomic, strong) OTJVolumePositionModel *positionModel;

/**
 *  k线model
 */
@property (nonatomic, strong) HLKLineModel *kLineModel;

/**
 *  线颜色
 */
@property (nonatomic, strong) UIColor *lineColor;

/**
 *  根据context初始化均线画笔
 */
- (instancetype)initWithContext:(CGContextRef)context;

/**
 *  绘制成交量
 */
- (void)draw;

@end
