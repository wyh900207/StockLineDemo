//
//  HLKLinePositionModel.h
//  StockLineDemo
//
//  Created by wyh on 2019/4/19.
//  Copyright © 2019 wyh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HLKLinePositionModel : NSObject

/**
 开盘点
 */
@property (nonatomic, assign) CGPoint open_point;

/**
 收盘点
 */
@property (nonatomic, assign) CGPoint close_point;

/**
 最高盘点
 */
@property (nonatomic, assign) CGPoint high_point;

/**
 最低点
 */
@property (nonatomic, assign) CGPoint low_point;

+ (instancetype)modelWithOpen:(CGPoint)open close:(CGPoint)close high:(CGPoint)high low:(CGPoint)low;

@end
