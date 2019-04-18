//
//  HLKLineModel.h
//  StockLineDemo
//
//  Created by wyh on 2019/4/18.
//  Copyright © 2019 wyh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HLKLineModel : NSObject

/**
 前一个Model
 */
@property (nonatomic, strong) HLKLineModel *previousModel;

/**
 该Model及其之前所有收盘价之和
 */
@property (nonatomic, strong) NSNumber *sumOfLastClose;

/**
 该Model及其之前所有成交量之和
 */
@property (nonatomic, strong) NSNumber *sumOfLastVolume;

/**
 日期
 */
@property (nonatomic, copy) NSString *date;

/**
 开盘价
 */
@property (nonatomic, strong) NSNumber *open;

/**
 收盘价
 */
@property (nonatomic, strong) NSNumber *close;

/**
 最高价
 */
@property (nonatomic, strong) NSNumber *high;

/**
 最低价
 */
@property (nonatomic, strong) NSNumber *low;


//初始化Model
- (void)initWithArray:(NSArray *)array;
- (void) initWithDict:(NSDictionary *)dict;
//初始化第一条数据
- (void) initFirstModel;
//初始化其他数据
- (void)initData ;

@end
