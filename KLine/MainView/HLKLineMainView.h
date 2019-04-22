//
//  HLKLineMainView.h
//  StockLineDemo
//
//  Created by wyh on 2019/4/18.
//  Copyright © 2019 wyh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HLKLineConfig.h"
@class HLKLineModel, HLKLinePositionModel;

@protocol HLKLineMainViewDelegate <NSObject>

@optional

/**
 *  长按显示手指按着的Y_KLinePosition和KLineModel
 */
- (void)kLineMainViewLongPressKLinePositionModel:(HLKLinePositionModel *)kLinePositionModel kLineModel:(HLKLineModel *)kLineModel;

/**
 *  当前MainView的最大值和最小值
 */
- (void)kLineMainViewCurrentMaxPrice:(CGFloat)maxPrice minPrice:(CGFloat)minPrice;

/**
 *  当前需要绘制的K线模型数组
 */
- (void)kLineMainViewCurrentNeedDrawKLineModels:(NSArray *)needDrawKLineModels;

/**
 *  当前需要绘制的K线位置模型数组
 */
- (void)kLineMainViewCurrentNeedDrawKLinePositionModels:(NSArray *)needDrawKLinePositionModels;

/**
 *  当前需要绘制的K线颜色数组
 */
- (void)kLineMainViewCurrentNeedDrawKLineColors:(NSArray *)kLineColors;

@optional

@end

@interface HLKLineMainView : UIView

/**
 模型数组
 */
@property (nonatomic, strong) NSArray<HLKLineModel *> *kLineModels;

/**
 *  父ScrollView
 */
@property (nonatomic, weak, readonly) UIScrollView *parentScrollView;

/**
 代理
 */
@property (nonatomic, weak) id<HLKLineMainViewDelegate> delegate;

/**
 K线类型: K线 / 分时 / 其他
 */
@property (nonatomic, assign) HLKLineMainViewType type;

/**
 *  需要绘制Index开始值
 */
@property (nonatomic, assign) NSInteger needDrawStartIndex;

/**
 *  捏合点
 */
@property (nonatomic, assign) NSInteger pinchStartIndex;

/**
 画MainView所有线
 */
- (void)drawMainView;

/**
 更新MainView宽度
 */
- (void)updateMainViewWidth;

/**
 获取needDrawStartIndex
 
 @param scorll 是否在视图滚动的时候获取
 @return needDrawStartIndex
 */
- (NSInteger)getNeedDrawStartIndexWithScroll:(BOOL)scorll;

/**
 *  长按的时候根据原始的x位置获得精确的x的位置
 */
- (CGFloat)getExactXPositionWithOriginXPosition:(CGFloat)originXPosition;

/**
 移除所有监听
 */
- (void)removeAllObserver;


@end
