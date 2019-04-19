//
//  HLKLinePositionModel.m
//  StockLineDemo
//
//  Created by wyh on 2019/4/19.
//  Copyright © 2019 wyh. All rights reserved.
//

#import "HLKLinePositionModel.h"

@implementation HLKLinePositionModel

+ (instancetype)modelWithOpen:(CGPoint)open close:(CGPoint)close high:(CGPoint)high low:(CGPoint)low {
    HLKLinePositionModel *model = [HLKLinePositionModel new];
    model.open_point = open;
    model.close_point = close;
    model.high_point = high;
    model.low_point = low;
    
    return model;
}

@end
