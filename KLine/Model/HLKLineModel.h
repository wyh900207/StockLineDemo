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


#pragma 内部自动初始化

//移动平均数分为MA（简单移动平均数）和EMA（指数移动平均数），其计算公式如下：［C为收盘价，N为周期数］：
//MA（N）=（C1+C2+……CN）/N


//MA（7）=（C1+C2+……CN）/7
@property (nonatomic, copy) NSNumber *MA7;

//MA（30）=（C1+C2+……CN）/30
@property (nonatomic, copy) NSNumber *MA30;

@property (nonatomic, copy) NSNumber *MA12;

@property (nonatomic, copy) NSNumber *MA26;

@property (nonatomic, copy) NSNumber *Volume_MA7;

@property (nonatomic, copy) NSNumber *Volume_MA30;

@property (nonatomic, copy) NSNumber *Volume_EMA7;

@property (nonatomic, copy) NSNumber *Volume_EMA30;

#pragma BOLL线

@property (nonatomic, copy) NSNumber *MA20;

// 标准差 二次方根【 下的 (n-1)天的 C-MA二次方 和】
@property (nonatomic, copy) NSNumber *BOLL_MD;

// n-1 天的 MA
@property (nonatomic, copy) NSNumber *BOLL_MB;

// MB + k * MD
@property (nonatomic, copy) NSNumber *BOLL_UP;

// MB - k * MD
@property (nonatomic, copy) NSNumber *BOLL_DN;

//  n 个 ( Cn - MA20)的平方和
@property (nonatomic, copy) NSNumber *BOLL_SUBMD_SUM;

// 当前的 ( Cn - MA20)的平方
@property (nonatomic, copy) NSNumber *BOLL_SUBMD;

#pragma 第一个EMA等于MA；即EMA(n) = MA(n)

// EMA（N）=2/（N+1）*（C-昨日EMA）+昨日EMA；
//@property (nonatomic, assign) CGFloat EMA7;
@property (nonatomic, copy) NSNumber *EMA7;

// EMA（N）=2/（N+1）*（C-昨日EMA）+昨日EMA；
//@property (nonatomic, assign) CGFloat EMA30;
@property (nonatomic, copy) NSNumber *EMA30;

// EMA（N）=2/（N+1）*（C-昨日EMA）+昨日EMA；
//@property (nonatomic, assign) CGFloat EMA7;
@property (nonatomic, copy) NSNumber *EMA12;

// EMA（N）=2/（N+1）*（C-昨日EMA）+昨日EMA；
//@property (nonatomic, assign) CGFloat EMA30;
@property (nonatomic, copy) NSNumber *EMA26;

//DIF=EMA（12）-EMA（26）         DIF的值即为红绿柱；
//@property (nonatomic, assign) CGFloat DIF;
@property (nonatomic, copy) NSNumber *DIF;

//今日的DEA值（即MACD值）=前一日DEA*8/10+今日DIF*2/10.
//@property (nonatomic, assign) CGFloat DEA;
@property (nonatomic, copy) NSNumber *DEA;

//EMA（12）=昨日EMA（12）*11/13+C*2/13；   即为MACD指标中的快线；
//EMA（26）=昨日EMA（26）*25/27+C*2/27；   即为MACD指标中的慢线；
//@property (nonatomic, assign) CGFloat MACD;
@property (nonatomic, copy) NSNumber *MACD;


//KDJ(9,3.3),下面以该参数为例说明计算方法。
//9，3，3代表指标分析周期为9天，K值D值为3天
//RSV(9)=（今日收盘价－9日内最低价）÷（9日内最高价－9日内最低价）×100
//K(3日)=（当日RSV值+2*前一日K值）÷3
//D(3日)=（当日K值+2*前一日D值）÷3
//J=3K－2D
//@property (nonatomic, assign) CGFloat RSV_9;
@property (nonatomic, copy) NSNumber *RSV_9;

//@property (nonatomic, assign) CGFloat KDJ_K;
@property (nonatomic, copy) NSNumber *KDJ_K;

//@property (nonatomic, assign) CGFloat KDJ_D;
@property (nonatomic, copy) NSNumber *KDJ_D;

//@property (nonatomic, assign) CGFloat KDJ_J;
@property (nonatomic, copy) NSNumber *KDJ_J;


//初始化Model
- (void)initWithArray:(NSArray *)array;
- (void) initWithDict:(NSDictionary *)dict;
//初始化第一条数据
- (void) initFirstModel;
//初始化其他数据
- (void)initData ;

@end
