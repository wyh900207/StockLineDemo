//
//  OTJAssistView.h
//  StockLineDemo
//
//  Created by wyh on 2019/4/23.
//  Copyright © 2019 wyh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OTJAssistView;

@protocol OTJAssistViewDelegate <NSObject>

@optional

/**
 *  当前AccessoryView的最大值和最小值
 */
- (void)kLineAccessoryViewCurrentMaxValue:(CGFloat)maxValue minValue:(CGFloat)minValue;

@end

@interface OTJAssistView : UIView

/**
 * 需要绘制的K线模型数组
 */
@property (nonatomic, strong) NSArray *needDrawKLineModels;

/**
 * 需要绘制的K线位置数组
 */
@property (nonatomic, strong) NSArray *needDrawKLinePositionModels;

/**
 *  K线的颜色
 */
@property (nonatomic, strong) NSArray *kLineColors;

/**
 *  代理
 */
@property (nonatomic, weak) id<OTJAssistViewDelegate> delegate;

/**
 *  Accessory指标种类
 */
@property (nonatomic, assign) HLKLineType targetLineStatus;

/**
 *  绘制
 */
- (void)draw;


@end
