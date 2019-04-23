//
//  HLKLineModel.m
//  StockLineDemo
//
//  Created by wyh on 2019/4/18.
//  Copyright © 2019 wyh. All rights reserved.
//

#import "HLKLineModel.h"

@implementation HLKLineModel


- (NSNumber *)KDJ_K
{
    if (!_KDJ_K) {
        _KDJ_K = @((self.RSV_9.floatValue + 2 * (self.previousModel.KDJ_K ? self.previousModel.KDJ_K.floatValue : 50) )/3);
    }
    return _KDJ_K;
}

- (NSNumber *)KDJ_D {
    if(!_KDJ_D) {
        _KDJ_D = @((self.KDJ_K.floatValue + 2 * (self.previousModel.KDJ_D ? self.previousModel.KDJ_D.floatValue : 50))/3);
    }
    return _KDJ_D;
}

- (NSNumber *)KDJ_J {
    if(!_KDJ_J) {
        _KDJ_J = @(3*self.KDJ_K.floatValue - 2*self.KDJ_D.floatValue);
    }
    return _KDJ_J;
}

- (NSNumber *)EMA12 {
    if (!_EMA12) {
        _EMA12 = @((2 * self.close.floatValue + 11 * self.previousModel.EMA12.floatValue) / 13);
    }
    return _EMA12;
}

- (NSNumber *)EMA26
{
    if (!_EMA26) {
        _EMA26 = @((2 * self.close.floatValue + 25 * self.previousModel.EMA26.floatValue)/27);
    }
    return _EMA26;
}

- (NSNumber *)DIF {
    if (!_DIF) {
        _DIF = @(self.EMA12.floatValue - self.EMA26.floatValue);
    }
    return _DIF;
}

- (NSNumber *)DEA {
    if (!_DEA) {
        _DEA = @(self.previousModel.DEA.floatValue * 0.8 + 0.2 * self.DIF.floatValue);
    }
    return _DEA;
}

- (NSNumber *)MACD {
    if (!_MACD) {
        _MACD = @(2 * (self.DIF.floatValue - self.DEA.floatValue));
    }
    return _MACD;
}

@end
