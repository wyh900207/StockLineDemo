//
//  OTJVolumeView.h
//  StockLineDemo
//
//  Created by wyh on 2019/4/23.
//  Copyright © 2019 wyh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HLKLineModel.h"
#import "HLKLinePositionModel.h"

@protocol OTJVolumeViewDelegate <NSObject>

@optional

/**
 *  当前VolumeView的最大值和最小值
 */
- (void)kLineVolumeViewCurrentMaxVolume:(CGFloat)maxVolume minVolume:(CGFloat)minVolume;

@end


@interface OTJVolumeView : UIView

/**
 * 需要绘制的K线模型数组
 */
@property (nonatomic, strong) NSArray<HLKLineModel *> *needDrawKLineModels;

/**
 * 需要绘制的K线位置数组
 */
@property (nonatomic, strong) NSArray<HLKLinePositionModel *> *needDrawKLinePositionModels;

/**
 *  K线的颜色
 */
@property (nonatomic, strong) NSArray *kLineColors;

/**
 *  代理
 */
@property (nonatomic, weak) id<OTJVolumeViewDelegate> delegate;

///**
// *  Accessory指标种类
// */
//@property (nonatomic, assign) Y_StockChartTargetLineStatus targetLineStatus;

/**
 *  绘制
 */
- (void)draw;

@end
